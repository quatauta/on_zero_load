module OnZeroLoad
  class Net
    # The current network interface statistics from <code>/proc/net/dev</code> as
    # array. The file's lines are just split on whitespace and <code>/[-:|]/</code>. The
    # numeric field values are converted to integers.
    #
    #  [["Inter", "Receive", "Transmit"],
    #   ["face", "bytes", "packets", "errs", "drop", "fifo", "frame", "compressed", "multicast",
    #            "bytes", "packets", "errs", "drop", "fifo", "colls", "carrier", "compressed"],
    #   ["lo",   1062918186, 1571073, 0, 0, 0, 0, 0, 0,
    #            1062918186, 1571073, 0, 0, 0, 0, 0, 0],
    #   ["eth0", 1101824917,  834046, 0, 0, 0, 0, 0, 0,
    #              66796500,  742011, 0, 0, 0, 0, 0, 0]]
    def self.current_raw
      open("/proc/net/dev") { |f| f.readlines } .map { |line|
        line.strip.split(/[-:|[:space:]]+/).map { |field|
          /^[[:digit:].,]+$/ =~ field ? field.to_i : field
        }
      }
    end

    # The current network interface statistics as hash. The interface-name-keys are
    # strings; the counter-keys are symbols.
    #
    #  { "lo"   => { :receive  => { :bytes => 1062918168, :packets => 1571073,
    #                               :errs => 0, :drop => 0, :fifo => 0, :frame => 0,
    #                               :compressed => 0, :multicast => 0 },
    #                :transmit => { :bytes => 1062918168, :packets => 1571073,
    #                               :errs => 0, :drop => 0, :fifo => 0, :colls => 0,
    #                               :carrier => 0, :compressed => 0 } },
    #    "eth0" => { :receive  => { :packets => 1101824917, :bytes => 834046,
    #                               :errs => 0, :drop => 0, :fifo => 0, :frame => 0,
    #                               :compressed => 0, :multicast => 0 },
    #                :transmit => { :bytes => 66796500, :packets => 742011,
    #                               :errs => 0, :drop => 0, :fifo => 0, :colls => 0,
    #                               :carrier => 0, :compressed => 0 } } }
    def self.current
      values = {}
      data   = downcase_header_sym(self.current_raw)

      data[2 .. data.size].each do |line|
        name           = line.first
        values[name] ||= {}

        line[1 .. line.size].each_with_index do |field, index|
          dir  = data[0][index / 8 + 1] # first header line, should be :receive or :transmit
          type = data[1][index + 1]     # second header line, should be field name

          values[name][dir]     ||= {}
          values[name][dir][type] = field
        end
      end

      values
    end

    # TODO (comment downcase_header_sym)
    def self.downcase_header_sym(data)
      [0..1].each do |n| # convert headers to downcase symbols
        data[n] = data[n].map { |l| l.map { |f| f.downcase.to_sym } }
      end

      data
    end
  end
end
