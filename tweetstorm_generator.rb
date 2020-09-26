require_relative 'exceptions'

class TweetstormGenerator
  MAX_PREFIX_COUNT = 6 # for prefix like 11/20, does not support 101/120
  MAX_TWEETS_COUNT = 100
  MAX_TWEET_CHAR_COUNT = 140 - MAX_PREFIX_COUNT

  def self.run(tweet_str)
    return tweet_str if tweet_str.size <= 140

    tweets = generate_tweet_chunks(tweet_str)
    append_prefix_to_tweets!(tweets)

    tweets
  end

  class << self
    private

    def append_prefix_to_tweets!(tweets)
      tweets_count = tweets.count
      raise MaxTweetsException if tweets_count >= MAX_TWEETS_COUNT

      tweets.each.with_index do |tweet, index|
        page_index = index + 1
        tweets[index] = "#{page_index}/#{tweets_count} #{tweet}"
      end
    end

    def generate_tweet_chunks(tweet_str)
      tweets = []
      tweet = ''

      tweet_str.split(' ').each do |word|
        raise WordExceedCharCountException unless within_max_char_count?(word)

        if tweet.empty? && within_max_char_count?(word)
          tweet = word
        elsif within_max_char_count?("#{tweet} #{word}")
          tweet = "#{tweet} #{word}"
        else
          tweets << tweet
          tweet = word
        end
      end

      unless tweet.empty?
        tweets << tweet
      end

      tweets
    end

    def within_max_char_count?(str)
      str.size < MAX_TWEET_CHAR_COUNT
    end
  end
end

