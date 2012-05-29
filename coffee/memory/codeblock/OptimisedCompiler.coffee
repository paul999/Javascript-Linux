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

class OptimisedCompiler
	constructor: ->
		@bufferMicrocodes = new Array()
		@bufferPositions = new Array()
		@bufferOffset = 0

	getCodeBlock: (source) ->
		@buildCodeBlockBuffers(source)

#		arraycopy(@bufferMicrocodes, 0, newMicrocodes, 0, @bufferOffset)
#		arraycopy(@bufferPositions, 0, newPositions, 0, @bufferOffset)

		if (proc.isProtectedMode())
			return new ProtectedModeUBlock(@bufferMicrocodes, @bufferPositions)
		else
			return new RealModeUBlock(@bufferMicrocodes, @bufferPositions)

	buildCodeBlockBuffers: (source) ->
		@bufferOffset = 0
		@bufferMicrocodes = new Array()
		@bufferPositions = new Array()
		position = 0

		while (source.getNext())

			uCodeLength = source.getLength()
			uCodeX86Length = source.getX86Length()

			position += uCodeX86Length

			for i in [0...uCodeLength]
				data = source.getMicrocode()
				@bufferMicrocodes[@bufferOffset] = data
				@bufferPositions[@bufferOffset] = position
				@bufferOffset++
