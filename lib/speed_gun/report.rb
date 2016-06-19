# frozen_string_literal: true
require 'securerandom'
require 'speed_gun'

class SpeedGun::Report
  # @return [String] Report ID
  attr_reader :id

  # @return [Array<SpeedGun::Source>] Profiled source codes
  attr_reader :sources

  # @return [Array<SpeedGun::Event>] Recorded events
  attr_reader :events

  def initialize
    @id = SecureRandom.uuid
    @sources = []
    @events = []
  end
end
