# Demo

1. Show Create User and Team
1. Show Push to Registry
1. Show DTR with new Image and Tag
1. Login as UserB show Compose Application
1. As UserB show Restricted Control on app created
1. Login as UserA show restricted access



## User Admin

### Create Users
- userA, FullName=userA_NA
  - Default Permission: View Only
- userB, FullName=userB_RC
  - Default Permission: Restricted Control

### Create Teams
- teamA
  - Add user: userA
  - Permissions - add resource label
    - ProjectXYZ - View Only
    - TeamA - Full Control
- teamB
  - Add user: userB
  - Permission - add resource label
    - ProjectXYZ - Full Control
    - TeamB - Restricted Control

### Login as userB
https://docs.docker.com/ucp/configuration/dtr-integration/
- Create Application - ProjectXYZ
  - /presentation/webB/docker-compose.yml

```
# EXPECT ERROR: if TeamB resource label is used.
Created docker/ucp-compose:1.1.2 compose container
Started compose container 68a732146b299a089abf110b41c63577483dd5b07561be3b5377e8326fb7be35
Creating network "projectxyz_default" with the default driver
Creating projectxyz_nginxProjectXYZ_1

ERROR: for nginxProjectXYZ  Permission denied: host mounted volumes not allowed.  You must specify a group label with Full Access or request Full Access from your administrator.
Successfully deployed ProjectXYZ

# ** New test **
# EXPECT SUCCESS: if ProjectXYZ label is used
Created docker/ucp-compose:1.1.2 compose container
Started compose container c940aa799e9e2a65bc632d094521da38f7ad91ff9f254c73550436ea0ad9a03d
Creating projectxyz_nginxProjectXYZ_1
Successfully deployed projectXYZ
```

### Login as userA

- EXPECT ERROR: Restart ProjectXYZ container
  - UserA only has 'View Only'.
  - NOTE: buttons are still displayed but action results in error. 
![dummy](images/userA_projectXYZ_restart_error.png)

### Login as userB

- EXPECT SUCCESS: ProjectXYZ connect console

![dummy](images/userB_projectXYZ_console_success.png)
