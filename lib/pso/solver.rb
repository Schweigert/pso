require 'thread'
require 'pso/zero_vector'
require 'pso/functions/rastrigin'

module Pso
  class Solver
    def initialize(din: 5, density: 5000, f: Pso::Rastrigin, center: ZeroVector[0,0,0,0,0], radius: 5.12, method: :min_by)
      @f = f.new
      @din = din
      @center = center
      @radius = radius
      @method = method
      @density = density

      generate_swarm
    end

    def generate_swarm
      Array.new(@density)
      @swarm = Array.new(@density) { generate_random_particle }
      @swarm_best = @swarm.map { |particle| [@f.f(particle), particle] }
    end

    def generate_random_noise_particle
      @center.map { rand * 2 - 1 }
    end

    def generate_random_particle
      @center + (generate_random_noise_particle * (@radius * rand))
    end

    def perfect_particle
      if @method == :min_by
        @swarm.min_by do |element|
          @f.f(element)
        end
      else
        @swarm.max_by do |element|
          @f.f(element)
        end
      end
    end

    def solve(precision: 2000, threads: 4)
      Array.new(threads).map do
        Thread.new do
          (precision / threads).times do
            perfect = perfect_particle
            for index in 0...@din
              new_vector = normalize(interate(@swarm[index], @swarm_best[index].last, perfect))

              if is_best(@swarm_best[index].first, @f.f(new_vector))
                @swarm_best[index] = [@f.f(new_vector), new_vector]
              end

              @swarm[index] = new_vector
            end
          end
        end
      end.each do |thread|
        thread.join
      end

      perfect = perfect_particle
      [@f.f(perfect), perfect]
    end

    private

    def is_best(best, now)
      if @method == :min_by
        now < best
      else
        now > best
      end
    end

    def normalize(vector)
      if (vector - @center).magnitude > @radius
        ((vector - @center).normalize * @radius) + @center
      end

      vector
    end

    def interate(vector, best, perfect)
      return vector + (generate_random_noise_particle) + (best - vector).normalize + (perfect - vector).normalize
    end
  end
end
