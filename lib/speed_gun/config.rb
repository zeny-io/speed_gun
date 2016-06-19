require 'speed_gun'

class SpeedGun::Config
  DEFAULT_PREFIX = '/speed_gun'

  # @return [Boolean] Enabled SpeedGun
  attr_accessor :enabled

  # @return [String] Console and API endpoint prefix
  attr_accessor :prefix

  attr_accessor :skip_paths
  attr_accessor :lineprof_paths

  def initialize
    @enabled = true
    @prefix = DEFAULT_PREFIX
    @skip_paths = []
    @lineprof_paths = []
    @ignored_profilers = []
  end

  # @return [Boolean] Enabled SpeedGun
  def enabled?
    enabled
  end

  def disabled?
    !enabled?
  end
end
