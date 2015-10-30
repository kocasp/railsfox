class Station < ActiveRecord::Base
	has_many :connections
	has_many :connected_stations, :through => :connections
end
