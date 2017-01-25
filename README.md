## TODO

* remove connection_id from station
* add basic tests
-- random webpage connection crowl
* capybara timeout error catching from crowler
* dont remove old courses before saving new ones

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
