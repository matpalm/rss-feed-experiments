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
#classifiers << MultinominalBayesClassifier.new
classifiers << MarkovChainClassifier.new(:include_start_end => true)

crossvalidators = classifiers.collect { |classifier| CrossValidator.new(classifier, slice.to_i, num_slices.to_i) }

articles.each_with_index do |article, idx|
	crossvalidators.each do |crossvalidator|
		crossvalidator.training_pass idx, article	
	end
end
articles.each_with_index do |article, idx|
	crossvalidators.each do |crossvalidator|
		crossvalidator.testing_pass idx, article	
	end
end

crossvalidators.each do |crossvalidator|
	classifier = crossvalidator.classifier
	display_name = classifier.respond_to?(:display_name) ? classifier.display_name : classifier.class.to_s
	puts "result #{display_name} #{crossvalidator.pass_rate}"
end

