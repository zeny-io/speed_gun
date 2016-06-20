# frozen_string_literal: true
require 'rack'
require 'speed_gun'
require 'speed_gun/app'
require 'speed_gun/profiler/rack_profiler'
require 'speed_gun/profiler/line_profiler'

class Rack::SpeedGun
  def initialize(app)
    @app = app

  end

  def call(env)
    return @app.call(env) if SpeedGun.config.disabled? || skip?(env['PATH_INFO'])

    return call_speed_gun_app(env) if under_speed_gun?(env)

    SpeedGun.current_report = SpeedGun::Report.new

    SpeedGun::Profiler::RackProfiler.profile('rack', rack: rack_info(env), request: request_info(env)) do |event|
      res = SpeedGun::Profiler::LineProfiler.profile { @app.call(env) }
      res[1]['X-Speed-Gun-Report'] = SpeedGun.current_report.id
      event.payload[:response] = {
        status: res[0],
        headers: res[1]
      }
      res
    end
  ensure
    if SpeedGun.current_report
      SpeedGun.config.logger.debug("Speed Gun ID: #{SpeedGun.current_report.id}")
      SpeedGun.config.logger.debug(
        "Check out here: #{base_url(env)}/reports/#{SpeedGun.current_report.id}"
      ) if SpeedGun.config.webapp
      Thread.start(SpeedGun.current_report) do |report|
        SpeedGun.config.store.store(report)
      end
    end
    SpeedGun.current_report = nil
  end

  private

  def under_speed_gun?(env)
    SpeedGun.config.webapp && env['PATH_INFO'].match(/\A#{Regexp.escape(SpeedGun.config.prefix)}/)
  end

  def call_speed_gun_app(env)
    env['PATH_INFO'].sub!(/\A#{Regexp.escape(SpeedGun.config.prefix)}/, '')

    SpeedGun::App.call(env)
  end

  def skip?(path_info)
    SpeedGun.config.skip_paths.any? do |path|
      case path
      when String
        path_info.start_with?(path)
      when Regexp
        path_info =~ path
      else
        false
      end
    end
  end

  def rack_info(env)
    {
      version: env['rack.version'],
      url_scheme: env['rack.url_scheme']
    }
  end

  def request_info(env)
    {
      method: env['REQUEST_METHOD'],
      path: env['PATH_INFO'],
      headers: request_headers(env),
      query: Rack::Utils.parse_query(env['QUERY_STRING'])
    }
  end

  def request_headers(env)
    headers = {}
    env.each_pair do |key, val|
      if key.start_with?('HTTP_')
        headers[key[5..-1].split('_').map(&:capitalize).join('-')] = val
      end
    end
    headers
  end

  def base_url(env)
    scheme = env['rack.url_scheme']
    host = env['HTTP_HOST'] || "#{env['SERVER_NAME'] || env['SERVER_ADDR']}:#{env['SERVER_PORT']}"

    "#{scheme}://#{host}#{SpeedGun.config.prefix}"
  end
end
