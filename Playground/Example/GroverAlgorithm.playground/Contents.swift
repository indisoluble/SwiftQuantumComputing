import SwiftQuantumComputing // for macOS

let element = "11010"

var gates = [Gate.not(target: 0)]
gates += Gate.hadamard(targets: 0...element.count)

let times = Int((Double.pi / 4.0) * sqrt(pow(2.0, Double(element.count))))
for _ in 0..<times {
    // Phase inversion
    gates += [Gate.oracle(truthTable:[element],
                          target: 0,
                          controls: (1...element.count).reversed())]

    // Inversion about mean
    gates += [Gate.makeInversionAboutMean(inputs: (1...element.count).reversed()).get()]
}

MainDrawerFactory().makeDrawer().drawCircuit(gates)

let circuit = MainCircuitFactory().makeCircuit(gates: gates)
let statevector = circuit.statevector().get()

let probabilities = statevector.summarizedProbabilities(byQubits: (1...element.count).reversed()).get()

let (foundElement, _) = probabilities.max { $0.value < $1.value }!

print("Element: \(element). Found element: \(foundElement). Success? \(element == foundElement)")
