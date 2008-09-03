require 'cross_validator'
require 'classifier/classifier.rb'

describe 'cross_validator' do
	
	it 'should calculate the correct testing / training range for first of three' do
		cv = CrossValidator.new(nil, 0, 3)
		
		cv.should_train(0).should be_false
		cv.should_train(1).should be_true		
		cv.should_train(2).should be_true
		
		cv.should_test(0).should be_true
		cv.should_test(1).should be_false
		cv.should_test(2).should be_false
	end

	it 'should calculate the correct testing / training range for second of three' do
		cv = CrossValidator.new(nil, 1, 3)
		
		cv.should_train(0).should be_true
		cv.should_train(1).should be_false
		cv.should_train(2).should be_true
		
		cv.should_test(0).should be_false
		cv.should_test(1).should be_true
		cv.should_test(2).should be_false
	end

	it 'should calculate the correct testing / training range for last of three' do
		cv = CrossValidator.new(nil, 2, 3)
		
		cv.should_train(0).should be_true
		cv.should_train(1).should be_true
		cv.should_train(2).should be_false
		
		cv.should_test(0).should be_false
		cv.should_test(1).should be_false
		cv.should_test(2).should be_true
	end

	it 'should pass correct test and train to classifier and get pass rate correct' do		
		classifier = mock(:classifier)
		classifier.should_receive(:reset)				
		classifier.should_receive(:train).with(:w1, :c1)
		classifier.should_receive(:train).with(:w3, :c3)		
		classifier.should_receive(:classify).with(:w2).and_return(:c2)			
				
		articles = []
		articles << { :words => :w1, :classification => :c1 }
		articles << { :words => :w2, :classification => :c2 }
		articles << { :words => :w3, :classification => :c3 }
		
		cv = CrossValidator.new classifier, 1, 3
		cv.pass_rate.should == 0
		articles.each_with_index { |a,i| cv.training_pass(i,a) }
		articles.each_with_index { |a,i| cv.testing_pass(i,a) }
		cv.pass_rate.should == 1

	end
	
end
