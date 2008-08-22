class TheRegisterRules
	
	def should_read article
		!!(article[:url].to_s =~ /theregister/)
	end

end