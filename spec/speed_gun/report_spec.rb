# frozen_string_literal: true
require 'spec_helper'

describe SpeedGun::Report do
  subject(:report) { SpeedGun::Report.new }

  describe '#id' do
    subject(:id) { report.id }

    it { is_expected.to be_a String }
    it('should be a UUID') { is_expected.to match %r{\A[0-9a-f]{8}-(?:[0-9a-f]{4}-){3}[0-9a-f]{12}\Z}i }
  end

  describe '#sources' do
    subject(:sources) { report.sources }

    it { is_expected.to be_a Array }
  end

  describe '#events' do
    subject(:events) { report.events }

    it { is_expected.to be_a Array }
  end
end
