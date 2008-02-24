require File.join(File.dirname(__FILE__), '..', 'spec_helper')
require 'on_zero_load/monitor'


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
