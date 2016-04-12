#!/bin/bash

DOMAIN=dtr.local

# create repo
curl -k -Lik \
	--user admin:adminadmin -X POST \
	--header "Content-Type: application/json" \
	--header "Accept: application/json" \
    -d "{  \"name\": \"foo\",  \"shortDescription\": \"foo\",  \"longDescription\": \"foo\",  \"visibility\": \"public\"}" "https://${DOMAIN}/api/v0/repositories/admin"

# login to dtr
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
