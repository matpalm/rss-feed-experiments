require 'classifier/vector_space_model'

describe 'vector_space_model' do

    describe 'utility methods' do

        before :each do
            @vsm = VectorSpaceModel.new
            @vsm.train split_to_sym("shipment of gold"), :d1
            @vsm.train split_to_sym("damaged in a fire"), :d1
            @vsm.train split_to_sym("delivery of silver arrived in a silver truck"), :d2
            @vsm.train split_to_sym("shipment of gold arrived in a truck"), :d3
        end

        it 'should keep track of number of classes' do
            @vsm.num_classes.should == 3
        end

        it 'should correctly calc number of classes with a particular term' do
            @vsm.num_classes_with(:a).should == 3
            @vsm.num_classes_with(:arrived).should == 2
            @vsm.num_classes_with(:damaged).should == 1            
            @vsm.num_classes_with(:superdupericecream).should == 0
        end

        it 'should be able to calculate inverse document frequency for a particular term' do
            @vsm.idf(:a).should == 0
            @vsm.idf(:arrived).should be_close(0.405, 0.01) # 0.176 if log10
            @vsm.idf(:silver).should be_close(1.098, 0.01)  # 0.477 if log10
            @vsm.idf(:superdupericecream).should == 0  # TODO what should this be??
        end

    end

    describe "document vector for class" do

        it 'should return empty document vectors before any training data ' do
            vsm = VectorSpaceModel.new
            vsm.document_vector_for_class(:d1).should == {}
            vsm.document_vector_for_class(:d2).should == {}
        end

        it 'should return document vectors for simple built up example' do
            vsm = VectorSpaceModel.new

            assert_like vsm.document_vector_for_class(:d1), { }
            assert_like vsm.document_vector_for_class(:d2), { }

            vsm.train split_to_sym("gold"), :d1
            vsm.train split_to_sym("silver delivery"), :d2
            assert_like vsm.document_vector_for_class(:d1), { :gold => 0.693 }
            assert_like vsm.document_vector_for_class(:d2), { :silver => 0.693, :delivery => 0.693 }

            vsm.train split_to_sym("damaged in fire"), :d1
            vsm.train split_to_sym("in silver fire"), :d2
            assert_like vsm.document_vector_for_class(:d1), { :gold => 0.693, :damaged => 0.693 }
            assert_like vsm.document_vector_for_class(:d2), { :silver => 1.386, :delivery => 0.693 }
        end

    end

    describe "document vector for terms" do

        it 'should build doc vector for terms in the same way it does for a trained class' do
            vsm = VectorSpaceModel.new
            vsm.train split_to_sym("shipment of gold damaged in a fire"), :d1
            vsm.train split_to_sym("delivery of silver arrived in a silver truck"), :d2
            vsm.train split_to_sym("shipment of gold arrived in a truck"), :d3
            actual = vsm.document_vector_for_terms(split_to_sym("gold silver truck"))
            expected = { :gold => 0.405, :silver => 1.098, :truck => 0.405}
            assert_like actual, expected
        end

    end

    def assert_like a, b
#        puts "a #{a.inspect} b #{b.inspect}"
        a.keys.size.should == b.keys.size
        b.keys.each do |term|            
            a[term].should be_close(b[term], 0.01)
        end
    end

    def split_to_sym words
        words.split.collect {|w| w.to_sym }
    end
    
end	