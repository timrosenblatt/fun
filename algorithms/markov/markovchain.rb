#!/usr/bin/env ruby -w

args = Hash.new
$*.each do |k, v|
  arg = k.split('=')
  args[arg[0]] = arg[1]
end

print args
$minimum_size = args['minimum_size'] != nil ? args['minimum_size'].to_i : 10000
$order        = args['order'] != nil        ? args['order'].to_i : 4


def train(order)
  print "initializing training: order ", order, "<br />"

  corpus = ''

  File.open('corpus.txt', 'r') do |f|
    while line = f.gets
      corpus = corpus << line
    end
  end

  return false if corpus.length < $minimum_size
  print "corpus meets size requirements (", corpus.length, " characters, ", $minimum_size," required)<br />"


# going to test splitting based on words and see how close i can get
#corpus = corpus.split(' ')
#puts corpus.inspect
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

  print "about to normalize ", priors.length, " values<br />"

  priors.each do |k,v|
    priors_normalized[k] = normalizeWeights(priors[k])
  end
puts priors_normalized.inspect
  return priors_normalized
end

def generate(size, priors, order)
  print "starting generate for order ", order, "...<br />-----------<br />"

  text = ''

  text = text << getRandomIndex(priors).to_s

  0.upto(size) do |i|
    #print "text[",i,"...",i+order-1,"] is '",text[i..i+order-1], "'\n"
    index = getWeightedRandomIndex(priors[text[i..i+order-1]])
    text = text << index.to_s
  end

  return text
end


def normalizeWeights(weights)
  total = 0

  weights.each do |k,v|
    total += v
  end

  weights.each do |k,v|
    #print "before ", weights[k]
    weights[k] = (weights[k]*1.0) / total
    #print " and after ", weights[k], "\n"
  end

  return weights
end

def getRandomIndex(hash)
  return hash.keys[rand(hash.size)]
end

def getWeightedRandomIndex(weights)
  #print "Starting getWeightedRandomIndex\n"
  # the weights must all add up to 1 or this won't work.
  # also, I need to check if ruby's rand is 0-.99999...
  # or .000001 to 1
  total = 0
  weights.each do |k,v|
    total += v
  end
  #print "total weights: ",total,"\n"
  the_rand = rand()  # this was previously recalculated on every "each" below
  #now actually do the calculation
  total = 0
  weights.each do |k,v|
    total += v
    return k if total > the_rand
  end

  #print "uh oh fallback\n"
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


final_string_size = 1000

training = train($order)


#5.times do print "HEREITCOMES\n" end
print generate(final_string_size, training, $order)
#5.times do print "THEREITWENT\n" end
