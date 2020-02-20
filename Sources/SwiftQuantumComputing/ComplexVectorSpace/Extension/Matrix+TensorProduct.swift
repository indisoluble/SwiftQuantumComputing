//
//  Matrix+TensorProduct.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 16/02/2020.
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

import Foundation

// MARK: - Main body

extension Matrix {

    // MARK: - Internal class methods

    static func tensorProduct(_ lhs: Matrix, _ rhs: Matrix) -> Matrix {
        let rowCount = (lhs.rowCount * rhs.rowCount)
        let columnCount = (lhs.columnCount * rhs.columnCount)

        return try! Matrix.makeMatrix(rowCount: rowCount, columnCount: columnCount) { (row, column) -> Complex in
            let lhsColumn = (column / rhs.columnCount)
            let lhsRow = (row / rhs.rowCount)

            let rhsColumn = (column % rhs.columnCount)
            let rhsRow = (row % rhs.rowCount)

            return lhs[lhsRow,lhsColumn] * rhs[rhsRow,rhsColumn]
        }
    }
}
