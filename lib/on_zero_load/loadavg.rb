module OnZeroLoad
  class LoadAvg
    # The current loadavg values from <code>/proc/loadavg</code> as three-elemental array
    # of floats.
    #
    #  [0.16, 0.14, 0.11]
    def self.current_raw
      data = open("/proc/loadavg") { |f| f.readline } .split[0..2]
      
      data.map { |field|
        /^[[:digit:].,]+$/ =~ field ? field.to_f : field
      }
    end

    # The current loadavg as a hash.
    #
    #  { :one => 0.16, :five => 0.14, :fifteen => 0.11 }
    def self.current
      data = self.current_raw

      { :one     => data[0],
        :five    => data[1],
        :fifteen => data[2] }
    end
  end
end
