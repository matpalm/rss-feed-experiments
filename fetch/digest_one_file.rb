#!/usr/bin/ruby
require 'ftools'
require 'word_digester'

def today_dts 
 time_now = Time.now
 ret = time_now.year.to_s
 ret << '0' if time_now.month < 10
 ret << time_now.month.to_s
 ret << '0' if time_now.day < 10
 ret << time_now.day.to_s
 ret.to_i
end

def file_to_process
 `ls data/heading*`.each_line do |file|
  file.chomp!
  file.gsub! /data./, ''
  dts = file.gsub /.*headings./, ''
  print "next dts #{dts}\n"
  return file if dts.to_i < today_dts
  break
 end
 nil
end

raise "two args please" unless ARGV.length==2
src,dest = ARGV

wd = WordDigester.new
wd.collect_words_from_file src
wd.remove_single_character_words
wd.save dest
