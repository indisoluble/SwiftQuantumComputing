import SwiftQuantumComputing // for iOS

let factory = MainCircuitFactory()

func isFunctionConstant(truthTable: [String]) -> Bool {
    let gates = [
        FixedGate.hadamard(target: 1),
        FixedGate.hadamard(target: 0),
        FixedGate.oracle(truthTable: truthTable, target: 0, controls: [1]),
        FixedGate.hadamard(target: 1)
    ]
    let circuit = factory.makeCircuit(qubitCount: 2, gates: gates)!

    let measure = circuit.measure(qubits: [1], afterInputting: "01")!

    return (abs(1 - measure[0]) < 0.001)
}

print("Function: f(0) = 0, f(1) = 0. Is it constant? \(isFunctionConstant(truthTable: []))")
print("Function: f(0) = 1, f(1) = 1. Is it constant? \(isFunctionConstant(truthTable: ["0", "1"]))")
print("Function: f(0) = 1, f(1) = 0. Is it constant? \(isFunctionConstant(truthTable: ["0"]))")
print("Function: f(0) = 0, f(1) = 1. Is it constant? \(isFunctionConstant(truthTable: ["1"]))")
