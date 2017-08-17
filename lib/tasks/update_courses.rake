# rake update_courses task
# @param :days [Integer] number of days ahead that crowler will be performed for
# 	called as rake update_courses[12]. 30 is the default.
task :update_courses, [:days] => :environment do |t, args|

	# set number of days to crawl since today
	if args[:days].present?
		no_days = args[:days].to_i
	else
		no_days = 7
	end

	#remove all past courses
	# p "Removing past courses from db..."
	Course.where(["departure_time < ?", DateTime.now]).destroy_all

	# perform crowl
	# p "Updating courses for next #{no_days} days..."
	start_time = DateTime.now
	Connection.all.each	do |connection|
		p "Starting crawl for course from #{connection.station.name} to #{connection.connected_station.name}"

		# p "Clearing sidekiq jobs..."
		# Sidekiq.redis { |conn| conn.flushdb }
		# p "Adding crawl to background sidekiq job ..."
		# ConnectionWorker.perform_async(no_days, connection.id)
		Action::Crawl::Intercity.new(DateTime.now+1.day, DateTime.now+no_days.days, connection).execute
		ConnectionCrawlMailer.confirm_crawl(connection).deliver_now
	end
	stop_time =  DateTime.now
	p "Courses updated! Started: #{start_time}, finished: #{stop_time}"
end
