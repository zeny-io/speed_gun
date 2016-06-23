require 'speed_gun/hook'

SpeedGun.hook('Net::HTTP') do
  depends do
    defined?(Net) && defined?(Net::HTTP)
  end

  execute do
    require 'speed_gun/profiler/http_profiler'

    class Net::HTTP
      def request_with_speedgun(req, *args, &block)
        payload = { request: { method: req.method, uri: req.uri.to_s, headers: req.to_hash } }

        SpeedGun::Profiler::HTTPProfiler.profile('http.' + req.method.downcase, payload) do |event|
          res = request_without_speedgun(req, *args, &block)

          event.payload[:response] = {
            version: res.http_version,
            code: res.code,
            headers: res.to_hash
          }

          res
        end
      end

      alias request_without_speedgun request
      alias request request_with_speedgun
    end
  end
end
