bootstrap:  prepare install

prepare:
	brew update
	brew install carthage

# installation
install: carthage_update

carthage_update:
	carthage update --platform iOS --cache-builds
