require 'markov_chain'

class Array
    def choose_one
        pick = rand()
        self.each_with_index do |val,idx|
            return idx if pick < val
            pick -= val
        end
        raise "shouldn't have got here? pick=#{pick} array=#{self.inspect}"
    end
end

class MarkovChainWalker < MarkovChain
    attr_accessor :state   

    alias super_trans_prob trans_prob

    def initialize
        super
        reset
    end
    
    def trans_prob a, b
        prob_fraction = super_trans_prob a, b
        prob_fraction[0].to_f / prob_fraction[1]
    end

    def reset
        @state = :START
    end

    def at_end
        @state == :END
    end
    
    def step
        possible_next_states = edges_from(@state).to_a
        return if possible_next_states.empty?
        trans_probabilities = possible_next_states.collect { |s| trans_prob @state, s }
        idx = trans_probabilities.choose_one
        next_state = possible_next_states[idx]
        @state = next_state
    end

    def walk_once
        reset
        while not at_end
            step
            printf "%s ", state if not at_end
        end
        printf "\n"
    end
    
end
