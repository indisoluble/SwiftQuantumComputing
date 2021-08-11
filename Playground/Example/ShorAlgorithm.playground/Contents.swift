import SwiftQuantumComputing // for macOS

// Complete list of prime numbers (2 will be randomly selected) & maximun number of threads
// the simulator will be allowed to use
let primes: Set<Int> = [3, 5]
let maxConcurrency = 4

let factory = MainCircuitFactory(statevectorConfiguration: .direct(calculationConcurrency: maxConcurrency))
let drawer = MainDrawerFactory().makeDrawer()

let actualFactors = Array(primes).shuffled()[..<2]
let input = actualFactors.reduce(1, *)
print("Looking for factors of: \(input)\n")

let n = Int(Foundation.log2(Double(input)).rounded(.up))
let qubitCount = 3 * n

print("Build Quantum Fourier Transformation gate with \(qubitCount - n) inputs")
let start = CFAbsoluteTimeGetCurrent()
let fourierGate = Gate.makeQuantumFourierTransform(inputs:(n..<qubitCount).reversed(),
                                                   inverse: true).get()
let diff = CFAbsoluteTimeGetCurrent() - start
print("Gate built in \(diff) seconds (\(diff / 60.0) minutes)\n")

print("Build other quantum gates that only depends on the number of qubits\n")
let notGate = Gate.not(target: 0)
let hadamardGates = Gate.hadamard(targets: n..<qubitCount)

var factors: [Int] = []
for base in (2..<input).shuffled() {
    print("Try randomly selected base: \(base)")

    let gcd = EuclideanSolver.findGreatestCommonDivisor(base, input)
    if gcd != 1 {
        print("Factors found for base \(base): \([gcd, input / gcd]). Try another base\n")

        continue
    }

    print("Build modular exponentiation for base \(base) & modulus \(input) with quantum gates")
    var start = CFAbsoluteTimeGetCurrent()
    let modExpGates = Gate.makeModularExponentiation(base: base,
                                                     modulus: input,
                                                     exponent: (n..<qubitCount).reversed(),
                                                     inputs: (0..<n).reversed()).get()
    var diff = CFAbsoluteTimeGetCurrent() - start
    print("Gates built in \(diff) seconds (\(diff / 60.0) minutes)")

    print("Build quantum circuit with \(qubitCount) qubits, base \(base) & modulus \(input)")
    start = CFAbsoluteTimeGetCurrent()
    let gates = [notGate] + hadamardGates + modExpGates + [fourierGate]
    drawer.drawCircuit(gates).get()
    let circuit = factory.makeCircuit(gates: gates)
    diff = CFAbsoluteTimeGetCurrent() - start
    print("Circuit built in \(diff) seconds (\(diff / 60.0) minutes)")

    print("Run quantum circuit with \(qubitCount) qubits & \(circuit.gates.count) gates")
    start = CFAbsoluteTimeGetCurrent()
    let state = circuit.statevector().get()
    let probs = state.groupedProbabilities(byQubits: (0..<n).reversed(),
                                           summarizedByQubits: (n..<qubitCount).reversed()).get()
    diff = CFAbsoluteTimeGetCurrent() - start
    print("Execution completed in \(diff) seconds (\(diff / 60.0) minutes)")

    let (bottomMeasure, topMeasures) = probs.randomElement()!
    let srtMeasures = topMeasures.summary.sorted { $0.value > $1.value }
    let topMeasure = srtMeasures.first(where: { Int($0.key, radix: 2)! != 0 })!.key
    print("Bottom qubits measurement: \(bottomMeasure). Top qubits measurement: \(topMeasure)")

    print("Use top measurement \(topMeasure) to find a candidate period")
    let y = Int(topMeasure, radix: 2)!
    let Q = Int(Foundation.pow(Double(2), Double(2 * n)))
    let value = Rational(numerator: y, denominator: Q)
    let limit = Rational(numerator: 1, denominator: 2 * Q)
    let aprox = ContinuedFractionsSolver.findApproximation(of: value,
                                                           differenceBelowOrEqual: limit).get()

    let period = aprox.denominator
    print("Validating candidate period: \(period)")

    if period % 2 != 0 {
        print("Period \(period) is odd. Discard period & try another base\n")

        continue
    }

    let basePowPeriod = Int(Foundation.pow(Double(base), Double(period)))
    let bppMod = basePowPeriod.quotientAndRemainder(dividingBy: input,
                                                    division: .euclidean).remainder
    if bppMod != 1.quotientAndRemainder(dividingBy: input, division: .euclidean).remainder {
        print("(\(base)^\(period)) mod \(input) != 1 mod \(input). Discard period",
              "& try another base\n")

        continue
    }

    let halfPeriod = period / 2
    let basePowHalfPeriod = Int(Foundation.pow(Double(base), Double(halfPeriod)))
    let bphpMod = basePowHalfPeriod.quotientAndRemainder(dividingBy: input,
                                                         division: .euclidean).remainder
    if bphpMod == (-1).quotientAndRemainder(dividingBy: input, division: .euclidean).remainder {
        print("(\(base)^\(halfPeriod)) mod \(input) == -1 mod \(input). Discard period",
              "& try another base\n")

        continue
    }

    print("Period \(period) is valid\n")

    factors.append(contentsOf: [
        EuclideanSolver.findGreatestCommonDivisor(basePowHalfPeriod + 1, input),
        EuclideanSolver.findGreatestCommonDivisor(basePowHalfPeriod - 1, input)
    ])

    break
}

if Set(actualFactors) == Set(factors) {
    print("Factors found: \(factors) == actual factors: \(actualFactors) --> SUCCESS")
} else {
    print("Factors found: \(factors) != actual factors: \(actualFactors) --> FAILURE")
}
