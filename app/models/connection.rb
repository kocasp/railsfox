class Connection < ActiveRecord::Base
	belongs_to :station
	belongs_to :connected_station, :class_name => "Station"
	has_many :courses	


	def self.find_by_station_names(starting, ending)
		start_station = Station.find_by_name(starting)
		end_station = Station.find_by_name(ending)
		Connection.where(station: start_station, connected_station: end_station).first
	end

	def start_station_name
		station.name
	end

	def end_station_name
		connected_station.name
	end

	def name
		"#{start_station_name} -> #{end_station_name}"
	end
end
