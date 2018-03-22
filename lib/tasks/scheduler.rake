desc "This task is called by the Heroku scheduler add-on"
task :expired_test => :environment do
  puts "expired test"
  puts "it works."
end

task :toot => :environment do

    client = Mastodon::REST::Client.new(base_url: ENV["MASTODON_URL"], bearer_token: ENV["ACCESS_TOKEN"])

    client.public_timeline(:local => true, :limit => 10000).each do |toot|
      if /創作/ =~ toot.content then 
        response = client.reblog(toot.id)
      end
    end
      
    #連合タイムラインのBoost
    client.public_timeline(:limit => 10000).each do |toot|
      if /創作/ =~ toot.content then 
        response = client.reblog(toot.id)
      end
    end
end
