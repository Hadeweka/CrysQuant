module CrysQuant
  class Register
    @size : UInt64
    @state_vector : Matrix(Complex)
    @qubits : Array(Qubit)

    include Enumerable(Qubit)

    def initialize(size : UInt64, state : UInt64)
      if 2**size <= state
        raise "State #{state} greater than size #{2**size} of register"
      end

      @size = size
      @state_vector = CrysQuant.create_state_vector(state, @size)

      @qubits = [] of Qubit
      0.upto(@size - 1) {|i| @qubits.push Qubit.new(register: self, position: i)}
    end

    def [](position : Int64)
      @qubits[position]
    end

    def [](position_1 : Int64, position_2 : Int64)
      Tuple.new(@qubits[position_1], @qubits[position_2])
    end

    # TODO: Can this be generalized?
    def [](position_1 : Int64, position_2 : Int64, position_3 : Int64)
      Tuple.new(@qubits[position_1], @qubits[position_2], @qubits[position_3])
    end

    def swap_qubits(position_1 : Int64, position_2 : Int64)
      new_state_vector = Matrix(Complex).new(2**@size, 1) do |index, i, j|
        # Some bit magic to swap two bits.
        # What we want to do, is to copy each value of the state vector to a new one,
        # but with the bit positions given as arguments swapped for each index.
        # For example, if position_1 is 3 and position_2 is 5, we want to swap
        # bits 3 and 5 for each index (like 0b011010 -> 0b110010 and vice versa).
        # This does the same as applying a SWAP(3, 5) gate to the register,
        # but without the matrix multiplication.

        # First, a bit mask with 1 on a bit which is about to get swapped is generated (else 0).
        swap_bits = (1 << position_1) | (1 << position_2)

        # Then, the mask is applied to the index.
        masked_index = index & swap_bits 

        # If the result is zero or equal to the mask, nothing needs to be done, because then the bits are equal.
        # Otherwise, they definitely need to be swapped.
        if masked_index != 0 && masked_index != swap_bits
          # If the bit mask is xor'd to the index, the bits at the swap positions will be inverted.
          # Since we excluded the case of equal bits, they will effectively be swapped here.
          swapped_index = index ^ swap_bits
          @state_vector[swapped_index] 
        else
          # The bits are equal, so just take the old value.
          @state_vector[index]
        end
      end

      # Finally, replace the old state vector with the new one.
      @state_vector = new_state_vector
    end

    def each
      @qubits.each {|i| yield i}
    end

    def size
      @size
    end

    def apply(matrix : Matrix)
      @state_vector = matrix * @state_vector
    end

    def apply(gate : Gate, qubit)
      classical_qubit = @size - qubit - 1

      matrix = Matrix.identity(2**classical_qubit).⊗(gate.content)

      if qubit > 0
        matrix = matrix.⊗(Matrix.identity(2**qubit))
      end

      apply(matrix)
    end

    # TODO: Higher qubit-count gates

    def measure : UInt64
      found = false

      # TODO: Max iteration depth and invalid value

      test_value = 0

      while !found
        test_value = rand(2**@size)
        if rand < @state_vector[test_value, 0].abs2
          found = test_value
        end
      end

      test_value.to_u64
    end

    def measure!
      new_state = measure
      @state_vector = CrysQuant.create_state_vector(new_state, @size)
      new_state
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