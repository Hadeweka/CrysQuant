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

    def each
      @qubits.each {|i| yield i}
    end

    def size
      @size
    end

    def swap_qubits(position_1 : Int64, position_2 : Int64)
      return if position_1 == position_2

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

    def apply_on_lowest_qubits(matrix : Matrix)
      gate_size = matrix.rows.size

      final_state_vector = nil

      0.upto(2**@size // gate_size - 1) do |k|
        state_vector_partition = Matrix(Complex).new(gate_size, 1) do |index, i, j|
          @state_vector[row: k * gate_size + index, column: 0]
        end

        if !final_state_vector
          final_state_vector = matrix * state_vector_partition 
        else
          final_state_vector = final_state_vector.append(matrix * state_vector_partition)
        end
      end

      if non_nil_final_state_vector = final_state_vector
        @state_vector = non_nil_final_state_vector
      else
        raise("Application of matrix of state vector failed")
      end
    end

    def apply_directly(matrix : Matrix)
      @state_vector = matrix * @state_vector
    end

    def apply(gate : Gate, *qubits)
      current_qubit_positions = Array.new(size: @size) {|i| i}
      swaps = Array(Tuple(Int64, Int64)).new

      # Swap the Qubits to be operated on with the lowest qubits
      0.upto(qubits.size - 1) do |i|
        # Find the current position of the destination qubit
        destination_index = current_qubit_positions.index(qubits[i])

        # Destination index could technically be nil, but this should not happen
        if destination_index
          swap_qubits(i.to_i64, destination_index.to_i64)

          # Store all swaps
          current_qubit_positions.swap(i.to_i64, destination_index.to_i64)
          swaps.push({i.to_i64, destination_index.to_i64})
        end
      end

      # Apply the gate
      apply_on_lowest_qubits(gate.content)

      # Swap everything back
      swaps.reverse.each do |swap|
        swap_qubits(swap[0], swap[1])
        current_qubit_positions.swap(swap[0], swap[1])
      end
    end

    def probe : UInt64
      found = false

      # TODO: Max iteration depth and invalid value

      test_value = 0

      while !found
        test_value = rand(2**@size)
        if rand < @state_vector[row: test_value, column: 0].abs2
          found = test_value
        end
      end

      test_value.to_u64
    end

    def measure
      new_state = probe
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