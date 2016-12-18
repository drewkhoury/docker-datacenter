#!/bin/bash

# create test dockerfile
mkdir foo
cd foo
touch hello
cat <<EOF | sudo tee Dockerfile > /dev/null
FROM scratch
COPY hello /
CMD ["/hello"]
EOF

# create a image tag locally,
# image name `${DTR_HOST}/admin/foo`
# must match repo name `https://${DTR_HOST}/repositories/admin/foo/details`
docker build -t ${DTR_URL}/admin/foo:tag1 .

# create repo
curl -k -Lik \
	--user admin:${UCP_PASSWORD} -X POST \
	--header "Content-Type: application/json" \
	--header "Accept: application/json" \
    -d "{  \"name\": \"foo\",  \"shortDescription\": \"foo\",  \"longDescription\": \"foo\",  \"visibility\": \"public\"}" "https://${DTR_URL}/api/v0/repositories/admin"

# login to dtr
docker login -u admin -p ${UCP_PASSWORD} -e foo@bar.com ${DTR_URL}

# push the image tag to the dtr repo,
# a repo can hold many image tags for the same image,
# e.g `${DTR_HOST}/admin/foo:tag1` and `${DTR_HOST}/admin/foo:tag2`
docker push ${DTR_URL}/admin/foo:tag1
