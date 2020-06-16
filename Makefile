documentation:
	@jazzy \
		--module DMSwift \
		--swift-build-tool spm \
		--build-tool-arguments -Xswiftc,-swift-version,-Xswiftc,5
	@rm -rf ./build