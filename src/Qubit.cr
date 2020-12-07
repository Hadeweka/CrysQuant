module CrysQuant
  class Qubit
    def initialize(@register : Register, @position : Int64 | Int32)
    end

    def apply(gate)
      @register.apply(gate, @position)
    end

    # This surely can be solved in a more elegant fashion
    def probe
      @register.probe.to_s(2).rjust(@register.size, '0')[-@position-1].to_i
    end
  end
end