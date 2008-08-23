require 'classifier/word_occ'

describe 'word_occ_classifier' do
	
	before :each do
		@c = WordOccClassifier.new
	end
		
	it 'should be trainable for a single word' do
		@c.train([:a], :blah)
		@c.classify([:a]).should == [:blah]
	end

	it 'should reflect cant be be trainable for a single word that doesnt exist in training set' do
		@c.train([:a], :blah_de_blah)
		@c.classify([:b]).should == []
	end

	it 'should be trainable for a single word across two feeds with same data' do
		@c.train([:a], :test1)
		@c.train([:a], :test2)
		classified = @c.classify([:a])
		classified.should have(2).elements
		classified.should include(:test1)
		classified.should include(:test2)
	end

	it 'should be trainable for a single word across two feeds with clear winner' do
		@c.train([:a,:b], :test1)
		@c.train([:a,:c], :test2)		
		@c.classify([:a,:c]).should == [:test2]
		@c.classify([:a,:b]).should == [:test1]
	end

end