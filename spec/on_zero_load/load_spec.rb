# -*- coding: utf-8; -*-
# frozen_string_literal: true
# vim:set fileencoding=utf-8:

require File.join(File.dirname(__FILE__), '..', 'spec_helper')

module OnZeroLoad
  describe "System monitor loadavg raw data" do
    before do
      @raw = LoadAvg.current_raw
    end

    it "is a non-empty array" do
      @raw.should be_kind_of(Array)
      @raw.should_not be_empty
    end

    it "contains three floating-point numbers" do
      @raw.should have(3).items
      @raw.each do |a|
        a.should be_kind_of(Float)
      end
    end

    it "contains only numbers greater or equal then zero" do
      @raw.each do |a|
        a.should be >= 0.0
      end
    end
  end


  describe "System monitor loadavg data" do
    before do
      @raw  = [1.45, 1.2, 0.7]
      @load = LoadAvg.current(@raw)
    end

    it "includes values for one, five and fifteen minute load" do
      @load[:one].should_not be_nil
      @load[:five].should_not be_nil
      @load[:fifteen].should_not be_nil
    end

    it "includes only numeric values" do
      @load[:one].should     be_kind_of(Numeric)
      @load[:five].should    be_kind_of(Numeric)
      @load[:fifteen].should be_kind_of(Numeric)
    end

    it "includes the raw data value for one minute load" do
      @load[:one].should == @raw[0]
    end

    it "includes the raw data value for five minute load" do
      @load[:five].should == @raw[1]
    end

    it "includes the raw data value for fifteen minute load" do
      @load[:fifteen].should == @raw[2]
    end
  end
end
