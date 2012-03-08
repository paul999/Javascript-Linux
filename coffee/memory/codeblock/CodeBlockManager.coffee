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
		@Chain = new DefaultCodeBlockFactory(new ProtectedModeUDecoder(), new OptimisedCompiler(), @BLOCK_LIMIT)

		@bgc = new BackgroundCompiler(new OptimisedCompiler(), new CachedCodeBlockCompiler());

		@compilingChain = new DefaultCodeBlockFactory(new ProtectedModeUDecoder(), @bgc, @BLOCK_LIMIT);
	toString: () ->
		"CodeBlockManager"

	getCodeBlockAt: (offset, operandSize) ->
		block = null
		block = @tryFactory(@ModeChain,offset, operandSize)

		if (!block || block == null)
			block = @tryFactory(@Chain, offset, operandSize)

			if (!block || block == null)
				throw "Couldnt find capable block"
		return block

	tryFactory: (ff, offset, operandSizeFlag) ->
		try
			log "Got offset in try: #{offset}"
			@byteSource.set(offset)
			return ff.getCodeBlock(@byteSource, operandSizeFlag)
		catch e
			#orignal:
			#return new SpanningProtectedModeCodeBlock(new CodeBlockFactory[]{protectedModeChain});
			log e
			throw e
