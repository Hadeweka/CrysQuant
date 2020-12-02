module CrysQuant
  module GateMatrix
    Unity = Matrix.identity(2)
    Zero = Matrix[[0, 0], [0, 0]]

    Base_00 = State_0.⊗(State_0.⊤)
    Base_01 = State_0.⊗(State_1.⊤)
    Base_10 = State_1.⊗(State_0.⊤)
    Base_11 = State_1.⊗(State_1.⊤)

    Bases = [[Base_00, Base_01], [Base_10, Base_11]]

    Helper_A = Matrix[[1, 0], [0, Complex.new(1/2, 1/2)]]
    Helper_B = Matrix[[Complex.new(1/2, 1/2), 0], [0, 1.0]]

    Pauli_X = Matrix[[0, 1], [1, 0]]
    Pauli_Y = Matrix[[0, -I], [I, 0]]
    Pauli_Z = Matrix[[1, 0], [0, -1]]

    Hadamard = Matrix[[1, 1], [1, -1]] / Math.sqrt(2)

    Rotation_X_90 = Matrix[[1, -I], [-I, 1]] / Math.sqrt(2)
    Rotation_Y_90 = Matrix[[1, -1], [1, 1]] / Math.sqrt(2)

    Rotation_Phase_90 = Matrix[[1, 0], [0, I]]
    Rotation_Phase_45 = Matrix[[1, 0], [0, Complex.new(1, 1) / Math.sqrt(2)]]

    Sqrt_NOT = Matrix[[Complex.new(1, 1), Complex.new(1, -1)], [Complex.new(1, -1), Complex.new(1, 1)]] / 2

    CNOT = Base_00.⊗(GateMatrix::Unity) + Base_11.⊗(GateMatrix::Pauli_X)
    SWAP = [[Base_00, Base_10], [Base_01, Base_11]]
    Sqrt_SWAP = [[Helper_A, Base_10 * Complex.new(1/2, -1/2)], [Base_01 * Complex.new(1/2, -1/2), Helper_B]]

    CCNOT = [[Unity, Zero, Zero, Unity], [Zero] * 4, [Zero] * 4, CNOT.flatten]
    CSWAP = [[Unity, Zero, Zero, Unity], [Zero] * 4, [Zero] * 4, SWAP.flatten]
  end
end