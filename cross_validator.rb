#!/usr/bin/env ruby

class CrossValidator
	
	def initialize classifier
		@classifier = classifier
	end
	
	def validate articles, slice, num_slices
		puts "slice #{slice} num_slices #{num_slices}"
		split_articles = split(articles, num_slices)
		testing_set, training_set = training_test_for split_articles, slice			
		train(training_set)
		test(testing_set)					
	end
	
	def split(array, num_slices) 
		slices = []
		from = 0
		size = array.length / num_slices
		continue = true
		while continue
			slice = array.slice(from, size)
			continue = !(slice.nil? || slice.empty?)
			slices << slice if continue
			from += size
		end
		slices
	end
	
	def training_test_for array, idx
		return nil if idx<0 || idx>=array.size
		result = []
		array.each_with_index do |element, array_idx|
			result << element unless array_idx == idx
		end
		[array[idx], result]
	end
	
	def train(articles)		
		@classifier.reset			
		articles.flatten.each do |article|							
			@classifier.train(article[:words], article[:classification])
		end					
	end
	
	def test(articles)		
		total =0
		correct = 0
		articles.flatten.each do |article|				
			total += 1 
			classification = @classifier.classify(article[:words]) 
			classification = [classification] unless classification.is_a? Array
#			puts "\t{url => #{article[:url]} should_read => #{article[:should_read]}} gives classification #{classification}"
			correct +=1 if classification==[article[:classification]]
		end	
		result = correct.to_f / total		
		puts "correct=#{correct} of total=#{total} => result=#{result}"
		result
	end
	
end

