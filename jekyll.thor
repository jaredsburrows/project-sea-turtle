require "stringex"
require "json"
require "net/http"
require "thor"

class Jekyll < Thor
  desc "new", "create a new post"
  method_option :editor, :default => "subl"

  def new
    url = "https://newsapi.org/v1/articles?source=cnn&sortBy=top&apiKey=63c394c42ffd45afab11bb4928a4b879"
    uri = URI(url)
    response = Net::HTTP.get(uri)
    json = JSON.parse(response)

    json["articles"].each do |article|
      create_post(article)
    end
  end

  private

  def create_post(article)
    title = sanitize(article["title"])
    description = sanitize(article["description"])
    date = Time.now.strftime("%Y-%m-%d")
    filename = "_posts/#{date}-#{title.to_url}.markdown"

    puts "Creating new post: #{filename}"
    File.open(filename, "w") do |post|
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

  def sanitize(str)
    str.gsub(/[^0-9a-z ]/i, '')
  end
end

Jekyll.start(ARGV)
