require_relative 'tweetstorm_generator'


if ARGV[0].nil?
  p "Incorrect argument, expecting a String"
end

tweets = TweetstormGenerator.run(ARGV[0])

tweets.each do |tweet|
  p tweet
end