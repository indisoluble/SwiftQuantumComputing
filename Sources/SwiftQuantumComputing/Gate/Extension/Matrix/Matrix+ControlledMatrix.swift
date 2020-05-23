//
//  Matrix+ControlledMatrix.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 04/03/2020.
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

    static func makeControlledMatrix(matrix: Matrix) -> Matrix {
        let quadRowCount = matrix.rowCount
        let rowCount = 2 * quadRowCount
        let quadColCount = matrix.columnCount
        let colCount = 2 * quadColCount
        return try! Matrix.makeMatrix(rowCount: rowCount, columnCount: colCount, value: { row, col in
            let quad = Quadrant(row: row,
                                column: col,
                                quadrantRowCount: quadRowCount,
                                quadrantColumnCount: quadColCount)
            switch quad {
            case .first(let quadRow, let quadCol):
                return (quadRow == quadCol ? Complex.one : Complex.zero)
            case .second:
                return Complex.zero
            case .third:
                return Complex.zero
            case .fourth(let quadRow, let quadCol):
                return matrix[quadRow, quadCol]
            }
        }).get()
    }
}

// MARK: - Private body

private extension Matrix {

    // MARK: - Private types

    enum Quadrant {
        case first(quadrantRow: Int, quadrantColumn: Int)
        case second(quadrantRow: Int, quadrantColumn: Int)
        case third(quadrantRow: Int, quadrantColumn: Int)
        case fourth(quadrantRow: Int, quadrantColumn: Int)

        init(row: Int, column: Int, quadrantRowCount: Int, quadrantColumnCount: Int) {
            if (row < quadrantRowCount) {
                if (column < quadrantColumnCount) {
                    self = .first(quadrantRow: row, quadrantColumn: column)
                } else {
                    self = .second(quadrantRow: row, quadrantColumn: column - quadrantColumnCount)
                }
            } else {
                if (column < quadrantColumnCount) {
                    self = .third(quadrantRow: row - quadrantRowCount, quadrantColumn: column)
                } else {
                    self = .fourth(quadrantRow: row - quadrantRowCount,
                                   quadrantColumn: column - quadrantColumnCount)
                }
            }
        }
    }
}
