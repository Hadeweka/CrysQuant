# CrysQuant

CrysQuant is a quantum gate simulation library in development.

# Description

CrysQuant is based on an older project (https://github.com/Hadeweka/HDWQuantum), which was written in Ruby at that time.
However, the computation speed of Crystal allows for much more complex scenarios than in Ruby.

# Features

* Basic range of quantum gates
* Custom quantum gates can be added easily using matrices
* Measuring of registers (with and without wave-function collapse)
* Inspection of the full quantum state of registers

# Installing

CrysQuant is a shard which can be installed by including it into your shard.yml file.

# How to use

The following code creates a 5-Qubit register with the initial state |11000> and then puts the 0th
bit into a superposition of 0 and 1 using a Hadamard gate:
```crystal
qreg = CrysQuant::Register.new(5, 0b11000)
qreg[0].apply_one_qubit_gate(CrysQuant::Gate::Hadamard)
puts 10000.times.sum {|i| qreg.measure} / 10000
```
The last line measures the state of the register 10000 times and averages the results.
Since the initial state |11000> equals the decimal number 24, 
and the other part of the superposition has the state |11001> (representing 25), 
the result will be approximately 24.5.

Note that quantum gate computations require absurdly large matrices, so your memory will probably
overflow at about 15 qubits, maybe even earlier. Generally, computations up to about 10 qubits
should not pose any problems on regular machines.

# Roadmap

* [ ] Finish basic routines
* [X] Add collapsing measuring
* [ ] Support for Anyolite to allow for scripting
* [ ] Add examples and specs