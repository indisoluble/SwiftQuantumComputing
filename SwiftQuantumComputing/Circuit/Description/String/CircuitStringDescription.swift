//
//  CircuitStringDescription.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 05/09/2018.
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

struct CircuitStringDescription {

    // MARK: - Public properties

    let description: String

    // MARK: - Init methods

    init() {
        self.init(description: "")
    }

    private init(description: String) {
        self.description = description
    }
}

// MARK: - CustomPlaygroundDisplayConvertible methods

extension CircuitStringDescription: CustomPlaygroundDisplayConvertible {
    var playgroundDescription: Any {
        return description
    }
}

// MARK: - CircuitDescription methods

extension CircuitStringDescription: CircuitDescription {
    func applyingDescriber(_ describer: CircuitGateDescribable,
                           inputs: [Int]) -> CircuitStringDescription {
        let gateDescription = describer.gateDescription(with: inputs).toString()
        let next = (description.isEmpty ? gateDescription : description + "\n" + gateDescription)

        return CircuitStringDescription(description: next)
    }
}
