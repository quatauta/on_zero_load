module OnZeroLoad
  module Monitor
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
    def self.net_raw()
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
    def self.net()
      values = {}
      data   = self.net_raw

      [0..1].each do |n| # convert headers to downcase symbols
        data[n] = data[n].map { |l| l.map { |f| f.downcase.to_sym } }
      end

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

    # The current cpu activity counters from <code>/proc/stat</code> as array for each CPU
    # and accumulated for all CPUs.
    #
    # From Linux Kernel 2.6.23 <code>Documentation/filesystems/proc.txt</code>:
    #
    #  1.8 Miscellaneous kernel statistics in /proc/stat
    #  -------------------------------------------------
    #  Various pieces of information about kernel activity are available in the /proc/stat
    #  file.  All of the numbers reported in this file are aggregates since the system
    #  first booted.  [...]
    #  - user: normal processes executing in user mode
    #  - nice: niced processes executing in user mode
    #  - system: processes executing in kernel mode
    #  - idle: twiddling thumbs
    #  - iowait: waiting for I/O to complete
    #  - irq: servicing interrupts
    #  - softirq: servicing softirqs
    #
    # See PROC(5) (a.k.a <code>man 5 proc</code>), and Linux
    # Kernel files <code>Documentation/filesystems/proc.txt</code> and
    # <code>Documentation/cpu-load.txt</code> for more information.
    #
    #  [["cpu",  102750, 267374, 97858, 736771, 83711, 937, 839, 0],
    #   ["cpu0", 102750, 267374, 97858, 736771, 83711, 937, 839, 0]]
    def self.cpu_raw()
      open("/proc/stat") { |f| f.readlines } \
      .grep(/^cpu/i) \
      .map { |line|
        line.strip.split.map { |field|
          /^[[:digit:].,]+$/ =~ field ? field.to_i : field
        }
      }
    end

    def self.cpu()
      all = [:user, :nice, :system, :idle, :iowait, :irq, :softirq, :steal]
      act = all - [:idle, :iowait]
      values = {}

      self.cpu_raw.each do |line|
        cpu = line.first
        val = values[cpu] = {}

        all.each_with_index { |s, i| val[s] = line[i + 1] }

        val[:active] = act.inject(0) { |sum, f| sum + val[f] }
        val[:total]  = all.inject(0) { |sum, f| sum + val[f] }
      end

      values
    end
  end
end
