#!/usr/bin/env ruby

require 'parser'
require 'the_register_rules'
require 'the_register_or_lamborghini_rules'

require 'classifier/m_algo'
require 'classifier/word_occ'
require 'classifier/naive_bayes'
require 'classifier/multinominal_bayes'
require 'classifier/markov_chain'

require 'cross_validator'
require 'yaml'

slice, num_slices = ARGV

articles = []
Parser.new.articles_from_stdin do |a|
	a[:classification] = a[:url]
	articles << a 
end


classifiers = []
#classifiers << MAlgoClassifier.new
classifiers << WordOccClassifier.new
classifiers << NaiveBayesClassifier.new
classifiers << MultinominalBayesClassifier.new
classifiers << MarkovChainClassifier.new(:include_start_end => true)

classifiers.each do |classifier|
	result = CrossValidator.new(classifier).validate(articles, slice.to_i, num_slices.to_i)	
	display_name = classifier.respond_to?(:display_name) ? classifier.display_name : classifier.class.to_s
	puts "result #{display_name} #{result}"
end