require 'on_zero_load/cpu'
require 'on_zero_load/loadavg'
require 'on_zero_load/main'
require 'on_zero_load/net'


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

  # Returns the authors for the library as array of strings.
  #
  # Depending on +type+, it returns an array of names (<tt>:name</tt>, default), emails
  # (<tt>:email</tt>), names with emails (<tt>:name_email</tt>), short OpenPGP key ids
  # (<tt>:key</tt>), long key ids (<tt>:key_long</tt>), or key fingerprints
  # (<tt>:key_fp</tt>).
  #
  #  authors             => ["Daniel Schömer"]
  #  authors :name       => ["Daniel Schömer"]
  #  authors :email      => ["daniel.schoemer@gmx.net"]
  #  authors :name_email => ["Daniel Schömer <daniel.schoemer@gmx.net>"]
  #  authors :key        => ["0xFAF565D3"]
  #  authors :key_long   => ["0xAE51A5F9FAF565D3"]
  #  authors :key_fp     => ["0CC2 DE1B B005 66BE 43A9  73FC AE51 A5F9 FAF5 65D3"]
  def self.authors(type = :name)
    case type
    when :name
      AUTHORS.map { |a| a[:name] }
    when :email
      AUTHORS.map { |a| a[:email] }
    when :name_email
      AUTHORS.map { |a|
        [ a[:name],
          a[:email] ? "<%s>" % a[:email] : nil,
        ].compact.join(" ")
      } .join(", ")
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
end
