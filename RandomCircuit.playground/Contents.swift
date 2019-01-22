import SwiftQuantumComputing // for macOS

let uf1 = Matrix([[Complex(0), Complex(1)],
                  [Complex(1), Complex(0)]])!
let uf2 = Matrix([[Complex(0), Complex(1), Complex(0), Complex(0)],
                  [Complex(1), Complex(0), Complex(0), Complex(0)],
                  [Complex(0), Complex(0), Complex(1), Complex(0)],
                  [Complex(0), Complex(0), Complex(0), Complex(1)]])!
let gates: [Gate] = [
    ControlledNotGate(),
    HadamardGate(),
    MatrixGate(matrix: uf1),
    MatrixGate(matrix: uf2),
    NotGate(),
    OracleGate(truthTable: ["1"], truthTableQubitCount: 1),
    OracleGate(truthTable: ["110", "10", "0"], truthTableQubitCount: 3),
    PhaseShiftGate(radians: acos(Double(3) / Double(5)))
]

let circuit = CircuitFactory.makeRandomizedCircuit(qubitCount: 8, depth: 10, gates: gates)!

let date = Date()
print("Measuring ...")

let probabilities = circuit.probabilities(afterInputting: "11100010")!
print("Measurement completed in \(-date.timeIntervalSinceNow) seconds\n")

print("\(probabilities.count) possible output/s:")
for (output, probability) in probabilities.sorted(by: { $0.1 > $1.1 }) {
    print(String(format: "%@ -> %.2f %%", output, probability * 100))
}
