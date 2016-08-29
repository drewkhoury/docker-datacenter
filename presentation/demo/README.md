# Demo
https://docs.docker.com/ucp/configuration/dtr-integration/

### Contents
- Demo outline
- Pre-setup for Demo
- Start Demo
----

## Demo outline
[Role] - [System] - [Action]
1. Show Website v2 is boring
1. Admin - UCP - Show User/Team/Resource Labels
1. Admin - DTR - Show tags v1 and v2, but v3 does not exist
1. Logout as Admin
1. Dev - Dev - Push to Registry 
1. Dev - DTR - View new Image and Tag
1. Dev - UCP - Deploy via Compose
- a. Fail - access denied
8. Release - UCP - Deploy via Compose
- a. success - App created
9. 1 week later - website is slow
10. Dev - UCP - View container (see logs, stats)
11. Dev - UCP - has found fix
- a. Fail - access denied to console

#### Roles
- Admin - admin
- Dev - drew
- Release - pablo

---
## Pre-setup for Demo

### 1. Start Vagrant
```
vagrant up docker1

# IP address of docker1
# cat /etc/hosts | grep docker1
```

### 2. UCP
See https://docs.docker.com/ucp/user-management/permission-levels/

#### Create Users
- [dev-username], FullName=Dev_VO
  - Default Permission: View Only
- [release-username], FullName=Release_RC
  - Default Permission: Restricted Control

#### Create Teams
- dev-vo
  - Add user: [dev-username]
  - Permissions - add resource label
    - ProjectXYZ - View Only
- release-fc
  - Add user: [release-username]
  - Permission - add resource label
    - ProjectXYZ - Full Control
    - NOTE: Console requires FC

### 3. DTR and Push Images
- run script to create dtr accounts/teams

```
vagrant up ddc_docker_dev
vagrant ssh ddc_docker_dev -c '/home/vagrant/sync/presentation/demo/scripts/dtr-setup.sh'
vagrant ssh ddc_docker_dev -c '/home/vagrant/sync/presentation/demo/scripts/dev-push.sh v1v2'
```

### 4. Release v2
- run script to release v2 of website

```
vagrant ssh docker1 -c '/home/vagrant/sync/presentation/demo/scripts/release-v2.sh'
```

----

## Start Demo

1. ### Show ProjectXYZ website v2 is boring - http://docker1:8080

1. ### Admin - UCP - Show User/Team/Resource Labels

1. ### Admin - DTR - Show tags v1 and v2, v3 does not exist

1. ### Logout as Admin user

1. ### Dev - Dev - Push to Registry
- Run script
```
vagrant ssh ddc_docker_dev -c '/home/vagrant/sync/presentation/demo/scripts/dev-push.sh v3'
```

6. ### Dev - DTR - View new Image and Tag
- Login as Dev - show uploaded image and tags

7. ### Dev - UCP - Deploy via Compose 
- Login as [dev-username]
- Create Application - ProjectXYZ
  - /presentation/webB/release/docker-compose.yml
  - NOTE: update IP address
- Failure - access denied

8. ### Release - UCP - Deploy via Compose
- Login as [release-username]
- Create Application - ProjectXYZ
  - /presentation/webB/release/docker-compose.yml
  - NOTE: update IP address
- Success
  - http://docker1:8081

9. ### 1 week later - website is slow

10. ### Dev - UCP - View container (see logs, stats)
- Login as [dev-username]
- Show Containers list - show column Label
- View Container - show logs, stats pages

11. ### Dev - UCP - has found fix.
- Open console to make changes
- Failure - access denied

## End Demo
---

## Debugging Tips

### Login into DTR is failing
- Ensure you are using IP address in URL for both UCP and DTR website

### DTR website is not running
```
# log in to UCP - check 5 containers are started for DTR
# if not run following do following:
#
# Find --existing-replica-id at UCP web site Applications page
# eg "Docker Trusted Registry 2.0.3 - (Replica afb7d048d0ba)"
#
# REPLACE BELOW - "?" with valid id eg. "existing_replica_id=afb7d048d0ba"
# vagrant ssh docker1 -c 'export existing_replica_id=?; /home/vagrant/sync/scripts/supporting/dtr-re-install.sh'

```

## Sample Images

###  Login as [dev-user]
EXPECT ERROR: Restart ProjectXYZ container
  - [dev-user] only has 'View Only'.
  - NOTE: buttons are still displayed but action results in error. 

![dummy](images/userA_projectXYZ_restart_error.png)

### Login as Admin

EXPECT SUCCESS: ProjectXYZ connect console

![dummy](images/userB_projectXYZ_console_success.png)
