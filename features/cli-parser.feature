Feature: Command-Line Options

  Scenario Outline: Parse a single limit, get that
    When I give <options> as command-line options
    Then the options key should be <key>
    And the value should be <value>
    And the value type should be <class>

    Examples:
      | options      | key  | value    | class           |
      | --load=0.3   | load | 0.3      | RubyUnits::Unit |
      | --load=.3    | load | 0.3      | RubyUnits::Unit |
      | --cpu=23     | cpu  | 23 %     | RubyUnits::Unit |
      | --cpu=23%    | cpu  | 23 %     | RubyUnits::Unit |
      | --cpu=0.23   | cpu  | 23 %     | RubyUnits::Unit |
      | --disk=45KiB | disk | 45 KiB/s | RubyUnits::Unit |
      | --disk=45Ki  | disk | 45 KiB/s | RubyUnits::Unit |
      | --disk=45K   | disk | 45 KiB/s | RubyUnits::Unit |
      | --disk=45    | disk | 45 KiB/s | RubyUnits::Unit |
      | --net=10Kib  | net  | 10 Kib/s | RubyUnits::Unit |
      | --net=10Ki   | net  | 10 Kib/s | RubyUnits::Unit |
      | --net=10K    | net  | 10 Kib/s | RubyUnits::Unit |
      | --net=10     | net  | 10 Kib/s | RubyUnits::Unit |
      | --idle=5min  | idle | 300 s    | RubyUnits::Unit |
      | --idle=300   | idle | 300 s    | RubyUnits::Unit |
      | --load 0.3   | load | 0.3      | RubyUnits::Unit |
      | --load .3    | load | 0.3      | RubyUnits::Unit |
      | --cpu 23%    | cpu  | 23 %     | RubyUnits::Unit |
      | --disk 45KiB | disk | 45 KiB/s | RubyUnits::Unit |
      | --net 10Kib  | net  | 10 Kib/s | RubyUnits::Unit |
      | --idle 5min  | idle | 300 s    | RubyUnits::Unit |
      | -l 0.21      | load | 0.21     | RubyUnits::Unit |
      | -l .21       | load | 0.21     | RubyUnits::Unit |
      | -c 12%       | cpu  | 12 %     | RubyUnits::Unit |
      | -d 32KiB     | disk | 32 KiB/s | RubyUnits::Unit |
      | -n 85Kib     | net  | 85 Kib/s | RubyUnits::Unit |
      | -i 0:03:21   | idle | 201 s    | RubyUnits::Unit |
      | -l0.21       | load | 0.21     | RubyUnits::Unit |
      | -l.21        | load | 0.21     | RubyUnits::Unit |
      | -c12%        | cpu  | 12 %     | RubyUnits::Unit |
      | -d32KiB      | disk | 32 KiB/s | RubyUnits::Unit |
      | -n85Kib      | net  | 85 Kib/s | RubyUnits::Unit |
      | -i0:3:21     | idle | 201 s    | RubyUnits::Unit |

  Scenario Outline: Parse multiple limits, get only last one
    When I give <options> as command-line options
    Then the options key should be <key>
    And the value should be <value>
    And the value type should be <class>

    Examples:
      | options                       | key  | value    | class           |
      | --load 0.5    --load 0.8      | load | 0.8      | RubyUnits::Unit |
      | --cpu 5%      --cpu 2%        | cpu  | 2 %      | RubyUnits::Unit |
      | --disk 450Kib --disk 12KiB    | disk | 12 KiB/s | RubyUnits::Unit |
      | --net 11Kib   --net 2Kib      | net  | 2 Kib/s  | RubyUnits::Unit |
      | --idle 0:03:02 --idle 0:02:30 | idle | 150 s    | RubyUnits::Unit |
      | -l 0.2     -l 0.1             | load | 0.1      | RubyUnits::Unit |
      | -c 11%     -c 53%             | cpu  | 53 %     | RubyUnits::Unit |
      | -d 912Kib  -d 32KiB           | disk | 32 KiB/s | RubyUnits::Unit |
      | -n 41Kib   -n 23Kib           | net  | 23 Kib/s | RubyUnits::Unit |
      | -i 0:04:21 -i 0:06:14         | idle | 374 s    | RubyUnits::Unit |
