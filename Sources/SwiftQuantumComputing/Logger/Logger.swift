//
//  Logger.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 16/06/2019.
//  Copyright © 2019 Enrique de la Torre. All rights reserved.
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

#if !os(Linux)

import os.log

#endif

// MARK: - Main body

struct Logger {

    // MARK: - Private properties

    #if !os(Linux)

    private let logger: OSLog

    #endif

    // MARK: - Internal init methods

    init(filepath: String = #file) {
        #if !os(Linux)

        let filename = (filepath as NSString).lastPathComponent
        let category = (filename as NSString).deletingPathExtension

        logger = OSLog(subsystem: Constants.subsystem, category: category)

        #endif
    }

    // MARK: - Internal methods

    func debug(_ message: String) {
        #if os(Linux)
        debugPrint(message)
        #else
        os_log("%@", log: logger, type: .debug, message)
        #endif
    }

    func info(_ message: String) {
        #if os(Linux)
        debugPrint(message)
        #else
        os_log("%@", log: logger, type: .info, message)
        #endif
    }
}

// MARK: - Private body

private extension Logger {

    // MARK: - Constants

    enum Constants {
        static let subsystem = "com.indisoluble.SwiftQuantumComputing"
    }
}
