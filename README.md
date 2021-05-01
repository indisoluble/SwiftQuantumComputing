# Quantum circuit simulator in Swift

[![CI Status](https://github.com/indisoluble/SwiftQuantumComputing/workflows/build/badge.svg?branch=master)](https://github.com/indisoluble/SwiftQuantumComputing/actions?query=branch%3Amaster)
[![codecov](https://codecov.io/gh/indisoluble/SwiftQuantumComputing/branch/master/graph/badge.svg)](https://codecov.io/gh/indisoluble/SwiftQuantumComputing)
![platforms](https://img.shields.io/badge/platform-iOS%20%7C%20macOS%20%7C%20Linux-lightgrey.svg)
[![Documentation](https://indisoluble.github.io/SwiftQuantumComputing/badge.svg)](https://indisoluble.github.io/SwiftQuantumComputing)

## Usage

![Usage](https://raw.githubusercontent.com/indisoluble/SwiftQuantumComputing/master/Images/Usage.jpg)

Check code in [Circuit.playground](https://github.com/indisoluble/SwiftQuantumComputing/tree/master/Playground/Usage/Circuit.playground/Contents.swift).

## Algorithms

* Use a genetic algorithm to automatically generate a quantum circuit - Check example in [Genetic.playground](https://github.com/indisoluble/SwiftQuantumComputing/tree/master/Playground/Usage/Genetic.playground/Contents.swift).
* Two-level decomposition: Decompose any gate into an equivalent sequence of not gates and fully controlled phase shifts, z-rotations, y-rotations & not gates - Check example in [TwoLevelDecomposition.playground](https://github.com/indisoluble/SwiftQuantumComputing/tree/master/Playground/Usage/TwoLevelDecomposition.playground/Contents.swift).

## Other algorithms

* Euclidean Algorithm: Find greatest common divisor of two integers - Check example in [EuclideanAlgorithm.playground](https://github.com/indisoluble/SwiftQuantumComputing/tree/master/Playground/Usage/EuclideanAlgorithm.playground/Contents.swift).
* Continued Fractions: Find an approximation to a given rational number - Check example in [ContinuedFractions.playground](https://github.com/indisoluble/SwiftQuantumComputing/tree/master/Playground/Usage/ContinuedFractions.playground/Contents.swift).
* Gaussian Elimination: Solve a system of XOR equations - Check example in [XorGaussianElimination.playground](https://github.com/indisoluble/SwiftQuantumComputing/tree/master/Playground/Usage/XorGaussianElimination.playground/Contents.swift).

## More examples

* Bernstein–Vazirani algorithm - Check code in [BernsteinVaziraniAlgorithm.playground](https://github.com/indisoluble/SwiftQuantumComputing/tree/master/Playground/Example/BernsteinVaziraniAlgorithm.playground/Contents.swift).
* Deutsch's algorithm - Check code in [DeutschAlgorithm.playground](https://github.com/indisoluble/SwiftQuantumComputing/tree/master/Playground/Example/DeutschAlgorithm.playground/Contents.swift).
* Deutsch-Jozsa algorithm - Check code in [DeutschJozsaAlgorithm.playground](https://github.com/indisoluble/SwiftQuantumComputing/tree/master/Playground/Example/DeutschJozsaAlgorithm.playground/Contents.swift).
* Grover's algorithm - Check code in [GroverAlgorithm.playground](https://github.com/indisoluble/SwiftQuantumComputing/tree/master/Playground/Example/GroverAlgorithm.playground/Contents.swift).
* Shor's Algorithm - Check code in [ShorAlgorithm.playground](https://github.com/indisoluble/SwiftQuantumComputing/tree/master/Playground/Example/ShorAlgorithm.playground/Contents.swift).
* Simon's periodicity algorithm - Check code in [SimonPeriodicityAlgorithm.playground](https://github.com/indisoluble/SwiftQuantumComputing/tree/master/Playground/Example/SimonPeriodicityAlgorithm.playground/Contents.swift).

## Documentation

Documentation for the project can be found [here](https://indisoluble.github.io/SwiftQuantumComputing).

## References

* [Automatic Quantum Computer Programming: A Genetic Programming Approach](https://www.amazon.com/Automatic-Quantum-Computer-Programming-Approach/dp/038736496X)
* [Continued Fractions and the Euclidean Algorithm](https://www.math.u-bordeaux.fr/~pjaming/M1/exposes/MA2.pdf)
* [Decomposition of unitary matrices and quantum gates](https://arxiv.org/abs/1210.7366)
* [Decomposition of unitary matrix into quantum gates](https://github.com/fedimser/quantum_decomp/blob/master/res/Fedoriaka2019Decomposition.pdf)
* [IBM Qiskit](https://github.com/Qiskit/qiskit-terra)
* [qHiPSTER: The Quantum High Performance Software Testing Environment](https://arxiv.org/abs/1601.07195)
* [Quantum Computing for Computer Scientists](https://www.amazon.com/Quantum-Computing-Computer-Scientists-Yanofsky/dp/0521879965)
* [Shor's Quantum Factoring Algorithm](https://arxiv.org/abs/quant-ph/0010034)

## SwiftPM dependencies

* [CBLAS-Linux](https://github.com/indisoluble/CBLAS-Linux) (only for Linux)
* [Swift Argument Parser](https://github.com/apple/swift-argument-parser)
* [Swift Numerics](https://github.com/apple/swift-numerics)

### Linux

This package depends on [BLAS](http://www.netlib.org/blas/) if running on Linux, more exactly, [Ubuntu](https://www.ubuntu.com).

This dependency is reflected in `Package.swift` with [CBLAS-Linux](https://github.com/indisoluble/CBLAS-Linux), which in turn expects to find the following file: `/usr/include/x86_64-linux-gnu/cblas-netlib.h`. So, after installing [BLAS](http://www.netlib.org/blas/) (in case it is not already there):

```
sudo apt-get install libblas-dev
```

Check `cblas-netlib.h` is in the expected location.
