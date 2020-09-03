import SwiftQuantumComputing // for macOS

let circuitFactory = MainCircuitFactory()
let drawer = MainDrawerFactory().makeDrawer()

func isFunctionConstant(truthTable: [String], qubitCount: Int) -> Bool {
    var gates = [Gate.not(target: 0)]
    gates += Gate.hadamard(targets: 0...qubitCount)
    gates += [Gate.oracle(truthTable: truthTable, controls: (1...qubitCount).reversed(), target: 0)]
    gates += Gate.hadamard(targets: 1...qubitCount)

    try! drawer.drawCircuit(gates).get()

    let circuit = circuitFactory.makeCircuit(gates: gates)
    let statevector = try! circuit.statevector().get()
    let probabilities = try! statevector.summarizedProbabilities(byQubits: (1...qubitCount).reversed()).get()

    let zeros = String(repeating: "0", count: qubitCount)
    let zerosProbabilities = probabilities[zeros] ?? 0.0

    return (abs(1.0 - zerosProbabilities) < 0.001)
}

func makeQubitCombinations(qubitCount: Int) -> [String] {
    return (0..<Int.pow(2, qubitCount)).map { String($0, bitCount: qubitCount) }
}

func selectHalfQubitCombinations(_ combinations: [String]) -> [String] {
    return combinations.randomElements(count: combinations.count / 2)
}

let qubitCount = 3

print("Funtion: f(<Any input>) = 0")
print("Is it constant? \(isFunctionConstant(truthTable: [], qubitCount: qubitCount)) \n")

print("Funtion: f(<Any input>) = 1")
let truthtable = makeQubitCombinations(qubitCount: qubitCount)
print("Is it constant? \(isFunctionConstant(truthTable: truthtable, qubitCount: qubitCount)) \n")

print("Funtion: f(<Half inputs>) = 1")
let halfTruthtable = selectHalfQubitCombinations(truthtable)
print("Is it constant? \(isFunctionConstant(truthTable: halfTruthtable, qubitCount: qubitCount))")
