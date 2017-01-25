# rake update_courses task
# @param :days [Integer] number of days ahead that crowler will be performed for
# 	called as rake update_courses[12]. 30 is the default.
task :update_courses, [:days] => :environment do |t, args|

	# set number of days to crawl since today
	if args[:no_days].present?
		no_days = args[:no_days].to_i.days
	else
		no_days = 30.days
	end

	#remove all past courses
	p "Removing past courses from db..."
	Course.where(["departure_time < ?", DateTime.now]).destroy_all

	# perform crowl
	p "Updating courses for next month..."
	Connection.all.each	do |connection|
		p "Starting crawl for course from #{connection.station.name} to #{connection.connected_station.name}"
		Action::Crawl::Intercity.new(DateTime.now, DateTime.now+no_days, connection).execute
	end

	p "Courses updated!"
end
