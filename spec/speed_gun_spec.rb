# frozen_string_literal: true
require 'spec_helper'

describe SpeedGun do
  describe '.version' do
    subject(:version) { SpeedGun.version }

    it 'has a version number' do
      expect(SpeedGun::VERSION).not_to be nil
    end

    it 'is a valid semantic version' do
      expect { Semantic::Version.new(SpeedGun::VERSION) }.not_to raise_error
    end

    it { is_expected.to be_a Semantic::Version }
  end
end
