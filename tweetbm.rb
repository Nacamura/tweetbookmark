require 'json'
load './tweetbookmark/mylogger.rb'
load './tweetbookmark/mytwitter.rb'
load './tweetbookmark/instapaper.rb'
load './tweetbookmark/pocket.rb'

class TweetBookMark
  include MyLogger
  def call
    settings = load_json("./tweetbookmark/settings.txt")
    stored_urls = load_json("./tweetbookmark/urls.txt")
    twitter = MyTwitter.new(settings)
    ng_words = settings["ng_words"]
    urls = twitter.gather_hatebu_urls_without_ng(ng_words).reverse!
    new_urls = urls.reject {|url| stored_urls.include? url}
    Instapaper.new(settings).add_all(new_urls)
    Pocket.new(settings).add_all(new_urls)
    store_json(urls, "./tweetbookmark/urls.txt")
  end

  def load_json(textfile_path)
    open(textfile_path) do |io|
      JSON.load(io)
    end
  end

  def store_json(array, textfile_path)
    open(textfile_path, "w") do |io|
      JSON.dump(array, io)
    end
  end
end