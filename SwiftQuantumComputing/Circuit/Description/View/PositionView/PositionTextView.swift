//
//  PositionTextView.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 07/10/2018.
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

class PositionTextView: PositionView {

    // MARK: - Outlets

    #if os(macOS)
    @IBOutlet weak var label: NSTextField!
    #else
    @IBOutlet weak var label: UILabel!
    #endif

    // MARK: - Public methods

    func showInputs(_ inputs: [Int]) {
        showText("U(\(inputs.map { String($0) }.joined(separator: ",")))")
    }

    func showRadians(_ radians: Double) {
        showText(String(format: "R(%.2f)", radians))
    }

    func showIndex(_ index: Int) {
        showText("q\(index) : |0>")
    }
}

// MARK: - Private body

private extension PositionTextView {

    // MARK: - Private methods

    func showText(_ text: String) {
        #if os(macOS)
        label.stringValue = text
        #else
        label.text = text
        #endif
    }
}
