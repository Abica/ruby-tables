class Table
  include Enumerable

  def self.[] *args
    new *args
  end

  def initialize *args
    @values = []
    @records = {}
    process *args
  end

  def [] key
    if key.is_a? Integer
      @values[ key ]
    else
      @records[ key ]
    end
  end

  def []= key, value
    if key.is_a? Integer
      @values[ key ] = value
    else
      process_hash key => value
    end
  end

  def << arg
    process arg
  end

  def + other
    values = self.to_a + other.to_a 
    Table[ self.pairs, other.pairs, *values ]
  end

  def first
    @values.first
  end

  def last
    @values.last
  end

  def size
    @values.size
  end

  alias length size

  def each &block
    @values.each &block
  end

  def sort &block
    @values.sort &block
  end

  def each_pair &block
    @records.each_pair &block
  end

  def each_key &block
    @records.each_key &block
  end

  def pairs
    @records
  end

  def keys
    @records.keys
  end

  def values
    @records.values
  end

  private
    def process *args
      args.each do | arg |
        if arg.is_a? Hash
          process_hash arg
        else
          @values << arg
        end
      end
    end

    def process_hash hsh
      hsh.each do | key, value |
        key = [ key ] if key.is_a? Integer
        @records[ key ] = value

        next unless key.is_a? Symbol
        next if respond_to? key and respond_to? "#{ key }="

        instance_eval <<-EOM
          def #{ key }
            @records[ #{ key.inspect } ]
          end

          def #{ key }= value
            @records[ #{ key.inspect } ] = value
          end
        EOM
      end
    end

    def method_missing meth_id, *args 
      name = meth_id.id2name
      if key = name[ /(\w+)=/, 1 ]
        process_hash key.to_sym => args.first
      end
    end
end
