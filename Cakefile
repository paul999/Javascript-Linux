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

# Code from the Cakefile is based on https://raw.github.com/krismolendyke/InstantJasmineCoffee/master/Cakefile
fs     = require 'fs'
{exec} = require 'child_process'
util   = require 'util'
coffee = require 'coffee-script'

SrcCoffeeDir     = 'coffee'

TargetJsDir      = 'src'

TargetFileName   = 'emulator'
TargetCoffeeFile = "#{TargetJsDir}/#{TargetFileName}.coffee"
TargetJsFile     = "#{TargetJsDir}/#{TargetFileName}.js"
TargetJsMinFile  = "#{TargetJsDir}/#{TargetFileName}.min.js"

CoffeeOpts = " --output #{TargetJsDir} --compile #{TargetCoffeeFile}"

#CoffeeFiles = [
#    'memory/codeblock/CodeBlockManager'
#    'memory/AbstractMemory'
#    'memory/AddressSpace'
#    'memory/LazyCodeBlockMemory'
#    'memory/LinearAddressSpace'
#    'memory/PhysicalAddressSpace'
#    'motherboard/DMAController'
#    'motherboard/InterruptController'
#    'motherboard/IntervalTimer'
#    'motherboard/IOPortHandler'
#    'motherboard/RTC'
#    'processor/ProcessorException'
#    'processor/processor'
#    'general'
#    'pc'
#    'test'
#]


header = """
/**
 * A JavaScript x86 emulator
 * Some of the code based on:
 *	JPC: A x86 PC Hardware Emulator for a pure Java Virtual Machine
 *	Release Version 2.0
 *
 *	A project from the Physics Dept, The University of Oxford
 *
 *	Copyright (C) 2007-2009 Isis Innovation Limited
 *
 * Javascript version written by Paul Sohier, 2012
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as published by
 * the Free Software Foundation.
 **/

"""

task 'watchugly', 'Watch source files and build + minify changes', ->
	invoke 'buildugly'
	util.log "Watching for changes in #{SrcCoffeeDir}"
	exec "cat coffee/files.txt", (err, stdout, stderr) ->
		handleError(err) if err
		handleError(stderr) if stderr
		cf = stdout.split("\n")
		util.log "Found #{cf.length} files"

		cf = stdout.split("\n")
		for file in cf then do (file) ->
			fs.watchFile "#{SrcCoffeeDir}/#{file}.coffee", (curr, prev) ->
				if +curr.mtime isnt +prev.mtime
					util.log "Saw change in #{SrcCoffeeDir}/#{file}.coffee"
					invoke 'buildugly'

task 'watch', 'Watch source files and build changes', ->
	invoke 'build'
	util.log "Watching for changes in #{SrcCoffeeDir}"

	exec "cat coffee/files.txt", (err, stdout, stderr) ->
		handleError(err) if err
		handleError(stderr) if stderr
		cf = stdout.split("\n")

		util.log "Found #{cf.length} files"
		for file in cf then do (file) ->
			fs.watchFile "#{SrcCoffeeDir}/#{file}.coffee", (curr, prev) ->
				if +curr.mtime isnt +prev.mtime
					util.log "Saw change in #{SrcCoffeeDir}/#{file}.coffee"
					invoke 'build'

task 'buildugly', 'Build a single JavaScript file from src files and minify them', ->
	invoke 'build'
	invoke 'uglify'

task 'build', 'Build a single JavaScript file from src files', ->
	util.log "Building #{TargetJsFile}"

	exec "cat coffee/files.txt", (err, stdout, stderr) ->
		handleError(err) if err
		handleError(stderr) if stderr
		cf = stdout.split("\n")

		appContents = new Array
		remaining = cf.length
		util.log "Appending #{cf.length} files to #{TargetCoffeeFile}"

		for file, index in cf then do (file, index) ->
			if (file != "")
				fs.readFile "#{SrcCoffeeDir}/#{file}.coffee"
						  , 'utf8'
						  , (err, fileContents) ->
					handleError(err) if err

					appContents[index] = "#Start file: #{file}\n\n" + fileContents + "#end file: #{file}\n\n"
					util.log "[#{index + 1}] #{file}.coffee"
					process() if --remaining is 0
			else
				process() if --remaining is 0

		process = ->
			fs.writeFile TargetCoffeeFile
					   , appContents.join('\n\n')
					   , 'utf8'
					   , (err) ->
				handleError(err) if err

				exec "coffee #{CoffeeOpts}", (err, stdout, stderr) ->
					handleError(err) if err
					message = "Compiled #{TargetJsFile}"
					displayNotification message
					util.log message
	#				fs.unlink TargetCoffeeFile, (err) -> handleError(err) if err

					addHeader TargetJsFile
task 'uglify', 'Minify and obfuscate', ->
	#Compiler: http://code.google.com/closure/compiler/
	exec "java -jar ../compiler-latest/compiler.jar --language_in=ECMASCRIPT5_STRICT --compilation_level=ADVANCED_OPTIMIZATIONS --manage_closure_dependencies --js=src/emulator.js --js_output_file=src/emulator-min.js", (err, stdout, stderr) ->
		handleError(err) if err
		addHeader "src/emulator-min.js"
		util.log stdout
		util.log stderr
		util.log "Minified emulator.js"
		displayNotification "Minified emulator.js"

coffee = (options = "", file) ->
    util.log "Compiling #{file}"
    exec "coffee #{options} -c #{file}", (err, stdout, stderr) ->
        handleError(err) if err

addHeader = (file) ->
	fs.readFile "#{file}"
			, 'utf8'
			, (err, fileContents) ->
		handleError(err) if err

		util.log "Write #{file} with new header"

		nw = header + fileContents

		fs.unlink file, (err) -> handleError(err) if err

		fs.writeFile file
				, nw
				, 'utf8'
				, (err) ->
			handleError(err) if err

handleError = (error) ->
    util.log error
    displayNotification error

displayNotification = (message = '') ->
    options = {
        title: 'Compileresult'
    }
    try
	    growl = require('growl')
	    growl(message, options)
