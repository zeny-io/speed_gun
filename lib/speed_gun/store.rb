require 'msgpack'
require 'speed_gun'

class SpeedGun::Store
  def serialize(obj)
    ["#{obj.class.name}/#{obj.id}", MessagePack.pack(obj.to_hash)]
  end

  def deserialize(key, msg)
    return nil if msg.nil? || msg.empty?
    hash = MessagePack.unpack(msg)
    klass, id = *key.split('/', 2)
    obj = Object.const_get(klass).from_hash(hash)
    obj.instance_variable_set(:@id, id)
    obj
  end
end
