require 'pso/function'
require 'pso/zero_vector'

module Pso
  class Schwefel < Pso::Function
    def f(vector)
      alpha = 418.982887
      vector.map { |n| -n * Math.sin(Math.sqrt(n.to_f.abs))}.sum + alpha * vector.size
    end
  end
end
