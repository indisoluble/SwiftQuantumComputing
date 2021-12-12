import SwiftQuantumComputing // for macOS
//: 1. Compose a list of quantum gates. Insert them in the same order you want them to appear in the quantum circuit
let gates: [Gate] = [
    .not(target: 0),
    .hadamard(target: 1),
    .phaseShift(radians: 0.25, target: 2),
    .rotation(axis: .z, radians: 1, target: 3),
    .matrix(matrix: try Matrix([[.zero, .one], [.one, .zero]]), inputs: [4]),
    .oracle(truthTable: ["01", "10"],
            controls: [0, 1],
            gate: .rotation(axis: .x, radians: 0.5, target: 3)),
    .controlled(gate: .hadamard(target: 4), controls: [2, 0])
]
//: 2. Draw the quantum circuit to see how it looks
let drawer = MainDrawerFactory().makeDrawer()
try drawer.drawCircuit(gates).get()
//: 3. Build the quantum circuit with the list of gates
let circuit = MainCircuitFactory().makeCircuit(gates: gates)
//: 4. Use the quantum circuit
let result = try circuit.statevector().get()
print("Statevector: \(result)\n")
print("Probabilities: \(result.probabilities())\n")
print("Unitary: \(try circuit.unitary().get())\n")
