# frozen_string_literal: true
require 'semantic'

module SpeedGun
  VERSION = '2.0.0-alpha.1'

  def self.version
    @version ||= Semantic::Version.new(VERSION)
  end
end
