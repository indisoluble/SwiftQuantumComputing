import SwiftQuantumComputing // for iOS

func isFunctionConstant(truthTable: [String]) -> Bool {
    let gates = [
        Gate.hadamard(target: 1),
        Gate.hadamard(target: 0),
        Gate.oracle(truthTable: truthTable, target: 0, controls: [1]),
        Gate.hadamard(target: 1)
    ]
    let circuit = CircuitFactory.makeCircuit(qubitCount: 2, gates: gates)!

    let measure = circuit.measure(qubits: [1], afterInputting: "01")!

    return (abs(1 - measure[0]) < 0.001)
}

print("Function: (f(0) = 0, f(1) = 0)")
print("Is it constant? \(isFunctionConstant(truthTable: []))")
print()

print("Function: (f(0) = 1, f(1) = 1)")
print("Is it constant? \(isFunctionConstant(truthTable: ["0", "1"]))")
print()

print("Function: (f(0) = 1, f(1) = 0)")
print("Is it constant? \(isFunctionConstant(truthTable: ["0"]))")
print()

print("Function: (f(0) = 0, f(1) = 1)")
print("Is it constant? \(isFunctionConstant(truthTable: ["1"]))")
print()
