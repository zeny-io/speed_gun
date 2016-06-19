require 'speed_gun'
require 'rack/speed_gun'
require 'rails/railtie'

class SpeedGun::Railtie < ::Rails::Railtie
   initializer 'speed_gun' do |app|
    app.middleware.insert(0, Rack::SpeedGun)
  end
end
