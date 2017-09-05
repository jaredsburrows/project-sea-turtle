require "stringex"
require "rubygems"
require "json"
require "net/http"

class Jekyll < Thor
  desc "new", "create a new post"
  method_option :editor, :default => "subl"
  def new()
    url = "https://newsapi.org/v1/articles?source=breitbart-news&sortBy=top&apiKey=63c394c42ffd45afab11bb4928a4b879"
    uri = URI(url)
    response = Net::HTTP.get(uri)
    json = JSON.parse(response)

    json["articles"].each do |article|

      title = article["title"].gsub(/[^0-9a-z ]/i, '')
      description = article["description"].gsub(/[^0-9a-z ]/i, '')
      url = article["url"].gsub(/[^0-9a-z ]/i, '')
      urlToImage = article["urlToImage"].gsub(/[^0-9a-z ]/i, '')

      date = Time.now.strftime("%Y-%m-%d")
      # filename = "./_posts/#{date} - #{title}.markdown"
      filename = "_posts/#{date}-#{title.to_url}.markdown"

      puts "Creating new post: #{filename}"
      open(filename, "w") do |post|
        post.puts "---"
        post.puts "layout: post"
        post.puts "title: #{title}"
        post.puts "tags:"
        post.puts " -"
        post.puts "---"
        post.puts "#{description}"
      end

      system(options[:editor], filename)

    end
  end
end
