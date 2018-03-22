desc "This task is called by the Heroku scheduler add-on"
task :expired_test => :environment do
  puts "expired test"
  puts "it works."
end

task :toot => :environment do

    client = Mastodon::REST::Client.new(base_url: ENV["MASTODON_URL"], bearer_token: ENV["ACCESS_TOKEN"])
    @keywords = Keyword.all

    #ローカルタイムラインの指定キーワードを含むTootのBoost
    client.public_timeline(:local => true, :limit => 10000).each do |toot|
      @keywords.each do |keyword|
        if /#{keyword}/ =~ toot.content then 
          response = client.reblog(toot.id)
        end
      end
    end
      
    #連合タイムラインの指定キーワードを含むTootのBoost
    client.public_timeline(:limit => 10000).each do |toot|
      @keywords.each do |keyword|
        if /#{keyword}/ =~ toot.content then 
          response = client.reblog(toot.id)
        end
      end
    end
end
