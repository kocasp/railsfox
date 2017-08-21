require 'capybara/poltergeist'

class Crowler

	def initialize(date, connection)
		@date = date
		@results = []
		@connection = connection
		@start_station_name = @connection.station.name
		@end_station_name = @connection.connected_station.name
	end

	def perform_crawl
		setup
		return false unless enter_connection_page_correctly
		iterate_courses
		@results
	end

	def setup
		Capybara.register_driver :poltergeist do |app|
		  Capybara::Poltergeist::Driver.new(app, js_errors: false, timeout: 120, phantomjs_options: ['--load-images=no'])
		end
		Capybara.default_driver = :poltergeist
		@browser = Capybara.current_session
		@start_url = "http://www.intercity.pl/pl/"
	end

	def enter_connection_page_correctly

		@browser.visit @start_url

		@browser.fill_in('seek[stname][0]', :with => @start_station_name)
		@browser.find("a[title='#{@start_station_name}']").click
		@browser.fill_in('seek[stname][1]', :with => @end_station_name)
		@browser.find("a[title='#{@end_station_name}']").click

		@browser.fill_in('seek[time]', :with => '00:00')
		@browser.first(".ui-timepicker-list li").click

		travel_date = @date.strftime
		puts "performing crawl for #{travel_date}"
		@browser.fill_in('seek[date]', :with => travel_date)
		@browser.click_on 'Szukaj'

		@courses_found = @browser.all(".train_main_content_box li", :visible=>false).count

		counter = 0
		while counter < 20
			puts "sleep...(#{@courses_found}/20)"
			break if  @courses_found > 20
			sleep(2)
			@courses_found = @browser.all(".train_main_content_box li", :visible=>false).count
			counter += 1
		end

		puts "	znaleziono #{@courses_found} połączeń PKP"

		return @courses_found > 0 ? true : false
	end

	def iterate_courses
		# click all undisplayed prices simultaneusly
		@browser.all(".train_main_content_box li", :visible=>false).each do |c2|
			unless c2.first(".ramka_eip").nil?
				route = c2.first("div", :visible=>false)[:id]
				departure_time = c2.first(".godziny.do_prawej", :visible=>false)
				price = c2.first(".cena_klasa_2", :visible=>false)
				if price.text == "Sprawdź cenę od w klasie 2"
					@browser.execute_script("$('##{route} .cena_klasa_2').click()")
				end
			end
		end

		@browser.all(".train_main_content_box li", :visible=>false).each do |c|
			#check if connection is INTERCITY PREMIUM. premium connections have orange border caused by 'ramka_eip' class

			unless c.first(".ramka_eip").nil?
				route = c.first("div", :visible=>false)[:id]

				departure_time = c.first(".godziny.do_prawej", :visible=>false)
				departure_date = c.all(".daty.do_lewej", :visible=>false).last
				arrival_time = c.first(".godziny.do_lewej", :visible=>false)
				arrival_date = c.all(".daty.do_prawej", :visible=>false).last
				price = c.first(".cena_klasa_2", :visible=>false)

				#check if there is an hour and price field in connection div
				unless departure_time.nil? || price.nil?
					puts "	departure time: #{departure_time.text}"

					#detect if click needed
					if price.text == "Sprawdź cenę od w klasie 2" || price.text == ""

						#capybara click couldnt help so JS click is triggered
						@browser.execute_script("$('##{route} .cena_klasa_2').click()")
						while price.text == "Sprawdź cenę od w klasie 2"
							@browser.execute_script("$('##{route} .cena_klasa_2').click()")
							sleep(1)
						end

						while price.text.empty? do
							price = c.first(".cena_klasa_2", :visible=>false)
							sleep(1) if price.text.empty?
						end
					end

					dt = Time.parse(departure_time.text)
					dd = Date.parse(departure_date.text)
					at = Time.parse(arrival_time.text)
					ad = Date.parse(arrival_date.text)

					departure_datetime = DateTime.new(dd.year, dd.month, dd.day, dt.hour, dt.min)
					arrival_datetime = DateTime.new(ad.year, ad.month, ad.day, at.hour, at.min)

					@results << Course.new(departure_time: departure_datetime, arrival_time: arrival_datetime, price: parse_price(price), connection: @connection)
				end
			end
		end
	end

	def parse_price(price)
		return nil if price.text == "Brak możliwości sprawdzenia"
		raise "Czas serwisowy! Pamiętaj o przerwie technologicznej w systemie internetowej sprzedaży w godzinach 23:30 - 1:00 " if price.text == "Czas serwisowy"
		ticket_price = price.text.split(/\W+/)[5].to_f
		raise "price suspiciously low. price.text: #{price.text}, ticket_price: #{ticket_price}" if ticket_price < 10
		ticket_price
	end

end
