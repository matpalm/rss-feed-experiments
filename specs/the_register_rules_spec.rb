require 'the_register_rules.rb'

describe 'the_register_rules' do
	
	before :each do
		@p = TheRegisterRules.new
	end
		
	it 'should say read for anything from the register' do		
		@p.should_read({ :url => :theregister, :words => [] }).should be(true)		
	end

	it 'should say ignore for anything from others' do
		@p.should_read({ :url => :something_else, :words => [] }).should be(false)				
	end
	
end