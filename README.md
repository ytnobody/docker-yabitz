# ytnobody/yabitz

[livedoor/yabitz](https://github.com/livedoor/yabitz) in a container

## SYNOPSIS

   # docker run \
       -e YABITZ_INIT=1 \
       -e YABITZ_DBHOST=mysql_host_name \
       -e YABITZ_DBNAME=mysql_db_name \
       -e YABITZ_DBUSER=mysql_db_user_name \
       -e YABITZ_DBPASS=mysql_db_password \
       -e YABITZ_USER_DBHOST=mysql_host_name_for_user_database \
       -e YABITZ_USER_DBNAME=mysql_db_name_for_user_database \
       -e YABITZ_USER_DBUSER=mysql_db_user_name_for_user_database \
       -e YABITZ_USER_DBPASS=mysql_db_password_for_user_database \
       --name yabitz \
       -p 8080:8080 \
       --rm \
       -it ytnobody/yabitz
       

## CREATE ADMIN ACCOUNT

    docker exec -it yabitz /bin/bash user_add

## ENVIRONMENT VARIABLES

* YABITZ_DBHOST : required - Hostname of mysql that used as main database

* YABITZ_DBNAME : required - Database name

* YABITZ_DBUSER : required - Database user

* YABITZ_DBPASS : optional - Database password

* YABITZ_USER_DBHOST : required - Hostname of mysql that used as user database

* YABITZ_USER_DBNAME : required - User database name

* YABITZ_USER_DBUSER : required - User database user

* YABITZ_USER_DBPASS : optional - User database password

* YABITZ_INIT : optional - Create each tables that used by yabitz when specified as true.

## SEE ALSO

* [livedoor/yabitz](https://github.com/livedoor/yabitz)

