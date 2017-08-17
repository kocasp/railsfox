class ConnectionCrawlMailer < ActionMailer::Base
  default from: "crawl-confirmation@pkpfox.pl"

  def confirm_crawl(connection)
    @connection = connection
    mail(to: "kocasp@gmail.com", subject: 'Connection crawl has been succesfully completed')
  end
end
