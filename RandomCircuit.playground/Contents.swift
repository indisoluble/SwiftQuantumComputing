import SwiftQuantumComputing // for macOS

let uf1 = Matrix([[Complex(0), Complex(1)],
                  [Complex(1), Complex(0)]])!
let uf2 = Matrix([[Complex(0), Complex(1), Complex(0), Complex(0)],
                  [Complex(1), Complex(0), Complex(0), Complex(0)],
                  [Complex(0), Complex(0), Complex(1), Complex(0)],
                  [Complex(0), Complex(0), Complex(0), Complex(1)]])!

let gates = [
    CircuitGate.makeControlledNot(),
    CircuitGate.makeHadamard(),
    CircuitGate.makeNot(),
    CircuitGate.makeOracle(matrix: uf1),
    CircuitGate.makeOracle(matrix: uf2),
    CircuitGate.makePhaseShift(radians: acos(Double(3) / Double(5)))]

let date = Date()
let circuit = CircuitFactory.makeRandomlyGeneratedCircuit(qubitCount: 8, depth: 10, gates: gates)!
print("Circuit built in \(-date.timeIntervalSinceNow) seconds")

print("Probabilities:")
for (bits, probability) in circuit.probabilities()!.sorted(by: { $0.1 > $1.1 }) {
    print("\"\(bits)\": \(probability)")
}
