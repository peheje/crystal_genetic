class Agent
  property score : Float64
  property xs : Array(Float64)

  def initialize(n : Int32, bounds : Range(Float64, Float64))
    @xs = Array.new(n) { rand(bounds) }
    @score = calculate_score()
  end

  def initialize(a : Agent)
    @xs = a.xs.clone
    @score = a.@score
  end

  def calculate_score()
    # f(0) = 0, n params
    s = 0.0
    xs.size.times { |i| s += xs[i] * xs[i] }
    @score = s
  end

  def booth()
    # f(1.0,3.0) = 0, 2 params
    t1 = (xs[0] + 2*xs[1] - 7.0) ** 2
    t2 = (2*xs[0] + xs[1] - 5.0) ** 2
    @score = t1 + t2
  end
end

params = 100
bounds = -10.0..10.0
generations = 1000
print = 100
pop_size = 200
mutate_range = 0.2..0.95
crossover_range = 0.1..1.0

crossover = 0.9
mutate = 0.4

donor = Agent.new(params, bounds)
trial = Agent.new(params, bounds)
pop = Array.new(pop_size) { Agent.new(params, bounds) }

generations.times do |g|
  crossover = rand(crossover_range)
  mutate = rand(mutate_range)

  pop_size.times do |i|

    # Get three others
    others = Array.new(3) { rand(pop_size - 1) }

    x0 = pop[others[0]].xs
    x1 = pop[others[1]].xs
    x2 = pop[others[2]].xs
    xt = pop[i]

    # Create donor
    params.times { |j| donor.xs[j] = x0[j] + (x1[j] - x2[j]) * mutate }

    # Limit bounds
    params.times { |j| donor.xs[j].clamp(bounds) }

    # Create trial
    params.times { |j| trial.xs[j] = rand < crossover ? donor.xs[j] : xt.xs[j] }

    trial.calculate_score()
    
    pop[i] = Agent.new(trial) if trial.score < xt.score
  end

  if g.remainder(print) == 0
    mean = pop.map { |x| x.score }.sum / pop_size
    best = pop.min_by { |x| x.score }
    puts "GEN #{g}"
    puts "MEAN #{mean}"
    #puts "BEST #{best.xs}"
  end
end