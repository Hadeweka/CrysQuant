require "./src/CrysQuant.cr"

qreg = CrysQuant::Register.new(5, 0b11000)
qreg[0].apply_one_qubit_gate(CrysQuant::Gate::Hadamard * CrysQuant::Gate::Hadamard)
puts 10000.times.sum {|i| qreg.measure} / 10000