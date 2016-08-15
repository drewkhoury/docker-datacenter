#! /bin/bash

# https://docs.docker.com/apidocs/v2.0.1/

source ${SCRIPT_PATH}/scripts/supporting/common-environment.sh

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
  "name": "devops",
  "fullName": "devops",
  "isOrg": true,
  "isActive": true
  }
EOF
)

# Create Team - TeamB
# POST /enzi/v0/accounts/{orgNameOrID}/teams
action_dtr_data "POST" "/enzi/v0/accounts/devops/teams" @<(cat <<EOF
{
  "name": "teamb",
  "description": "team b"
}
EOF
)

# add a member to a team
# PUT /enzi/v0/accounts/{orgNameOrID}/teams/{teamNameOrID}/members/{memberNameOrID}
action_dtr_data "PUT" "/enzi/v0/accounts/devops/teams/teamb/members/userb" @<(cat <<EOF
{
  "isAdmin": false,
  "isPublic": true
}
EOF
)

# create repo
# POST /api/v0/repositories/{namespace}

action_dtr_data "POST" "/api/v0/repositories/devops" @<(cat <<EOF
{
  "name": "project-xyz",
  "shortDescription": "short",
  "longDescription": "long",
  "visibility": "public"
  }
EOF
)

# grant write access to repo and team
# PUT /api/v0/repositories/{namespace}/{reponame}/teamAccess/{teamname}
action_dtr_data "PUT" "/api/v0/repositories/devops/project-xyz/teamAccess/teamb" @<(cat <<EOF
{
  "accessLevel": "read-write"
}
EOF
)