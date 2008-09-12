class Hash

    def cos_sim other
        Math.acos( dot_product(other) / ( magnitude * other.magnitude ) )
    end

    def dot_product other
        dp = 0
        all_keys = (keys + other.keys).uniq
        all_keys.each do |key|
            next unless has_key? key and other.has_key? key
            dp += self[key] * other[key]
        end
        dp
    end

    def magnitude
        Math.sqrt values.inject(0) { |acc,value| acc += value * value }
    end
end

class VectorSpaceModelClass

    def initialize
        @term_freq = {}
    end

    def add_words terms
        terms.each do |term|
            @term_freq[term] ||= 0
            @term_freq[term] += 1
        end        
    end

    def document_vector idf_supplier
        vector = {}
        uniq_terms.each do |term|             
            tf_idf = term_frequency(term) * idf_supplier.inverse_document_frequency(term)
            vector[term] = tf_idf unless tf_idf == 0
        end         
        vector
    end
    
    def uniq_terms
        @term_freq.keys
    end

    def has_term term
        @term_freq.has_key? term
    end

    def term_frequency term
        return 0 unless has_term term
        @term_freq[term]
    end

end