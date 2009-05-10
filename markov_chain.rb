require 'set'
require 'zlib'

class MarkovChain
	attr_accessor :start_states, :num_examples, :edges, :num_edges, :count_nodes_from

	def initialize        
		@num_edges = 0
		@num_examples = 0
		@count_nodes_from = {} # { :s -> N }
		@edges = {} # { :s1 => { :s2 => N }}
	end

	def start_prob state
		trans_prob :START, state
	end
	
	def end_prob state
		trans_prob state, :END
	end

    # transistion probability from a to b
    # returned as fraction array; eg [1,2] represents 0.5
	def trans_prob state_a, state_b		
		return [0, @num_edges] unless @edges.has_key? state_a		
		
		#return [0, @count_nodes_from[state_a]] unless @edges[state_a].has_key? state_b		
		return [0, @num_edges] unless @edges[state_a].has_key? state_b		
		
		[@edges[state_a][state_b], @count_nodes_from[state_a]]
	end
	
	def example states	
		@num_examples += 1
		last_state = nil
		states.each do |state|
			if last_state.nil?
				#puts "addititonal start state for #{state}"
				add_edge :START, state                
			else
				#puts "edge from #{last_state} to #{state}"
				add_edge last_state, state
			end
			last_state = state
		end
		add_edge last_state, :END
	end

    def add_edge from, to
        add_edges from, to, 1
    end
    
	def add_edges from, to, n
        puts "#{self.object_id} add_edges #{from} -> #{to} (#{n})"
		@num_edges += n
		@count_nodes_from[from] ||= 0
		@count_nodes_from[from] += n
		@edges[from] ||= {}
		@edges[from][to] ||= 0 
		@edges[from][to] += n				
	end

    def edges_from from
        return Set.new unless @edges.has_key? from
        Set.new(@edges[from].keys)
    end

    def write_to_disk file
        file = Zlib::GzipWriter.new(File.new(file,'w'))
        file.write Marshal.dump(self)
        file.close
    end

    def self.read_from_disk file
        file = Zlib::GzipReader.open(file)        
        mc = Marshal.load file.read
        file.close
        mc
    end

    def merge other
        @num_examples += other.num_examples
        other.edges.each do |from, edges_to|
            edges_to.each do | to, count |
                add_edges from, to, count
            end
        end
    end
end