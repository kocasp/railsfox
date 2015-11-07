class Course < ActiveRecord::Base
	belongs_to :connection

	def departure_dayname
		case departure_time.wday
		when 1
			"poniedziałek"
		when 2
			"wtorek"
		when 3
			"środa"
		when 4
			"czwartek"
		when 5
			"piątek"
		when 6
			"sobota"
		when 0
			"niedziela"
		end
	end
end
