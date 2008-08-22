require 'multinominal_bayes_classifier'

describe 'multinominal_bayes_classifier' do
	
	before :each do
		@c =MultinominalBayesClassifier.new
	end

	it 'should have patched fixnum for factorial ' do
		1.factorial.should == 1
		2.factorial.should == 2
		3.factorial.should == 6
		4.factorial.should == 24
	end
	
	it 'should impl hash_for correctly' do
		hash = @c.hash_for [:yellow,:yellow,:blue]
		hash.keys.size.should == 2
		hash[:yellow].should ==2
		hash[:blue].should ==1
	end

	it 'should give correct probabilities across a single class' do
		@c.train([:yellow], :class1)
		@c.probability_of_word(:yellow, :class1).should == [1,1]
	end	
	
	describe 'for yellow yellow blue example' do
		before :each do
			@c.train([:yellow, :yellow, :yellow], :class1)
			@c.train([:blue], :class1)
		end

		it 'should give correct word probabilities' do
			@c.probability_of_word(:yellow, :class1).should == [3,4]
			@c.probability_of_word(:blue, :class1).should == [1,4]
			@c.probability_of_word(:red, :class1).should == [0,4]
			@c.probability_of_word(:yellow, :class2).should == nil
		end	

		it 'should give correct word bag operand probabilties' do						
			@c.probability_of_words_over_frequencies([:yellow,:yellow,:yellow], :class2).should == nil
			@c.probability_of_words_over_frequencies([:yellow,:yellow,:yellow], :class1).should ==[ [[3,4],3] ]
			@c.probability_of_words_over_frequencies([:blue,:blue,:blue], :class1).should == [ [[1,4], 3] ]
			
			probs = @c.probability_of_words_over_frequencies([:yellow,:yellow,:blue], :class1)			
			probs.should have(2).elements 
			probs.should include([[3,4],2]) and include([[1,4],1])
			
			probs = @c.probability_of_words_over_frequencies([:yellow,:blue,:blue], :class1)
			probs.should have(2).elements
			probs.should include([[3,4], 1]) and include([[1,4], 2])
		end	

		describe 'multinominal_operand' do
			it 'for zero occurences' do
				@c.multinominal_operand([[3,4],0]).should ==nil
				@c.multinominal_operand([[3,0],4]).should ==nil
			end
			it 'for std values' do
				@c.multinominal_operand([[3,4],1]).should == [3,4]
				@c.multinominal_operand([[3,4],2]).should == [(3*3), (4*4)*(2*1)]
				@c.multinominal_operand([[3,4],3]).should == [(3*3*3), (4*4*4)*(3*2*1)]
			end
			it 'zero numerator should be same as std values' do
				@c.multinominal_operand([[0,4],1]).should == [0,4]
				@c.multinominal_operand([[0,4],2]).should == [(0*0), (4*4)*(2*1)]
				@c.multinominal_operand([[0,4],3]).should == [(0*0*0), (4*4*4)*(3*2*1)]			
			end
		end

		it 'multinominal_operands' do
			# [:yellow,:yellow,:yellow] ==[ [[3,4],3] ] = 3^3 / 4^3*3! = 27 / 384 = 0.070312
			@c.multinominal_operands([:yellow,:yellow,:yellow], :class1).should == [[27,384]]
		
			# [:yellow,:yellow,:blue] ==[ [[3,4],2], [[1,4],1] ] = [3^2 / 4^2*2!, 1/4]  = [9/32, 1/4] = [0.28125, 0.25]			
			operands = @c.multinominal_operands([:yellow,:yellow,:blue], :class1)
			operands.should have(2).elements
			operands.should include([9,32]) and include([1,4])
		end

		it 'minimal impl of overall probability without estimator' do
			# [:yellow,:yellow,:yellow] ==[ [[3,4],3] ] = 3^3 / 4^3*3! = 27 / 384 = 0.070312
			@c.probability_of_words_minimal([:yellow,:yellow,:yellow], :class1).should be_close(Math.log(0.070312), 0.001)
			
			# [:yellow,:yellow,:blue] ==[ [[3,4],2], [[1,4],1] ] = [3^2 / 4^2*2!, 1/4]  = [9/32, 1/4] = [0.28125, 0.25]			
			@c.probability_of_words_minimal([:yellow,:yellow,:blue], :class1).should be_close(Math.log(0.28125) + Math.log(0.25), 0.001)
		end
		
		it 'minimal impl of overall probability with estimator' do			
			# [:yellow,:yellow,:green] ==[ [[0,4],1], [[3,4],2] ] = [0^1 / 4^1*1!,  3^2 / 4^2*2!]  = [0/4, 9/32] = [1/34, 10/34] (estimator)
			@c.probability_of_words_minimal([:yellow,:yellow,:green], :class1).should be_close(Math.log(0.02941) + Math.log(0.29411), 0.001)
		end
		
=begin	
		it 'should give correct word bag probabilities' do						
			@c.probability_of_words([:yellow,:yellow,:yellow], :class1).should == (27.0 / 64)
			@c.probability_of_words([:blue,:blue,:blue], :class1).should == (1.0 / 64)		
			@c.probability_of_words([:yellow,:yellow,:blue], :class1).should == (27.0 / 64)		
			@c.probability_of_words([:yellow,:blue,:blue], :class1).should == (9.0 / 64)			
			
			@c.train([:yellow, :blue, :blue, :blue, :blue, :blue, :blue, :blue, :blue, :blue], :class2)		
			@c.probability_of_words([:blue,:yellow,:blue], :class2).should be_close(0.243, 0.01)
		end	

		it 'should use laplace estimator to avoid zero probabilities' do
			@c.probability_of_words([:yellow,:blue,:red], :class1).should_not == 0
		end
		
		it 'should give correct word bag probabilities using minimal impl' do
			
			# redivide by 6 (3!) since it's normalised out
			# have to re expontentiate since not required for comparisons (a>b => e^a > e^b)
			
			Math.exp(@c.probability_of_words_minimal([:yellow,:yellow,:yellow], :class1)).should == (27.0 / 64) /6
			Math.exp(@c.probability_of_words_minimal([:blue,:blue,:blue], :class1)).should == (1.0 / 64) /6	
			Math.exp(@c.probability_of_words_minimal([:yellow,:yellow,:blue], :class1)).should == (27.0 / 64) /6		
			Math.exp(@c.probability_of_words_minimal([:yellow,:blue,:blue], :class1)).should be_close((9.0 / 64) /6, 0.001)
			
			@c.train([:yellow, :blue, :blue, :blue, :blue, :blue, :blue, :blue, :blue, :blue], :class2)		
			Math.exp(@c.probability_of_words_minimal([:blue,:yellow,:blue], :class2)).should be_close(0.243/6, 0.001) 
		end	

		it 'shouldnt matter what order test set is in' do
			yyd = @c.probability_of_words([:yellow,:yellow,:blue], :class1)
			@c.probability_of_words([:yellow,:blue,:yellow], :class1).should == yyd
			@c.probability_of_words([:blue,:yellow,:yellow], :class1).should == yyd
		end

	
	
	it 'should give correctly classify across a yellow blue example' do
		@c.train([:yellow, :yellow, :yellow, :blue], :class1)		
		@c.train([:yellow, :blue, :blue, :blue, :blue, :blue, :blue, :blue, :blue, :blue], :class2)		
		@c.classify([:blue,:yellow,:blue]).should == [:class1]
	end
=end
	end

end
