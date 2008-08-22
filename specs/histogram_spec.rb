require 'histogram'

describe 'histogram' do

	it 'should generate correct histogram with one bucket' do				
		h = Histogram.new([1,3,2,4], 1)
		h.values.should == [4]		
		h.range(0).should == [1,4]
		h.midpt(0).should == 2.5
	end

	it 'should generate correct histogram with two buckets' do				
		h = Histogram.new([1,3,2,4], 2)
		h.values.should == [2,2]
		h.range(0).should == [1,2.5]
		h.midpt(0).should == 1.75		
		h.range(1).should == [2.5,4]
		h.midpt(1).should == 3.25
	end

	it 'should generate correct histogram with three buckets' do				
		h = Histogram.new([1,3,2,40], 3)
		h.values.should == [3,0,1]
		h.range(0).should == [1,14]
		h.range(1).should == [14,27]
		h.range(2).should == [27,40]
	end

end