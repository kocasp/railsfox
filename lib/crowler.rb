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
		Capybara.register_driver :poltergeist do |app|
		  Capybara::Poltergeist::Driver.new(app, js_errors: false)
		end
		Capybara.default_driver = :poltergeist

		browser = Capybara.current_session

		url = "http://www.intercity.pl/pl/"

		browser.visit url
		browser.fill_in('seek[stname][0]', :with => @start_station_name)
		browser.find("a[title='#{@start_station_name}']").click
		# cos = browser.find('li a', title: "Kraków Głowny")
		# puts cos
		browser.fill_in('seek[stname][1]', :with => @end_station_name)
		browser.find("a[title='#{@end_station_name}']").click

		travel_date = @date.strftime
		puts "performing crawl for #{travel_date}"
		browser.fill_in('seek[date]', :with => travel_date)

		browser.click_on 'Szukaj'
		sleep(7)

		puts "	znaleziono #{browser.all(".train_main_content_box li", :visible=>false).count} połączeń PKP"



		browser.all(".train_main_content_box li", :visible=>false).each do |c|
			#check if connection is INTERCITY PREMIUM
			unless c.first(".ramka_eip").nil?
				route = c.first("div", :visible=>false)[:id]
				#puts " processing EIP #{route} ..."

				departure_time = c.first(".godziny.do_prawej", :visible=>false)
				departure_date = c.all(".daty.do_lewej", :visible=>false).last
				arrival_time = c.first(".godziny.do_lewej", :visible=>false)
				arrival_date = c.all(".daty.do_prawej", :visible=>false).last
				price = c.first("#cena_klasa_2", :visible=>false)

				#check if there is an hour and price field in connection div
				unless departure_time.nil? || price.nil?
					puts "	---------------------------------------"
					puts "	processing EIP #{route} ..."

					puts "	departure time: #{departure_time.text}"
					puts "	arrival time: #{arrival_time.text}"
					puts "	price: #{price.text}"

					#detect if click needed
					if price.text == "Sprawdź cenę od w klasie 2"
						puts "	click needed!"
						puts "	running JS: $('##{route} #cena_klasa_2').click()"

						#capybara click couldnt help so JS click is triggered
						browser.execute_script("$('##{route} #cena_klasa_2').click()")
						while price.text.empty? do
							#binding.pry
							price = c.first("#cena_klasa_2", :visible=>false)
							sleep(2) if price.text.empty?
						end
						puts "	price: #{price.text}"
					end

					dt = Time.parse(departure_time.text)
					dd = Date.parse(departure_date.text)
					at = Time.parse(arrival_time.text)
					ad = Date.parse(arrival_date.text)

					departure_datetime = DateTime.new(dd.year, dd.month, dd.day, dt.hour, dt.min)
					arrival_datetime = DateTime.new(ad.year, ad.month, ad.day, at.hour, at.min)

					@results << Course.new(departure_time: departure_datetime, arrival_time: arrival_datetime, price: price.text.split(/\W+/)[5].to_f, connection: @connection)
				end
			end
		end

		@results

	end

end