# frozen_string_literal: true

# vim:set fileencoding=utf-8:

require "ruby-units"

module OnZeroLoad
  class Net
    # The current network interface statistics as hash. The interface-name-keys are
    # strings; the counter-keys are symbols.
    #
    # Data is read from the files in <code>/sys/class/net/*/statistics/</code>.
    #
    #   { "lo"   => { :collisions => 0,
    #                 :multicast  => 0,
    #                 :receive    => { :bytes => 15891551,   :compressed => 0,
    #                                  :crc_errors => 0,     :dropped => 0,
    #                                  :errors => 0,         :fifo_errors => 0,
    #                                  :frame_errors => 0,   :length_errors => 0,
    #                                  :missed_errors => 0,  :over_errors => 0,
    #                                  :packets => 232208 },
    #                 :transmit   => { :aborted_errors => 0, :bytes => 15891551,
    #                                  :carrier_errors => 0, :compressed => 0,
    #                                  :dropped => 0,        :errors => 0,
    #                                  :fifo_errors => 0,    :heartbeat_errors => 0,
    #                                  :packets => 232208,   :window_errors => 0 } },
    #     "eth0" => { :collisions => 0,
    #                 :multicast  => 0,
    #                 :receive    => { :bytes => 8220192299, :compressed => 0,
    #                                  :crc_errors => 0,     :dropped => 37,
    #                                  :errors => 0,         :fifo_errors => 0,
    #                                  :frame_errors => 0,   :length_errors => 0,
    #                                  :missed_errors => 0,  :over_errors => 0,
    #                                  :packets => 5911129 },
    #                 :transmit   => { :aborted_errors => 0, :bytes => 342981201,
    #                                  :carrier_errors => 0, :compressed => 0,
    #                                  :dropped => 0,        :errors => 0,
    #                                  :fifo_errors => 0,    :heartbeat_errors => 0,
    #                                  :packets => 3694591,  :window_errors => 0 } } }
    def self.current
      values = {}

      Dir.glob("/sys/class/net/*/statistics").each do |dir|
        dev = File.basename(File.dirname(dir))

        Dir.entries(dir).reject { |e| e =~ /^\.+/ } .sort.each do |file|
          key   = File.basename(file).
            downcase.
            sub(/^tx_/, "transmit_").
            sub(/^rx_/, "receive_").
            split("_", 2).
            map(&:to_sym)
          value = File.read(File.join(dir, file)).to_i

          case key.size
          when 1 then (values[dev] ||= {})[key.first] = value
          else ((values[dev] ||= {})[key.first] ||= {})[key[1..-1].join("_").to_sym] = value
          end
        end
      end

      values
    end
  end
end
