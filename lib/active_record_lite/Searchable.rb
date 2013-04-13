module Searchable
	def where(params)
		where_line = params.map do |key, value| 
			"#{key} = ?"
		end.join(", ")

		results = DBConnection.execute(<<-SQL, *params.values)
		SELECT *
		FROM #{self.table_name}
		WHERE #{where_line}
		SQL

		parse_all(results) #not sure i understand this part
	end

end