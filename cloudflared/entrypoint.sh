#!/bin/ash
set -e

domain=kory33.net
tunnel_name=kory33-net-generic

# login if cert.pem not found
if [ ! -f ~/.cloudflared/cert.pem ]; then
  cloudflared tunnel login
fi

# ensure that the tunnel exists
cloudflared tunnel create $tunnel_name || true

# the format output by `cloudflared tunnel list --output yaml` is 
# - id: ********-****-****-****-************
#   name: ********
#   createdat: ****-**-**T**:**:**.******Z
#   deletedat: 0001-01-01T00:00:00Z
#   connections: []
tunnel_id=$(
    cloudflared tunnel list \
      --name kory33-net-generic \
      --output yaml \
      | yq eval '.[0].id' -
)

# route all domains in ingress rules specified in tunnel-confing.yaml
yq e ".ingress.[].hostname | select(. != null)" \
  /tmp/tunnel-config.yaml \
  | xargs cloudflared tunnel route dns $tunnel_id

# start the tunnel
cloudflared tunnel --config /tmp/tunnel-config.yaml --no-autoupdate run $tunnel_id
