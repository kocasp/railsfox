## Server installation

sudo sh install_phantom.sh:
```
#!/usr/bin/env bash
# This script install PhantomJS in your Debian/Ubuntu System
#
# This script must be run as root:
# sudo sh install_phantomjs.sh
#

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

PHANTOM_VERSION="phantomjs-1.9.8"
ARCH=$(uname -m)

if ! [ $ARCH = "x86_64" ]; then
  $ARCH="i686"
fi

PHANTOM_JS="$PHANTOM_VERSION-linux-$ARCH"

sudo apt-get update
sudo apt-get install build-essential chrpath libssl-dev libxft-dev -y
sudo apt-get install libfreetype6 libfreetype6-dev -y
sudo apt-get install libfontconfig1 libfontconfig1-dev -y

cd ~
wget https://bitbucket.org/ariya/phantomjs/downloads/$PHANTOM_JS.tar.bz2
sudo tar xvjf $PHANTOM_JS.tar.bz2

sudo mv $PHANTOM_JS /usr/local/share
sudo ln -sf /usr/local/share/$PHANTOM_JS/bin/phantomjs /usr/local/bin
```

## TODO
* make poltergeist work more asynchronous (avoid sleep(7))
* remove connection_id from station
* add basic tests
-- random webpage connection crawl
* capybara timeout error catching from crowler
* dont remove old courses before saving new ones
* set expected daily courses amount on particular connection
*!! create a updated_at and updated_to fields in connection to allow to start from last day after update is distrupted (requires crawler refactoring)
Apparently there is a problem running Capybara Poltergeist crawl simultaneusly via sidekiq. Various errors appear. Crawl performs well when running separately on foreground via ConnectionWorker.new(no_days, connection_id) but parallel sidekiq jobs throws:

NoMethodError: undefined method `downcase' for false:FalseClass
2017-08-16T16:19:15.500Z 46456 TID-ow3lgir04 WARN: /Users/macbook/.rvm/gems/ruby-2.0.0-p643/gems/poltergeist-1.7.0/lib/capybara/poltergeist/browser.rb:102:in `tag_name'

WARN: ArgumentError: no time information in "{\"status\"=>\"success\"}"

WARN: ArgumentError: wrong number of arguments (0 for 2)

and many more...
Need to investigate this

Maybe running every crawl in different Capybara session/browser will help ...
!!!!Different ports seem to work!!!

# Docs
## Models
There are `Connection`, `Course` and `Station` models.
`Station` is a station having a :name.
`Connection` belongs to station and connected_station which are start and end points of the connection. Both are `Station` class
`Course` is a course of a train on a particular connection. It has :departure_time and :arrival_time

## Rake
Webcrowl is perform by raketask `rake update_courses` defined in lib/tasks/update_courses.rake

## Custom commands
To remove and re-crawl data for particular day run f.e `Action::Crawl::Intercity.new(Date.new(2017,1,31), Date.new(2017,1,31), Connection.first).execute`

#Ngrok
If there is ngrok installed please run `./ngrok http -subdomain=railsfox 3000` from ngrok folder to test the API responses

# Crawler takes approximately 15mins to crawl through one connection

# to perform background job you must have Redis installed and run `redis-server` as well run `bundle exec sidekiq`
# to clear all Sidekiq jobs and remaining tasks do the `Sidekiq.redis { |conn| conn.flushdb }` from the console

