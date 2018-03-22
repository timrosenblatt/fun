#!/usr/bin/env ruby -w

class MontyHallIteration
  CAR = 1
  GOAT = 0

  def initialize
    # with respect to Bayer and Diaconis
    @doors = [CAR, GOAT, GOAT].shuffle.shuffle
    @contestant_first_guess = rand(3)

    # Just to initialize the values and get them out of the way
    door_opened_by_monte
    door_not_opened_by_monte
  end

  attr_reader :doors, :contestant_first_guess

  def call
    if behind_door(contestant_first_guess) == CAR
      return :contestant_wins_first_guess
    else
      return :contestant_should_have_switched
    end
  end

  private

  def behind_door(number)
    doors[number]
  end

  # The one that isn't the first guess and isn't the car
  # Since the doors were shuffled, it's reasonable to take the first one we find
  def door_opened_by_monte
    @door_opened_by_monte ||= begin
      the_door = nil

      doors.each_with_index do |behind_door, door_number|
        next if door_number == contestant_first_guess
        next if behind_door == CAR
        the_door = door_number
      end

      the_door
    end
  end

  def door_not_opened_by_monte
    @door_not_opened_by_monte ||= begin
      raise StandardError if @door_opened_by_monte.nil?

      door_options = [0, 1, 2]
      door_options.delete(@contestant_first_guess)
      door_options.delete(@door_opened_by_monte)

      door_options[0]
    end
  end
end


class MonteHallSimulation
  def initialize(iterations)
    @iterations = iterations
    @results = { contestant_wins_first_guess: 0, contestant_should_have_switched: 0 }
  end

  attr_reader :iterations
  attr_accessor :results

  def call
    iterations.times do
      result = MontyHallIteration.new.call
      results[result] += 1
    end

    results
  end
end

puts MonteHallSimulation.new(100_000).call
