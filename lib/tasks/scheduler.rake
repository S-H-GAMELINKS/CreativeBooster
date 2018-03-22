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

      client.hashtag_timeline(keyword, :limit => 1000).each do |toot|
        if /#{keyword}/ =~ toot.content
          response = client.reblog(toot.id)
        end
      end
    end
end