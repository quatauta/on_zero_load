module OnZeroLoad
  class Main
    autoload :MainOptParse, 'on_zero_load/main/optparse'
    autoload :MainTrollop,  'on_zero_load/main/trollop'

    def self.parse(args = ARGV, parser = :optparse)
      case parser
      when :optparse
        self.parse_optparse(args)
      when :trollop
        self.parse_trollop(args)
      end
    end

    def self.parse_optparse(args = ARGV)
      MainOptParse.parse(args)
    end

    def self.parse_trollop(args = ARGV)
      MainTrollop.parse(args)
    end
  end
end
