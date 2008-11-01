Feature: Command-Line Interface

  Scenario: Give a single limit
    When I give --load 0.3 as command-line options
    Then the options key should be load
    And the values should be 0.3
    And each value should be of class Float

  More Examples:
    | Options           | Key  | Value | Class |
    | --load 0          | load | 0.0   | Float |
    | --load 0 --load 0 | load | 0.0   | Float |
