require 'm_algo_classifier.rb'

describe 'm_algo_classifier' do
	
	before :each do
		@c = MAlgoClassifier.new
	end
	
	it 'should accept (though ignore) train messages' do
		@c.train([:words], :clas)
	end

	it 'should classify empty set and nil as false' do
		@c.classify([]).should == false
		@c.classify(nil).should == false
	end

	it 'should classify anything with first word first char less equal to m as true' do
		@c.classify([:aaa,:something]).should == true
		@c.classify([:maa,:something]).should == true
	end
	
	it 'should classify anything with first word first char after m as false' do
		@c.classify([:naa,:something]).should == false
		@c.classify([:zaa,:something]).should == false
	end
	
end