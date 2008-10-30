$:.unshift(File.dirname(__FILE__) + '/../../lib')

require 'on_zero_load'
require 'spec'

Before do
end

After do
end

When /I give (.*) as command-line options/ do |options|
  @opts = OnZeroLoad::Main.parse(options.split(/\s+/))
end

Then /the options key should be (\w+)/ do |expected_key_name|
  @key = expected_key_name.to_sym

  @opts.should be_kind_of(Hash)
  @opts.should have_key(@key)
  @opts[@key].should_not be_nil
  @opts[@key].should be_kind_of(Array)
end

Then /the values should be (.*)/ do |expected_values|
  @opts[@key].map { |v| v.to_s } .should == expected_values.split(/, +/)
end

Then /the classes should be (\w+)/ do |expected_class_name|
  @opts[@key].each do |v|
    v.class.name.should == expected_class_name
  end
end
