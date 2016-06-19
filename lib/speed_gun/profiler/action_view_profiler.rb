# frozen_string_literal: true
require 'speed_gun/profiler/active_support_notifications_profiler'

class SpeedGun::Profiler::ActionViewProfiler < SpeedGun::Profiler::ActiveSupportNotificatiosProfiler
  subscribe %r{^!(render_template|render_partial)\.action_view$}
end
