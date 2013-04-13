require 'active_support/inflector'

module Associatable
	def belongs_to(name, params = {})

		define_method(name) do 
			aps = BelongsToAssocParams.new(name, params)

			query = send(aps.foreign_key)

			result =	DBConnection.execute(<<-SQL, query)
				SELECT *
				FROM #{aps.other_table}
				WHERE #{aps.primary_key} = ?
			SQL

			aps.other_class.parse_all(result)
		end	
	end

	def has_many(name, params = {})

		define_method(name) do
			aps = HasManyAssocParams.new(name, params)

			query = send(aps.primary_key)

			result =	DBConnection.execute(<<-SQL, query)
				SELECT *
				FROM #{aps.other_table}
				WHERE #{aps.foreign_key} = ?
			SQL

			aps.other_class.parse_all(result)
		end
	end

	def has_one_through(name, assoc1, assoc2)
		 params1 = self.class.BelongsToAssocParams[assoc1]
     params2 = params1.other_class.assoc_params[assoc2]
		 assoc_params[name] = BelongsToAssocParams.new(name, params)
	end

	class HasManyAssocParams
		def initialize(name, params = {})
			@name = name
			@params = params
		end

		def other_class
			if @params[:class_name]
				other_class = @params[:class_name].constantize
			else
				other_class = @name.to_s.singularize.camelize.constantize
			end
		end

		def other_table
			other_class.table_name
		end

		def primary_key
			if @params[:primary_key]
				primary_key = @params[:primary_key].to_s 
			else 
				primary_key = "id"
			end
		end

		def foreign_key
			foreign_key = @params[:foreign_key].to_s
		end
	end

	class BelongsToAssocParams
		def initialize(name, params = {})
			@name = name
			@params = params
		end

		def other_class
			if @params[:class_name]
				other_class = @params[:class_name].constantize
			else
				other_class = @name.to_s.camelize.constantize
			end
		end

		def other_table
			other_class.table_name
		end

		def primary_key
			if @params[:primary_key]
				primary_key = @params[:primary_key].to_s 
			else 
				primary_key = "id"
			end
		end

		def foreign_key
			if @params[:foreign_key]
				foreign_key = @params[:foreign_key].to_s
			else 
				foreign_key = "#{@name}_id"
			end
		end
	end




end