# docker proxy :: https://docs.docker.com/engine/admin/systemd/
# - this is used for pulling images e.g `sudo docker pull docker/ucp`
sudo mkdir /etc/systemd/system/docker.service.d
cat <<EOF | sudo tee /etc/systemd/system/docker.service.d/http-proxy.conf > /dev/null
[Service]
Environment="HTTP_PROXY=http://10.0.2.2:3128/" "NO_PROXY=localhost,127.0.0.1,docker1,docker2,docker3"
EOF