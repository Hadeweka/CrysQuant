module CrysQuant
  class Register
    @size : UInt32
    @state_vector : Matrix(Complex)
    @qubits : Array(Qubit)

    include Enumerable(Qubit)

    def initialize(size : UInt32, state : UInt32)
      if 2**size <= state
        raise "State #{state} greater than size #{2**size} of register"
      end

      @size = size
      @state_vector = CrysQuant.create_state_vector(state, @size)

      @qubits = [] of Qubit
      0.upto(@size - 1) {|i| @qubits.push Qubit.new(register: self, position: i)}
    end

    def [](position : Int32)
      @qubits[position]
    end

    def [](position_1 : Int32, position_2 : Int32)
      Tuple.new(@qubits[position_1], @qubits[position_2])
    end

    # TODO: Can this be generalized?
    def [](position_1 : Int32, position_2 : Int32, position_3 : Int32)
      Tuple.new(@qubits[position_1], @qubits[position_2], @qubits[position_3])
    end

    def each
      @qubits.each {|i| yield i}
    end

    def size
      @size
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

    def measure : UInt32
      found = false

      # TODO: Max iteration depth

      test_value = 0

      while !found
        test_value = rand(2**@size)
        if rand < @state_vector[test_value, 0].abs2
          found = test_value
        end
      end

      test_value.to_u32
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