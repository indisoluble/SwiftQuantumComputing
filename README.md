# A quantum circuit simulator in Swift

[![CI Status](https://travis-ci.org/indisoluble/SwiftQuantumComputing.svg)](https://travis-ci.org/indisoluble/SwiftQuantumComputing)
[![codecov.io](https://codecov.io/github/indisoluble/SwiftQuantumComputing/coverage.svg)](https://codecov.io/github/indisoluble/SwiftQuantumComputing)
[![Version](https://img.shields.io/cocoapods/v/SwiftQuantumComputing.svg)](http://cocoapods.org/pods/SwiftQuantumComputing)
![platforms](https://img.shields.io/badge/platform-iOS%20%7C%20macOS%20%7C%20Linux-lightgrey.svg)

In this repository you can find a quantum circuit simulator written in Swift and speeded up with [Accelerate.framework](https://developer.apple.com/documentation/accelerate) in iOS/macOS and [BLAS](http://www.netlib.org/blas/) in Linux. Along side the simulator there is also a genetic algorithm to automatically generate circuits able to solve a given quantum problem.

The code written so far is mostly based on the content of: [Quantum Computing for Computer Scientists](https://www.amazon.com/Quantum-Computing-Computer-Scientists-Yanofsky/dp/0521879965), with a few tips from [Automatic Quantum Computer Programming: A Genetic Programming Approach](https://www.amazon.com/Automatic-Quantum-Computer-Programming-Approach/dp/038736496X). It is also inspired by [IBM Qiskit](https://github.com/Qiskit/qiskit-terra).

## Usage

To create a circuit gate by gate:

![Deutsch's Algorithm](https://raw.githubusercontent.com/indisoluble/SwiftQuantumComputing/master/Images/DeutschAlgorithm.jpg)

Check `DeutschAlgorithm.playground` for the actual code.

Previous playground shows how to produce a statevector for a given circuit. To get the unitary matrix that represents a circuit:

![Unitary matrix for a circuit](https://raw.githubusercontent.com/indisoluble/SwiftQuantumComputing/master/Images/Unitary.jpg)

Full code is in `Unitary.playground`.

Or check `Genetic.playground` to see how to configure the genetic algorithm to produce a quantum circuit:

![Circuit generated with a genetic algorithm](https://raw.githubusercontent.com/indisoluble/SwiftQuantumComputing/master/Images/Genetic.jpg)

### Linux

As mentioned above, this package depends on [BLAS](http://www.netlib.org/blas/) if running on Linux, more exactly, [Ubuntu](https://www.ubuntu.com).

This dependency is reflected in `Package.swift` with [CBLAS-Linux](https://github.com/indisoluble/CBLAS-Linux), which in turn expects to find the following file: `/usr/include/x86_64-linux-gnu/cblas-netlib.h`. So, after installing [BLAS](http://www.netlib.org/blas/) (in case it is not already there):

```
sudo apt-get install libblas-dev
```

Check `cblas-netlib.h` is in the expected location.
