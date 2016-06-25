# frozen_string_literal: true
require 'semantic'
require 'speed_gun/version'
require 'speed_gun/config'
require 'speed_gun/report'
require 'speed_gun/hook'
require 'rack/speed_gun'
require 'speed_gun/railtie' if defined?(::Rails)

module SpeedGun
  class << self
    # @return [Semantic::Version] Version
    def version
      @version ||= Semantic::Version.new(VERSION)
    end

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

    def get_backtrace(backtrace = caller(2))
      backtrace = Rails.backtrace_cleaner.clean(backtrace) if defined?(Rails)

      backtrace.map do |called|
        filename, line, trace = *called.split(':', 3)
        filename = File.expand_path(filename)
        [filename, line.to_i, trace]
      end
    end
  end
end
