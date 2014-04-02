require 'twitter'

class MyTwitter
	include MyLogger
	def initialize(settings)
		@logger = get_logger
		Twitter.configure do |config|
			config.consumer_key = settings["consumer_key"]
			config.consumer_secret = settings["consumer_secret"]
			config.oauth_token = settings["access_token"]
			config.oauth_token_secret = settings["access_token_secret"]
		end
		@target_user = settings["target_user"]
		@count = settings["count"]
	end

	def gather_timeline
		Twitter.user_timeline(@target_user, options={:count => @count})
	end

	def gather_hatebu_urls
		gather_timeline.map do |t|
			t.text.slice(/http[^\s]*$/)
		end
	end

	def gather_hatebu_urls_without_ng(ng_words)
		gather_timeline.reject do |t|
			has_ng_word?(t.text, ng_words)
		end.map do |t|
			t.text.slice(/http[^\s]*$/)
		end
	end

	def has_ng_word?(text, ng_words)
		has_ng_word = false
		ng_words.each do |ng_word|
			has_ng_word = (text.match(ng_word) != nil)
			break if has_ng_word
		end
		@logger.debug("skip:" + text) if has_ng_word
		has_ng_word
	end

end