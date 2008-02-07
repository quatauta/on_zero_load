# $Id$

# Equivalent to a header guard in C/C++
# Used to prevent the class/module from being loaded more than once
unless defined? OnZeroLoad

module OnZeroLoad
  AUTHORS = [ { :name    => "Daniel Schömer",
                :email   => "daniel.schoemer@gmx.net",
                :openpgp => "0CC2 DE1B B005 66BE 43A9  73FC AE51 A5F9 FAF5 65D3" },
            ]
  VERSION = {
    :major  => 0,
    :minor  => 0,
    :fix    => 1,
  }

  # :stopdoc:
  LIBPATH = ::File.expand_path(::File.dirname(__FILE__)) + ::File::SEPARATOR
  PATH    = ::File.dirname(LIBPATH) + ::File::SEPARATOR
  # :startdoc:

  # Returns the authors for the library as array of strings.
  def self.authors
    AUTHORS.map { |a| a[:name] }
  end

  # Returns the author's emails as array of strings.
  def self.emails
    AUTHORS.map { |a| a[:email] }
  end

  # Returns the version string for the library.
  def self.version(type = :string)
    case type
    when :numbers
      [:major, :minor, :fix].map { |n| VERSION[n] }
    else
      [:major, :minor, :fix].map { |n| VERSION[n] } .join('.')
    end
  end

  # Returns the library path for the module. If any arguments are given,
  # they will be joined to the end of the libray path using
  # <tt>File.join</tt>.
  def self.libpath(*args)
    args.empty? ? LIBPATH : ::File.join(LIBPATH, *args)
  end

  # Returns the lpath for the module. If any arguments are given,
  # they will be joined to the end of the path using
  # <tt>File.join</tt>.
  def self.path(*args)
    args.empty? ? PATH : ::File.join(PATH, *args)
  end

  # Utility method used to require all files ending in .rb that lie in the
  # directory below this file that has the same name as the filename passed
  # in. Optionally, a specific _directory_ name can be passed in such that
  # the _filename_ does not have to be equivalent to the directory.
  def self.require_all_libs_relative_to(fname, dir = nil)
    basedir   = ::File.expand_path(::File.dirname(fname))
    dir     ||= ::File.basename(fname, '.*')
    search_me = ::File.join(basedir, dir, '**', '*.rb')

    Dir.glob(search_me).sort.each do |rb|
      require rb.sub(basedir + ::File::SEPARATOR, "").sub(/\.rb$/i, "")
    end
  end

end  # module OnZeroLoad

OnZeroLoad.require_all_libs_relative_to __FILE__

end  # unless defined?

# EOF
