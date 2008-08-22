class Array
		
	def gcd a, b
		while b!=0
			tmp = b
			b = a % b
			a = tmp
		end
		return a
	end
		
	def lcm_pair a, b
		a*b / gcd(a,b)
	end
		
	def lcm 
		uniq.inject(1) { |a,b| lcm_pair(a,b) }
	end
	
	def has_at_least_one_zero?
		!!(find { |f| f[0]==0 })
	end

	def denominators 
		collect { |f| f[1] }
	end

	def recalc_with_lcm
		lcm_across_fractions = denominators.lcm
		adjusted_numerators = collect do |fr| 
			num, denom = fr
			num_modifier = lcm_across_fractions / denom
			num * num_modifier
		end
		[adjusted_numerators, lcm_across_fractions]
	end
	
	def apply_estimator
		numerators, denominator = recalc_with_lcm
		numerators.collect { |n| [n+1, denominator+numerators.length] }		
	end

	def eval_fractions		
		collect { |f| f[0].to_f / f[1].to_f }
	end
	
	def log_sum
		begin
			eval_fractions.inject(0) { |sum, fr| sum + Math.log(fr) }
		rescue
			puts "doh!"
			0
		end
	end
	
end
