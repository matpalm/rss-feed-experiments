class MarkovChain
		
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
		@num_edges += 1
		@count_nodes_from[from] ||= 0
		@count_nodes_from[from] += 1				
		@edges[from] ||= {}
		@edges[from][to] ||= 0 
		@edges[from][to] += 1				
	end
	
end