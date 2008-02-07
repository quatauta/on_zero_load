require File.join(File.dirname(__FILE__), '..', 'spec_helper')
require 'on_zero_load/monitor'


describe "System monitor loadavg raw data" do
  before do
    @loadavg_raw = OnZeroLoad::Monitor.loadavg_raw
  end

  it "is a non-empty array" do
    @loadavg_raw.should be_kind_of(Array)
    @loadavg_raw.should_not be_empty
  end

  it "contains three floating-point numbers" do
    @loadavg_raw.should have(3).elements
    @loadavg_raw.each do |a|
      a.should be_kind_of(Float)
    end
  end

  it "contains only numbers between zero and twenty" do
    @loadavg_raw.each do |a|
      a.should be_between(0, 20)
    end
  end
end


describe "System monitor loadavg data" do
  before do
    @loadavg_raw = OnZeroLoad::Monitor.loadavg_raw
    @loadavg     = OnZeroLoad::Monitor.loadavg
  end

  it "is a non-empty hash" do
    @loadavg.should be_kind_of(Hash)
    @loadavg.should_not be_empty
  end

  it "includes values for one, five and fifteen minute load" do
    @loadavg.should include(:one)
    @loadavg.should include(:five)
    @loadavg.should include(:fifteen)
  end

  it "includes only numeric values" do
    @loadavg.each_pair do |key, value|
      value.should be_kind_of(Numeric)
    end
  end

  it "includes the raw data value for one minute load" do
    @loadavg[:one].should == @loadavg_raw[0]
  end

  it "includes the raw data value for five minute load" do
    @loadavg[:five].should == @loadavg_raw[1]
  end

  it "includes the raw data value for fifteen minute load" do
    @loadavg[:fifteen].should == @loadavg_raw[2]
  end
end


describe "System monitor network raw data" do
  before do
    @net_raw = OnZeroLoad::Monitor.net_raw
  end

  it "is a non-empty array" do
    @net_raw.should be_kind_of(Array)
    @net_raw.should_not be_empty
  end

  it "is a 2-dimensional array" do
    @net_raw.each do |a|
      a.should be_kind_of(Array)
    end
  end

  it "contains headers in the first two sub-arrays" do
    @net_raw.size.should >= 2
    @net_raw[0..1].each do |a|
      a.should_not be_empty
      a.each do |b|
        b.should be_kind_of(String)
      end
    end
  end

  it "contains interface name and 16 numbers for each interface" do
    @net_raw[2 .. @net_raw.size].each do |a|
      a.first.should be_kind_of(String)
      a.size.should == 17
      a[1 .. a.size].each do |n|
        n.should be_kind_of(Numeric)
      end
    end
  end
end


describe "System monitor network data" do
  before do
    @net_raw = OnZeroLoad::Monitor.net_raw
    @net     = OnZeroLoad::Monitor.net
  end

  it "is a non-empty hash" do
    @net.should be_kind_of(Hash)
    @net.should_not be_empty
  end

  it "contains the interfaces from raw data" do
    raw_names = @net_raw[2 .. @net_raw.size].map {|a| a.first }.sort
    names     = @net.keys.sort

    names.should == raw_names
  end

  it "contains hashes for receive and transmit counters per interface" do
    @net.each_pair do |name, values|
      values.should be_kind_of(Hash)
      [:receive, :transmit].each do |a|
        values.keys.should include(a)
        values[a].should be_kind_of(Hash)
      end
    end
  end

  it "contains counters per interface addressed by counter-name-symbols" do
    @net.each_pair do |name, values|
      values.each_pair do |direction, counters|
        counters.should_not be_empty
        counters.keys.each do |counter_name|
          counter_name.should be_kind_of(Symbol)
        end
      end
    end
  end

  it "contains numbers as counter values" do
    @net.each_pair do |name, values|
      values.each_pair do |direction, counters|
        counters.each_pair do |counter_name, value|
          value.should be_kind_of(Numeric)
        end
      end
    end
  end

  it "contains a defined set of receive and transmit counters per interface" do
    @net.each_pair do |name, values|
      [:bytes, :packets, :errs, :drop, :fifo, :frame,
       :compressed, :multicast].each do |c|
        values[:receive].keys.should include(c)
      end

      [:bytes, :packets, :errs, :drop, :fifo, :colls,
       :carrier, :compressed].each do |c|
        values[:transmit].keys.should include(c)
      end
    end
  end
end
