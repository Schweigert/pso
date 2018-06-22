require 'matrix'

module Pso
  class Function
    def f(vector)
      vector.magnitude
    end
  end
end
