# frozen_string_literal: true
require 'logger'
require 'speed_gun'
require 'speed_gun/store/memory_store'

class SpeedGun::Config
  DEFAULT_PREFIX = '/speed_gun'

  # @return [Boolean] Enabled SpeedGun
  attr_accessor :enabled

  attr_accessor :store

  # @return [String] Console and API endpoint prefix
  attr_accessor :prefix

  attr_accessor :logger

  attr_accessor :skip_paths
  attr_accessor :lineprof_paths
  attr_accessor :ignored_profilers

  def initialize
    @enabled = true
    @store = SpeedGun::Store::MemoryStore.new
    @prefix = DEFAULT_PREFIX
    @logger = ::Logger.new(STDOUT)
    @skip_paths = ['/favicon.ico']
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
