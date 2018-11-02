//
//  PositionView.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 16/09/2018.
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

class PositionView: SQCView {

    // MARK: - Init methods

    override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }
}

// MARK: - Private body

private extension PositionView {

    // MARK: - Private methods

    func commonInit() {
        let packageName = NSStringFromClass(type(of: self))
        let className = packageName.split(separator: ".").last!

        let bundle = Bundle(for: type(of: self))

        #if os(macOS)
        var objects: NSArray?
        bundle.loadNibNamed(String(className), owner: self, topLevelObjects: &objects)

        let nib = objects!
        #else
        let nib = bundle.loadNibNamed(String(className), owner: self, options: nil)!
        #endif

        let view = nib.filter { $0 is SQCView }.first as! SQCView

        addSubview(view)

        view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        view.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
    }
}
