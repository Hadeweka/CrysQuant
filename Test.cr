require "./src/CrysQuant.cr"

include CrysQuant

qreg = Register.new(5, 0b11000)
qreg[0].apply_one_qubit_gate(Gate::Hadamard)
puts 10000.times.sum {|i| qreg.measure} / 10000

puts GateMatrix::Base_00.⊗(GateMatrix::Unity) + GateMatrix::Base_11.⊗(GateMatrix::Pauli_X)