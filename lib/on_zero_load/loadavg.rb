module OnZeroLoad
  # Objects of this class represent the average load (loadavg) of a Linux system.
  #
  # The loadavg can be obtained from the file <code>/proc/loadavg</code>. See <code>man 5
  # proc</code> for detailed description of that file.
  class LoadAvg
    include Comparable

    # The load averaged over the last minute. Negative numbers are rejected by raising a
    # +ArgumentExecption+. See <code>#validate</code>.
    attr_accessor :one

    # The load averaged over the five minutes. Negative numbers are rejected by raising a
    # +ArgumentExecption+. See <code>#validate</code>.
    attr_accessor :five

    # The load averaged over the fifteen minutes. Negative numbers are rejected by raising
    # a +ArgumentExecption+. See <code>#validate</code>.
    attr_accessor :fifteen

    # Holds the available attribute names to simplify some methods.
    LOADS = [ :one, :five, :fifteen ].freeze

    # Create a new instance and set the loadavg values.
    #
    # Accepted parameter-keywords are <code>:one</code>, <code>:five</code> and
    # <code>:fifteen</code>.  They must hold +nil+'s or positive numbers.  See
    # <code>#validate</code>.
    def initialize(params = {})
      LOADS.each do |load|
        self.send("#{load}=".to_sym, params[load])
      end
    end

    def one=(one) # :nodoc:
      validate(one)
      @one = one
    end

    def five=(five) # :nodoc:
      validate(five)
      @five = five
    end

    def fifteen=(fifteen) # :nodoc:
      validate(fifteen)
      @fifteen = fifteen
    end

    # Tests if +value+ is +nil+ or a positive number. Raises an +ArgumentException+ if
    # not.
    def validate(value)
      unless (value.nil? || (value.kind_of?(Numeric) && 0 <= value))
        raise ArgumentError.new("Loadavg values must be positive, not #{value}.")
      end
    end

    # Computes a hash-value. Creates an array of the loadavg values and returns the
    # array's hash-value.
    def hash
      LOADS.map { |load|
        self.send(load)
      }.hash
    end

    # Tests this instance for equality to another object.  Both are considered equal, if
    # +other+ responds to <code>one</code>, <code>five</code> and <code>fifteen</code>,
    # and returns values equal to those of this instance.
    def == other
      self.equal?(other) ||
      LOADS.all? { |load|
        other.respond_to?(load) && self.send(load) == other.send(load)
      }
    end

    alias_method(:eql?, :==)

    # Compares this instance to another object.  The comparison takes into account only
    # the non-+nil+ loadavg values of both objects.  Returns -1 if this instance is
    # considered smaller than +other+, 0 if both are considered equal, and 1 if this
    # instance is considered larger than +other+.
    #
    # FIXME (describe <=> algorithm in detail)
    def <=> other
      comparisons = LOADS.map { |load|
        a = self.send(load)
        b = other.respond_to?(load) && other.send(load)

        a <=> b if a && b
      }.compact

      if comparisons.empty?
        nil
      else
        comparisons.find { |comparison| 0 != comparison } || 0
      end
    end

    # Returns a string representation of this instance.
    def to_s
      "load:" + LOADS.map { |load|
        "#{self.send(load)}:#{load}" if self.send(load)
      }.compact.join(",")
    end

    alias_method(:inspect, :to_s)

    # Parses +string+ to a +LoadAvg+ instance.
    #
    # Scans +string+ for substrings that look like a valid loadavg specification. Only the
    # last value for the one-, five- and fifteen-minute loadavg is stored in the retured
    # object.
    #
    # A valid loadavg specification looks like this: (EBNF)
    #
    #  loadavg = number | number ":" minutes
    #  number  = [ sign ] digits [ "." digits ] [ "e" [ sign ] digits ]
    #  minutes = "one" | "five" | "fifteen" | "1" | "5" | "15"
    #  sign    = "+" | "-"
    #  digits  = digit { digit }
    #  digit   = "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9"
    #
    # A loadavg specification without +minutes+ is assumed to be a one-minute loadavg.
    def self.parse(string)
      num    = '[+-]?(?:\d*\.\d+|\d+)(?:e[+-]?\d+)?'
      load   = '\b(one|five|fifteen|1|5|15)\b'
      expr   = Regexp.new("(#{num})(?::(#{load}))?")
      sub    = { "1" => "one", "5" => "five", "15" => "fifteen" }
      params = {}

      string.to_s.scan(expr).map do |value, load|
        value  = value.to_f
        load ||= "one"

        sub.each do |num, str|
          load.sub!(Regexp.new("^#{num}$"), str)
        end

        params[load.to_sym] = value
      end

      self.new(params)
    end
  end
end
