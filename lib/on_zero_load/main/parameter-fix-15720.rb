require 'main'

module Main
  class Parameter
    # I found bug #15720 in gem main-2.5.0.  Since there was no answer to the bug report
    # within a few days, I needed to include the fix in my code.
    #
    # http://rubyforge.org/tracker/index.php?func=detail&aid=15720&group_id=1024&atid=4025
    #
    # Here is the description of the bug copied from the URL above:
    #
    #  If at least one of the short option names given to Main::Parameter.initialize is
    #  alphabetically greater than the long option name, there will be an ArgumentError
    #  "only one long name allowed". I think this is a bug in main-2.5.0.
    #  
    #  The bug is located in line 90 of main-2.5.0/lib/main/parameter.rb. The option names
    #  are just reverse-sorted. The attached patch fixes this.
    #  
    #  = Fix =
    #  
    #  Modify the reverse-sorting to reverse-sort the names on their size and forward-sort
    #  them alphabetically. Instead of sorting ["dry-run", "d", "n"] to ["d", "dry-run",
    #  "n"], this results in ["dry-run", "d", "n"].
    #  
    #  - @names = @names.sort.reverse
    #  + @names = @names.sort { |a, b|
    #  +   size_cmp = -1 * (a.size <=> b.size) # "aaa", "aa", "a"
    #  +   0 != size_cmp ? size_cmp : a.downcase <=> b.downcase
    #  + }
    def initialize name, *names, &block
      @names = Cast.list_of_string name, *names
      @names.map! do |name|
        if name =~ %r/^-+/
          name.gsub! %r/^-+/, ''
        end

        if name =~ %r/=.*$/
          argument( name =~ %r/=\s*\[.*$/ ? :optional : :required )
          name.gsub! %r/=.*$/, ''
        end

        name
      end
      # @names = @names.sort.reverse
      # The line above was fixed by the next four
      # Reported as bug #15720
      # http://rubyforge.org/tracker/index.php?func=detail&aid=15720&group_id=1024&atid=4025
      @names = @names.sort { |a, b|
        size_cmp = -1 * (a.size <=> b.size) # "aaa", "aa", "a"
        0 != size_cmp ? size_cmp : a.downcase <=> b.downcase
      }
      @names[1..-1].each do |name|
        raise ArgumentError, "only one long name allowed (#{ @names.inspect })" if
          name.size > 1
      end

      DSL.evaluate(self, &block) if block
    end
  end
end
