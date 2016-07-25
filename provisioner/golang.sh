#!/bin/bash -eu
#--------------------------------------
# Go (golang)
#
# Environment Variables:
#   PROV_GO_VERSION: go version (e.g. "1.6.3")
#--------------------------------------

: ${PROV_GO_VERSION:=${1:-1.6.3}}

# Download and install
mkdir -p /opt/src
pushd /opt/src
wget --quiet "https://storage.googleapis.com/golang/go${PROV_GO_VERSION}.linux-amd64.tar.gz"
tar -C /usr/local -xf "go${PROV_GO_VERSION}.linux-amd64.tar.gz"
popd

# Add to PATH
cat <<'EOS' >/etc/profile.d/golang.sh
export PATH=/usr/local/go/bin:$PATH
EOS
