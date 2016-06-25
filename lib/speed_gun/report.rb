# frozen_string_literal: true
require 'securerandom'
require 'speed_gun'

class SpeedGun::Report
  # @return [String] Report ID
  attr_reader :id

  attr_accessor :name

  # @return [Array<SpeedGun::Source>] Profiled source codes
  attr_reader :sources

  # @return [Array<SpeedGun::Event>] Recorded events
  attr_reader :events

  def self.from_hash(hash)
    report = new

    hash['sources'].map! do |source_id, hash|
      SpeedGun::Source.from_hash(hash, source_id)
    end

    hash['events'].map! do |event_id, hash|
      SpeedGun::Event.from_hash(hash, event_id)
    end

    hash.each_pair do |key, val|
      report.instance_variable_set(:"@#{key}", val)
    end

    report
  end

  def initialize
    @id = SecureRandom.uuid
    @name = nil
    @sources = []
    @events = []
  end

  def record(event)
    @events.push(event)
  end

  def source(source)
    @sources.push(source)
  end

  def nearlest_event_started_at
    @events.sort_by(&:started_at).first.started_at
  end

  def latest_event_finished_at
    @events.sort_by { |event| event.roughly_finished_at.to_f * -1 }.first.roughly_finished_at
  end

  def duration
    latest_event_finished_at.to_f - nearlest_event_started_at.to_f
  end

  def to_hash
    {
      name: name,
      sources: sources.map { |source| [ source.id, source.to_hash ] },
      events: events.map { |event| [event.id, event.to_hash] }
    }
  end
end
