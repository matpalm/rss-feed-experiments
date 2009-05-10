require 'classifier/vector_space_model_class'
require 'classifier/classifier'

class VectorSpaceModel < Classifier
    def new_class_info
        VectorSpaceModelClass.new
    end

    def probability_of_words_given_class terms, clas
        class_document_vector = document_vector_for_class clas
        article_document_vector = document_vector_for_terms terms
    end

    def document_vector_for_class clas
        return {} unless @classes.include? clas
        @class_info[clas].document_vector self
    end

    def document_vector_for_terms terms
        terms_vector_class = VectorSpaceModelClass.new
        terms_vector_class.add_words terms
        terms_vector_class.document_vector self
    end

    def idf term
        freq = num_classes_with(term)
        return 0 if freq==0
        Math.log(num_classes.to_f / freq)        
    end

    def num_classes
        @classes.size
    end

    def num_classes_with term
        @class_info.values.inject(0) { |a,v| v.has_term(term) ? a+1 : a }
    end

end