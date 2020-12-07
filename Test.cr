require "./src/CrysQuant.cr"

include CrysQuant

qreg = Register.new(4, 0b1000)
qreg.apply(Gate::Hadamard, 1)

qreg.apply(Gate::CNOT, 3, 1)
puts qreg.inspect
puts 10000.times.sum {|i| qreg.measure} / 10000
