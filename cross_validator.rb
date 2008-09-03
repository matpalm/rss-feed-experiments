
class CrossValidator
	attr_accessor :classifier

	def initialize classifier, slice, num_slices
		@classifier = classifier
		@slice = slice
		@num_slices = num_slices		
		raise "invalid slice #{slice} #{num_slices}" if slice<0 or slice>=num_slices	
		
		@classifier.reset if @classifier
		@total = @correct = 0
	end
		
	def should_train idx
		! should_test idx
	end
	
	def should_test idx
		(idx - @slice) % @num_slices == 0		
	end	

	def training_pass idx, article		
		return unless should_train idx
		@classifier.train(article[:words], article[:classification]) 
	end
	
	def testing_pass idx, article
		return unless should_test idx
		@total += 1 
		classification = @classifier.classify(article[:words]) 
		classification = [classification] unless classification.is_a? Array
		@correct +=1 if classification==[article[:classification]]
	end	
	
	def pass_rate
		return 0 unless @total > 0
		pass_rate = @correct.to_f / @total		
#		puts "correct=#{@correct} of total=#{@total} => pass_rate=#{pass_rate}"
		pass_rate
	end	

end

