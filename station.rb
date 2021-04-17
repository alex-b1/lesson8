# frozen_string_literal: true

require_relative './instance_counter'

class Station
  include InstanceCounter

  @@instances = {}

  attr_accessor :trains, :name

  def initialize(name)
    @name = name
    validate!
    @trains = []
    @@instances[name] = self

    register_instance
  end

  def get_trains(block)
    @trains.each do |i|
      block.call(i)
    end
  end

  def arrival_train(train)
    @trains << train
  end

  def depart_train(train)
    @trains.filter! { |i| i.number != train.number }
    train.go_ahead

    train.accelerate while train.accelerate < 80
  end

  def trains_by_type
    {
      cargo: (@trains.filter { |i| i.type == :cargo }).count,
      passenger: (@trains.filter { |i| i.type == :passenger }).count
    }
  end

  def self.all
    @@instances
  end

  def valid?
    validate!
    true
  rescue StandardError
    false
  end

  private

  def validate!
    raise 'Неверное значение' if name.empty?
    raise 'Такая станция уже есть' if @@instances[name]
  end
end
