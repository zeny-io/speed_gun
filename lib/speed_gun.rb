# frozen_string_literal: true
require 'speed_gun/version'
require 'speed_gun/config'
require 'speed_gun/report'
require 'rack/speed_gun'
require 'speed_gun/railtie' if defined?(::Rails)

module SpeedGun
  class << self
    # @return [SpeedGun::Config]
    def config
      @config ||= SpeedGun::Config.new
    end

    # @yield [config] Configure speed gun
    # @yieldparam config [SpeedGun::Config]
    def configure
      yield config
    end

    # @return [SpeedGun::Report, nil]
    def current_report
      Thread.current[:speed_gun_report]
    end

    def current_report=(report)
      Thread.current[:speed_gun_report] = report
    end

    def record(event)
      current_report && current_report.record(event)
    end

    def get_report(id)
      config.store.load("SpeedGun::Report/#{id}")
    end
  end
end
