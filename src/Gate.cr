module CrysQuant
  class Gate
    Gate.implement(Unity, alternative_names: [Identity])
    Gate.implement(Zero)

    Gate.implement(Pauli_X, alternative_names: [X])
    Gate.implement(Pauli_Y, alternative_names: [Y])
    Gate.implement(Pauli_Z, alternative_names: [Z, NOT])

    Gate.implement(Hadamard, alternative_names: [H])

    Gate.implement(Rotation_X_90, alternative_names: [S])
    Gate.implement(Rotation_Y_90, alternative_names: [T])

    Gate.implement(Rotation_Phase_90)
    Gate.implement(Rotation_Phase_45)

    Gate.implement(Sqrt_NOT)

    Gate.implement(CNOT)
    Gate.implement(SWAP)
    Gate.implement(Sqrt_SWAP)

    Gate.implement(CCNOT, alternative_names: [Toffoli])
    Gate.implement(CSWAP, alternative_names: [Fredkin])

    enum Type
      UNKNOWN
      MATRIX
      ARRAY_2
      ARRAY_3
    end

    @type : Type = Type::UNKNOWN
    @matrix_content : Matrix(Complex) | Nil
    @array_content : Array(Array(Matrix(Complex))) | Nil

    def initialize(matrix : Matrix)
      @type = Type::MATRIX

      @matrix_content = CrysQuant.convert_to_complex_matrix(matrix)
      @array_content = nil
    end

    def initialize(array : Array(Array(Matrix)))
      if array.size == 2
        @type = Type::ARRAY_2
      elsif array.size == 4
        @type = Type::ARRAY_3
      else
        raise("Invalid array size for gate: #{array.size}")
      end

      @array_content = Array.new(size: array.size) do |m|
        Array.new(size: array.size) do |n|
          CrysQuant.convert_to_complex_matrix(array[m][n])
        end
      end
      @matrix_content = nil
    end

    def get_matrix_content(i = 0, j = 0) : Matrix(Complex)
      if @type == Type::UNKNOWN
        raise("Unknown content type for gate")
      elsif @type == Type::MATRIX
        if content = @matrix_content
          content
        else
          raise("Corrupted matrix content")
        end
      else
        if content = @array_content
          content[i][j]
        else
          raise("Corrupted matrix content")
        end
      end
    end
  end
end