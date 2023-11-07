#!/bin/sh

#
# Watir/Selenium Testing 
#
# usage: ./go Test.rb
# Must start server> RAILS_ENV=test bundle exec rails s

# Catch up on tests
RAILS_ENV=test bundle exec rails db:migrate

echo "*** Remeber to start server in test mode"
echo $1

RAILS_ENV=test ruby $1