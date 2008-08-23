#!/usr/bin/env ruby
require 'rss_poller'
rp = RssPoller.new
File.open(ARGV[0]).each { |url| rp.add_url url.chomp! }
rp.write_latests
