#!/usr/bin/env ruby -w

def train(order)
  print "initializing training\n"

  corpus = ''

  File.open('corpus.txt', 'r') do |f|
    while line = f.gets
      corpus = corpus << line
    end
  end

#print corpus

  return false if corpus.length < 100
  print "corpus meets size requirements\n"

  priors = Hash.new
  priors_normalized = Hash.new

  0.upto(corpus.length) do |i|
#    print corpus[i]
    next if corpus[i] == nil
    next if corpus[i+order] == nil
    priors[corpus[i..i+order-1]] = Hash.new unless priors.has_key?(corpus[i..i+order-1])

    priors[corpus[i..i+order-1]][corpus[i+order]] = 0 if priors[corpus[i..i+order-1]][corpus[i+order]] == nil

    priors[corpus[i..i+order-1]][corpus[i+order]] = priors[corpus[i..i+order-1]][corpus[i+order]] + 1
  end

  print "about to normalize\n"

  priors.each do |k,v|
    priors_normalized[k] = normalizeWeights(priors[k])
  end

  return priors_normalized
end

def generate(size, priors, order)
  print "starting generate...\n"

  text = ''

  text = text << getRandomIndex(priors)

  0.upto(size) do |i|
    print "text[",i,"...",i+order-1,"] is '",text[i..i+order-1], "'\n"
    index = getWeightedRandomIndex(priors[text[i..i+order-1]])
    text = text << index
  end

  return text
end


def normalizeWeights(weights)
  total = 0

  weights.each do |k,v|
    total += v
  end

  weights.each do |k,v|
    print "before ", weights[k]
    weights[k] = (weights[k]*1.0) / total
    print " and after ", weights[k], "\n"
  end

  return weights
end

def getRandomIndex(hash)
  return hash.keys[rand(hash.size)]
end

def getWeightedRandomIndex(weights)
  print "Starting getWeightedRandomIndex\n"
  # the weights must all add up to 1 or this won't work.
  # also, I need to check if ruby's rand is 0-.99999...
  # or .000001 to 1
  total = 0
  weights.each do |k,v|
    total += v
  end
  print "total weights: ",total,"\n"

  #now actually do the calculation
  total = 0
  weights.each do |k,v|
    total += v
    return k if total > rand()
  end

  print "uh oh fallback\n"
  return k
end


#t = train(3)
#each do |k,v|
#  t[k].each do |k2,v2|
    #print "key is "
    #print k2
    #print " and v is "
    #print v2
    #print "\n"
#  end
#end

order = 5
final_string_size = 1000

training = train(order)

5.times do print "HEREITCOMES\n" end
print generate(final_string_size, training, order)
5.times do print "THEREITWENT\n" end
