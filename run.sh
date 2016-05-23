#!/bin/bash

RACK_ENV=production

if [ $YABITZ_INIT ] ; then
  bundle exec ruby scripts/db_schema.rb
  bundle exec ruby scripts/instant/db_schema_membersource.rb $YABITZ_MEMBER_DBHOST $YABITZ_MEMBER_DBUSER $YABITZ_MEMBER_DBPASS
fi

bundle exec unicorn -E production
