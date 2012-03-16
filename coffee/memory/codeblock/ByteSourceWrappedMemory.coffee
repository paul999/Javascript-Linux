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

class ByteSourceWrappedMemory
	constructor: ->
		@offset = null
		@startingPosition = null

	set: (@offset) ->
		@startingPosition = @offset

		if (@startingPosition == 18286)
			throw new LengthIncorrectError('0x8')

	getOffset: ->
		return @offset

	getByte: ->

		tmp = window.pc.getMemoryOffset(8, @offset)
		@offset++

#		log "New offset: #{@offset}, start #{@startingPosition}, returned: #{tmp}"

		if (!tmp && tmp != 0)
			throw new LengthIncorrectError("getByte has been undefined, data: #{tmp}")


		return tmp

	skip: (count) ->
		if (@offset + count >= window.pc.getMemorySize())
			throw new MemoryOutOfBound()

		@offset += count

	reset: ->
		@offset = @startingPosition

	toString: ->
		if (@startingPosition == 18286)
			throw new LengthIncorrectError('0x8')

		return "ByteSourceWrappedMemory @ " + @startingPosition
