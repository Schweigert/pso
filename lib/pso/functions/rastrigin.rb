require 'pso/function'
require 'pso/zero_vector'

module Pso
  class Rastrigin < Pso::Function
    def f(vector)
      fitness = 10 * vector.size
      fitness + vector.map { |n| n ** 2 - 10 * Math.cos(2 * Math::PI * n) }.sum
    end
  end
end
