require 'main'
require 'ruby-units'


module Main
  # Adds two new castings to the +main+ gem (http://rubyforge.org/projects/codeforpeople
  # and http://codeforpeople.com/lib/ruby/main). These castings are used in the
  # <code>on-zero-load</code> executable.
  #
  # +byte_per_sec+::
  #  Casts the option's value to a number in bytes per second. Uses the
  #  <code>ruby-units</code> gem for the unit information.
  #
  #  Example use within a +Main+ block:
  #   option "disk=[N]", "d" do
  #     cast :byte_per_sec
  #     default "0 Kib/s"
  #     validate { |n| n =~ "Kib/s" && 0 <= n }
  #   end
  #
  # +load_avg+::
  #  Casts the option's value to a OnZeroLoad::LoadAvg. The option's value should be a
  #  string like <code>"1.25:one"</code>. See <code>OnZeroLoad::LoadAvg</code>'s
  #  <code>parse</code> method for more information about what the input may look like.
  #
  #   "2.42"         -> { :value => 2.42, :type => :one }
  #   "1.61:one"     -> { :value => 1.61, :type => :one }
  #   "0.59:five"    -> { :value => 0.59, :type => :five }
  #   "0.34:fifteen" -> { :value => 0.34, :type => :fifteen }
  #
  #  Example use within a +Main+ block:
  #   option "load=[N]", "l" do
  #     cast :loadavg
  #     default "0.0:one"
  #   end
  #
  # +percent+::
  #  Casts the option's value to percents. Uses the <code>ruby-units</code> gem for the
  #  unit information. This one really doesn't need the <code>ruby-unit</code>, I chose
  #  it only for consistency.
  #
  #  Example use within a +Main+ block:
  #   option "cpu=[N]", "c" do
  #     cast :percent
  #     default "0 %"
  #     validate { |n| n =~ "%" && ("0%".u .. "100%".u).include?(n) }
  #   end
  #
  # +seconds+::
  #  Cases the option's value to seconds. Uses the <code>ruby-units</code> gem for the
  #  unit information.
  #
  #  Example use within a +Main+ block:
  #   option "sleep=N", "s" do
  #     cast :seconds
  #     default "60 s"
  #     validate { |n| n =~ "s" && 0 < n }
  #   end
  module Cast
    {
      :byte_per_sec => "byte/second",
      :percent      => "percent",
      :seconds      => "seconds",
    }.each do |sym, unit|
      cast sym do |obj|
        a = Unit.new(obj)
        a.unitless? ? a.to_f.unit(unit) : a
      end
    end

    cast :loadavg do |obj|
      OnZeroLoad::LoadAvg.parse(obj)
    end
  end
end
