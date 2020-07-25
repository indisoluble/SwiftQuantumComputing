documentation:
	@jazzy \
		--clean \
		--build-tool-arguments -scheme,SwiftQuantumComputing_macOS \
		--no-hide-documentation-coverage \
		--theme fullwidth \
		--output ./docs \
		--documentation=./*.md
