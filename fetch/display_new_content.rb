#!/usr/bin/env ruby
require 'rss_poller'
$data_file = ARGV[0].chomp
p = RssPoller.new.display_new_content
