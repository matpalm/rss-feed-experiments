# multinominal class info

class MNClassInfo
	attr_reader :count
	attr_reader :words_freq
	
	def initialize
		@num_words = 0
		@words_freq = {}
	end	
	
	def add_words words
		@num_words += words.size
		words.each do |word|
			@words_freq[word] ||= 0
			@words_freq[word] += 1
		end
	end
	
	def has word
		@words_freq.has_key? word
	end
	
	def probability_of word		
		[frequency_of(word),  @num_words]
	end
	
	def frequency_of word
		@words_freq[word] ? @words_freq[word] : 0		
	end

end