module OnZeroLoad
  class LoadAvg
    include Comparable

    attr_accessor :one
    attr_accessor :five
    attr_accessor :fifteen

    LOADS = [ :one, :five, :fifteen ] # :nodoc:

    def initialize(params = {})
      LOADS.each do |load|
        self.send("#{load}=".to_sym, params[load])
      end
    end

    def hash
      LOADS.map { |load|
        self.send(load)
      }.hash
    end

    def == other
      self.equal?(other) ||
      LOADS.all? { |load|
        other.respond_to?(load) && self.send(load) == other.send(load)
      }
    end

    alias_method :eql?, :==

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

    def to_s
      "load:" + LOADS.map { |load|
        "#{self.send(load)}:#{load}" if self.send(load)
      }.compact.join(",")
    end

    alias_method(:inspect, :to_s)

    def self.parse(string)
      num    = '[+-]?(?:\d*\.\d+|\d+)(?:e\d+)?'
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
