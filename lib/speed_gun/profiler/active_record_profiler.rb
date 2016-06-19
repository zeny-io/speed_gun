# frozen_string_literal: true
require 'speed_gun/profiler/active_support_notifications_profiler'

class SpeedGun::Profiler::ActiveRecordProfiler < SpeedGun::Profiler::ActiveSupportNotificatiosProfiler
  subscribe(%r{\.active_record$}, [:binds])
end
