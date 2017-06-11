# README
This is a pretty terse guide to setting up this package:

PostgreSQL as the database: for a larger database (ours has a few hundred thousand items) and fuzzy search use pg_trgm and GIN indexing to expedite load time.

check out the gemfile for additional dependencies


requires ENV[ONSITE_API_KEY]
locally do:
export ONSITE_API_KEY="get_this_key_from_api_server"
for heroku:
heroku config:set ONSITE_API_KEY="access_token_goes_here"

postgres login if failure:
psql -h localhost -U postgres postgres


need to install unaccent extension in postgres:

rails db
\dx #this lists installed extensions
create extension unaccent;

on heroku:

heroku pg:psql
create extension unaccent;
create extension pg_trgm;
from: https://blog.heroku.com/announcing_support_for_17_new_postgres_extensions_including_dblink

start server with:
rails server -b 0.0.0.0 -p 3000

to import db - (while API server is running)
Song.import_all_songs

Then need to build the search indexes for pg_search:
rake pg_search:multisearch:rebuild[Songs]
and
rake pg_search:multisearch:rebuild[Artist]

seed database
rake db:seed
or heroku run rake db:seed

TODO: create a smaller seeds.rb that doesn't include song library. current seeds provides a library that likely won't link to actual kjams soIDs


for redis: (followed this: http://tutorials.jumpstartlab.com/topics/performance/background_jobs.html)

brew install redis
redis-server
OR brew services start redis //starts redis and adds it to login startups

start workers:
bundle exec rake environment resque:work QUEUE=*

start schedule for repeating jobs:
bundle exec clockwork config/clock.rb
