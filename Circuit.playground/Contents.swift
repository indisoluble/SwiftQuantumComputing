import SwiftQuantumComputing // for macOS
//: 1. Compose a list of quantum gates. Insert them in the same order
//:    you want them to appear in the quantum circuit
let gates = [
    Gate.controlledNot(target: 0, control: 2),
    Gate.hadamard(target: 1),
    Gate.matrix(matrix: Matrix([[Complex(0), Complex(1)], [Complex(1), Complex(0)]]), inputs: [2]),
    Gate.not(target: 1),
    Gate.oracle(truthTable: ["00", "11"], target: 0, controls: [2, 1]),
    Gate.phaseShift(radians: 0, target: 2)
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
print("Unitary: \(circuit.unitary())\n")
