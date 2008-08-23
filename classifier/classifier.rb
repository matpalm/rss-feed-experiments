require 'set'

class Classifier
	
	def initialize			
		reset
	end
	
	def reset		
		@class_info = {}
		@classes = Set.new
	end
	
	def train(words, clas)
		#puts "train with #{words.inspect} for class #{clas}"
		@classes << clas	
		@class_info[clas] ||= new_class_info
		@class_info[clas].add_words(words)
	end
	
	def classify words
		max_prob = nil
		max_prob_class = []
		@classes.each do |clas|
			prob = probability_of_words_given_class words, clas
			if prob == max_prob or max_prob==nil
				max_prob = prob
				max_prob_class << clas
			elsif prob > max_prob
				max_prob = prob
				max_prob_class = [clas]
			end
		end
		max_prob_class
	end
		
end
