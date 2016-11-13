# -*- coding: utf-8; -*-
# frozen_string_literal: true
# vim:set fileencoding=utf-8:

module OnZeroLoad
  class Disk
    # The current I/O statistics read from <code>/proc/diskstats</code> as array for each
    # block device.
    #
    # From Linux Kernel 2.6.34 <code>Documentation/iostats.txt</code>:
    #
    #  Field  1 -- # of reads completed
    #  Field  2 -- # of reads merged, field 6 -- # of writes merged
    #  Field  3 -- # of sectors read
    #  Field  4 -- # of milliseconds spent reading
    #  Field  5 -- # of writes completed
    #  Field  6 -- # of reads merged
    #  Field  7 -- # of sectors written
    #  Field  8 -- # of milliseconds spent writing
    #  Field  9 -- # of I/Os currently in progress
    #  Field 10 -- # of milliseconds spent doing I/Os
    #  Field 11 -- weighted # of milliseconds spent doing I/Os
    #
    # See <code>Documentation/iostats.txt</code> for more information on the fields.
    #
    #  [["sda", 1035624, 729786, 61642589, 3015817, 580170, 2520045, 25853354, 4139270, 0, 2184914, 7154789],
    #   ["sr0", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]]
    #
    # (Only the statistics for devices +sda+ and +sr0+ are shown for simplicity.)
    def self.current_raw
      lines = open('/proc/diskstats', &:readlines)

      lines.map do |line|
        line.strip.split[2..-1].map do |field|
          /^[[:digit:].,]+$/ =~ field ? field.to_i : field
        end
      end
    end

    # The current I/O statistics for each block device. The values returned by
    # <code>#current_raw</code> are converted into hashes.
    #
    #  { "sda" => { :read_ms  => 3018928, :read_sectors   => 61658637, :reads  => 1036434, :reads_merged  => 730003,
    #               :write_ms => 4142753, :write_sectors  => 25895394, :writes => 581769,  :writes_merged => 2523701,
    #               :io_ms    => 2189660, :io_ms_weighted => 7161380,  :io_in_progress => 0 },
    #    "sr0" => { :read_ms  => 0, :read_sectors   => 0, :reads  => 0, :reads_merged  => 0,
    #               :write_ms => 0, :write_sectors  => 0, :writes => 0, :writes_merged => 0,
    #               :io_ms    => 0, :io_ms_weighted => 0, :io_in_progress => 0,}, }
    #
    # (Only the statistics for devices +sda+ and +sr0+ are shown for simplicity.)
    def self.current(raw = current_raw)
      fields = [:reads, :reads_merged, :read_sectors, :read_ms,
                :writes, :writes_merged, :write_sectors, :write_ms,
                :io_in_progress, :io_ms, :io_ms_weighted]
      values = {}

      raw.each do |line|
        device = line.shift

        line.each_with_index do |value, index|
          field = fields[index]

          (values[device] ||= {})[field] = value
        end
      end

      values
    end
  end
end
