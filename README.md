# A Quantum Computing experiment based on Swift

In this repository you can find a simple quantum circuit simulator written in Swift.

Over time and as I learn more about quantum computing, I will add more Swift code to experiment with these concepts.

The code written so far is mostly based on the content of: [Quantum Computing for Computer Scientists](https://www.amazon.com/Quantum-Computing-Computer-Scientists-Yanofsky/dp/0521879965), with a few tips from [Automatic Quantum Computer Programming: A Genetic Programming Approach](https://www.amazon.com/Automatic-Quantum-Computer-Programming-Approach/dp/038736496X). It is also inspired by [IBM Qiskit](https://github.com/Qiskit/qiskit-terra).

## Usage

For a more detailed example, check `DeutschAlgorithm.playground`.

```swift
import SwiftQuantumComputing

print("Deutsch's Algorithm")
print("Function: (f(0) = 1, f(1) = 0)")
let uf = Matrix([[Complex(0), Complex(1), Complex(0), Complex(0)],
                 [Complex(1), Complex(0), Complex(0), Complex(0)],
                 [Complex(0), Complex(0), Complex(1), Complex(0)],
                 [Complex(0), Complex(0), Complex(0), Complex(1)]])!
print("Uf:")
print(uf)

let qubitCount = 2

let not = NotGateFactory(qubitCount: qubitCount)!
let hadamard = HadamardGateFactory(qubitCount: qubitCount)!
let oracle = GateFactory(qubitCount: qubitCount, baseMatrix: uf)!

var register = Register(qubitCount: qubitCount)!
register = register.applying(not.makeGate(input: 0)!)!
register = register.applying(hadamard.makeGate(input: 1)!)!
register = register.applying(hadamard.makeGate(input: 0)!)!
register = register.applying(oracle.makeGate(inputs: 1, 0)!)!
register = register.applying(hadamard.makeGate(input: 1)!)!

let measure = register.measure(qubits: 1)!

print("Is it constant? \((abs(1 - measure[0]) < 0.001))")
```