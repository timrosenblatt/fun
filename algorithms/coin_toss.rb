#!/usr/bin/env ruby -w

class CoinTossStatistics
  def initialize(iterations)
    @iterations = iterations
    @streak_counter = []
  end
  attr_reader :iterations

  def call
    coin = nil
    previous_coin = flip
    streak = 0

    @iterations.times do
      # puts "streak #{streak}; coin #{coin}; previous_coin #{previous_coin}"
      coin = flip

      if coin == previous_coin
        streak += 1
      else
        previous_coin = coin
        record_streak(streak)
        streak = 0
      end
    end

    record_streak(streak)

    @streak_counter
  end

  private

  def flip
    rand(2)
  end

  def record_streak(streak)
    @streak_counter[streak] = @streak_counter[streak].nil? ? 1 : @streak_counter[streak] + 1
  end
end

CoinTossStatistics.new(1_000_000).call.each_with_index do |number_of_times, streak_length|
  puts "#{streak_length} in a row, #{number_of_times} times"
end
