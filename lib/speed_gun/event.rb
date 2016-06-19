# frozen_string_literal: true
require 'securerandom'
require 'speed_gun'

class SpeedGun::Event
  # @return [String] Event ID
  attr_reader :id
  # @return [String] Event name
  attr_reader :name
  # @return [Hash] Event payload
  attr_reader :payload
  # @return [Time] Started time of event
  attr_reader :started_at
  # @return [Time, nil] Finished time of event
  attr_reader :finished_at

  def self.from_hash(hash, id = nil)
    new(
      hash['name'],
      hash['payload'],
      Time.at(hash['started_at'].to_f),
      hash['finished_at'] ? Time.at(hash['finished_at']) : nil
    ).tap do |event|
      event.instance_variable_set(:@id, id) if id
    end
  end

  def initialize(name, payload = {}, started_at = Time.now, finished_at = nil)
    @id = SecureRandom.uuid
    @name = name.to_s
    @payload = payload
    @started_at = started_at
    @finished_at = finished_at
  end

  def finish!
    @finished_at = Time.now
  end

  def finished?
    @finished_at
  end

  def duration
    finished_at ? finished_at.to_f - started_at.to_f : 0
  end

  def to_hash
    {
      'name' => name,
      'payload' => payload,
      'started_at' => started_at.to_f,
      'finished_at' => finished? ? finished_at.to_f : nil
    }
  end
end
