import SwiftQuantumComputing // for macOS
//: 1. Compose a list of quantum gates. Insert them in the same order
//:    you want them to appear in the quantum circuit
let matrix = Matrix([[Complex.one, Complex.zero, Complex.zero, Complex.zero],
                     [Complex.zero, Complex.one, Complex.zero, Complex.zero],
                     [Complex.zero, Complex.zero, Complex.zero, Complex.one],
                     [Complex.zero, Complex.zero, Complex.one, Complex.zero]])
let gates = [
    Gate.controlledMatrix(matrix: matrix, inputs: [2, 3], control: 1),
    Gate.controlledNot(target: 0, control: 3),
    Gate.hadamard(target: 3),
    Gate.matrix(matrix: matrix, inputs: [2, 1]),
    Gate.not(target: 2),
    Gate.oracle(truthTable: ["01", "10"], target: 3, controls: [0, 1]),
    Gate.phaseShift(radians: 0.25, target: 1)
]
//: 2. Draw the quantum circuit to see how it looks
let drawer = MainDrawerFactory().makeDrawer()
drawer.drawCircuit(gates)
