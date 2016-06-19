require 'fileutils'
require 'speed_gun/store'

class SpeedGun::Store::FileStore < SpeedGun::Store
  def initialize(basedir)
    @basedir = basedir
  end

  def store(obj)
    key, val = serialize(obj)

    filepath = pathnize(key)
    dirname = File.dirname(filepath)
    FileUtils.mkdir_p(dirname) unless File.directory?(dirname)
    File.open(filepath, 'wb') do |fp|
      fp.write(val)
    end
  end

  def load(key)
    filepath = pathnize(key)
    return nil unless File.exist?(filepath)

    msg = File.open(filepath, 'rb', &:read)
    deserialize(key, msg)
  end

  private

  def pathnize(key)
    klass, id = *key.split('/', 2)

    File.join(@basedir, *klass.split('::'), id)
  end
end
