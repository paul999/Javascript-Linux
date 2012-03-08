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

class DefaultCodeBlockFactory
	constructor: (@decoder, @compiler, @limit) ->

	getCodeBlock: (source, operandSize) ->
		log "Got source in factory: " + source + " decoded: " + @decoder
		return @compiler.getCodeBlock(@decoder.decodeProtected(source, operandSize, @limit))
