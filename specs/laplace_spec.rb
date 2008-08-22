require 'laplace'

describe 'laplace' do
	
	it 'should calc gcd for pair of numbers' do
		[].gcd(15,36).should ==3
		[].gcd(4,2).should ==2
		[].gcd(3,2).should ==1	
	end
	
	it 'should calc lcd for a pair of numbers' do
		[].lcm_pair(15,36).should ==180
		[].lcm_pair(4,2).should ==4
		[].lcm_pair(3,2).should ==6	
	end

	it 'should calc lcd for array of numbers with duplicates' do
		[15,36,15,5,6].lcm.should ==180
		[4,2,4,2,2,4].lcm.should ==4
		[3,2,2,3,2,2,1].lcm.should ==6	
	end

	it 'should be able to pick if there is at least one zero fraction' do
		[[1,2],[3,4]].should_not have_at_least_one_zero
		[[1,2],[0,4]].should have_at_least_one_zero
		[[0,2],[3,4]].should have_at_least_one_zero
	end
	
	it 'should be able to extract denominators from fraction array' do
		[[1,2],[3,4],[3,4]].denominators.should == [2,4,4]
		[[1,4],[0,6]].denominators.should == [4,6]
	end

	it 'should be able to regen fractions with lcm' do
		[[1,1], [1,4], [1,1], [1,2], [1,4], [0,1]].recalc_with_lcm.should == [[4,1,4,2,1,0],4]
	end

	it 'should be able to apply a laplacian estimator' do
		[[1,1], [1,4], [1,1], [1,2], [1,4], [0,1]].apply_estimator.should == [[5,10], [2,10], [5,10], [3,10], [2,10], [1,10]]
	end

	it 'should eval fractions' do
		[[5,10]].eval_fractions.should ==[0.5]
		[[1,4]].eval_fractions.should ==[0.25]		
		[[5,10],[1,4]].eval_fractions.should ==[0.5,0.25]		
	end
	
	it 'should calc log sum' do
		ln_half = -0.69314
		ln_quarter = -1.38629
		[[5,10]].log_sum.should be_close(ln_half, 0.001)
		[[1,4]].log_sum.should be_close(ln_quarter, 0.001)
		[[5,10], [1,4]].log_sum.should be_close(ln_half + ln_quarter, 0.001)
	end

end

