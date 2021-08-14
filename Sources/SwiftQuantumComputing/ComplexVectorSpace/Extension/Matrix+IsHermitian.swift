//
//  Matrix+IsHermitian.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 05/07/2021.
//  Copyright © 2021 Enrique de la Torre. All rights reserved.
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

extension Matrix {

    // MARK: - Internal properties

    var isHermitian: Bool {
        guard isSquare else {
            return false
        }

        for row in 0..<rowCount {
            for column in row..<columnCount {
                if !self[row, column].isApproximatelyEqual(to: self[column, row].conjugate,
                                                           absoluteTolerance: SharedConstants.tolerance) {
                    return false
                }
            }
        }

        return true
    }
}
