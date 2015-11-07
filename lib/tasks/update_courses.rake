task :update_courses => :environment do
	#remove all past courses
	p "Removing past courses from db..."
	Course.where(["departure_time < ?", DateTime.now]).destroy_all

	p "Updating courses for next month..."

	# connection = Connection.find_by_station_names("Kraków Główny", "Warszawa Centralna")
	Connection.all.each	do |connection|
		p "Starting crawl for course from #{connection.station.name} to #{connection.connected_station.name}"
		Action::Crawl::Intercity.new(DateTime.now, DateTime.now+30.days, connection).execute
	end

	p "Courses updated!"
end