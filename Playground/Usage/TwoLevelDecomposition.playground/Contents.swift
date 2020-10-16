import SwiftQuantumComputing // for macOS

//: 1. Define a gate
let gate = Gate.oracle(truthTable: ["000", "101"], controls: [4, 5, 2], gate: .not(target: 0))
//: 2. (Optional) Draw the gate to see how it looks
let drawer = MainDrawerFactory().makeDrawer()
drawer.drawCircuit([gate]).get()
//: 3. Decompose gate into an equivalent sequence of fully controlled matrix gates and not gates
let decomposition = TwoLevelDecompositionSolver.decomposeGate(gate).get()
//:42. (Optional) Draw the decomposition to see how it looks
drawer.drawCircuit(decomposition).get()
