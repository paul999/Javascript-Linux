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
		@source = null
		@offset = null
		@startingPosition = null

	set: (@source, @offset) ->
		@startingPosition = @offset

	getOffset: ->
		return @offset

	getByte: ->

		tmp = @source.getByte(@offset)
		@offset++

		if (!tmp && tmp != 0)
			throw new LengthIncorrectError("getByte has been undefined, source: #{@source}, data: #{tmp}, source #{@source}")


		return tmp

	skip: (count) ->
		if (@offset + count >= @source.getSize())
			throw new "Out of bound"

		@offset += count

	reset: ->
		@offset = @startingPosition

	toString: ->
		return "ByteSourceWrappedMemory: [" + @source + "] @ 0x" + @startingPosition