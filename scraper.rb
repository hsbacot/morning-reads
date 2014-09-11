#!/usr/bin/env ruby

# executable 
# chmod +x name.rb

require 'nokogiri'
require 'open-uri'
require 'json'
require 'pony'

# get most recent article in medium collection & email to self
###### COLLECTIONS #####
# coffee time
# business development
# better humans

class Article
  attr_accessor :title, :link, :collection
end

class Reader
  
  def initialize
    @base = "https://medium.com"
    @collections = ["coffee-time-1", "business-startup-development-and-more", "better-humans", "race-class", "futures-exchange", "online-marketing"]
    @articles = []
    @body = ""
  end

  def get_articles
    puts "Getting Articles"
    @collections.each do |collection|
      doc = Nokogiri::HTML(open("#{@base}/#{collection}"))
      # if doc.css('.bucket-item .postItem-title a') returns [] use other layout
      if doc.css('.bucket-item .postItem-title a').empty?
        link = doc.css('.blockGroup--posts .block-title a').first
      else
        link = doc.css('.bucket-item .postItem-title a').first
      end
      href = @base + link.attributes["href"].value
      title = link.text
      a = Article.new
      a.title = title
      a.link = href
      a.collection = collection.split("-").map(&:capitalize).join(" ")
      @articles << a
      puts a.collection
      puts a.title
      puts "\n"
      @body << "#{a.collection} \n#{a.title} \n#{a.link}\n\n"
    end 
  end


  def send_reads
    puts "Sending Mail"
    Pony.mail(
      to: "your_email@placeholder.com",
      from: "readborg@260moore.com",
      subject: "Your Read!",
      body: @body
    )
  end
end

r = Reader.new
r.get_articles
r.send_reads
