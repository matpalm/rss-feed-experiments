class TheRegisterOrLamborghiniRules
	
	def should_read article
		!!(article[:url].to_s =~ /theregister/)  || article[:words].include?(:lamborghini)
	end

end