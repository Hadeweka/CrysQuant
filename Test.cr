require "./src/CrysQuant.cr"

include CrysQuant

qreg = Register.new(5, 0b11000)
qreg.apply_on_lowest_qubits(GateMatrix::Hadamard)
puts 10000.times.sum {|i| qreg.measure} / 10000
