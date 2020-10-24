import SwiftQuantumComputing // for macOS

let factory = MainCircuitFactory(statevectorConfiguration: .elementByElement(maxConcurrency: 4))
let drawer = MainDrawerFactory().makeDrawer()

//: 1. Define gates
let gates = [
    Gate.oracle(truthTable: ["0000", "1010"], controls: [7, 5, 2, 10], gate: .not(target: 0)),
    Gate.oracle(truthTable: ["0011", "1100"], controls: [6, 10, 0, 1], gate: .not(target: 3)),
    Gate.oracle(truthTable: ["1100", "1001"], controls: [3, 7, 4, 0], gate: .not(target: 10))
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
//: 6. Build a new circuit and measure how long it takes to get the statevector. Statevector calculation is optimized
//: for the type of gates returned in the decomposition
start = CFAbsoluteTimeGetCurrent()
factory.makeCircuit(gates: decomposition).statevector().get()
diff = CFAbsoluteTimeGetCurrent() - start
print("Decomposed circuit executed in \(diff) seconds")
