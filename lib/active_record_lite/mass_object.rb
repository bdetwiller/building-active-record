class MassObject

	def self.set_attrs(*attributes)
		@attributes = []
		attributes.each do |attribute|
			attr_accessor attribute
			@attributes << attribute
		end
	end

	def self.attributes
		@attributes
	end

	def initialize(params)
		params.each do |key, value|
			raise "mass assignment to unregistered attribute #{key}" unless self.class.attributes.include?(key.to_sym)
			instance_variable_set("@#{key}", value)
		end
	end

end



