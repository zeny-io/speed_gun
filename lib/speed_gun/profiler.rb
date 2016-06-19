require 'speed_gun'
require 'speed_gun/event'

class SpeedGun::Profiler
  def self.profile(*args, &block)
    new.profile(*args, &block)
  end

  def profile(name = self.class.name, payload = {}, &block)
    started_at = Time.now

    event = SpeedGun::Event.new(name, payload, started_at)
    result = yield(event)
    event.finish!

    SpeedGun.record(event)

    result
  end
end
