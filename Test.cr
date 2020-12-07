require "./src/CrysQuant.cr"

qreg = CrysQuant::Register.new(5, 0b11000)
qreg[0].apply(CrysQuant::Gate::Hadamard)
puts 10000.times.sum {|i| qreg.probe} / 10000