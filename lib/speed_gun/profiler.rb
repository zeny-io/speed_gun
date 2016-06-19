# frozen_string_literal: true
require 'speed_gun'
require 'speed_gun/event'

class SpeedGun::Profiler
  def self.profile(*args, &block)
    new.profile(*args, &block)
  end

  def self.ignore?
    SpeedGun.config.ignored_profilers.any? do |ignore|
      name.include?(ignore)
    end
  end

  def profile(name = self.class.name, payload = {})
    started_at = Time.now

    event = SpeedGun::Event.new(name, payload, started_at)
    result = yield(event)
    event.finish!

    SpeedGun.record(event) unless self.class.ignore?

    result
  end
end
