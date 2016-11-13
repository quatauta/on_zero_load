# -*- coding: utf-8; -*-
# frozen_string_literal: true
# vim:set fileencoding=utf-8:

require File.join(File.dirname(__FILE__), '..', 'spec_helper')
require 'on_zero_load/net'

module OnZeroLoad
  describe 'System monitor network data' do
    before do
      @net = Net.current
    end

    it 'contains hashes for receive and transmit counters per interface' do
      @net.each_pair do |_name, values|
        expect(values).to be_kind_of(Hash)
        [:receive, :transmit].each do |a|
          expect(values.keys).to include(a)
          expect(values[a]).to be_kind_of(Hash)
        end
      end
    end

    it 'contains counters per interface addressed by counter-name-symbols' do
      @net.each_pair do |_name, values|
        [:receive, :transmit].each do |direction|
          expect(values[direction]).not_to be_empty
          values[direction].keys.each do |counter_name|
            expect(counter_name).to be_kind_of(Symbol)
          end
        end
      end
    end

    it 'contains numbers as counter values' do
      @net.each_pair do |_name, values|
        [:receive, :transmit].each do |direction|
          values[direction].each_pair do |_counter_name, value|
            expect(value).to be_kind_of(Numeric)
          end
        end
      end
    end

    it 'contains a defined set of counters per interface' do
      dev_keys = [:collisions, :multicast, :receive, :transmit]
      rx_keys  = [:bytes,
                  :compressed,
                  :crc_errors,
                  :dropped,
                  :errors,
                  :fifo_errors,
                  :frame_errors,
                  :length_errors,
                  :missed_errors,
                  :over_errors,
                  :packets]
      tx_keys  = [:aborted_errors,
                  :bytes,
                  :carrier_errors,
                  :compressed,
                  :dropped,
                  :errors,
                  :fifo_errors,
                  :heartbeat_errors,
                  :packets,
                  :window_errors]

      @net.each_pair do |_name, values|
        expect(values.keys).to include(*dev_keys)
        expect(values[:receive].keys).to include(*rx_keys)
        expect(values[:transmit].keys).to include(*tx_keys)
      end
    end
  end
end
