def calculate_score(xs : Array(Float64))
  # f(0) = 0, n params
  s = 0.0
  xs.size.times { |i| s += xs[i] * xs[i] }
  s
end

params = 300
bounds = -10.0..10.0
generations = 10000
print = 1000
pop_size = 200
mutate_range = 0.2..0.95
crossover_range = 0.1..1.0

crossover = 0.9
mutate = 0.4

others = Array.new(3, 0)
donor = Array.new(params, 0.0)
trial = Array.new(params, 0.0)
pop = Array.new(pop_size) { Array.new(params, 0.0) }
scores = Array.new(pop_size, 0.0)

start_dt = Time.utc

# Init pop
pop_size.times do |i|
  params.times do |j|
    pop[i][j] = rand(bounds)
  end
  scores[i] = calculate_score(pop[i])
end

# Run generations
generations.times do |g|
  crossover = rand(crossover_range)
  mutate = rand(mutate_range)

  pop_size.times do |i|
    # Get three others
    3.times { |j| others[j] = rand(pop_size - 1) }
    x0 = pop[others[0]]
    x1 = pop[others[1]]
    x2 = pop[others[2]]
    xt = pop[i]

    # Create donor
    params.times { |j| donor[j] = (x0[j] + (x1[j] - x2[j]) * mutate).clamp(bounds) }

    # Create trial
    params.times { |j| trial[j] = rand < crossover ? donor[j] : xt[j] }
    trial_score = calculate_score(trial)
    
    if trial_score < scores[i]
      pop[i] = trial.dup
      scores[i] = trial_score
    end
  end

  if g.remainder(print) == 0
    mean = scores.sum / pop_size
    #best = scores.min
    puts "GEN #{g}"
    puts "MEAN #{mean}"
    #puts "BEST #{best.xs}"
  end
end

end_dt = Time.utc
puts end_dt - start_dt
