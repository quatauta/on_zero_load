# frozen_string_literal: true

# vim:set fileencoding=utf-8:

module OnZeroLoad
  class LoadAvg
    # The current loadavg values from <code>/proc/loadavg</code> as three-elemental array
    # of floats.
    #
    #  [0.16, 0.14, 0.11]
    def self.current_raw
      data = open("/proc/loadavg", &:readline) .split[0..2]

      data.map do |field|
        /^[[:digit:].,]+$/.match?(field) ? field.to_f : field
      end
    end

    # The current loadavg as a hash.
    #
    #  { :one => 0.16, :five => 0.14, :fifteen => 0.11 }
    def self.current(raw = current_raw)
      {one: raw[0], five: raw[1], fifteen: raw[2]}
    end
  end
end
