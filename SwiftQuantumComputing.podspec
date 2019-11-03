Pod::Spec.new do |s|
  s.name         = "SwiftQuantumComputing"
  s.version      = "13.0.0"
  s.summary      = "A quantum circuit simulator."
  s.description  = <<-DESC
  A quantum circuit simulator written in Swift and speeded up with Accelerate.framework in iOS/macOS and BLAS in Linux. It also counts with a genetic algorithm to find a circuit that solves a given quantum problem.
                   DESC
  s.homepage     = "https://github.com/indisoluble/SwiftQuantumComputing"
  s.license      = "Apache License, Version 2.0"
  s.author       = { "Enrique de la Torre" => "indisoluble_dev@me.com" }

  s.ios.deployment_target = "11.4"
  s.osx.deployment_target = "10.13"
  
  s.source = { :git => "https://github.com/indisoluble/SwiftQuantumComputing.git", :tag => "#{s.version}" }

  s.source_files     = "Sources/SwiftQuantumComputing/**/*.swift"
  s.ios.source_files = "Sources/SwiftQuantumComputing_iOS/**/*.swift"
  s.osx.source_files = "Sources/SwiftQuantumComputing_macOS/**/*.swift"
  s.swift_version    = '5.0'

  s.ios.resources = "Sources/SwiftQuantumComputing_iOS/**/*.xib"
  s.osx.resources = "Sources/SwiftQuantumComputing_macOS/**/*.xib"

  s.frameworks = 'Accelerate'
end
