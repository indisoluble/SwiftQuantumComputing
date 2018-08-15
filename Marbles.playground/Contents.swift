import SwiftQuantumComputing

func execute(initialState: Vector, graph: Matrix, times: Int) -> Vector? {
    let accuracy = 0.001

    guard (abs(initialState.squaredNorm - Double(1)) <= accuracy) else {
        print("Sum of the squared modulus of \(initialState) is not 1")

        return nil
    }

    guard graph.isUnitary(accuracy: accuracy) else {
        print("\(graph) is not unitary")

        return nil
    }

    let clicks = Array(repeating: graph, count: times)
    return clicks.reduce(initialState) { (state: Vector?, matrix: Matrix) -> Vector? in
        guard let state = state else {
            return nil
        }

        guard let nextState = (matrix * state) else {
            print("\(matrix) * \(state) return nil")

            return nil
        }

        return nextState
    }
}

let value = (1 / sqrt(2))
let graphElements = [
    [Complex(real: value, imag: 0), Complex(real: value, imag: 0), Complex(real: 0, imag: 0)],
    [Complex(real: 0, imag: -value), Complex(real: 0, imag: value), Complex(real: 0, imag: 0)],
    [Complex(real: 0, imag: 0), Complex(real: 0, imag: 0), Complex(real: 0, imag: 1)]
]
let graph = Matrix(graphElements)!
print("graph:")
print(graph)

let initialStateElements = [
    Complex(real: (1 / sqrt(3)), imag: 0),
    Complex(real: 0, imag: (2 / sqrt(15))),
    Complex(real: sqrt(2 / 5), imag: 0)
]
let initialState = Vector(initialStateElements)!
print("initialState:")
print(initialState)

let result = execute(initialState: initialState, graph: graph, times: 1)
print("result:")
print(result ?? "nil")

let expectedElements = [
    Complex(real: (1 / sqrt(6)), imag: (2 / sqrt(30))),
    Complex(real: -(2 / sqrt(30)), imag: -sqrt(5 / 30)),
    Complex(real: 0, imag: sqrt(2 / 5))
]
let expectedResult = Vector(expectedElements)!
print("expectedResult:")
print(expectedResult)
