import SwiftQuantumComputing // for macOS
//: 1. Define rational value to approximate
let value = Rational(numerator: 15, denominator: 11)
//: 2. And a limit or maximum difference between approximation and original value
let limit = Rational(numerator: 1, denominator: 33)
//: 3. Use Continued Fractions solver to find a solution
let approximation = ContinuedFractionsSolver.findApproximation(of: value,
                                                               differenceBelowOrEqual: limit)
print("Approximation for \(value) (limit: \(limit)): \(approximation)")
