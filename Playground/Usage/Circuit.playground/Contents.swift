import SwiftQuantumComputing // for macOS
//: 1. Compose a list of quantum gates. Insert them in the same order
//:    you want them to appear in the quantum circuit
let matrix = Matrix([[Complex.one, Complex.zero, Complex.zero, Complex.zero],
                     [Complex.zero, Complex.one, Complex.zero, Complex.zero],
                     [Complex.zero, Complex.zero, Complex.zero, Complex.one],
                     [Complex.zero, Complex.zero, Complex.one, Complex.zero]])
let gates = [
    Gate.hadamard(target: 3),
    Gate.controlledMatrix(matrix: matrix, inputs: [3, 4], control: 1),
    Gate.controlledNot(target: 0, control: 3),
    Gate.matrix(matrix: matrix, inputs: [3, 2]),
    Gate.not(target: 1),
    Gate.oracle(truthTable: ["01", "10"], target: 3, controls: [0, 1]),
    Gate.phaseShift(radians: 0.25, target: 0)
]
//: 2. (Optional) Draw the quantum circuit to see how it looks
let drawer = MainDrawerFactory().makeDrawer()
drawer.drawCircuit(gates)
//: 3. Build the quantum circuit with the list of gates
let circuit = MainCircuitFactory().makeCircuit(gates: gates)
//: 4. Use the quantum circuit
print("Statevector: \(circuit.statevector())\n")
print("Probabilities: \(circuit.probabilities())\n")
print("Summarized probabilities: \(circuit.summarizedProbabilities())\n")
let groupedProbs = circuit.groupedProbabilities(byQubits: [1, 0], summarizedByQubits: [4, 3, 2])
print("Grouped probabilities: \(groupedProbs)")
print("Unitary: \(circuit.unitary())\n")
