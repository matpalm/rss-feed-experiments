class MAlgoClassifier
	
	def reset
	end
	
	def train(a,b)
	end
	
	def classify(words)
		return false unless words
		return false if words.empty?
		first_char = words.first.to_s.strip[0].chr.downcase
		return first_char <= 'm'
	end
	
end
