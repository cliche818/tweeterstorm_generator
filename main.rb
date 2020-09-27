require_relative 'tweetstorm_generator'


if ARGV[0].nil?
  p "Incorrect argument, expecting a String"
else
  tweets = TweetstormGenerator.run(ARGV[0])

  p '-----------Tweets---------------------------'

  tweets.each do |tweet|
    p tweet
  end
end
