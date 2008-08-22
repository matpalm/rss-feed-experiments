#!/usr/bin/env ruby
require 'parser'
require 'the_register_rules'
require 'multinominal_bayes_classifier'; 

rules = TheRegisterRules.new
c = MultinominalBayesClassifier.new

total =0 
correct = 0

Parser.new.articles_from_stdin do |a|
	a[:should_read] = rules.should_read(a)
	c.train(a[:words], a[:should_read])

	total += 1
	result = c.classify(a[:words])		
	correct += 1 if result.length==1 && result[0] == a[:should_read]
	percentage_correct = correct.to_f / total * 100
	puts "classified as #{result.inspect}, is actually #{a[:should_read]}; correct #{correct}/#{total} = #{percentage_correct}%"
end
