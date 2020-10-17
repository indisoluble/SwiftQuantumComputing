//
//  Complex+Matrix.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 17/07/2020.
//  Copyright © 2020 Enrique de la Torre. All rights reserved.
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

import ComplexModule
import Foundation

// MARK: - Main body

extension Complex where RealType == Double {

    // MARK: - Internal init methods

    enum InitError: Error {
        case use1x1Matrix
    }

    init(_ matrix: Matrix) throws {
        guard ((matrix.rowCount == 1) && (matrix.columnCount == 1)) else {
            throw InitError.use1x1Matrix
        }

        let complex = matrix.first

        self.init(complex.real, complex.imaginary)
    }
}
