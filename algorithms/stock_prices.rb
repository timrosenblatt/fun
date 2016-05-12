#!/usr/bin/env ruby -w

# Found this one on interviewcake.com -- looks fun
#
# Suppose we could access yesterday's stock prices as an array, where:
#
# The indices are the time in minutes past trade opening time, which
# was 9:30am local time.
# The values are the price in dollars of Apple stock at that time.
# So if the stock cost $500 at 10:30am, stock_prices_yesterday[60] = 500.
#
# Write an efficient function that takes stock_prices_yesterday and returns the
# best profit I could have made from 1 purchase and 1 sale of 1 Apple stock
# yesterday.
#
# For example:
#
#   stock_prices_yesterday = [10, 7, 5, 8, 11, 9]
#
# get_max_profit(stock_prices_yesterday)
# returns 6 (buying for $5 and selling for $11)
#
# No "shorting"—you must buy before you sell. You may not buy and sell in the
# same time step (at least 1 minute must pass).

stock_prices_yesterday = [10, 7, 5, 8, 11, 9]

# HULK SMASH
# Not going to do this in *true* brute force fashion, which would be
# comparing every single value against every single other value. That wouldn't
# make sense because there'd be comparisons made where the sale would occur
# before the purchase and I'd have to track that separately.
# Instead, I'm keeping pointers so that comparisons
# are only done for time frames that make sense
def brute_force(stock_prices)
  best_buy_time = nil
  best_sell_time = nil
  best_price = 0

  length = stock_prices.length

  length.times do |buy_time|
    (buy_time+1..length-1).each do |sell_time|
      current_price = price_at(prices: stock_prices,
                               buy_time: buy_time,
                               sell_time: sell_time)

      # treating this as finding the first
      # opportunity during the time period
      # where we can find that price
      if current_price > best_price
        best_price = current_price
        best_buy_time = buy_time
        best_sell_time = sell_time
      end
    end
  end

  { best_price: best_price, best_buy_time: best_buy_time, best_sell_time: best_sell_time }
end

def price_at(prices:, buy_time:, sell_time:)
  prices[sell_time] - prices[buy_time]
end

brute_force stock_prices_yesterday

###

# After brute force...a more efficient implementation...
# I think the logic behind this question is basically
# For every value, what's the smallest number that occurs
# after it -- at a higher index?
# Or, with a hat tip to Jacobi -- for every index, what's the largest value
# that comes prior to it? Once that information is known, this whole question
# is reduced to a single O(n) scan (and this could probably be done inline)
# So, I think the issue here is about finding an optimal way to calculate that
# information.
# I think there's probably a way to find some local optimziations (if this
# were for HUGE data sets) where maybe we could only look at monotonically
# increasing sections of the price graph
#
# The approach I'm taking is to make the problem easier by reducing the search
# space. My logic is that since there's an ordering component to the
# problem (the sell has to happen exclusively after the buy), there's an
# optimization based on the ordering -- find the smallest number with the
# largest number after it. Another way to say that is that we're interested
# in comparing small ("buy") numbers to big ("sell") numbers.
#
# If there's a small number, it's worth comparing. If there's a bigger number
# after it, the second one is not worth treating as a "buy" number. If there's
# a known small "buy" number, the only prices that are worth considering
# occur after it and are cheaper.
# Conversely, if there's a known "sell" number, any lower numbers
# that come after it aren't worth considering -- only higher prices that
# would be a better deal.
#
# So, my optimization is to do a single scan through the price list and build
# two price lists -- buy prices and sell prices. To build the list of buy
# prices, I'm going to include the first price in the list and then only
# add numbers to that list that are smaller than the last (smallest) price found
# so far. Also -- building the sell price list -- start with the first number
# and then only add prices that are higher than it. Both of these lists will
# include price and time information (the time information comes in handy
# for the second phase).
#
# In the second phase, I will do the comparison, looking at buy-sell
# opportunities. This is where the time information comes in -- since the
# new buy and sell lists are potentially very out-of-order compared to the
# original price list, the time information will be used to ensure that
# comparisons are only made if the buy price happened before the sell price.

TimePrice = Struct.new(:time, :price)

def optimized_reduce_search_space(stock_prices)
  buy_prices = [] # store the low numbers
  sell_prices = [] # store the high numbers

  stock_prices.each_with_index do |price, time|

  end
end

# When I'm done implementing the two algorithms, I'm gonna write a generator
# and then a tester for the two, so that running test(10000) will generate
# n prices and then Benchmark.bm the two algorithms, comparing that the output
# is the same, and comparing the runtimes.
