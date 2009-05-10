require 'the_register_or_lamborghini_rules'

describe 'the_register_or_lamborghini_rules.rb' do
	
	before :each do
		@p = TheRegisterOrLamborghiniRules.new
	end
		
	it 'should say read for anything from the register' do		
		@p.should_read({ :url => :theregister, :words => [] }).should be(true)		
	end

	it 'should say ignore for anything from others that dont have lamborghini' do
		@p.should_read({ :url => :something_else, :words => [] }).should be(false)		
		@p.should_read({ :url => :something_else, :words => [:blah,:de,:blah] }).should be(false)		
	end
	
	it 'should say read for anything that has lamborghini' do
		@p.should_read({ :url => :something_else, :words => [:lamborghini] }).should be(true)		
		@p.should_read({ :url => :something_else, :words => [:other,:words,:lamborghini] }).should be(true)		
		@p.should_read({ :url => :theregister, :words => [:lamborghini,:other,:words] }).should be(true)		
	end


end