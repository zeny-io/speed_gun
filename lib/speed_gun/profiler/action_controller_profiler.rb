# frozen_string_literal: true
require 'speed_gun/profiler/active_support_notifications_profiler'

class SpeedGun::Profiler::ActionControllerProfiler < SpeedGun::Profiler::ActiveSupportNotificatiosProfiler
  subscribe(
    %r{\.action_controller$},
    [:request]
  )
end
