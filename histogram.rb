class Histogram
	
	def initialize values, num_buckets
		@num_buckets = num_buckets
		
		@min = values.inject {|i,a| i<a ? i:a }
		max = values.inject {|i,a| i>a ? i:a }
		delta = max - @min
		@bucket_size = delta.to_f / num_buckets
		raise "0 buckets size" if @bucket_size==0
		#puts "num_buckets=#{num_buckets} min=#{min} max=#{max} delta=#{delta} size=#{bucket_size}"

		@buckets = []
		values.each do |v|
			offset = (v - @min).to_i
			idx = (offset / @bucket_size).floor
			idx -=1 if idx>num_buckets-1
			#puts "value #{v} (offset #{offset}) going to bucket #{idx}"
			@buckets[idx] ||=0
			@buckets[idx] +=1
		end
		
	end	
	
	def range bucket
		from = @min + (@bucket_size*bucket)
		to = from + @bucket_size
		[from,to]
	end
	
	# return an array of 'plottable' points corresponding to this histogram
	# x values are midpts of bucket ranges
	# y values are number of entries in that bucket
	def coords
		result = []
		@num_buckets.times do |b|
			result << [ midpt(b), value(b) ]
		end
		result
	end
	
	def midpt bucket
		f,t = range(bucket)
		(f+t).to_f/2
	end
	
	def value bucket
		@buckets[bucket] || 0
	end
	
	def values
		@buckets.collect { |b| b || 0 }
	end	
	
end