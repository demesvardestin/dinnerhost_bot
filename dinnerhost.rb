require 'bundler/inline'

module DinnerHost
  class Config
    def self.initialize!
      ## Install Twitter if not already installed
      gemfile(true) do
        source 'https://rubygems.org'
        gems 'twitter'
      end
    end

    ## Configure Twitter client
    def self.config(cons_key, cons_sec, token, token_sec)
      client = Twitter::REST::Client.new do |config|
        config.consumer_key        = cons_key
        config.consumer_secret     = cons_sec
        config.access_token        = token
        config.access_token_secret = token_sec
      end
    end
  end

  class Bot
    ## Dispatch bot with 4 attributes: twitter client, search keyword,
    ## loop count, and batch size (number of tweets to grab, default is 1k)
    def self.dispatch(client, keyword, loops, batch_size=1000)
      ## Create/open a file at root directory (serves as 'db')
      f = File.open("users_reached.txt", "w+")

      ## Every 3 hours, grab most recent tweets containing keyword,
      ## check if tweet's user has already been reached by going through above file,
      ## reply to tweet, then update file with user's @handle.
      p "Starting tweet search..."
      tweet_count, loop_count = 0, 0
      loop do
        break if loop_count == loops
        client.search("#{keyword} -rt", result_type: "recent").take(batch_size).collect do |tweet|
          if !File.readlines(f).select {|l| l.include? tweet.user}.empty?
            client.update("Hey @#{tweet.user}, check out dinnerhost.co, an on-demand booking platform for private cooks!")
            f.write("#{tweet.user}\n")
            tweet_count += 1
            p "Replied to @#{tweet.user}"
          end
        end
        
        loop_count += 1
        sleep 10800
      end
      p "Successfully replied to #{tweet_count} tweets! Starting again in 3hrs."
    end
  end
end
