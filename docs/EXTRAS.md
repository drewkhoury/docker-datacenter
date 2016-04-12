# Extras

## Vagrant Tips
You can use `vagrant destroy -f` to remove all containers, `vagrant up docker1` to bring up a specific container and `vagrant ssh docker1` to ssh into specific a container. `vagrant provision docker1` will reprovision the VM (useful if the up command failed and you don't need to spin up a new VM).


## DTR Notes 

If you have authentication issues when doing a `docker push` make sure the repository is named EXACTLY the same as the image you're trying to push, and that the repo exists with the correct user access applied to it.

General dtr troubleshooting can be done with `cd /usr/local/etc/dtr/logs && tail -f *`.

## Interlock Notes

Have not got a confirmed/working setup for this demo yet.

- `cd ~ && git clone https://github.com/ehazlett/interlock.git` - works with boot2docker
- `cd ~ && git clone https://github.com/nicolaka/interlock-lbs.git` - works with ucp (with bugs ... need to point latest semver 1.0.1?)

```
# hack for interlock
cat <<EOF | sudo tee /var/lib/docker/volumes/interlocknginx_nginx/_data/nginx.conf > /dev/null
events {
  worker_connections  4096;  ## Default: 1024
}
EOF
```