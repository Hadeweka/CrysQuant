require "./src/CrysQuant.cr"

t = Time.measure do
  qreg = CrysQuant::Register.new(10, 0b11000)
  qreg[0].apply(CrysQuant::Gate::Hadamard)
end
puts "#{t.total_milliseconds} ms"
