# A JavaScript x86 emulator
# Some of the code based on:
#	JPC: A x86 PC Hardware Emulator for a pure Java Virtual Machine
#	Release Version 2.0
#
#	A project from the Physics Dept, The University of Oxford
#
#	Copyright (C) 2007-2009 Isis Innovation Limited
#
# Javascript version written by Paul Sohier, 2012
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2 as published by
# the Free Software Foundation.

all: test build

clean:
	rm src/*.js

build:
	coffee -l -b -c -j pc.js -o src/ coffee/*.coffee
	coffee -l -b -c -j motherboard.js -o src/ coffee/motherboard/*.coffee
	coffee -l -b -c -j memory.js -o src/ coffee/memory/*
	coffee -l -b -c -j processor.js -o src/ coffee/processor/*

test:
	coffeelint -f coffee/lint.json coffee/*.coffee
	coffeelint -f coffee/lint.json coffee/motherboard/*.coffee
	coffeelint -f coffee/lint.json coffee/memory/*.coffee
	coffeelint -f coffee/lint.json coffee/processor/*.coffee

minify: test build
	java -jar ../compiler-latest/compiler.jar --output_manifest=src/out --create_source_map=src/src --language_in=ECMASCRIPT5_STRICT --compilation_level=ADVANCED_OPTIMIZATIONS --manage_closure_dependencies --js=src/memory.js --js=src/motherboard.js --js=src/processor.js --js=src/pc.js --js_output_file=src/emulator-min.js
