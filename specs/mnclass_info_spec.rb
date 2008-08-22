require 'mnclass_info'

describe 'class_info' do
	before :each do
		@ci = MNClassInfo.new
	end
	
	it 'should correctly give probability for a single word' do
		@ci.add_words [:a]
		@ci.probability_of(:a).should == [1,1]
		@ci.probability_of(:b).should == [0,1]
	end
	
	it 'should impl has word correctly' do
		@ci.add_words [:a, :b]
		@ci.has(:a).should be_true
		@ci.has(:b).should be_true		
		@ci.has(:c).should be_false		
		@ci.add_words [:c]
		@ci.has(:a).should be_true
		@ci.has(:b).should be_true
		@ci.has(:c).should be_true
	end
	
	it 'should correctly give probability for a two words in equal proportion' do
		@ci.add_words [:a, :b]
		@ci.probability_of(:a).should == [1,2]
		@ci.probability_of(:b).should == [1,2]
		@ci.probability_of(:c).should == [0,2]
	end
	
	it 'should correctly give probability for a two words in differing proportions' do
		@ci.add_words [:a, :b, :b]
		@ci.probability_of(:a).should == [1,3]
		@ci.probability_of(:b).should == [2,3]
		@ci.probability_of(:c).should == [0,3]
	end
	
end

