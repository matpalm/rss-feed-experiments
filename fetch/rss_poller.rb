require 'yaml'
require 'rss_reader'

class RssPoller 

 def initialize 
  read_latests
 end

 def read_latests
  if File.exists? 'latest.yaml'
   file = File.open("latest.yaml","r")
   @latests = YAML.load(file)
   file.close
  else
   @latests = {}
  end
 end

 def write_latests 
  file = File.open("latest.yaml","w")
  YAML.dump(@latests, file)
  file.close
 end

 def add_url url 
  @latests[url] ||= Time.parse("1 jan 2007") 
 end  

 def display_new_content
  data = File.open($data_file, 'a')
  at_least_one_modified = false
  @latests.each do |url, time| 
   print Time.now, "\n\tchecking #{url}\n"
   reader = RssReader.new url
   items = reader.items_since time
   print "\t\t#{reader.items_with_date.size} items in feed, #{items.size} new items since last check at #{time}\n"
   if (items.size > 0) 
    at_least_one_modified = true
    items.each do |item| 
     desc = reader.scraped_description item
     data.print "#{url}|#{item.date}|#{desc}\n" 
    end
    most_recent = reader.date_of_most_recent
    @latests[url] = most_recent
   end
  end
  write_latests if at_least_one_modified
  data.close
 end

end	
