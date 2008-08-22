require 'classifier'
require 'markov_chain'
require 'laplace'

class MarkovChain
	def add_words words
		example words
	end	
end

class MarkovChainClassifier < Classifier
		
	def initialize opts
		@include_start_end = opts[:include_start_end]
		super()
	end
	
	def new_class_info
		MarkovChain.new
	end
			
	def probability_of_words_given_class words, clas
		chain = @class_info[clas]
		#puts " chain #{chain.inspect}"
		probs = prob_fractions_of_words chain, words
		probs = probs.apply_estimator if probs.has_at_least_one_zero?
		#puts "post estimator (if required) #{probs.inspect}"
		#puts "result is #{probs.log_sum}"
		probs.log_sum
	end
	
	def prob_fractions_of_words chain, words
		last_word = nil
		probs = []
		words.each do |word|	
			if last_word.nil?
				probs << chain.start_prob(word) if @include_start_end
			else
				probs << chain.trans_prob(last_word, word)				
			end
			#puts "considering chain for [#{clas}] for '#{last_word}' -> '#{word}' probs now #{probs.inspect}"
			last_word = word
		end
		probs << chain.end_prob(last_word) if @include_start_end
		probs
	end
	
	def display_name
		"#{self.class}_#{@include_start_end}"
	end
	
end