#!/usr/bin/ruby

classifiers = [
	'MAlgoClassifier', 
	'WordOccClassifier', 
	'NaiveBayesClassifier', 
	'MultinominalBayesClassifier',
	'MarkovChainClassifier_true'
	]

titles = { 'MAlgoClassifier' => 'm-algorithm',
              'WordOccClassifier' => 'word occurences',
              'NaiveBayesClassifier' => 'naive bayes',
              'MultinominalBayesClassifier' => 'multinominal bayes',
	      'MarkovChainClassifier_false' => 'markov chain (exclude start/end)',
	      'MarkovChainClassifier_true' => 'markov chain'
	      }.freeze
	      
results = {}
class Result
	attr_reader :classifier
	def initialize classifier
		@classifier = classifier
		@scores = []
	end
	def add_result score
		@scores << score.to_f
	end
	def score idx
		@scores[idx]
	end
	def sort_results
		@scores.sort!
	end
	def average
		sum = @scores.inject(0) { |s,n| s+=n }
		sum.to_f / @scores.length
	end
	def min		
		@scores.inject(@scores.first) { |a,b| a<b ? a:b }
	end
	def max
		@scores.inject(@scores.first) { |a,b| a>b ? a:b }
	end
	def median
		@scores.sort[@scores.length/2]	
	end
end

def average_func_for classifier
	"#{classifier}_average(x)"
end
def min_func_for classifier
	"#{classifier}_min(x)"
end
def max_func_for classifier
	"#{classifier}_max(x)"
end

def gnuplot_preamble file, result_num
file.puts <<EOF
#!/usr/bin/gnuplot
set terminal png transparent nocrop enhanced size 300,480
set output 'result#{result_num}.png'
set xlabel "slice"
set xrange [-0.5:15.5]
set ylabel "accuracy"
set yrange [-0.05:1.05]
set ytics 0.1
set title "classifier comparison"
set key right bottom
EOF

end

STDIN.each do |line|		
	next unless line =~ /^result/
	classifier, result = line.chomp.gsub(/result /,'').split(/ /)
	results[classifier] = Result.new(classifier) unless results[classifier]
	results[classifier].add_result result
end

#results.keys.each {|k| results[k].sort_results}

dat = File.new('result.dat','w')
eg_result = results[results.keys.first]
continue = true
idx=0
while continue	
	dat.puts classifiers.collect { |k| results[k].score idx }.join(' ')
	idx += 1
	continue = ! eg_result.score(idx).nil?
end
dat.close

gnuplot = File.new('result.gp','w')
gnuplot_preamble gnuplot, 1
results.keys.each do |classifier|
	gnuplot.puts "#{average_func_for classifier}=#{results[classifier].median}"
end
plots = []
classifiers.each_with_index do |classifier, i|
	i += 1
	plots << "'result.dat' using #{i} notitle with points pt 2 lt #{i} lw 1"
	plots << "#{average_func_for classifier} title '#{titles[classifier]}' with lines lt #{i} lw 2"
end
gnuplot.puts "plot #{plots.join(',')}"
gnuplot.close
