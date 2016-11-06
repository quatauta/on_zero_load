# -*- coding: utf-8; -*-
# frozen_string_literal: true
# vim:set fileencoding=utf-8:

Before do
end

After do
end

When /I give (.*) as command-line options/ do |options|
  @opts = OnZeroLoad::CLI.parse(options.split(/\s+/))
end

Then /the options key should be (\w+)/ do |expected_key_name|
  @key = expected_key_name.to_sym

  expect(@opts).to be_kind_of(Hash)
  expect(@opts).to have_key(@key)
  expect(@opts[@key]).to be_truthy
end

Then /the value should be (.*)/ do |expected_value|
  expect(@opts[@key].to_s).to eq(expected_value)
end

Then /the values should be (.*)/ do |expected_values|
  expect(@opts[@key].map { |v| v.to_s }).to eq(expected_values.split(/; +/))
end

Then /the value type should be ([\w:]+)/ do |expected_class_name|
  expect(@opts[@key].class.name).to eq(expected_class_name)
end

Then /each value type should be ([\w:]+)/ do |expected_class_name|
  @opts[@key].each do |v|
    expect(v.class.name).to be_kind_of(expected_class_name)
  end
end
