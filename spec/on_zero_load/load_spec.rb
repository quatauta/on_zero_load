require File.join(File.dirname(__FILE__), '..', 'spec_helper')


module OnZeroLoad
  describe "LoadAverage object" do
    def create(*params)
      OnZeroLoad::LoadAvg.new(*params)
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
        a = OnZeroLoad::LoadAvg.parse(string)
        b = create(params)

        a.should eql(b)
      end
    end
  end
end
