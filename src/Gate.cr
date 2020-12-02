module CrysQuant
  class Gate
    Gate.implement(Unity, alternative_names: [Identity])
    Gate.implement(Zero)

    Gate.implement(Pauli_X, alternative_names: [X, NOT])
    Gate.implement(Pauli_Y, alternative_names: [Y])
    Gate.implement(Pauli_Z, alternative_names: [Z])

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

    property content : Matrix(Complex)

    def initialize(matrix : Matrix)
      @content = CrysQuant.convert_to_complex_matrix(matrix)
    end

    def *(other_gate : Gate)
      Gate.new(this_matrix * other_matrix)
    end
  end
end