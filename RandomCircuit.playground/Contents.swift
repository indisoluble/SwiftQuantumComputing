import SwiftQuantumComputing

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

let circuit = CircuitFactory.makeRandomlyGeneratedCircuit(qubitCount: 5, depth: 15, gates: gates)!

print("Measures: \(circuit.measure(qubits: [4, 3, 2, 1, 0])!)")
print()
