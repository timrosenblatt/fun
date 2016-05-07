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
  buy_time = 0
  sell_time = 1



end

def price_at(prices:, buy_time:, sell_time:)
  prices[sell_time] - prices[buy_time]
end


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
