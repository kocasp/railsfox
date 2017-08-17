
task :test_task => :environment do
  ConnectionCrawlMailer.confirm_crawl(Connection.last).deliver_now
end
