require 'matrix'

class ZeroVector < Vector
  def normalize
    return self if zero?
    super
  end
end
