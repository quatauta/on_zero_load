Feature: Command-Line Option Parser

  Scenario Outline: Parse a single limit, get that
    When I give <options> as command-line options
    Then the options key should be <key>
    And the value should be <value>
    And the value type should be <class>

    Examples:
      | options    | key   | value | class  |
      | --load=0.3 | load  | 0.3   | Float  |
      | --load=.3  | load  | 0.3   | Float  |
      | --cpu=23%  | cpu   | 23%   | String |
      | --disk=45k | disk  | 45k   | String |
      | --net=10k  | net   | 10k   | String |
      | --input=5m | input | 5m    | String |
      | --load 0.3 | load  | 0.3   | Float  |
      | --load .3  | load  | 0.3   | Float  |
      | --cpu 23%  | cpu   | 23%   | String |
      | --disk 45k | disk  | 45k   | String |
      | --net 10k  | net   | 10k   | String |
      | --input 5m | input | 5m    | String |
      | -l 0.21    | load  | 0.21  | Float  |
      | -l .21     | load  | 0.21  | Float  |
      | -c 12%     | cpu   | 12%   | String |
      | -d 32k     | disk  | 32k   | String |
      | -n 85k     | net   | 85k   | String |
      | -i 03:21   | input | 03:21 | String |
      | -l0.21     | load  | 0.21  | Float  |
      | -l.21      | load  | 0.21  | Float  |
      | -c12%      | cpu   | 12%   | String |
      | -d32k      | disk  | 32k   | String |
      | -n85k      | net   | 85k   | String |
      | -i03:21    | input | 03:21 | String |

  Scenario Outline: Parse multiple limits, get only last one
    When I give <options> as command-line options
    Then the options key should be <key>
    And the value should be <value>
    And the value type should be <class>

    Examples:
      | options                   | key   | value | class  |
      | --load 0.5   --load 0.8   | load  | 0.8   | Float  |
      | --cpu 5%     --cpu 2%     | cpu   | 2%    | String |
      | --disk 450k  --disk 12k   | disk  | 12k   | String |
      | --net 11k    --net 2k     | net   | 2k    | String |
      | --input 3:02 --input 2:30 | input | 2:30  | String |
      | -l 0.2  -l 0.1            | load  | 0.1   | Float  |
      | -c 11%  -c 53%            | cpu   | 53%   | String |
      | -d 912k -d 32k            | disk  | 32k   | String |
      | -n 41k  -n 23k            | net   | 23k   | String |
      | -i 4:21 -i 6:14           | input | 6:14  | String |
