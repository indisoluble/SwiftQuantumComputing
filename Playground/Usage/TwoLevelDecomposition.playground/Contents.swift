import SwiftQuantumComputing // for macOS

let factory = MainCircuitFactory()
let drawer = MainDrawerFactory().makeDrawer()

//: 1. Define gates
let gates = [
    Gate.oracle(truthTable: ["000000", "101011"],
                controls: [7, 5, 2, 10, 12, 14],
                gate: .not(target: 0)),
    Gate.oracle(truthTable: ["101011", "011000"],
                controls: [14, 6, 10, 0, 11, 1],
                gate: .hadamard(target: 3)),
    Gate.oracle(truthTable: ["110101", "110011"],
                controls: [3, 8, 4, 0, 13, 14],
                gate: .phaseShift(radians: 0.25, target: 10))
]
//: 2. (Optional) Draw gates to see how they look
drawer.drawCircuit(gates).get()
//: 3. Build circuit and measure how long it takes to get the statevector
var start = CFAbsoluteTimeGetCurrent()
factory.makeCircuit(gates: gates).statevector().get()
var diff = CFAbsoluteTimeGetCurrent() - start
print("Original circuit executed in \(diff) seconds")
//: 4. Decompose gates into an equivalent sequence of fully controlled matrix gates and not gates
start = CFAbsoluteTimeGetCurrent()
let decomposition = TwoLevelDecompositionSolver.decomposeGates(gates).get()
diff = CFAbsoluteTimeGetCurrent() - start
print("Original circuit decomposed in \(diff) seconds")
//: 5. (Optional) Draw decomposition to see how it looks
drawer.drawCircuit(decomposition).get()
//: 6. Build a new circuit and measure how long it takes to get the statevector.
//: Single qubit gates & fully controlled gates are faster to execute, however this
//: descomposition produces a lot of them
start = CFAbsoluteTimeGetCurrent()
factory.makeCircuit(gates: decomposition).statevector().get()
diff = CFAbsoluteTimeGetCurrent() - start
print("Decomposed circuit executed in \(diff) seconds")
