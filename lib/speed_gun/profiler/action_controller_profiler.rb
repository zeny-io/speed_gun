# frozen_string_literal: true
require 'speed_gun/profiler/active_support_notifications_profiler'

class SpeedGun::Profiler::ActionControllerProfiler < SpeedGun::Profiler::ActiveSupportNotificatiosProfiler
  subscribe(
    %r{^(process_action|send_file|send_data|redirect_to)\.action_controller$},
    [:request]
  )
end
