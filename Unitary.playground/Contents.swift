import SwiftQuantumComputing // for macOS

let qubitCount = 2
let truthTable = ["0", "1"]
let gates = [
    FixedGate.hadamard(target: 1),
    FixedGate.hadamard(target: 0),
    FixedGate.oracle(truthTable: truthTable, target: 0, controls: [1]),
    FixedGate.hadamard(target: 1)
]

let drawer = try! MainDrawerFactory().makeDrawer(qubitCount: qubitCount)
drawer.drawCircuit(gates)

let circuit = MainCircuitFactory().makeCircuit(gates: gates)
let unitary = try! circuit.unitary(usingQubitCount: qubitCount)

print("Unitary: [")
for row in unitary {
    print(row)
}
print("]")
