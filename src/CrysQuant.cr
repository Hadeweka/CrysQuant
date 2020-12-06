require "math"
require "matrix"
require "complex"

module CrysQuant
  VERSION = "0.0.1"

  State_0 = Matrix[[1], [0]]
  State_1 = Matrix[[0], [1]]

  I = Complex.new(0, 1)

  def self.create_state_vector(state : UInt64, size : UInt64)
    Matrix(Complex).new(rows: 2**size, columns: 1) do |index, i, j|
      Complex.new(index == state ? 1 : 0)
    end
  end

  def self.convert_to_complex_matrix(matrix : Matrix)
    Matrix.new(rows: matrix.rows.size, columns: matrix.columns.size) do |index, i, j|
      Complex.new(matrix[row: i, column: j])
    end
  end
end

require "./Macros.cr"

require "./Matrix_additions.cr"

require "./GateMatrix.cr"
require "./Gate.cr"
require "./Qubit.cr"
require "./Register.cr"