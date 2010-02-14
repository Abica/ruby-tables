# Implements a table data structure
class Table
  include Enumerable

  # takes a comma separated list of arrays and hashes and returns a table
  #
  # example:
  #   Table[ 1, 2, 3, 4, { :a => 3, :b => 5 }, 7, 8, { :c => 33 } ]
  def self.[] *args
    new *args
  end

  def initialize *args
    @values = []
    @records = {}
    process *args
  end

  # returns the value corresponding to the index or key
  #
  #   t = Table[ 1, 2, "string", { :a => 4, :b => 5 }, 3, 4 ]
  #   t[ 2 ] #=> "string"
  #   t[ :a ] #=> 4
  #
  # symbolized keys are also accessible via dot notation:
  #
  #   t.a #=> 4
  #   t.b #=> 5
  def [] key
    if key.is_a? Integer
      @values[ key ]
    else
      @records[ key ]
    end
  end

  # updates the value for a given key or index
  # if no entry exists for the given key or index then one is created
  #
  #   t = Table[ :a => "abcde", :b => 44332211 ]
  #   t[ :a ] = 43
  #   t[ :a ] #=> 43
  #   t[ 0 ] = 54
  #   t.first #=> 54
  #
  # note that like an array, if you insert a value into a table at an
  # index that doesn't yet exist, any gaps will be filled in with nil
  # such as:
  #
  #   t[ 5 ] = 100
  #   t.to_a #=> [ 54, nil, nil, nil, 100 ]
  #
  # symbolized keys also have setters so that you can use dot notation:
  #
  #   t.a = "bbcec"
  #   t.a #=> "bbcec"
  def []= key, value
    if key.is_a? Integer
      @values[ key ] = value
    else
      process_hash key => value
    end
  end

  # add a hash or value to this table
  #
  #   t = Table[ 1, 2, 3 ]
  #   t << { :a => 4, :b => 4 }
  def << arg
    process arg
  end

  # combines 2 tables
  #
  #   Table[ :a => 4, :b => 5 ] + Table[ 1, 2, 3, 4, { :c => 4 } ]
  def + other
    values = self.to_a + other.to_a 
    Table[ self.pairs, other.pairs, *values ]
  end

  # returns the first non pair item in the table
  #
  #   t = Table[ { :a => 4 }, 1, 2, 3, 4, { :b => 4, :c => 23 } ]
  #   t.first #=> 1
  def first
    @values.first
  end

  # returns the last non pair item in the table
  #
  #   t = Table[ { :a => 4 }, 1, 2, 3, 4, { :b => 4, :c => 23 } ]
  #   t.last #=> 4
  def last
    @values.last
  end

  # returns the length of all integer indexes
  #
  #   t = Table[ 1, 2, { :b => 4 }, 3, 4 ]
  #   t.size #=> 4
  def size
    @values.size
  end

  alias length size

  # iterate through each of the array values
  def each &block
    @values.each &block
  end

  # sort the array values
  #
  #   t = Table[ 2, 23, 54, { :a => 4 }, 49 ]
  #   t.sort #=> [ 2, 23, 49, 54 ]
  def sort &block
    @values.sort &block
  end

  # iterate through the key => value pairs in the table
  def each_pair &block
    @records.each_pair &block
  end

  # iterate through the hash keys in the table 
  def each_key &block
    @records.each_key &block
  end

  # returns a hash of all key => value pairs inside the table
  #
  #   t = Table[ 1, { :a => 4 }, 2, { :b => 543 } ]
  #   t.pairs #=> { :a => 4, :b => 543 }
  def pairs
    @records
  end

  # return an array of all hash keys in the table
  #
  #   t = Table[ 1, 2, { :a => 55, :b => 77 }, 3, { :c => 22 } ]
  #   t.keys #=> [ :a, :b, :c ]
  def keys
    @records.keys
  end

  # returns an array of all hash values in the table
  #
  #   t = Table[ 1, 2, { :a => 55, :b => 77 }, 3, { :c => 22 } ]
  #   t.values #=> [ 55, 77, 22 ]
  def values
    @records.values
  end

  private
    # adds +args+ into the table
    def process *args
      args.each do | arg |
        if arg.is_a? Hash
          process_hash arg
        else
          @values << arg
        end
      end
    end

    # adds a hash entries to the table and creates
    # setters and getters for them if the keys are symbolized
    #
    # any keys that are numeric are wrapped in an array so as
    # not to overlap array indices which could get confusing
    def process_hash hsh
      hsh.each do | key, value |
        key = [ key ] if key.is_a? Integer
        @records[ key ] = value

        next unless key.is_a? Symbol
        next if respond_to? key and respond_to? "#{ key }="

        instance_eval <<-EOM
          def #{ key }
            @records[ :#{ key } ]
          end

          def #{ key }= value
            @records[ :#{ key } ] = value
          end
        EOM
      end
    end

    # if an accessor is called that doesn't exist, the key => value
    # are added into the table
    def method_missing meth_id, *args
      name = meth_id.id2name
      if key = name[ /(\w+)=/, 1 ]
        process_hash key.to_sym => args.first
      end
    end
end
