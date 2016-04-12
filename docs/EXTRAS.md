# Extras

## Vagrant Tips
You can use `vagrant destroy -f` to remove all containers, `vagrant up docker1` to bring up a specific container and `vagrant ssh docker1` to ssh into specific a container. `vagrant provision docker1` will reprovision the VM (useful if the up command failed and you don't need to spin up a new VM).


## DTR Notes 

NOTE: This has been fully automated now, you probably don't need these notes!

Once you've done a `vagrant up`, DTR will be available on [https://docker1](https://docker1). It requires some configuration before you can use it. It also needs integration with UCP (which is a manual process).

### Apply some basic settings

- In settings>general :: Set Domain Name (docker1)
- In settings>licnese :: Apply Licence (docker_subscription.lic)
- In settings>auth    :: Choose 'managed' and create an admin account e.g admin/adminadmin.

### Create a repo to hold an image

A repo has a 1-1 relationship with an image, so the repo name and the image name must match exactly.
Repos can hold many images of the same name but with different tags, e.g `docker1/admin/foo:tag1` and `docker1/admin/foo:tag2`.

Create a new repo `foo` under the account `admin`.

```
vagrant ssh docker1

DOMAIN=dtr.local
curl --user admin:adminadmin -X POST --header "Content-Type: application/json" \
             --header "Accept: application/json" \
             -d "{
  \"name\": \"foo\",
  \"shortDescription\": \"foo\",
  \"longDescription\": \"foo\",
  \"visibility\": \"public\"
}" "https://${DOMAIN}/api/v0/repositories/admin"
```

### Create an image and push it to DTR

```
vagrant ssh docker1

# login to dtr
DOMAIN=dtr.local
docker login -u admin -p adminadmin -e foo@bar.com ${DOMAIN}

# create test dockerfile
touch hello
cat <<EOF | sudo tee Dockerfile > /dev/null
FROM scratch
COPY hello /
CMD ["/hello"]
EOF

# create a image tag locally,
# image name `${DOMAIN}/admin/foo` must match repo name `https://${DOMAIN}/repositories/admin/foo/details`
docker build -t ${DOMAIN}/admin/foo:tag1 .

# push the image tag to the dtr repo,
# a repo can hold many image tags for the same image,
# e.g `${DOMAIN}/admin/foo:tag1` and `${DOMAIN}/admin/foo:tag2`
docker push ${DOMAIN}/admin/foo:tag1

```

If you have problems with the login command above, troubleshoot with:

```
curl -v https://${DOMAIN}/login -u admin:adminadmin
curl -v https://${DOMAIN}/login --cacert /etc/pki/ca-trust/source/anchors/${DOMAIN}.crt --insecure
```

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