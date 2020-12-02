require "./src/CrysQuant.cr"

puts CrysQuant::Gate::CSWAP

qreg = CrysQuant::Register.new(5, 0b11000)
qreg.apply_one_qubit_gate(CrysQuant::Gate::Hadamard, 0)
puts qreg.inspect
puts 10000.times.sum {|i| qreg.measure} / 10000