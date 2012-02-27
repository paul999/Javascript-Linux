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

class CodeBlockManager
	constructor: ->
		log "CodeBlockManager start"

		@BLOCK_LIMIT = 1000
		@protectedModeChain = null
		@compilingProtectedModeChain = null
		@byteSource = null
		@bgc = null

		@byteSource = new ByteSourceWrappedMemory()
		@protectedModeChain = new DefaultCodeBlockFactory(new ProtectedModeUDecoder(), new OptimisedCompiler(), @BLOCK_LIMIT)

		@bgc = new BackgroundCompiler(new OptimisedCompiler(), new CachedCodeBlockCompiler());

		@compilingProtectedModeChain = new DefaultCodeBlockFactory(new ProtectedModeUDecoder(), @bgc, @BLOCK_LIMIT);
	toString: () ->
		"CodeBlockManager"

	getProtectedModeCodeBlockAt: (memory, offset, operandSize) ->
		block = null
		block = @tryProtectedModeFactory(@compilingProtectedModeChain,memory, offset, operandSize)

		if (!block || block == null)
			block = @tryProtectedModeFactory(@protectedModeChain, memory, offset, operandSize)

			if (!block || block == null)
				throw "Couldnt find capable block"
		return block

	tryProtectedModeFactory: (ff, memory, offset, operandSizeFlag) ->

		try
			@byteSource.set(memory, offset)
			log "Set source: " + @byteSource
			return ff.getProtectedModeCodeBlock(@byteSource, operandSizeFlag)
		catch e
			#orignal:
			#return new SpanningProtectedModeCodeBlock(new CodeBlockFactory[]{protectedModeChain});
			log e
			throw e
