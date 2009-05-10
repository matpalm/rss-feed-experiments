#!/usr/bin/env ruby
require 'parser'
#require 'the_register_rules'
require 'classifier/vector_space_model' 

#rules = TheRegisterRules.new
c = VectorSpaceModel.new

total =0 
correct = 0

Parser.new.articles_from_stdin do |a|
	a[:classification] = a[:url]
	c.train(a[:words], a[:classification])

	total += 1
	result = c.classify(a[:words])		
	correct += 1 if result.length==1 && result[0] == a[:classification]
	percentage_correct = correct.to_f / total * 100
	puts "classified as #{result.inspect}, is actually #{a[:classification]}; correct #{correct}/#{total} = #{percentage_correct}%"
end
