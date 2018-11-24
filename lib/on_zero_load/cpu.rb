# frozen_string_literal: true

# vim:set fileencoding=utf-8:

module OnZeroLoad
  class CPU
    # The current CPU activity counters from <code>/proc/stat</code> as array for each CPU
    # and accumulated for all CPUs.
    #
    # From Linux Kernel 4.8.3 <code>Documentation/filesystems/proc.txt</code>:
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
    #  - steal: involuntary wait
    #  - guest: running a normal guest
    #  - guest_nice: running a niced guest
    #
    # See PROC(5) (a.k.a <code>man 5 proc</code>), and Linux
    # Kernel files <code>Documentation/filesystems/proc.txt</code> and
    # <code>Documentation/cpu-load.txt</code> for more information.
    #
    #  [["cpu",  77507, 182684, 420187, 7786581, 44806, 0, 1589, 0, 0, 0],
    #   ["cpu0", 22353, 48526,  101261, 1939626, 11391, 0, 1527, 0, 0, 0]]
    def self.current_raw
      open("/proc/stat", &:readlines). \
        grep(/^cpu/i). \
        map do |line|
        line.strip.split.map do |field|
          /^[[:digit:].,]+$/.match?(field) ? field.to_i : field
        end
      end
    end

    # The current CPU activity counters. The values returned per CPU by
    # <code>#current_raw</code> are converted into hashes. The returned hash contains the
    # values per CPU (<code>"cpu0"</code>, <code>"cpu1"</code>, ...) and the cummulated
    # values (<code>"cpu"</code>). On a single processor, single core, non-hyper-threading
    # system, there will be only <code>"cpu0"</code> and <code>"cpu"</code>.
    #
    # In addition to the counters mentioned for <code>#current_raw</code>, the two
    # counters <code>:active</code> and <code>:total</code> are
    # calculated. <code>:active</code> contains the number of ticks during activity,
    # <code>:total</code> contains the sum of all counters.
    #
    #  { "cpu"  => { :user => 77507, :nice => 182684, :system => 420187, :idle => 7786581,
    #                :iowait => 44806, :irq => 0, :softirq => 1589, :steal => 0,
    #                :guest => 0, :guest_nice => 0, :active => 681967, :total => 8513354 },
    #    "cpu0" => { :user => 22353, :nice => 48526, :system => 101261, :idle => 1939626,
    #                :iowait => 11391, :irq => 0, :softirq => 1527, :steal => 0,
    #                :guest => 0, :guest_nice => 0, :active => 173667, :total => 2124684 } }
    def self.current(raw = current_raw)
      all = [:user, :nice, :system, :idle, :iowait, :irq, :softirq, :steal, :guest, :guest_nice]
      act = all - [:idle, :iowait]
      values = {}

      raw.each do |line|
        cpu = line.first
        val = values[cpu] = {}

        all.each_with_index { |s, i| val[s] = line[i + 1] if line[i + 1] }

        val[:active] = act.inject(0) { |sum, f| sum + val[f] }
        val[:total]  = all.inject(0) { |sum, f| sum + val[f] }
      end

      values
    end
  end
end
