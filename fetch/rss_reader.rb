require 'rss/1.0'
require 'rss/2.0'
require 'open-uri'
require 'hpricot'

class RssReader

 def initialize source
  content = ""
  begin
   open(source) do |s| content=s.read end
   @rss = RSS::Parser.parse(content, false)
  rescue Exception => e
   $stderr.print Time.now, ' read ', source, ' failed ', e.message, "\n"
  end
 end

 def items_with_date
  return [] if @rss==nil
  @rss.items.select { |item| item.respond_to? 'date' and item.date }
 end

 def items_since date
  items_with_date.select { |item| item.date > date }
 end

 def date_of_most_recent
  items = items_with_date
  return nil if items.size==0
  most_recent = items.first.date
  items.each do |item|
    most_recent = item.date if item.date > most_recent
  end 
  most_recent
 end

 def scraped_description item
  # parse text with hpricot
  doc = Hpricot(item.description)
  # select only the text elements
  text_elems = (doc/'*').select { |i| i.is_a? Hpricot::Text }
  # concat them all together into one string
  scraped = text_elems.inject('') do |str, i| 
   # hpricot still gets confused sometimes, remove final <>s
   str << (i.to_s.gsub /\<.*\>/, '') << ' ' 
  end
  # clean up white space
  scraped.gsub! /\n/, ' '
  scraped.gsub! /\s+/, ' '
  scraped
 end
 
 def dump_dates
  return if @rss==nil
  @rss.items.each { |item|
   print "date of item: ", item.date, "\n"
  }
 end

end
