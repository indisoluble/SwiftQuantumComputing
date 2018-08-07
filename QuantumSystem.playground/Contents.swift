import SwiftQuantumComputing

func likelihoodOfFindingAParticle(at index: Int, with ket: Vector) -> Double {
    return ket.normalized()[index].squaredModulus
}

func transitionAmplitude(from first: Vector, to second: Vector) -> Complex? {
    return Vector.innerProduct(second.normalized(), first.normalized())
}

func probabilityOfTransitioning(from first: Vector, to second: Vector) -> Double? {
    return transitionAmplitude(from: first, to: second)?.squaredModulus
}

func mean(of observable: Matrix, on state: Vector) -> Double? {
    guard observable.isHermitian else {
        print("\(observable) is not hermitian")

        return nil
    }

    guard let lhs = (observable * state) else {
        print("\(observable) & \(state) are not multipliable")

        return nil
    }

    return Vector.innerProduct(lhs, state)?.real
}

func variance(of observable: Matrix, on state: Vector) -> Double? {
    guard let meanValue = mean(of: observable, on: state) else {
        return nil
    }

    let identity = Matrix.makeIdentity(count: observable.rowCount)!
    let negativeMean = -(Complex(meanValue) * identity)
    let subtractedMean = (observable + negativeMean)!
    let squared = (subtractedMean * subtractedMean)!

    return mean(of: squared, on: state)
}

func evolveState(_ state: Vector, with unitaries: [Matrix]) -> Vector? {
    return unitaries.reduce(state) { (partial, unitary) -> Vector? in
        guard let partial = partial else {
            return nil
        }

        guard unitary.isUnitary(accuracy: 0.001) else {
            print("Matrix \(unitary) is not unitary")

            return nil
        }

        return (unitary * partial)
    }
}

let elements = [
    Complex(real: -3, imag: -1),
    Complex(real: 0, imag: -2),
    Complex(real: 0, imag: 1),
    Complex(real: 2, imag: 0)
]
let ket = Vector(elements)!
print("ket:")
print(ket)

let likelihood = likelihoodOfFindingAParticle(at: 2, with: ket)
print("likelihood: \(likelihood)")

let first = Vector([Complex(real: 1, imag: 0), Complex(real: 0, imag: -1)])!
print("first:")
print(first)

let second = Vector([Complex(real: 0, imag: 1), Complex(real: 1, imag: 0)])!
print("second:")
print(second)

let probability = probabilityOfTransitioning(from: first, to: second)!
print("probability: \(probability)")

let observable = Matrix([[Complex(real: 1, imag: 0), Complex(real: 0, imag: -1)],
                         [Complex(real: 0, imag: 1), Complex(real: 2, imag: 0)]])!
print("observable:")
print(observable)

let state = Vector([Complex(real: (sqrt(2) / 2), imag: 0), Complex(real: 0, imag: (sqrt(2) / 2))])!
print("state:")
print(state)

let meanValue = mean(of: observable, on: state)!
print("mean: \(meanValue)")

let varianceValue = variance(of: observable, on: state)!
print("variance: \(varianceValue)")

let eigens = observable.hermitianEigens()!
for (eigenvalue, eigenvector) in eigens {
    print("eigenvalue: \(eigenvalue)")
    print("eigenvector:")
    print(eigenvector)

    let probabilityEigen = probabilityOfTransitioning(from: state, to: eigenvector)!
    print("probability transition to eigenvector: \(probabilityEigen)")
}

let value = (sqrt(2) / 2)
let unitaries = [Matrix([[Complex(0), Complex(1)], [Complex(1), Complex(0)]])!,
                 Matrix([[Complex(value), Complex(value)], [Complex(value), Complex(-value)]])!]
print("unitaries:")
print(unitaries)

let evolved = evolveState(state, with: unitaries)!
print("evolved state:")
print(evolved)
