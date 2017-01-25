class Station < ActiveRecord::Base
	has_many :connections, dependent: :destroy
	has_many :connected_stations, :through => :connections
end
