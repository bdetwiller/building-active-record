require 'debugger'

class SQLObject < MassObject

	def self.set_table_name(name)
		@tablename = name
	end

	def self.table_name
		@tablename
	end

	def self.all
		results = DBConnection.execute(<<-SQL)
			SELECT *
			FROM #{self.table_name}
			SQL

		results.map do |result|
		 self.new(result)
		end
	end

	def self.find(id)
		result = DBConnection.execute(<<-SQL, id)
			SELECT *
			FROM #{self.table_name}
			WHERE id = ?
		SQL

		self.new(result.first)
	end

	def save
		if self.id.nil?
			create
		else
			update
		end
	end

	private 
	
	def attribute_values
		attribute_vals = self.class.attributes.map do |attr|
			send(attr)
		end
	end

	def update

		set_line = self.class.attributes.map do |attribute|
			"#{attribute} = ?"  
		end

		DBConnection.execute(<<-SQL, *attribute_values)
			UPDATE #{self.table_name}
			SET set_line.join(", ")
		SQL
	end

	def create 
		attributes_line = self.class.attributes.join(", ")
		questions = ["?"] * self.class.attributes.count
		questions_line = questions.join(", ")

		DBConnection.execute(<<-SQL, *attribute_values)
			INSERT INTO #{self.class.table_name}
			(#{attributes_line})
			VALUES (#{questions_line})
		SQL

		self.id = DBConnection.last_insert_row_id

	end

end
