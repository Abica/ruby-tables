require File.join( "spec", "spec_helper" )

describe Table do
  before :all do
    @args = [ 1, 2, 3, 4, 5, { :k => 4 }, 7, 8, { :v => 10 } ]
    @array_vals = @args.reject { | a | a.is_a? Hash }
    @table = Table[ *@args ]
  end

  describe "[]" do
    it "is a new Table instance" do
      t = Table[ *@args ]

      t.should be_a( Table )
    end
  end

  describe "#[]" do
    it "returns the value at index" do
      @array_vals.each_with_index do | val, i |
        @table[ i ].should == val
      end
    end

    it "returns the value at key" do
      @table[ :k ].should == @args[ 5 ][ :k ]
      @table[ :v ].should == @args[ 8 ][ :v ]
    end
  end

  describe "#[]=" do
    it "creates a new value at index" do
      i = 500
      new_value = "something_new"
      @table[ i ].should be_nil
      @table[ i ] = new_value
      @table[ i ].should == new_value
      @table.size.should >= i
    end

    it "updates the value at index" do
      i = 3
      old_value = @args[ i ]
      new_value = 34903489034
      @table[ i ].should == old_value
      @table[ i ] = new_value
      @table[ i ].should == new_value
    end

    it "creates a new value for key" do
      key = :something_long_and_fake
      new_value = 0b0110
      @table[ key ].should be_nil
      @table[ key ] = new_value
      @table[ key ].should == new_value
    end

    it "updates the value for key" do
      key = :v
      old_value = @args[ 8 ][ key ]
      new_value = 50000000

      @table[ key ].should == old_value
      @table[ key ] = new_value 

      @table[ key ].should == new_value
    end
  end

  describe "#<<" do
    it "pushes an argument onto the table" do
      vals = [ 4000, [ 5, 0, 0, 0 ], "6000" ]
      vals.each do | val |
        @table << val
        @table.last.should == val
      end

      hsh = { :this => 1, :was => 2, :added => 3 }
      @table << hsh
      hsh.each do | k, v |
        @table[ k ].should == v
      end
    end
  end

  describe "#+" do
    before :all do
      @t1 = Table[ 1, 2, 3, { :a => 5, :b => 6 } ]
      @t2 = Table[ 4, 5, { :c => 7, :d => 8 }, 6 ]
      @t3 = @t1 + @t2
    end

    it "should combine 2 tables together" do
      @t3.to_a.should == [ 1, 2, 3, 4, 5, 6 ]
      pairs = @t3.pairs
      [ :a, :b, :c, :d ].each do | key |
        pairs.should have_key( key )
      end
    end
  end

  describe "#first" do
    it "should return the first array element" do
      t = Table[ *50..80 ]
      t.first.should == 50

      t = Table[ :a => 4, :b => 5, :c => 6 ]
      t.first.should be_nil
    end
  end

  describe "#last" do
    it "should return the last array element" do
      t = Table[ *50..80 ]
      t.last.should == 80

      t = Table[ :a => 4, :b => 5, :c => 6 ]
      t.last.should be_nil

      t = Table[ 1, 2, 3, { :a => 4, :b => 5, :c => 6 }, 600, 700, 800 ]
      t.last.should == 800
    end
  end

  describe "#size" do
    it "should return the number of array elements in the table" do
      @table.size.should == @array_vals.size
    end

    it "should be the same as length" do
      @table.size.should == @table.length
    end
  end

  describe "#sort" do
    it "returns a sorted array" do
      rand_vals = @array_vals.sort_by { rand }
      sorted_vals = rand_vals.sort

      t = Table[ *rand_vals ]
      t.to_a.should_not == sorted_vals
      t.sort.should == sorted_vals
    end
  end

  describe "#pairs" do
    it "returns a hash of all of the key => value pairs" do
      pairs = @table.pairs
      [ :k, :v ].each do | key |
        pairs.should have_key( key )
      end
    end
  end

  describe "#keys" do
    it "returns an array of all hash keys" do
      pairs = @table.pairs
      [ :k, :v ].each do | key |
        pairs.should have_key( key )
      end
    end
  end

  describe "#values" do
    it "returns an array of all hash values" do
      @table.values.sort.should == [ 4, 10 ]
    end
  end

  describe "setters for hash keys" do
    it "should add a key if one doesn't exist" do
      key = :super_long_key_name
      meth_name = "#{ key }="
      value = 349348908340
      @table.should_not respond_to( meth_name )
      @table.send meth_name, value
      @table.should respond_to( meth_name )
      @table[ key ].should == value
    end

    it "should override an existing key" do
      @table.v.should == 10
      @table.v = 50
      @table.v.should == 50
    end
  end

  describe "getters for hash keys" do
    it "returns the value for a key" do
      @table.v.should == 10
    end
  end
end
