import SwiftQuantumComputing // for macOS
//: 1. Compose a list of quantum gates. Insert them in the same order
//:    you want them to appear in the quantum circuit
let matrix = Matrix([[.one, .zero, .zero, .zero],
                     [.zero, .one, .zero, .zero],
                     [.zero, .zero, .zero, .one],
                     [.zero, .zero, .one, .zero]])
let gates: [Gate] = [
    .not(target: 0),
    .hadamard(target: 1),
    .phaseShift(radians: 0.25, target: 2),
    .matrix(matrix: matrix, inputs: [3, 2]),
    .matrix(matrix: matrix, inputs: [0, 3]),
    .oracle(truthTable: ["0"], controls: [2], gate: .hadamard(target: 3)),
    .oracle(truthTable: ["01", "10"], controls: [0, 1], gate: .phaseShift(radians: 0.5, target: 3)),
    .oracle(truthTable: ["0"], controls: [0], target: 2),
    .controlled(gate: .hadamard(target: 4), controls: [2]),
    .controlled(gate: .matrix(matrix: matrix, inputs: [4, 2]), controls: [1, 0]),
    .controlledNot(target: 0, control: 3)
]
//: 2. (Optional) Draw the quantum circuit to see how it looks
let drawer = MainDrawerFactory().makeDrawer()
drawer.drawCircuit(gates).get()
//: 3. Build the quantum circuit with the list of gates
let circuit = MainCircuitFactory().makeCircuit(gates: gates)
//: 4. Use the quantum circuit
let statevector = circuit.statevector().get()
print("Statevector: \(statevector)\n")
print("Probabilities: \(statevector.probabilities())\n")
print("Summarized probabilities: \(statevector.summarizedProbabilities())\n")
let groupedProbs = statevector.groupedProbabilities(byQubits: [1, 0],
                                                    summarizedByQubits: [4, 3, 2]).get()
print("Grouped probabilities: \(groupedProbs)")
print("Unitary: \(circuit.unitary().get())\n")
