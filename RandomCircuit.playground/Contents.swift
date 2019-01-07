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
    MatrixGateFactory(matrix: uf1),
    MatrixGateFactory(matrix: uf2),
    PhaseShiftGateFactory(radians: acos(Double(3) / Double(5)))
]

let circuit = CircuitFactory.makeRandomizedCircuit(qubitCount: 8, depth: 10, factories: factories)!

let date = Date()
print("Measuring ...")

let probabilities = circuit.probabilities(afterInputting: "11100010")!
print("Measurement completed in \(-date.timeIntervalSinceNow) seconds\n")

print("\(probabilities.count) possible output/s:")
for (output, probability) in probabilities.sorted(by: { $0.1 > $1.1 }) {
    print(String(format: "%@ -> %.2f %%", output, probability * 100))
}
