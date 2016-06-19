# frozen_string_literal: true
require 'securerandom'
require 'speed_gun'

class SpeedGun::Source
  KEEP_RANGE = 3

  class Line
    attr_reader :id, :line, :code, :wall, :cpu, :calls, :allocations

    def self.from_hash(hash, id = nil)
      keys = %w(line code wall cpu calls allocations)
      vals = keys.map { |k| hash[k] }
      new(*vals).tap do |line|
        line.instance_variable_set(:@id, id) if id
      end
    end

    def initialize(line, code, wall, cpu, calls, allocations)
      @id = SecureRandom.uuid
      @line, @code, @wall, @cpu, @calls, @allocations = line, code, wall, cpu, calls, allocations
    end

    def to_s
      format('% 8.1fms + % 8.1fms (% 5d) % 5d allocs | %04d %s', cpu / 1000.0, (wall - cpu) / 1000.0, calls, allocations, line, code)
    end

    def to_hash
      {
        line: line,
        code: code,
        wall: wall,
        cpu: cpu,
        calls: calls,
        allocations: allocations
      }
    end
  end

  attr_reader :id, :file, :lines

  def self.from_hash(hash, id = nil)
    source = new(hash['file'], nil)

    lines = (hash['lines'] || []).map do |line_id, hash|
      Line.from_hash(hash, line_id)
    end

    source.instance_variable_set(:@lines, lines)
    source.instance_variable_set(:@id, id) if id

    source
  end

  def initialize(file, linesamples)
    @id = SecureRandom.uuid
    @file = file
    @lines = []
    analyze(file, linesamples) if linesamples
  end

  def analyze(file, linesamples)
    code_lines = File.exist?(file) ? File.readlines(file) : []

    keep_lines = []
    code_lines.each_with_index do |line, idx|
      sample = linesamples[idx + 1] || [0, 0, 0, 0]
      wall, cpu, calls, allocations = *sample

      keep_lines.push(idx) if calls > 0
      @lines.push(Line.new(idx + 1, line, wall, cpu, calls, allocations))
    end

    @lines.select! do |line|
      idx = line.line - 1
      ((KEEP_RANGE * -1)..KEEP_RANGE).any? { |n| keep_lines.include?(idx + n) }
    end
  end

  def to_s
    "#{file}====\n#{lines.map(&:to_s).join('')}"
  end

  def to_hash
    {
      file: file,
      lines: lines.map { |line| [ line.id, line.to_hash ] }
    }
  end
end
