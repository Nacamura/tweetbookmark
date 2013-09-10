require 'twitter'

class MyTwitter
	def initialize(settings)
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

	def gather_hatebu_urls_without_ng(regexp)
		gather_timeline.select do |t|
			puts t.text if t.text.match(regexp) #debug
			t.text.match(regexp).nil?
		end.map do |t|
			t.text.slice(/http[^\s]*$/)
		end
	end
end