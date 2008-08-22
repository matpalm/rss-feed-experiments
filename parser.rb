class Parser
		
	def parse line
		url,date,text = line.split(/\|/)
		words = text.gsub(/[^a-zA-Z0-9 ]/,' ').
				split(/\s+/).
				select { |w| w.length >1 }.
				collect { |w| w.downcase.to_sym }  		
		{:url => url.to_sym, :words => words}		
	end

	def articles_from_stdin		
		STDIN.each do |line|
			yield parse(line)
		end			
	end
	
end