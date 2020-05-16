import Foundation
import SwiftQuantumComputing

let factory = VectorCircuitFactory()

// Primes: https://en.wikipedia.org/wiki/List_of_prime_numbers
let primes: Set<Int> = [3, 5]

let actualFactors = Array(primes).shuffled()[..<2]
let input = actualFactors.reduce(1, *)
print("Looking for factors of: \(input)\n")

var factors: [Int] = []
while factors.isEmpty {
    let base = (2..<input).randomElement()!
    print("Try randomly selected base: \(base)")

    let gcd = EuclideanSolver.findGreatestCommonDivisor(base, input)
    if gcd != 1 {
        factors.append(contentsOf: [gcd, input / gcd])
        print("Factors found for base \(base): \(factors)\n")

        continue
    }

    print("Build quantum circuit for base \(base) & modulus \(input)")
    var start = DispatchTime.now()

    let n = Int(Foundation.log2(Double(input)).rounded(.up))
    let qubitCount = 3 * n

    var gates = [Gate.not(target: 0)]
    gates += Gate.hadamard(targets: n..<qubitCount)
    gates += try! Gate.makeModularExponentiation(base: base,
                                                 modulus: input,
                                                 exponent: (n..<qubitCount).reversed(),
                                                 inputs: (0..<n).reversed())
    gates += [try! Gate.makeQuantumFourierTransform(inputs:(n..<qubitCount).reversed(), inverse: true)]

    let circuit = factory.makeCircuit(gates: gates)
    var diff = Double(DispatchTime.now().uptimeNanoseconds - start.uptimeNanoseconds) / 1_000_000_000
    print("Circuit built in \(diff) seconds (\(diff / 60.0) minutes)")

    print("Run quantum circuit with \(qubitCount) qubits & \(circuit.gates.count) gates")
    start = DispatchTime.now()
    let probs = try! circuit.groupedProbabilities(byQubits: (0..<n).reversed(),
                                                  summarizedByQubits: (n..<qubitCount).reversed())
    diff = Double(DispatchTime.now().uptimeNanoseconds - start.uptimeNanoseconds) / 1_000_000_000
    print("Execution completed in \(diff) seconds (\(diff / 60.0) minutes)")

    let (bottomMeasure, topMeasures) = probs.randomElement()!
    let srtMeasures = topMeasures.summary.shuffled().sorted { $0.value > $1.value }
    let topMeasure = srtMeasures.first(where: { Int($0.key, radix: 2)! != 0 })!.key
    print("Bottom qubits measurement: \(bottomMeasure). Top qubits measurement: \(topMeasure)")

    print("Use top measurement \(topMeasure) to find a candidate period")
    let y = Int(topMeasure, radix: 2)!
    let Q = Int(Foundation.pow(Double(2), Double(2 * n)))
    let value = try! Rational(numerator: y, denominator: Q)
    let limit = try! Rational(numerator: 1, denominator: 2 * Q)
    let aprox = try! ContinuedFractionsSolver.findApproximation(of: value, differenceBelowOrEqual: limit)

    let period = aprox.denominator
    print("Validating candidate period: \(period)")

    if period % 2 != 0 {
        print("Period \(period) is odd. Discard & try again\n")

        continue
    }

    let basePowPeriod = Int(Foundation.pow(Double(base), Double(period)))
    let bppMod = basePowPeriod.quotientAndRemainder(dividingBy: input,
                                                    division: .euclidean).remainder
    if bppMod != 1.quotientAndRemainder(dividingBy: input, division: .euclidean).remainder {
        print("(\(base)^\(period)) mod \(input) != 1 mod \(input). Discard period & try again\n")

        continue
    }

    let halfPeriod = period / 2
    let basePowHalfPeriod = Int(Foundation.pow(Double(base), Double(halfPeriod)))
    let bphpMod = basePowHalfPeriod.quotientAndRemainder(dividingBy: input,
                                                         division: .euclidean).remainder
    if bphpMod == (-1).quotientAndRemainder(dividingBy: input, division: .euclidean).remainder {
        print("(\(base)^\(halfPeriod)) mod \(input) == -1 mod \(input). Discard & try again\n")

        continue
    }

    print("Period \(period) is valid")

    factors.append(contentsOf: [
        EuclideanSolver.findGreatestCommonDivisor(basePowHalfPeriod + 1, input),
        EuclideanSolver.findGreatestCommonDivisor(basePowHalfPeriod - 1, input)
    ])
    print("Factors found: \(factors)\n")
}

if Set(actualFactors) == Set(factors) {
    print("Factors found: \(factors) == actual factors: \(actualFactors) --> SUCCESS")
} else {
    print("Factors found: \(factors) != actual factors: \(actualFactors) --> FAILURE")
}
