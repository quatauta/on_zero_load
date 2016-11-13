# -*- coding: utf-8; -*-
# frozen_string_literal: true
# vim:set fileencoding=utf-8:

require File.join(File.dirname(__FILE__), '..', 'spec_helper')

module OnZeroLoad
  describe 'System monitor loadavg raw data' do
    before do
      @raw = LoadAvg.current_raw
    end

    it 'is a non-empty array' do
      expect(@raw).to be_kind_of(Array)
      expect(@raw).not_to be_empty
    end

    it 'contains three floating-point numbers' do
      expect(@raw.count).to eq(3)
      @raw.each do |a|
        expect(a).to be_kind_of(Float)
      end
    end

    it 'contains only numbers greater or equal then zero' do
      @raw.each do |a|
        expect(a).to be >= 0.0
      end
    end
  end

  describe 'System monitor loadavg data' do
    before do
      @raw  = [1.45, 1.2, 0.7]
      @load = LoadAvg.current(@raw)
    end

    it 'includes values for one, five and fifteen minute load' do
      expect(@load[:one]).to be_truthy
      expect(@load[:five]).to be_truthy
      expect(@load[:fifteen]).to be_truthy
    end

    it 'includes only numeric values' do
      expect(@load[:one]).to     be_kind_of(Numeric)
      expect(@load[:five]).to    be_kind_of(Numeric)
      expect(@load[:fifteen]).to be_kind_of(Numeric)
    end

    it 'includes the raw data value for one minute load' do
      expect(@load[:one]).to eq(@raw[0])
    end

    it 'includes the raw data value for five minute load' do
      expect(@load[:five]).to eq(@raw[1])
    end

    it 'includes the raw data value for fifteen minute load' do
      expect(@load[:fifteen]).to eq(@raw[2])
    end
  end
end
