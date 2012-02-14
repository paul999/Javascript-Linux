all: build test minify

build:
	coffee -l -c -j emulator.js -o src/ coffee/*.coffee

test:
	coffeelint -f coffee/lint.json coffee/*.coffee

minify:
	coffee -l -c -o src/ coffee/*.coffee
	java -jar ../compiler-latest/compiler.jar --js=src/emulator.js --js_output_file=src/emulator-min.js
