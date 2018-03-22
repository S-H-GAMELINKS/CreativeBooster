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

      client.hashtag_timeline(keyword.key, :limit => 500).each do |toot|
        if !toot.reblogged? then
          response = client.reblog(toot.id)
          response = client.favourite(toot.id)
        end
      end
    end
end

task :follow => :environment do
  client = Mastodon::REST::Client.new(base_url: ENV["MASTODON_URL"], bearer_token: ENV["ACCESS_TOKEN"])

  @keywords = Keyword.all

  @keywords.each do |keyword|
    
    client.hashtag_timeline(keyword.key, :limit => 5).each do |toot|
      url = toot.account.acct
      response = client.follow_by_uri(url)
    end
  end
end

task :unfollow => :environment do
  client = Mastodon::REST::Client.new(base_url: ENV["MASTODON_URL"], bearer_token: ENV["ACCESS_TOKEN"])

  @keywords = Keyword.all

  @keywords.each do |keyword|
    
    client.hashtag_timeline(keyword.key, :limit => 5).each do |toot|
      id = toot.account.id
      response = client.unfollow(id)
    end
  end
end
