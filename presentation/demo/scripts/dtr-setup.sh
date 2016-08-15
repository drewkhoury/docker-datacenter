#! /bin/bash

# https://docs.docker.com/apidocs/v2.0.1/

export SCRIPT_PATH=/home/vagrant/sync

source ${SCRIPT_PATH}/scripts/supporting/common-environment.sh

DTR_ORG=devops
DTR_REPO=project-xyz
DTR_USER=drew
DTR_PASSWORD=drew
DTR_TEAM=dev

#######
## DTR
#######

function action_dtr()
{
  type=$1
  url=$2

  curl -u admin:orca -k  -H "Content-Type: application/json" \
    -X ${type} https://${DTR_URL}${url} 
}

function action_dtr_data()
{
  type=$1
  url=$2
  data=$3 

  curl -u admin:orca -k  -H "Content-Type: application/json" \
    -X ${type} https://${DTR_URL}${url} --data ${data}
}

# Create DTR Org - Devops
# POST /enzi/v0/accounts
action_dtr_data "POST" "/enzi/v0/accounts" @<(cat <<EOF
{
  "name": "${DTR_ORG}",
  "fullName": "${DTR_ORG}",
  "isOrg": true,
  "isActive": true
  }
EOF
)

# Create Team - TeamB
# POST /enzi/v0/accounts/{orgNameOrID}/teams
action_dtr_data "POST" "/enzi/v0/accounts/${DTR_ORG}/teams" @<(cat <<EOF
{
  "name": "${DTR_TEAM}",
  "description": "${DTR_TEAM}"
}
EOF
)

# add a member to a team
# PUT /enzi/v0/accounts/{orgNameOrID}/teams/{teamNameOrID}/members/{memberNameOrID}
action_dtr_data "PUT" "/enzi/v0/accounts/${DTR_ORG}/teams/${DTR_TEAM}/members/${DTR_USER}" @<(cat <<EOF
{
  "isAdmin": false,
  "isPublic": true
}
EOF
)

# create repo
# POST /api/v0/repositories/{namespace}

action_dtr_data "POST" "/api/v0/repositories/${DTR_ORG}" @<(cat <<EOF
{
  "name": "${DTR_REPO}",
  "shortDescription": "short",
  "longDescription": "long",
  "visibility": "public"
  }
EOF
)

# grant write access to repo and team
# PUT /api/v0/repositories/{namespace}/{reponame}/teamAccess/{teamname}
action_dtr_data "PUT" "/api/v0/repositories/${DTR_ORG}/${DTR_REPO}/teamAccess/${DTR_TEAM}" @<(cat <<EOF
{
  "accessLevel": "read-write"
}
EOF
)