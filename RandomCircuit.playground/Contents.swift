import SwiftQuantumComputing // for macOS

let uf1 = Matrix([[Complex(0), Complex(1)],
                  [Complex(1), Complex(0)]])!
let uf2 = Matrix([[Complex(0), Complex(1), Complex(0), Complex(0)],
                  [Complex(1), Complex(0), Complex(0), Complex(0)],
                  [Complex(0), Complex(0), Complex(1), Complex(0)],
                  [Complex(0), Complex(0), Complex(0), Complex(1)]])!
let factories: [CircuitGateFactory] = [
    ControlledNotGateFactory(),
    HadamardGateFactory(),
    NotGateFactory(),
    OracleGateFactory(matrix: uf1),
    OracleGateFactory(matrix: uf2),
    PhaseShiftGateFactory(radians: acos(Double(3) / Double(5)))
]

let circuit = CircuitFactory.makeRandomizedCircuit(qubitCount: 8, depth: 10, factories: factories)!

let date = Date()

print("Probabilities:")
for (bits, probability) in circuit.probabilities()!.sorted(by: { $0.1 > $1.1 }) {
    print("\"\(bits)\": \(probability)")
}

print("Time elapsed: \(-date.timeIntervalSinceNow) seconds")
