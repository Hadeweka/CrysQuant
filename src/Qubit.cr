module CrysQuant
  class Qubit
    def initialize(@register : Register, @position : Int64 | Int32)
    end

    def apply_one_qubit_gate(gate)
      @register.apply_one_qubit_gate(gate, @position)
    end

    # This surely can be solved in a more elegant fashion
    def measure
      @register.measure.to_s(2).rjust(@register.size, '0')[-@position-1]
    end
  end
end