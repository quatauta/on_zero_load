Feature: Command-Line Interface

  Scenario: Parse a single limit, get that
    When I give --load 0.3 as command-line options
    Then the options key should be load
    And the value should be 0.3
    And the value type should be Float

    More Examples:
      | Options    | Key   | Value | Class  |
      | --cpu 23%  | cpu   | 23%   | String |
      | --disk 45k | disk  | 45k   | String |
      | --net 10k  | net   | 10k   | String |
      | --input 5m | input | 5m    | String |

  Scenario: Parse multiple limits, get only last one
    When I give --load 0.5 --load 0.8 as command-line options
    Then the options key should be load
    And the value should be 0.8
    And the value type should be Float

    More Examples:
      | --cpu 5%     --cpu 2%     | cpu   | 2%   | String |
      | --disk 450k  --disk 12k   | disk  | 12k  | String |
      | --net 11k    --net 2k     | net   | 2k   | String |
      | --input 3:02 --input 2:30 | input | 2:30 | String |
