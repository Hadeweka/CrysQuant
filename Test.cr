require "./src/CrysQuant.cr"

puts CrysQuant::Gate::CSWAP

qreg = CrysQuant::Register.new(5, 0b11000)
qbit = qreg[0]
qreg[0].apply_one_qubit_gate(CrysQuant::Gate::Hadamard)
puts qreg.inspect
puts 10000.times.sum {|i| qreg.measure} / 10000
puts qbit.measure

puts "====="

puts qreg.measure!
puts qreg.inspect
puts qbit.measure