# frozen_string_literal: true
require 'securerandom'

class SpeedGun::Report
  # @return [String] Report ID
  attr_reader :id

  def initialize
    @id = SecureRandom.uuid
  end
end
