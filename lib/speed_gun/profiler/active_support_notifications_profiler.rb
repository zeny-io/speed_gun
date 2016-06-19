# frozen_string_literal: true
require 'speed_gun/profiler'

class SpeedGun::Profiler::ActiveSupportNotificatiosProfiler < SpeedGun::Profiler
  def self.subscribe(event, ignore_payload = [])
    klass = self
    ActiveSupport::Notifications.subscribe(event) do |*args|
      klass.record(event, *args, ignore_payload)
    end
  end

  def self.record(event, name, started, ended, _id, payload, ignore_payload)
    name = "#{event}.#{name}"

    payload = payload.symbolize_keys

    ignore_payload.each do |key|
      payload.delete(key)
    end

    payload[:backtrace] = backtrace

    event = SpeedGun::Event.new(name, payload, started, ended)
    SpeedGun.current_report.record(event)
  end

  def self.backtrace
    Rails.backtrace_cleaner.clean(caller[2..-1]).map do |called|
      filename, line, trace = *called.split(':', 3)
      filename = File.expand_path(filename)
      [filename, line.to_i, trace]
    end
  end
end
