require 'json'
load './mylogger.rb'
load './mytwitter.rb'
load './instapaper.rb'

class TweetBookMark
  include MyLogger
  def execute
    settings = load_json("settings.txt")
    stored_urls = load_json("urls.txt")
    urls = MyTwitter.new(settings).gather_hatebu_urls_without_ng(/艦隊*これ/).reverse!
    new_urls = urls.reject {|url| stored_urls.include? url}
    Instapaper.new(settings).add_all_with_hatebu(new_urls)
    store_json(urls, "urls.txt")
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

TweetBookMark.new.execute