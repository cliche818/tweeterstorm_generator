# exception for a word that exceeds the maximum tweet count - prefix size count
class WordExceedCharCountException < StandardError

end

# exception for too many tweets generated (script does not support 100 or more tweets generated)
class MaxTweetsException < StandardError

end

# exception for if a single generated tweet character count exceeded 140
class TweetExceedMaxCharCountException < StandardError

end