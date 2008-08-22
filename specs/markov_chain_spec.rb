require 'markov_chain'

describe 'markov chain' do
	
	before :each do
		@mc = MarkovChain.new
	end
	
	describe 'on creation' do
		it 'should report zero start probabilities' do
			@mc.start_prob(:a).should ==[0,0]
			@mc.start_prob(:b).should ==[0,0]
		end
		
		it 'should report zero end probabilities' do
			@mc.start_prob(:a).should ==[0,0]
			@mc.start_prob(:b).should ==[0,0]
		end

		it 'should report zero transistion probabilities' do
			@mc.trans_prob(:a, :b).should ==[0,0]
			@mc.trans_prob(:b, :a).should ==[0,0]
		end
	end
	
	describe 'after given one example' do
		before :each do 
			@mc.example([:a, :b])
		end
		
		it 'should record start probabilities' do						
			@mc.start_prob(:a).should ==[1,1]		
			@mc.start_prob(:b).should ==[0,3] # 3 edges in total for START -> a -> b -> END		
			@mc.start_prob(:c).should ==[0,3]		
		end
		
		it 'should record end probabilities' do						
			@mc.end_prob(:a).should ==[0,3] 
			@mc.end_prob(:b).should ==[1,1]		
			@mc.end_prob(:c).should ==[0,3]		
		end

		it 'should record transistion probabilities' do
			@mc.trans_prob(:a, :b).should ==[1,1]
			@mc.trans_prob(:a, :c).should ==[0,3]
			@mc.trans_prob(:b, :d).should ==[0,3]
		end
		
		describe 'and another example' do
			before :each do 
				@mc.example([:a, :c])
			end
			
			it 'should record start probabilities' do						
				@mc.start_prob(:a).should ==[2,2]
				@mc.start_prob(:b).should ==[0,6] # 6 edges in total from examples	
				@mc.start_prob(:c).should ==[0,6]
			end
			
			it 'should record end probabilities' do						
				@mc.end_prob(:a).should ==[0,6]	
				@mc.end_prob(:b).should ==[1,1]						
				@mc.end_prob(:c).should ==[1,1]						
			end
			
			it 'should record transistion probabilities' do
				@mc.trans_prob(:a, :b).should ==[1,2]
				@mc.trans_prob(:a, :c).should ==[1,2]
				@mc.trans_prob(:a, :d).should ==[0,6]
				@mc.trans_prob(:b, :d).should ==[0,6]
			end
			
		end
		
	end
	
	describe 'after given a long example' do
		before :each do 
			@mc.example([:a, :a, :b, :a, :a, :c, :b, :c, :d])
		end
		
		it 'should record start probabilities' do						
			@mc.start_prob(:a).should ==[1,1]
			@mc.start_prob(:b).should ==[0,10] # 10 edges in total for START -> a ... -> d -> END
			@mc.start_prob(:c).should ==[0,10]
		end
		
		it 'should record transistion probabilities' do
			@mc.trans_prob(:a, :a).should ==[2,4]
			@mc.trans_prob(:a, :b).should ==[1,4]
			@mc.trans_prob(:a, :c).should ==[1,4]
			@mc.trans_prob(:a, :d).should ==[0,10]
			
			@mc.trans_prob(:b, :a).should ==[1,2]
			@mc.trans_prob(:b, :b).should ==[0,10]
			@mc.trans_prob(:b, :c).should ==[1,2]
			@mc.trans_prob(:b, :d).should ==[0,10]
		
			@mc.trans_prob(:c, :a).should ==[0,10] 
			@mc.trans_prob(:c, :b).should ==[1,2]
			@mc.trans_prob(:c, :c).should ==[0,10] 
			@mc.trans_prob(:c, :d).should ==[1,2]
			
		end

		it 'should record transistion probabilities for edges to node that has no outbounds' do
			[:a, :b, :c, :d].each do |dest|
				@mc.trans_prob(:d, dest).should ==[0,10] 
			end			
		end
		
		it 'should record transistion probabilities for edges to node that have neither in or outbounds' 
			
	end	

end