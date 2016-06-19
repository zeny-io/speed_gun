require 'rblineprof'
require 'speed_gun/source'
require 'speed_gun/profiler'

class SpeedGun::Profiler::LineProfiler < SpeedGun::Profiler
  def profile(*args, &block)
    result = nil
    lineprofiled = lineprof(/./) do
      result = yield
    end
    store(lineprofiled) if SpeedGun.current_report
    result
  end

  def store(lineprofiled)
    lineprofiled.each_pair do |file, linesamples|
      SpeedGun.current_report.sources.push(SpeedGun::Source.new(file, linesamples))
    end

    puts SpeedGun.current_report.sources.select { |source|
      source.file.end_with?('posts_controller.rb')
    }.first.to_s
  end
end
