require_relative 'db_connection'
require 'active_support/inflector'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    return @columns if @columns
    data = DBConnection.execute2(<<-SQL)
    SELECT
      *
    FROM
      #{self.table_name}
    SQL

    @columns = data[0].map {|el| el.to_sym}

  end

  def self.finalize!
    self.columns.each do |col|

      define_method("#{col}") do
        self.attributes[col]
      end

      define_method("#{col}=") do |value|
        self.attributes[col] = value
      end
    end

  end

  def self.table_name=(table_name)
    # ...
    define_method("#{name}=") do
      self.instance_variable_set("@#{name}", table_name)
    end
  end

  def self.table_name
    # ...
    name = self.name
    new_name = ''
    name.chars.each_with_index do |char, i|
      if char == char.upcase && i != 0
        char = '_' + char
      end
      new_name += char
    end
    new_name.downcase + 's'
  end

  def self.all
    # ...
    # name = "#{self.table_name}"

    data = DBConnection.execute(<<-SQL)
      SELECT
        *
      FROM
        #{self.table_name}
    SQL

    self.parse_all(data)
    # [{"id"=>1, "name"=>"Breakfast", "owner_id"=>1},
    # {"id"=>2, "name"=>"Earl", "owner_id"=>2},
    # {"id"=>3, "name"=>"Haskell", "owner_id"=>3},
    # {"id"=>4, "name"=>"Markov", "owner_id"=>3},
    # {"id"=>5, "name"=>"Stray Cat", "owner_id"=>nil}]
  end

  def self.parse_all(results)
    # ...
    results.map { |hash| self.new(hash) }
  end

  def self.find(id)
    # ...
    table = self.all
    table.find { |obj| obj.id == id }
  end

  def initialize(params = {})
    params.each do |attr_name, value|
      # puts k, SQLObject.columns
      attr_name = attr_name.to_sym
      raise "unknown attribute '#{attr_name}'" unless self.class.columns.include?(attr_name)
      self.send("#{attr_name}=", value)
    end
  end

  def attributes
    @attributes ||= Hash.new
    @attributes
  end

  def attribute_values
    # ...
    @attributes.values
  end

  def insert
    # ...

  data = DBConnection.execute(<<-SQL )
  INSERT INTO
    #{self.class.table_name} #{self.class.columns})
  VALUES
    (?, ?, ?)
  SQL



  end

  def update
    # ...
    data = DBConnection.execute(<<-SQL )
    UPDATE
      table_name
    SET
      col1 = ?, col2 = ?, col3 = ?
    WHERE
      id = ?
    SQL

    
  end

  def save
    # ...
  end
end
