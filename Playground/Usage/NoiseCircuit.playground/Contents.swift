import SwiftQuantumComputing // for macOS
//: 1. Compose a list of quantum gates & noises
let quantumOperators: [QuantumOperatorConvertible] = [
    Gate.hadamard(target: 0),
    Noise.bitFlip(probability: 0.35, target: 0),
    Gate.phaseShift(radians: 0.25, target: 2),
    Noise.phaseDamping(probability: 0.75, target: 2),
    Gate.controlled(gate: .hadamard(target: 1), controls: [2, 0]),
    Noise.bitFlip(probability: 0.8, target: 1)
]
//: 2. Build a quantum circuit with noise using the list
let circuit = MainNoiseCircuitFactory().makeNoiseCircuit(quantumOperators: quantumOperators)
//: 3. Use the quantum circuit with noise
print("Density matrix:: \(circuit.densityMatrix().get())\n")
