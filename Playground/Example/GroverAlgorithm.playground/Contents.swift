import SwiftQuantumComputing // for macOS

let element = "110101"

var gates = [Gate.not(target: 0)]
gates += Gate.hadamard(targets: 0...element.count)

let times = Int((Double.pi / 4.0) * sqrt(pow(2.0, Double(element.count))))
for _ in 0..<times {
    // Phase inversion
    gates += [Gate.oracle(truthTable:[element],
                          controls: (1...element.count).reversed(),
                          target: 0)]

    // Inversion about mean
    gates += [try Gate.makeInversionAboutMean(inputs: (1...element.count).reversed()).get()]
}

try MainDrawerFactory().makeDrawer().drawCircuit(gates).get()

let circuit = MainCircuitFactory().makeCircuit(gates: gates)
let statevector = try circuit.statevector().get()

let probabilities = try statevector.summarizedProbabilities(byQubits: (1...element.count).reversed()).get()

let (foundElement, _) = probabilities.max { $0.value < $1.value }!

print("Element: \(element). Found element: \(foundElement). Success? \(element == foundElement)")
