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
import os.log

// MARK: - Main body

struct BackendRegisterGateFactoryAdapter {

    // MARK: - Private properties

    private let qubitCount: Int

    // MARK: - Private class properties

    private static let logger = LoggerFactory.makeLogger()

    // MARK: - Internal init methods

    init(qubitCount: Int) {
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
    func makeGate(matrix: Matrix, inputs: [Int]) -> RegisterGate? {
        guard let factory = try? RegisterGateFactory(qubitCount: qubitCount, baseMatrix: matrix) else {
            os_log("makeGate failed: unable to build a gate factory",
                   log: BackendRegisterGateFactoryAdapter.logger,
                   type: .debug)

            return nil
        }

        return try? factory.makeGate(inputs: inputs)
    }
}
