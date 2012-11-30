require File.join(File.dirname(__FILE__), '..', 'spec_helper')
require 'on_zero_load/net'


module OnZeroLoad
  describe "System monitor network data" do
    before do
      @net = Net.current
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
        [:receive, :transmit].each do |direction|
          values[direction].should_not be_empty
          values[direction].keys.each do |counter_name|
            counter_name.should be_kind_of(Symbol)
          end
        end
      end
    end

    it "contains numbers as counter values" do
      @net.each_pair do |name, values|
        [:receive, :transmit].each do |direction|
          values[direction].each_pair do |counter_name, value|
            value.should be_kind_of(Numeric)
          end
        end
      end
    end

    it "contains a defined set of counters per interface" do
      dev_keys = [ :collisions, :multicast, :receive, :transmit ]
      rx_keys  = [ :bytes,
                   :compressed,
                   :crc_errors,
                   :dropped,
                   :errors,
                   :fifo_errors,
                   :frame_errors,
                   :length_errors,
                   :missed_errors,
                   :over_errors,
                   :packets ]
      tx_keys  = [ :aborted_errors,
                   :bytes,
                   :carrier_errors,
                   :compressed,
                   :dropped,
                   :errors,
                   :fifo_errors,
                   :heartbeat_errors,
                   :packets,
                   :window_errors ]
      
      @net.each_pair do |name, values|
        values.keys.should include(*dev_keys)
        values[:receive].keys.should include(*rx_keys)
        values[:transmit].keys.should include(*tx_keys)
      end
    end
  end
end
