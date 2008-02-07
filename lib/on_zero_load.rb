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
    :tiny   => 1,
  }
  HOMEPAGE = 'FIXME (project homepage)'

  # :stopdoc:
  LIBPATH = ::File.expand_path(::File.dirname(__FILE__)) + ::File::SEPARATOR
  PATH    = ::File.dirname(LIBPATH) + ::File::SEPARATOR
  # :startdoc:

  # Returns the authors for the library as array of strings.
  #
  # Depending on +type+, it returns an array of names (<tt>:name</tt>, default), emails
  # (<tt>:email</tt>), short OpenPGP key ids (<tt>:key</tt>), long key ids
  # (<tt>:key_long</tt>), or key fingerprints (<tt>:key_fp</tt>).
  #
  #  authors           => ["Daniel Schömer"]
  #  authors :name     => ["Daniel Schömer"]
  #  authors :email    => ["daniel.schoemer@gmx.net"]
  #  authors :key      => ["0xFAF565D3"]
  #  authors :key_long => ["0xAE51A5F9FAF565D3"]
  #  authors :key_fp   => ["0CC2 DE1B B005 66BE 43A9  73FC AE51 A5F9 FAF5 65D3"]
  def self.authors(type = :name)
    case type
    when :name
      AUTHORS.map { |a| a[:name] }
    when :email
      AUTHORS.map { |a| a[:email] }
    when :key
      AUTHORS.map { |a| a[:openpgp].map { |fp| "0x" + fp.split[-2..-1].join("") } }
    when :key_long
      AUTHORS.map { |a| a[:openpgp].map { |fp| "0x" + fp.split[-4..-1].join("") } }
    when :key_fp
      AUTHORS.map { |a|
        a[:openpgp].map { |fp|
          words = fp.split
          words[0..4].join(" ") + "  " + words[5..9].join(" ")
        }
      }
    end
  end

  # Returns the project's homepage
  def self.homepage
    HOMEPAGE
  end

  # Returns the version string for the library.
  #
  # Depending on +type+, the version is returned as string like <tt>"2.4.1"</tt>
  # (<tt>:string</tt>, default), ordered array of numbers (<tt>:numbers</tt>), or a hash
  # of numbers (<tt>:hash</tt>).
  #
  #  version          => "2.4.1"
  #  version :string  => "2.4.1"
  #  version :numbers => [2, 4, 1]
  #  version :hash    => { :major => 2, :minor => 4, :tiny => 1 }
  def self.version(type = :string)
    case type
    when :string
      [:major, :minor, :tiny].map { |n| VERSION[n] } .join('.')
    when :numbers
      [:major, :minor, :tiny].map { |n| VERSION[n] }
    when :hash
      VERSION
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
