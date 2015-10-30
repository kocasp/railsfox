module Action
  module Crawl
    class Intercity
    	
		def initialize (start_date, end_date, connection)
			@start_date = start_date
			@end_date = end_date
			@new_courses = []
			@connection = connection
		end

		def execute
			make_site_offline
			remove_existing_courses
			load_new_courses
			save_new_courses
			make_site_online
		end

		def remove_existing_courses
			(@start_date..@end_date).each do |date|
				time_range = @start_date.beginning_of_day..@end_date.end_of_day
				Course.where(departure_time: time_range, connection: @connection).destroy_all
			end
		end

		def load_new_courses
			(@start_date..@end_date).each do |date|
				crowler = ::Crowler.new(date, @connection)
				@new_courses.concat crowler.perform_crawl
			end
		end

		def save_new_courses
			@new_courses.each do |nc|
				nc.save!
			end
		end

		def make_site_offline
			#TODO
		end

		def make_site_online
			#TODO
		end
  	end
  end
end
