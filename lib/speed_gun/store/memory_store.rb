require 'speed_gun/store'

class SpeedGun::Store::MemoryStore < SpeedGun::Store
  def initialize
    @data = {}
  end

  def store(obj)
    key, val = serialize(obj)
    @data[key] = val
  end

  def load(key)
    deserialize(key, @data[key])
  end
end
