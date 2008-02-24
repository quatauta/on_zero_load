require File.join(File.dirname(__FILE__), '..', 'spec_helper')


module OnZeroLoad
  describe "System monitor loadavg raw data" do
    before do
      @raw = LoadAvg.current_raw
    end

    it "is a non-empty array" do
      @raw.should be_kind_of(Array)
      @raw.should_not be_empty
    end

    it "contains three floating-point numbers" do
      @raw.should have(3).elements
      @raw.each do |a|
        a.should be_kind_of(Float)
      end
    end

    it "contains only numbers between zero and twenty" do
      @raw.each do |a|
        a.should be_between(0, 20)
      end
    end
  end


  describe "System monitor loadavg data" do
    before do
      @raw  = LoadAvg.current_raw
      @load = LoadAvg.current
    end

    it "includes values for one, five and fifteen minute load" do
      @load.should respond_to(:one)
      @load.should respond_to(:five)
      @load.should respond_to(:fifteen)
    end

    it "includes only numeric values" do
      @load.one.should     be_kind_of(Numeric)
      @load.five.should    be_kind_of(Numeric)
      @load.fifteen.should be_kind_of(Numeric)
    end

    it "includes the raw data value for one minute load" do
      @load.one.should == @raw[0]
    end

    it "includes the raw data value for five minute load" do
      @load.five.should == @raw[1]
    end

    it "includes the raw data value for fifteen minute load" do
      @load.fifteen.should == @raw[2]
    end
  end


  describe "LoadAverage object" do
    def create(*params)
      LoadAvg.new(*params)
    end

    before do
      @empty = create()
    end

    it "stores one minute loadavg" do
      @empty.one.should be_nil
      @empty.one = 0.1
      @empty.one.should == 0.1
    end

    it "stores five minute loadavg" do
      @empty.five.should be_nil
      @empty.five = 0.2
      @empty.five.should == 0.2
    end

    it "stores fifteen minute loadavg" do
      @empty.fifteen.should be_nil
      @empty.fifteen = 0.3
      @empty.fifteen.should == 0.3
    end

    it "accepts only positive values" do
      lambda { @empty.one     = -1 } .should raise_error(ArgumentError)
      lambda { @empty.five    = -1 } .should raise_error(ArgumentError)
      lambda { @empty.fifteen = -1 } .should raise_error(ArgumentError)
    end

    it "has an initializer with named parameters" do
      p = { :one => 0.3, :five => 0.4, :fifteen => 0.5 }
      a = create(:one     => p[:one])
      b = create(:five    => p[:five])
      c = create(:fifteen => p[:fifteen])
      d = create(p)

      a.one.should     == p[:one]
      a.five.should    be_nil
      a.fifteen.should be_nil

      b.one.should     be_nil
      b.five.should    == p[:five]
      b.fifteen.should be_nil

      c.one.should     be_nil
      c.five.should    be_nil
      c.fifteen.should == p[:fifteen]

      d.one.should     == p[:one]
      d.five.should    == p[:five]
      d.fifteen.should == p[:fifteen]
    end

    it "has equivalent == and eql? methods" do
      @empty.should equal(@empty)
      @empty.should eql(@empty)
      (@empty.eql? @empty).should == (@empty == @empty)

      a = create()
      b = create(:one => 0.6, :five => 0.7, :fifteen => 0.8)

      @empty.should_not equal(a)
      @empty.should eql(a)
      @empty.should == a
      a.should_not equal(@empty)
      a.should eql(@empty)
      (a.eql? @empty).should == (a == @empty)

      a.one = b.one
      a.should_not eql(b) ; (a.eql? b).should == (a == b)
      b.should_not eql(a) ; (b.eql? a).should == (b == a)

      a.five = b.five
      a.should_not eql(b) ; (a.eql? b).should == (a == b)
      b.should_not eql(a) ; (b.eql? a).should == (b == a)

      a.fifteen = b.fifteen
      a.should eql(b) ; (a.eql? b).should == (a == b)
      b.should eql(a) ; (b.eql? a).should == (b == a)
    end

    it "has == and hash, such that a == b implies a.hash == b.hash" do
      a = create()
      b = create(:one => 0.6, :five => 0.7, :fifteen => 0.8)
      c = create(:one => 0.6, :five => 0.7, :fifteen => 0.8)

      (a == b).should == (a.hash == b.hash)
      (b == a).should == (b.hash == a.hash)
      (b == c).should == (b.hash == c.hash)
      (c == b).should == (c.hash == b.hash)
    end

    it "is comparable to others"
    it "allows comparing incomplete instances"

    it "can be parsed from string" do
      {
        ""            => {},
        "1"           => { :one => 1 },
        "0.1"         => { :one => 0.1 },
        "0.1,0.2"     => { :one => 0.2 },
        "1:one"       => { :one => 1 },
        "1:1"         => { :one => 1 },
        "0.1:one"     => { :one => 0.1 },
        "0.1:1"       => { :one => 0.1 },
        "0.2:five"    => { :five => 0.2 },
        "0.2:5"       => { :five => 0.2 },
        "0.3:fifteen" => { :fifteen => 0.3 },
        "0.3:15"      => { :fifteen => 0.3 },
        "load:1:one,2:five,3:fifteen" => { :one => 1, :five => 2, :fifteen => 3 },
        "load:1:1,2:5,3:15" => { :one => 1, :five => 2, :fifteen => 3 },
        "a0.1a"     => { :one => 0.1 },
        "a0.1:onea"     => { :one => 0.1 },
      }.each do |string, params|
        a = LoadAvg.parse(string)
        b = create(params)

        a.should eql(b)
      end
    end
  end
end
