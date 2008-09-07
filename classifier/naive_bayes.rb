#!/usr/bin/env ruby
require 'classifier/classifier.rb'
require 'laplace'

class ClassInfo
	attr_reader :count
	attr_reader :words_freq
	
	def initialize
		@count = 0
		@words_freq = {}
	end
		
	def add_words words
		@count += 1
		words.uniq.each do |word|
			@words_freq[word] ||= 0
			@words_freq[word] += 1
		end
	end
	
	def probability_of word
		[frequency_of(word), count]
	end

	private

	def frequency_of word
		@words_freq[word] ? @words_freq[word] : 0
	end

end

class NaiveBayesClassifier < Classifier

	def reset
		@total_training_examples = 0		
		super
	end
	
	def train(words, clas)		
		@total_training_examples += 1
		super words, clas
	end
	
	def new_class_info
		ClassInfo.new		
	end
	
	def probability_of_words_given_class words, clas
		prob_fractions = conditional_probabilities_with_estimator_if_required words.uniq, clas
		prob_fractions.log_sum
	end

    def conditional_probabilities_with_estimator_if_required(words, clas)
        probabilities = conditional_probabilities(words,clas)
        probabilities = probabilities.apply_estimator if probabilities.has_at_least_one_zero?
        probabilities
    end

    def conditional_probabilities(words, clas)
        words.collect { |word| conditional_probability(word, clas) }
    end

    def conditional_probability(word, clas)
        class_info = @class_info[clas]
        return 0 unless class_info
        class_info.probability_of(word)
    end

end

		