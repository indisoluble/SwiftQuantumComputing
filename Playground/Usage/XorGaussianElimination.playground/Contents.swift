import SwiftQuantumComputing // for macOS
//: 1. Define system of XOR equations:
//:    * `x6 ^      x4 ^      x2 ^ x1      = 0`
//:    * `          x4 ^                x0 = 0`
//:    * `x6 ^ x5 ^           x2 ^      x0 = 0`
//:    * `          x4 ^ x3 ^      x1 ^ x0 = 0`
//:    * `     x5 ^      x3 ^           x0 = 0`
//:    * `          x4 ^ x3 ^      x1      = 0`
//:    * `     x5 ^ x4 ^      x2 ^ x1 ^ x0 = 0`
let equations = [
    "1010110",
    "0010001",
    "1100101",
    "0011011",
    "0101001",
    "0011010",
    "0110111"
]
//: 2. Build Gaussian elimination solver
let solver = MainXorGaussianEliminationSolverFactory().makeSolver()
//: 3. Use solver
print("Solutions: \(solver.findActivatedVariablesInEquations(equations))")
