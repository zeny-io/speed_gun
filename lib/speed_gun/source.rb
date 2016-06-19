require 'speed_gun'

class SpeedGun::Source
  Line = Struct.new(:line, :code, :wall, :cpu, :calls, :allocations) do
    def to_s
      format("% 8.1fms + % 8.1fms (% 5d) % 5d allocs | %04d %s", cpu / 1000.0, (wall-cpu) / 1000.0, calls, allocations, line, code)
    end
  end

  attr_reader :file, :lines

  def initialize(file, linesamples)
    @file = file
    @lines = []
    analyze(file, linesamples)
  end

  def analyze(file, linesamples)
    code_lines = File.exists?(file) ? File.readlines(file) : []

    code_lines.each_with_index do |line, idx|
      sample = linesamples[idx + 1] || [0, 0, 0, 0]
      wall, cpu, calls, allocations = *sample

      @lines.push(Line.new(idx + 1, line, wall, cpu, calls, allocations))
    end
  end

  def to_s
    "#{file}====\n#{lines.map(&:to_s).join("")}"
  end
end
