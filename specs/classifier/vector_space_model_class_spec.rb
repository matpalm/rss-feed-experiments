require 'classifier/vector_space_model_class'

describe 'vector_space_model_class' do

    describe 'hash extensions' do
        it 'should implement magnitude' do
            { 0=>1, 1=>2, 2=>4, 6=>5, 7=>3 }.magnitude.should be_close(7.41,0.01)
            { 0=>2, 2=>4, 3=>2, 6=>6 }.magnitude.should be_close(7.74,0.01)
        end

        it 'should implement cross product' do
            a = { 1=>2, 2=>3 }
            b = { 1=>3, 2=>4 }
            expected_result = 2*3 + 3*4
            a.dot_product(b).should == expected_result
            b.dot_product(a).should == expected_result

            b = { 1=>3, 2=>4, 3=>4 }
            a.dot_product(b).should == expected_result
        end
    end

    describe 'frequency stuff' do
        it 'should be able to calculate term frequency' do
            vsmc = VectorSpaceModelClass.new()
            vsmc.add_words [ :a, :a, :b ]
            vsmc.term_frequency(:a).should == 2
            vsmc.term_frequency(:b).should == 1
            vsmc.term_frequency(:c).should == 0
        end
    end

end
