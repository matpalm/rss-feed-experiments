require 'naive_bayes_classifier'

describe 'naive_bayes_classifier' do

	def check_all_close a, b		
		a.should have(b.size).elements
		(0...a.size).each do |idx|
			a[idx].should be_close(b[idx], 0.01)
		end
	end
	
	before :each do
		@c = NaiveBayesClassifier.new
	end

	describe 'class probabilities' do
		it 'for single class with single example' do
			@c.train([], :a)	
			@c.class_probability(:a).should be_close(1, 0.01)
			@c.class_probability(:b).should be_close(0, 0.01)
		end

		it 'for single class with multiple examples' do
			@c.train([], :a)	
			@c.train([], :a)	
			@c.class_probability(:a).should be_close(1, 0.01)
			@c.class_probability(:b).should be_close(0, 0.01)
		end

		it 'for multiple classes with single examples' do
			@c.train([], :a)	
			@c.train([], :b)	
			@c.train([], :c)	
			@c.class_probability(:a).should be_close(1.to_f/3, 0.01)
			@c.class_probability(:b).should be_close(1.to_f/3, 0.01)		
			@c.class_probability(:c).should be_close(1.to_f/3, 0.01)		
		end

		it 'for multiple classes with single examples' do
			@c.train([], :a)	
			@c.train([], :b)	
			@c.train([], :c)	
			@c.class_probability(:a).should be_close(1.to_f/3, 0.01)
			@c.class_probability(:b).should be_close(1.to_f/3, 0.01)		
			@c.class_probability(:c).should be_close(1.to_f/3, 0.01)		
		end

		it 'for multiple classes with multiple examples' do
			@c.train([], :a)	
			@c.train([], :b)	
			@c.train([], :b)	
			@c.train([], :c)	
			@c.class_probability(:a).should be_close(1.to_f/4, 0.01)
			@c.class_probability(:b).should be_close(1.to_f/2, 0.01)		
			@c.class_probability(:c).should be_close(1.to_f/4, 0.01)		
		end
	end
	
	describe 'conditional probability fractions' do
		it 'for single class with single example' do
			@c.train([:on, :linux], :a)	
			@c.conditional_probability(:on, :a).should ==[1,1]
			@c.conditional_probability(:linux, :a).should ==[1,1]
		end

		it 'for single class with multiple examples' do
			@c.train([:on, :linux], :a)	
			@c.train([:on, :hollywood], :a)	
			@c.conditional_probability(:on, :a).should ==[2,2]
			@c.conditional_probability(:linux, :a).should ==[1,2]
			@c.conditional_probability(:hollywood, :a).should ==[1,2]
		end		

		it 'for multiple classes with single example' do
			@c.train([:on, :linux], :a)	
			@c.train([:on, :suess], :b)	
			
			@c.conditional_probability(:on, :a).should ==[1,1]
			@c.conditional_probability(:linux, :a).should ==[1,1]
			
			@c.conditional_probability(:on, :b).should ==[1,1]
			@c.conditional_probability(:suess, :b).should ==[1,1]
		end
		
		it 'for more than one occurence of a word in training set' do
			@c.train([:on, :on, :on, :linux, :linux], :a)				
			
			@c.conditional_probability(:on, :a).should ==[1,1]
			@c.conditional_probability(:linux, :a).should ==[1,1]
		end

	end
		
	describe 'for multiple classes with multiple examples' do
		
		before :each do
			@c.train([:on, :linux], :a)	
			@c.train([:on, :hollywood], :a)	
			@c.train([:on, :linux], :b)	
			@c.train([:on, :suess], :b)	
			@c.train([:on, :suess], :b)				
		end
				
		it 'checking conditional_probability' do			
			@c.conditional_probability(:on, :a).should ==[2,2]
			@c.conditional_probability(:linux, :a).should ==[1,2]
			@c.conditional_probability(:hollywood, :a).should ==[1,2]
			@c.conditional_probability(:suess, :a).should ==[0,2]
			
			@c.conditional_probability(:on, :b).should ==[3,3]
			@c.conditional_probability(:linux, :b).should ==[1,3]
			@c.conditional_probability(:hollywood, :b).should ==[0,3]
			@c.conditional_probability(:suess, :b).should ==[2,3]
		end		
		
		it 'checking conditional_probabilities' do
			@c.conditional_probabilities([:on,:linux,:hollywood,:suess], :a).should ==[[2,2],[1,2],[1,2],[0,2]]			
			@c.conditional_probabilities([:on,:linux,:hollywood,:suess], :b).should ==[[3,3],[1,3],[0,3],[2,3]]
		end		

		it 'checking conditional_probabilities_with_estimator' do
			@c.conditional_probabilities_with_estimator([:on,:linux,:hollywood], :a).should ==[[3,5],[2,5],[2,5]]					
			@c.conditional_probabilities_with_estimator([:on, :linux, :suess], :b).should ==[[4,6],[2,6],[3,6]]
			@c.conditional_probabilities_with_estimator([:on,:linux,:hollywood,:suess], :a).should ==[[3,6],[2,6],[2,6],[1,6]]					
			@c.conditional_probabilities_with_estimator([:on,:linux,:hollywood,:suess], :b).should ==[[4,7],[2,7],[1,7],[3,7]]
		end		
		
		it 'checking conditional_probabilities_with_estimator_if_required runs estimator when required' do
			ca1 = @c.conditional_probabilities_with_estimator_if_required([:on,:linux,:hollywood,:suess], :a)
			ca2 = @c.conditional_probabilities_with_estimator([:on,:linux,:hollywood,:suess], :a)
			ca1.should == ca2
			
			cb1 = @c.conditional_probabilities_with_estimator_if_required([:on,:linux,:hollywood,:suess], :b)
			cb2 = @c.conditional_probabilities_with_estimator([:on,:linux,:hollywood,:suess], :b)			
			cb1.should == cb2
		end

		it 'checking conditional_probabilities_with_estimator_if_required doesnt run estimator when not required' do
			ca1 = @c.conditional_probabilities_with_estimator_if_required([:on,:linux,:hollywood], :a)
			ca2 = @c.conditional_probabilities([:on,:linux,:hollywood], :a)
			ca1.should == ca2
			
			cb1 = @c.conditional_probabilities_with_estimator_if_required([:on, :linux, :suess], :b)
			cb2 = @c.conditional_probabilities([:on, :linux, :suess], :b)
			cb1.should == cb2
		end
		
	end
	
	describe 'classification' do
		
		before :each do
			@c = NaiveBayesClassifier.new
			@c.train([:on, :linux], :a)
			@c.train([:on, :hollywood], :b)			
		end
		
		it 'should classify exact matches correctly' do
			@c.classify([:on, :linux]).should == [:a]			
			@c.classify([:on, :hollywood]).should == [:b]			
		end
		
		it 'should classify partial matches' do
			@c.classify([:linux]).should == [:a]
			@c.classify([:hollywood]).should == [:b]
			@c.classify([:on]).should have(2).classes
			@c.classify([:on]).should include(:a)
			@c.classify([:on]).should include(:b)
		end
		
	end
	
	
end