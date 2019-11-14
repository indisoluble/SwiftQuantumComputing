import SwiftQuantumComputing // for macOS

let truthTable = ["0", "1"]
let gates = [
    FixedGate.not(target: 0),
    FixedGate.hadamard(target: 0),
    FixedGate.hadamard(target: 1),
    FixedGate.oracle(truthTable: truthTable, target: 0, controls: [1]),
    FixedGate.hadamard(target: 1)
]

let drawer = MainDrawerFactory().makeDrawer()
try! drawer.drawCircuit(gates)

let circuit = MainCircuitFactory().makeCircuit(gates: gates)
let unitary = try! circuit.unitary()

print("Unitary: [")
for row in unitary.elements {
    print(row)
}
print("]")
