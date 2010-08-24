desc 'Run all tasks for CruiseControl.rb []'
task 'cruise' => [ 'whitespace:check', 'test', 'metrics:all' ]
