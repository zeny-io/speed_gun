# frozen_string_literal: true
require 'speed_gun'
require 'speed_gun/store/file_store'
require 'rack/speed_gun'
require 'rails/railtie'

class SpeedGun::Railtie < ::Rails::Railtie
  initializer 'speed_gun' do |app|
    app.middleware.insert(0, Rack::SpeedGun)

    SpeedGun.configure do |config|
      config.logger = Rails.logger
      config.store = SpeedGun::Store::FileStore.new(Rails.root.join('tmp/speed_gun').to_s)
      config.skip_paths.push(app.config.assets.prefix)
    end

    ActiveSupport.on_load(:action_controller) do
      require 'speed_gun/profiler/action_controller_profiler'
    end

    ActiveSupport.on_load(:action_view) do
      require 'speed_gun/profiler/action_view_profiler'
    end

    ActiveSupport.on_load(:active_record) do
      require 'speed_gun/profiler/active_record_profiler'
    end
  end
end
