require "math"
require "matrix"
require "complex"

module CrysQuant
  VERSION = "0.0.1"

  State_0 = Matrix[[1], [0]]
  State_1 = Matrix[[0], [1]]

  I = Complex.new(0, 1)

  def self.create_state_vector(state : UInt32, size : UInt32)
    Matrix(Complex).new(2**size, 1) do |index, i, j|
      Complex.new(i == state ? 1 : 0)
    end
  end
end

require "./Matrix_Kronecker.cr"

require "./Qubit.cr"
require "./Gate.cr"
require "./Register.cr"