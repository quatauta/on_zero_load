module OnZeroLoad
  class CPU
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
    def self.current_raw
      open("/proc/stat") { |f| f.readlines } \
      .grep(/^cpu/i) \
      .map { |line|
        line.strip.split.map { |field|
          /^[[:digit:].,]+$/ =~ field ? field.to_i : field
        }
      }
    end

    def self.current
      all = [:user, :nice, :system, :idle, :iowait, :irq, :softirq, :steal]
      act = all - [:idle, :iowait]
      values = {}

      self.current_raw.each do |line|
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
