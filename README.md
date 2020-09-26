# Tweetstorm generator

### The challenge:

Do you know what a **Tweetstorm** is?

It's a way to bypass Twitter's blessed 140 chars limit.

It allows you to break down a larger corpus of text into tweets and post them in quick succession, forming a cohesive whole.

Since Twitter can barely count (and monotonically increasing numbers is hard!), the final order in which users will see the sequence might not be the one you posted. Or someone retweeted it, losing context.

In order to keep some sense of narrative and connection you prefix each piece of the corpus with the part that it represents (1/4, then 2/4 then 3/4 then 4/4).

**We just need to see the contents of each tweet on the screen, you don't need to integrate with Twitter API and really authenticate or post it to Twitter.**

### Assignment:

Create a program that receives a text of arbitrary length and creates a tweetstorm with it.

### Rules:

1. Each tweet can't be over 140 characters,
2. Each tweet must be prefixed with the current index / total count.
3. We'll call your program from a Unix shell, like /opt/hiring/yourname/tweetstormgenerator, with the text corpus passed as a parameter
4. You can only use Ruby language and stick to its built in library (if actually think you need a third-party lib to achieve this, we're curious to know what that would be).

### Jeff Notes
Developed with ruby version: 2.7.1

#### Instructions to run
1) clone repo
2) in repo directory, run:
`ruby main.rb "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc maximus lacus et dolor volutpat rhoncus. Praesent neque dolor, mollis at enim at, pulvinar ultrices ante. Suspendisse tristique varius enim, at porta odio egestas feugiat. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Ut id felis nulla. Sed molestie a libero in pulvinar. Morbi ipsum purus, maximus ac eros et, interdum auctor est. Sed fringilla erat turpis, sit amet dapibus arcu commodo porta. Fusce sit amet massa velit.
           Curabitur sed magna interdum lacus congue pellentesque ut in nibh. Aenean eget dictum dolor, at finibus purus. Vestibulum accumsan aliquam ante eu congue. Curabitur tempor vel turpis sed imperdiet. Aliquam ut scelerisque justo. Pellentesque a libero velit. Nulla vestibulum porttitor nibh, vitae feugiat mauris hendrerit at. Aenean facilisis lorem tortor. Nunc ut ex finibus, maximus mauris nec, sodales felis. Donec luctus orci hendrerit, egestas enim id, interdum libero. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nulla ultricies mi in sapien elementum aliquet.
           In ultrices urna tincidunt molestie luctus. Curabitur lacinia enim quis lectus malesuada, quis mollis mi feugiat. Morbi non efficitur ipsum. Morbi eu dignissim justo. Sed porta purus ut sapien sollicitudin, ut tristique massa cursus. Praesent luctus consectetur ex a feugiat. Integer dolor elit, ornare vitae dui nec, mollis porta eros."`

Will output

"1/12 Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc maximus lacus et dolor volutpat rhoncus. Praesent neque dolor, mollis"<br />
"2/12 at enim at, pulvinar ultrices ante. Suspendisse tristique varius enim, at porta odio egestas feugiat. Vestibulum ante ipsum primis in"<br />
"3/12 faucibus orci luctus et ultrices posuere cubilia curae; Ut id felis nulla. Sed molestie a libero in pulvinar. Morbi ipsum purus,"<br />
"4/12 maximus ac eros et, interdum auctor est. Sed fringilla erat turpis, sit amet dapibus arcu commodo porta. Fusce sit amet massa velit."<br />
"5/12 Curabitur sed magna interdum lacus congue pellentesque ut in nibh. Aenean eget dictum dolor, at finibus purus. Vestibulum accumsan"<br />
"6/12 aliquam ante eu congue. Curabitur tempor vel turpis sed imperdiet. Aliquam ut scelerisque justo. Pellentesque a libero velit. Nulla"<br />
"7/12 vestibulum porttitor nibh, vitae feugiat mauris hendrerit at. Aenean facilisis lorem tortor. Nunc ut ex finibus, maximus mauris nec,"<br />
"8/12 sodales felis. Donec luctus orci hendrerit, egestas enim id, interdum libero. Pellentesque habitant morbi tristique senectus et netus"<br />
"9/12 et malesuada fames ac turpis egestas. Nulla ultricies mi in sapien elementum aliquet. In ultrices urna tincidunt molestie luctus."<br />
"10/12 Curabitur lacinia enim quis lectus malesuada, quis mollis mi feugiat. Morbi non efficitur ipsum. Morbi eu dignissim justo. Sed porta"<br />
"11/12 purus ut sapien sollicitudin, ut tristique massa cursus. Praesent luctus consectetur ex a feugiat. Integer dolor elit, ornare vitae"<br />
"12/12 dui nec, mollis porta eros."

#### Assumptions
1) I can split tweets in the middle of sentences so one half of a sentence is in one tweet and another in the next tweet
2) I cannot split a word between two tweets, a single word must appear in a single tweet (for readability)
3) If a tweet is less or equal to 140 characters, I don't need to add a prefix (like 1/1)
4) I don't need to maximize that all 140 characters be used for every tweet including the prefix.  The problem I am avoiding is that if a generated tweet chunk is 140 character count,
then I will need to make adjustments to it and the subsequent generated tweet for more space because to add the prefix, I will need at least 4 more characters.
5) I am throwing an exception if a single word exceeds 140 character count because of assumption #2
6) Because of assumption #4, the script can't handle cases where 100 or more tweets are generated since there might not be enough room to add the prefix like (100/101), an exception is thrown in this case


#### Code design
- main.rb is the code to be run on terminal
- tweetstorm_generator.rb is the internal implementation (can be unit tested)
    - made up of 3 operations: generate_tweet_chunks, append_prefix_to_tweets! and verify_tweets_char_count
    - verify_tweets_char_count can be removed, but I felt it was useful to check all generated tweets are within 140 character count

#### Tests that can be added
No tests were written to avoid adding third party libraries (like RSpec) because of the instructions in the readme to only use base Ruby.
But if I were to write tests then I listed them below.  Some of the methods are private, but can be class methods in their own classes or made public to be able to be called in unit tests
- generate_tweet_chunks
    - a string than 140 chars should generate 1 tweet (array size == 1)
    - a string of 200 chars should generate 2 tweets (array size == 2)
    - exception is raise if a string with a word exceeding 140 chars is passed
- append_prefix_to_tweets!
    - passing an array of 2 generated tweets, test that the first chars of first tweet == "1/2" and first chars of second tweet ==  "2/2"
    - an exception is thrown if the number of tweets (array of strings) is equal to or more than 100
- verify_tweets_char_count
    - an exception is thrown if tweets contain a tweet that exceed 140 character count
- integration tests (calling TweetstormGenerator.run)
    - passing a string like "Lorem ipsum..." and checking the tweets count (like example above, should be 12 tweets)