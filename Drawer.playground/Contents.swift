import SwiftQuantumComputing // for macOS
//: 1. Compose a list of quantum gates. Insert them in the same order
//:    you want them to appear in the quantum circuit
let matrix = Matrix([[Complex(1), Complex(0), Complex(0), Complex(0)],
                     [Complex(0), Complex(1), Complex(0), Complex(0)],
                     [Complex(0), Complex(0), Complex(0), Complex(1)],
                     [Complex(0), Complex(0), Complex(1), Complex(0)]])
let gates = [
    FixedGate.controlledNot(target: 0, control: 3),
    FixedGate.phaseShift(radians: 0, target: 1),
    FixedGate.matrix(matrix: matrix, inputs: [2, 1]),
    FixedGate.not(target: 2),
    FixedGate.hadamard(target: 3),
    FixedGate.oracle(truthTable: ["01", "10"], target: 3, controls: [0, 1])
]
//: 2. Draw the quantum circuit to see how it looks
let drawer = MainDrawerFactory().makeDrawer()
drawer.drawCircuit(gates)
