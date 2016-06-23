require 'speed_gun'

class SpeedGun::Hook
  def self.hooks
    @hooks ||= []
  end

  def self.install!
    hooks.each do |hook|
      hook.available? && hook.install!
    end
  end

  attr_reader :name

  def initialize(name, &block)
    @name = name
    @installed = false
    @available_checker = -> { true }
    @execute = -> { true }
    self.class.hooks.push(self)
    instance_eval(&block)
  end

  def depends(&block)
    @available_checker = block
  end

  def execute(&block)
    @execute = block
  end

  def available?
    @available_checker.is_a?(Proc) && @available_checker.call
  end

  def install!
    return if @installed
    @execute.is_a?(Proc) && @execute.call
    @installed = true
  end
end

module SpeedGun
  def self.hook(name, &block)
    SpeedGun::Hook.new(name, &block)
  end
end

Dir[File.expand_path('../hook/**/*.rb', __FILE__)].each do |hook|
  require hook if File.file?(hook)
end
