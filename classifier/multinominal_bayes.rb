#!/usr/bin/env ruby
require 'classifier/classifier.rb'
require 'laplace' 

class MNClassInfo
	attr_reader :count
	attr_reader :words_freq
	
	def initialize
		@num_words = 0
		@words_freq = {}
	end	
	
	def add_words words
		@num_words += words.size
		words.each do |word|
			@words_freq[word] ||= 0
			@words_freq[word] += 1
		end
	end
	
	def has word
		@words_freq.has_key? word
	end
	
	def probability_of word		
		[frequency_of(word),  @num_words]
	end
	
	def frequency_of word
		@words_freq[word] ? @words_freq[word] : 0		
	end

end

class Fixnum
	def factorial
		return 1 if self<=1
		return 2 if self==2
		return @cached_fact if @cached_fact
		@cached_fact = calc_fac
	end

	private
	def calc_fac 
		prod = 1
		self.times { |i| prod*=(i+1) }
		prod
	end
end
	
class MultinominalBayesClassifier < Classifier
		
	def new_class_info
		MNClassInfo.new
	end
	
	def probability_of_words_given_class words, clas
		probability_of_words_minimal words, clas
	end
	
	# true impl of probability of words
	# warning for even a half decent sized test document words.size! will be HUGE
#	def probability_of_words(words, clas)
#		operands = multinominal_operands words, clas
#		operands.inject(1) {|accum, fr| accum * (fr[0].to_f / fr[1]) } * words.size.factorial
#	end

	# minimal impl of word prob
	# can be used for comparisons (ignores irrelevant * factorial and Math.exp)
	# uses logs instead of * since probabilties are tiny
	def probability_of_words_minimal(words, clas)					
		operands = multinominal_operands words, clas
		operands = operands.apply_estimator if operands.has_at_least_one_zero?
		operands.log_sum		
	end

	def multinominal_operands words, clas
		wofs = probability_of_words_over_frequencies(words, clas)
		operands = wofs.collect { |wof| multinominal_operand(wof) }		
	end

    def probability_of_words_over_frequencies(words, clas)
        class_info = @class_info[clas]
        return nil if class_info.nil?
        result_operands = []
        word_hash = hash_for words
        word_hash.keys.each do |word|
            freq_of_word = word_hash[word]
            freq_of_word ||= 0
            word_prob = class_info.probability_of word
            result_operands << [word_prob, freq_of_word]
        end
        result_operands
    end
    
    def multinominal_operand word_over_freq
		prob, freq = word_over_freq
		return nil if freq==0 
		return prob if freq==1
		prob_num, prob_denom = prob
		return nil if prob_denom==0 
		[prob_num**freq, (prob_denom**freq)*freq.factorial]
	end
	
	def hash_for words
		hash = {}
		words.each do |word| 
			hash[word] ||=0
			hash[word]+=1
		end
		hash
	end


end
				

		