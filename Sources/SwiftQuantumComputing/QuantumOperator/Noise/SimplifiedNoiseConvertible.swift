//
//  SimplifiedNoiseConvertible.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 14/09/2021.
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

// MARK: - Public types

/// Simplified representation of a quantum noise operator. Use to easily identify the type of a quantum noise and its components
public enum SimplifiedNoise {}

// MARK: - Hashable methods

extension SimplifiedNoise: Hashable {}

// MARK: - Protocol definition

/// A type with a simplified representation of a noise operator
public protocol SimplifiedNoiseConvertible {
    /// Simplified representation of the noise operator
    var simplified: SimplifiedNoise { get }
}
