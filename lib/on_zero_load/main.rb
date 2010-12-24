module OnZeroLoad
  class Main
    autoload :MainOptParse, 'on_zero_load/main/optparse'
    autoload :MainQuickl,   'on_zero_load/main/quickl'
    autoload :MainTrollop,  'on_zero_load/main/trollop'

    def self.parse(args = ARGV, parser = :quickl)
      case parser
      when :optparse
        self.parse_optparse(args)
      when :quickl
        self.parse_quickl(args)
      when :trollop
        self.parse_trollop(args)
      end
    end

    def self.parse_optparse(args = ARGV)
      MainOptParse.parse(args)
    end

    def self.parse_quickl(args = ARGV)
      MainQuickl.parse(args)
    end

    def self.parse_trollop(args = ARGV)
      MainTrollop.parse(args)
    end
  end
end
