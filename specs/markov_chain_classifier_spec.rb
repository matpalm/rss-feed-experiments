require 'markov_chain_classifier'

describe 'markov_chain' do
	before :each do
		
	end
	
	it 'should have classifier api' do
		@mcc = MarkovChainClassifier.new(:include_start_end => true)
		@mcc.should respond_to(:train)
		@mcc.should respond_to(:classify)
		@mcc.should respond_to(:reset)
	end
	
	it 'should calculate probs from word sequence including start and end probabilities' do
		@mcc = MarkovChainClassifier.new(:include_start_end => true)
		chain = mock(MarkovChain)		
		chain.should_receive(:start_prob).with(:a).and_return :p1
		chain.should_receive(:trans_prob).with(:a,:b).and_return :p2
		chain.should_receive(:trans_prob).with(:b,:a).and_return :p3
		chain.should_receive(:trans_prob).with(:a,:c).and_return :p4
		chain.should_receive(:end_prob).with(:c).and_return :p5
		@mcc.prob_fractions_of_words(chain, [:a, :b, :a, :c]).should == [ :p1, :p2, :p3, :p4, :p5 ]
	end
	
	it 'should calculate probs from word sequence not including start and end probabilities' do
		@mcc = MarkovChainClassifier.new(:include_start_end => false)
		chain = mock(MarkovChain)				
		chain.should_receive(:trans_prob).with(:a,:b).and_return :p2
		chain.should_receive(:trans_prob).with(:b,:a).and_return :p3
		chain.should_receive(:trans_prob).with(:a,:c).and_return :p4		
		@mcc.prob_fractions_of_words(chain, [:a, :b, :a, :c]).should == [:p2, :p3, :p4]
	end
	
end
