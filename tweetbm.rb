require 'json'
load 'mylogger.rb'
load 'mytwitter.rb'
load 'instapaper.rb'
load 'pocket.rb'

class TweetBookMark
  include MyLogger
  def call
    settings = load_json("settings.txt")
    stored_urls = load_json("urls.txt")
    twitter = MyTwitter.new(settings)
    ng_words = load_json("ng_words.txt")
    urls = twitter.gather_hatebu_urls_without_ng(ng_words).reverse!
    new_urls = urls.reject {|url| stored_urls.include? url}
    Instapaper.new(settings).add_all(new_urls)
    Pocket.new(settings).add_all(new_urls)
    store_json(urls, "urls.txt")
    twitter.dump_recorded
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