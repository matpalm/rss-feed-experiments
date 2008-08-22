require 'cross_validator'

describe 'cross_validator' do
	
	before :each do
		@cv = CrossValidator.new nil
	end
	
	it 'should split array' do			
		pending "doesnt work"
		@cv.split([1,2,3,4,5,6,7,8,9],3).should == [[1,2,3],[4,5,6],[7,8,9]]
		@cv.split([1,2,3,4,5,6,7,8,9,10],3).should == [[1,2,3,4],[5,6,7,8],[9,10]]
		@cv.split([1,2,3,4,5,6,7,8,9,10,11],3).should == [[1,2,3,4],[5,6,7,8],[9,10,11]]
		@cv.split([1,2,3,4,5,6,7,8,9,10,11,12],3).should == [[1,2,3,4],[5,6,7,8],[9,10,11,12]]
		@cv.split([1,2,3,4,5,6,7,8,9,10,11,12,13],3).should == [[1,2,3,4,5],[6,7,8,9,10],[11,12,13]]
	end

	it 'should extract training_test_for' do
		array = [1,2,3,4]
		@cv.training_test_for(array,-1).should == nil
		@cv.training_test_for(array,0).should == [1,[2,3,4]]
		@cv.training_test_for(array,1).should == [2,[1,3,4]]
		
		x,y = @cv.training_test_for(array,3)
		x.should == 4
		y.should == [1,2,3]
		
		@cv.training_test_for(array,5).should == nil
	end
	
end