#--------------------------------------
# Go (golang)
#
# Environment Variables:
#   GO_VERSION: go version (e.g. "1.6.2")
#--------------------------------------

GO_VERSION=${GO_VERSION:-1.6.2}

# Download and install
mkdir -p /opt/src
pushd /opt/src
wget --quiet "https://storage.googleapis.com/golang/go${GO_VERSION}.linux-amd64.tar.gz"
tar -C /usr/local -xf "go${GO_VERSION}.linux-amd64.tar.gz"
popd

# Add to PATH
cat <<'EOS' >/etc/profile.d/golang.sh
export PATH="/usr/local/go/bin:$PATH"
EOS
. /etc/profile.d/golang.sh
