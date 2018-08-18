import SwiftQuantumComputing

func isFunctionConstant(_ uf: Matrix) -> Bool {
    let qubitCount = 2

    let not = NotGate(qubitCount: qubitCount)!
    let hadamard = HadamardGate(qubitCount: qubitCount)!
    let oracle = RegisterGateFactory(qubitCount: qubitCount, baseMatrix: uf)!

    var register = Register(qubitCount: qubitCount)!
    register = try! not.apply(to: register, target: 0)
    register = try! hadamard.apply(to: register, target: 1)
    register = try! hadamard.apply(to: register, target: 0)
    register = register.applying(oracle.makeGate(inputs: 1, 0)!)!
    register = try! hadamard.apply(to: register, target: 1)

    let measure = register.measure(qubits: 1)!

    return (abs(1 - measure[0]) < 0.001)
}

print("Function: (f(0) = 0, f(1) = 0)")
let f1 = Matrix([[Complex(1), Complex(0), Complex(0), Complex(0)],
                 [Complex(0), Complex(1), Complex(0), Complex(0)],
                 [Complex(0), Complex(0), Complex(1), Complex(0)],
                 [Complex(0), Complex(0), Complex(0), Complex(1)]])!
print("Matrix:")
print(f1)
print("Is it constant? \(isFunctionConstant(f1))")
print()

print("Function: (f(0) = 1, f(1) = 1)")
let f2 = Matrix([[Complex(0), Complex(1), Complex(0), Complex(0)],
                 [Complex(1), Complex(0), Complex(0), Complex(0)],
                 [Complex(0), Complex(0), Complex(0), Complex(1)],
                 [Complex(0), Complex(0), Complex(1), Complex(0)]])!
print("Matrix:")
print(f2)
print("Is it constant? \(isFunctionConstant(f2))")
print()

print("Function: (f(0) = 1, f(1) = 0)")
let f3 = Matrix([[Complex(0), Complex(1), Complex(0), Complex(0)],
                 [Complex(1), Complex(0), Complex(0), Complex(0)],
                 [Complex(0), Complex(0), Complex(1), Complex(0)],
                 [Complex(0), Complex(0), Complex(0), Complex(1)]])!
print("Matrix:")
print(f3)
print("Is it constant? \(isFunctionConstant(f3))")
print()

print("Function: (f(0) = 0, f(1) = 1)")
let f4 = Matrix([[Complex(1), Complex(0), Complex(0), Complex(0)],
                 [Complex(0), Complex(1), Complex(0), Complex(0)],
                 [Complex(0), Complex(0), Complex(0), Complex(1)],
                 [Complex(0), Complex(0), Complex(1), Complex(0)]])!
print("Matrix:")
print(f4)
print("Is it constant? \(isFunctionConstant(f4))")
print()
