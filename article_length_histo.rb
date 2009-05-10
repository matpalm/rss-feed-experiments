require 'parser'
require 'histogram'
require 'fileutils'

url_to_histo = {}
Parser.new.articles_from_stdin do |a|		
	url = a[:url]	
	url_to_histo[url] ||= []
	url_to_histo[url] << a[:words].length
end

ROOT = '/tmp/alh'
FileUtils.mkdir ROOT unless File.exists? ROOT

idx=0
plots = []
url_to_histo.keys.each do |url|	
	word_lengths = url_to_histo[url]
	histo = Histogram.new word_lengths, 100
	puts "#{url} #{word_lengths.size} #{histo.coords.inspect}"	
	
	dat = File.new("#{ROOT}/#{idx}.dat",'w')
	histo.coords.each { |coord| dat.puts coord.join(' ') }	
	dat.close
	
	stipped_url = url.to_s.gsub(/http:../,'').gsub(/\/.*/,'')
	plots << "'#{ROOT}/#{idx}.dat' ti '#{stipped_url}' with boxes" 
	idx += 1
end

gp_script = File.new("#{ROOT}/plot.gp",'w')
gp_script.puts <<EOF
#!/usr/bin/gnuplot
set terminal png transparent nocrop enhanced size 1680,1050
set output '#{ROOT}/output.png'
set style data histogram
set style histogram cluster gap 0
set style fill solid border -1
set boxwidth 0.5
EOF
gp_script.puts "plot #{plots.join(',')}"
gp_script.close
	


	
	