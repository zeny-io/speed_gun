require 'rblineprof'
require 'speed_gun/source'
require 'speed_gun/profiler'

class SpeedGun::Profiler::LineProfiler < SpeedGun::Profiler
  def self.regexp
    if SpeedGun.config.lineprof_paths.empty?
      %r{.}
    else
      Regexp.union(*SpeedGun.config.lineprof_paths)
    end
  end

  def profile(*args, &block)
    return yield if self.class.ignore?

    result = nil
    lineprofiled = lineprof(self.class.regexp) do
      result = yield
    end
    store(lineprofiled) if SpeedGun.current_report
    result
  end

  def store(lineprofiled)
    lineprofiled.each_pair do |file, linesamples|
      source = SpeedGun::Source.new(file, linesamples)
      SpeedGun.current_report.sources.push(source) unless source.lines.empty?
    end
  end
end
