import SwiftQuantumComputing // for macOS
//: 1. Define two integers
let a = 252
let b = 105
//: 2. Use Euclidean solver to find greatest common divisor of these integers
let gcd = EuclideanSolver.findGreatestCommonDivisor(a, b)
print("Greatest common divisor of \(a) & \(b): \(gcd)")
