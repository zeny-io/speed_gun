require 'speed_gun'

class SpeedGun::Config
  DEFAULT_PREFIX = '/speed_gun'

  # @return [Boolean] Enabled SpeedGun
  attr_accessor :enabled

  # @return [String] Console and API endpoint prefix
  attr_accessor :prefix

  def initialize
    @enabled = true
    @prefix = DEFAULT_PREFIX
  end

  # @return [Boolean] Enabled SpeedGun
  def enabled?
    enabled
  end
end
