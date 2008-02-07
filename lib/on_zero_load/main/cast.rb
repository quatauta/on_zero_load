require 'main'

module Main
  # Adds two new castings to the +main+ gem (http://rubyforge.org/projects/codeforpeople/
  # and http://codeforpeople.com/lib/ruby/main/). These castings are used in the
  # <code>on-zero-load</code> executable.
  #
  # byte_per_sec::
  #  Casts the option's value to a number in bytes per second. Uses the
  #  <code>ruby-units</code> gem for the unit information.
  #
  #  Example use within a +Main+ block:
  #   option "disk=[N]", "d" do
  #     arity -1
  #     cast :byte_per_sec
  #     default 0.unit("byte/second")
  #     description "Bytes/second read from or written to disk, 0 <= N."
  #     validate { |n| 0 <= n }
  #   end
  #
  # load_avg::
  #  Casts the option's value to a OnZeroLoad::LoadAvg. The option's value should be a
  #  string like <code>"1.25:one"</code>. It's split a the first colon. The first part is
  #  converted to a number. The second specifies the loadavg type and must match one of
  #  the symbols <code>:one</code>, <code>:five</code> and <code>:fifteen</code>. The
  #  casting result is a OnZeroLoad::LoadAvg containing <code>:value</code> and
  #  <code>:type</code>.
  #
  #   "2.42"         -> { :value => 2.42, :type => :one }
  #   "1.61:one"     -> { :value => 1.61, :type => :one }
  #   "0.59:five"    -> { :value => 0.59, :type => :five }
  #   "0.34:fifteen" -> { :value => 0.34, :type => :fifteen }
  #
  #  Example use within a +Main+ block:
  #   option "load=[N]", "l" do
  #     arity -1
  #     cast :loadavg
  #     default "0.0:one"
  #     description "Loadavg of one, five or fifteen minutes. " \
  #                 "Format: <N>:[one*,five,fifteen], 0 <= N: " \
  #                 "0.32, 0.41:one, 0.1:five, 0.8:fifteen"
  #     validate { |n| 0 <= n[:value] &&
  #                    [:one, :five, :fifteen].include?(n[:type]) }
  #   end
  module Cast
    cast :byte_per_sec do |obj|
      a = Unit.new(obj)
      a.unitless? ? a.to_f.unit("byte/second") : a
    end

    cast :loadavg do |obj|
      OnZeroLoad::LoadAvg.parse(obj)
    end
  end
end
