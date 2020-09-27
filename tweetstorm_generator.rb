require_relative 'exceptions'

class TweetstormGenerator
  MAX_PREFIX_COUNT = 6 # for prefix like 11/20, does not support 101/120
  MAX_TWEETS_COUNT = 100
  MAX_TWEET_CHAR_COUNT = 140
  MAX_TWEET_BUFFER = MAX_TWEET_CHAR_COUNT - MAX_PREFIX_COUNT

  def self.run(tweet_str)
    return [tweet_str] if tweet_str.size <= MAX_TWEET_CHAR_COUNT

    tweets = generate_tweet_chunks(tweet_str)
    append_prefix_to_tweets!(tweets)
    verify_tweets_char_count(tweets) # can be removed

    tweets
  end

  class << self
    private

    def generate_tweet_chunks(tweet_str)
      tweets = []
      tweet = ''

      tweet_str.split(' ').each do |word|
        raise WordExceedCharCountException unless within_max_char_count?(word)

        if tweet.empty?
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

    def append_prefix_to_tweets!(tweets)
      tweets_count = tweets.count
      raise MaxTweetsException if tweets_count >= MAX_TWEETS_COUNT

      tweets.each.with_index do |tweet, index|
        page_index = index + 1
        tweets[index] = "#{page_index}/#{tweets_count} #{tweet}"
      end
    end

    def verify_tweets_char_count(tweets)
      tweets.each do |tweet|
        raise TweetExceedMaxCharCountException if tweet.size > MAX_TWEET_CHAR_COUNT
      end
    end

    def within_max_char_count?(str)
      str.size < MAX_TWEET_BUFFER
    end
  end
end

