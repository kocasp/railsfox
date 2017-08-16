class ConnectionWorker
  include Sidekiq::Worker

  def perform(no_days, connection_id)
    Action::Crawl::Intercity.new(DateTime.now, DateTime.now+no_days.days, Connection.find(connection_id)).execute
  end

  def self.job_name(start_time = DateTime.now, end_time = DateTime.now+30.days, connection)
    "ROBOTA"
  end
end
