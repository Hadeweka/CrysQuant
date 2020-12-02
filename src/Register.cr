require "math"
require "matrix"
require "complex"

require "./Matrix_Kronecker.cr"

module CrysQuant
  class Register
    @size : UInt32
    @state_vector : Matrix(Complex)

    def initialize(size : UInt32, position : UInt32)
      if 2**size <= position
        raise "Position #{position} greater than size #{2**size} of register"
      end

      @size = size
      @state_vector = Matrix(Complex).new(2**size, 1) do |index, i, j|
        Complex.new(i == position ? 1 : 0)
      end
    end

    def apply_matrix(matrix)
      @state_vector = matrix * @state_vector
    end

    def apply_one_qubit_gate(gate, qubit)
      classical_qubit = @size - qubit - 1

      matrix = Matrix.identity(2**classical_qubit).kronecker_product(gate)

      if qubit > 0
        matrix = matrix.kronecker_product(Matrix.identity(2**qubit))
      end

      apply_matrix(matrix)
    end

    # TODO: Higher qubit-count gates

    def measure
      found = false

      while !found
        test_value = rand(2**@size)
        if rand < @state_vector[test_value, 0].abs2
          found = test_value
        end
      end

      test_value
    end

    def inspect
      final_string = ""

      0.upto(2**@size - 1) do |i|
        final_string += "|#{i.to_s(2).rjust(@size, '0')}> is #{@state_vector[i].abs} (#{@state_vector[i]})\n"
      end

      final_string
    end
  end
end