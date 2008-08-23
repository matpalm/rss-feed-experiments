#!./usr/bin/env ruby

class WordOccClassifier
	def initialize	
		reset
	end
	
	def reset
		@words_per_feed = {} # feed url-> set of words
	end
	
	def train(words, clas)
		@words_per_feed[clas] ||= Set.new
		@words_per_feed[clas].merge(words)
#		puts "trained with words #{words.inspect} for class [#{clas}] now includes #{@words_per_feed[clas].inspect}"
	end
	
	def classify(words)
		max_common = 0
		result = []
		@words_per_feed.keys.each do |clas|			
			num_common = @words_per_feed[clas].intersection(words).size	
#			puts "classifying #{words.inspect} num_common=#{num_common} for class [#{clas}]"
			if num_common == max_common and max_common>0
				result << clas
			elsif num_common > max_common
				result = [clas]
				max_common = num_common
			end
		end
#		puts "classifying #{words.inspect} as #{result.inspect}"
		return result
	end
		
end