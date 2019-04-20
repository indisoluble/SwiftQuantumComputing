//
//  BackendRegisterGateFactoryAdapter.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 22/08/2018.
//  Copyright © 2018 Enrique de la Torre. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation

// MARK: - Main body

struct BackendRegisterGateFactoryAdapter {

    // MARK: - Private properties

    private let qubitCount: Int

    // MARK: - Internal init methods

    enum InitError: Error {
        case qubitCountHasToBeBiggerThanZero
    }

    init(qubitCount: Int) throws {
        guard qubitCount > 0 else {
            throw InitError.qubitCountHasToBeBiggerThanZero
        }

        self.qubitCount = qubitCount
    }
}

// MARK: - Equatable methods

extension BackendRegisterGateFactoryAdapter: Equatable {
    static func ==(lhs: BackendRegisterGateFactoryAdapter,
                   rhs: BackendRegisterGateFactoryAdapter) -> Bool {
        return (lhs.qubitCount == rhs.qubitCount)
    }
}

// MARK: - BackendRegisterGateFactory methods

extension BackendRegisterGateFactoryAdapter: BackendRegisterGateFactory {
    func makeGate(matrix: Matrix, inputs: [Int]) throws -> RegisterGate {
        var factory: RegisterGateFactory!
        do {
            factory = try RegisterGateFactory(qubitCount: qubitCount, baseMatrix: matrix)
        } catch RegisterGateFactory.InitError.matrixIsNotSquare {
            throw BackendRegisterGateFactoryMakeGateError.matrixIsNotSquare
        } catch RegisterGateFactory.InitError.matrixRowCountHasToBeAPowerOfTwo {
            throw BackendRegisterGateFactoryMakeGateError.matrixRowCountHasToBeAPowerOfTwo
        } catch RegisterGateFactory.InitError.matrixHandlesMoreQubitsThanAreAvailable {
            throw BackendRegisterGateFactoryMakeGateError.matrixHandlesMoreQubitsThanAreAvailable
        } catch {
            fatalError("Unexpected error: \(error).")
        }

        do {
            return try factory.makeGate(inputs: inputs)
        } catch RegisterGateFactory.MakeGateError.inputCountDoesNotMatchBaseMatrixQubitCount {
            throw BackendRegisterGateFactoryMakeGateError.inputCountDoesNotMatchMatrixQubitCount
        } catch RegisterGateFactory.MakeGateError.inputsAreNotUnique {
            throw BackendRegisterGateFactoryMakeGateError.inputsAreNotUnique
        } catch RegisterGateFactory.MakeGateError.inputsAreNotInBound {
            throw BackendRegisterGateFactoryMakeGateError.inputsAreNotInBound
        } catch RegisterGateFactory.MakeGateError.gateIsNotUnitary {
            throw BackendRegisterGateFactoryMakeGateError.gateIsNotUnitary
        } catch {
            fatalError("Unexpected error: \(error).")
        }
    }
}
