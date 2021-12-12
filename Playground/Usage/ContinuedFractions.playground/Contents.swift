import SwiftQuantumComputing // for macOS
//: 1. Define rational value to approximate
let value = try Rational(numerator: 15, denominator: 11)
//: 2. And a limit or maximum difference between approximation and original value
let limit = try Rational(numerator: 1, denominator: 33)
//: 3. Use Continued Fractions solver to find a solution
let approximation = try ContinuedFractionsSolver.findApproximation(of: value,
                                                                   differenceBelowOrEqual: limit).get()
print("Approximation for \(value) (limit: \(limit)): \(approximation)")
