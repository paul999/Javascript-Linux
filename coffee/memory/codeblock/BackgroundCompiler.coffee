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

class BackgroundCompiler
	constructor: (@immediate, @delayed) ->
		@COMPILER_QUEUE_SIZE = 256
		@COMPILE_REQUEST_THRESHOLD = 1024
		@compilerQueue = null

		@compilerQueue = new CompilerQueue(@COMPILER_QUEUE_SIZE);
	getProtectedModeCodeBlock: (source) ->
		log "got source" + source
		imm = @immediate.getProtectedModeCodeBlock(source)
		return new ProtectedModeCodeBlockWrapper(imm)

class CompilerQueue

	constructor: (size) ->
		@queue = new Array(size)

	addBlock: (block) ->

		for i in [0...@queue.length]
			if (!@queue[i] || @queue[i] == null)
				@queue[i] = block
				return true

		for i in [0...queue.length]
			if (block.executeCount > @queue.executeCount)
				@queue[i] = block
				return true
		return false

	getBlock: ->
		index = 0
		maxCount = 0

		for i in [0...@queue.length]
			if ((@queue[i] != null) && (@queue[i].executeCount > maxCount))
				maxCount = @queue[i].executeCount
				index = i

		block = @queue[index]
		queue[index] = null

		maxCount /= 2

		for i in [0...@queue.length]
			if (@queue[i] == null)
				continue
			if (@queue[i].executeCount <  maxCount)
				@queue[i] = null
		return block
