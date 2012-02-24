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
#		@byteSource = new ByteSourceWrappedMemory()
#		@protectedModeChain = new DefaultCodeBlockFactory(new ProtectedModeUDecoder(), new OptimisedCompiler(), BLOCK_LIMIT)

#		@bgc = new BackgroundCompiler(new OptimisedCompiler(), new CachedCodeBlockCompiler());

#		@compilingProtectedModeChain = new DefaultCodeBlockFactory(new ProtectedModeUDecoder(), @bgc, 1000);
	toString: () ->
		"CodeBlockManager"
	initialised: ->
		return true
