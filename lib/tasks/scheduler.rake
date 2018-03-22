desc "This task is called by the Heroku scheduler add-on"
task :expired_test => :environment do
  puts "expired test"
  puts "it works."
end

task :toot => :environment do

    client = Mastodon::REST::Client.new(base_url: ENV["MASTODON_URL"], bearer_token: ENV["ACCESS_TOKEN"])
    @keywords = Keyword.all

    #指定のハッシュタグを含むTootのBoost
    @keywords.each do |keyword|

      client.hashtag_timeline(keyword.key, :limit => 100).each do |toot|
          response = client.reblog(toot.id)
          response = client.favourite(toot.id)
      end
    end
end

task :follow => :environment do
  client = Mastodon::REST::Client.new(base_url: ENV["MASTODON_URL"], bearer_token: ENV["ACCESS_TOKEN"])

  @keywords = Keyword.all

  @keywords.each do |keyword|
    
    client.hashtag_timeline(keyword.key, :limit => 5).each do |toot|
      response = client.follow_by_uri(toot.uri)
    end
  end
end