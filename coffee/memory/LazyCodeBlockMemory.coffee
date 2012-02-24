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

class LazyCodeBlockMemory extends AbstractMemory
	constructor: (@size, manager) ->
		super
		@PLACEHOLDER = null#new BlankCodeBlock()
		@realCodeBuffer = new Array()
		@protectedCodeBuffer = new Array()
		@ALLOCATION_THRESHOLD = 10
		@buffer = new Int32Array()
		@nullReadCount = 0


	toString: () ->
		"LazyCodeBlockMemory"

	getSize: ->
		return 4096
	initialised: ->
		return true

	copyArrayIntoContents: (address, buf, offset, len) ->
		try
			@buffer = arraycopy(buf, offset, @buffer, address, len)
		catch e
			@allocateBuffer()
			@buffer = arraycopy(buf, offset, @buffer, address, len)
		@regionAltered(address, address + len - 1)

	allocateBuffer: ->
		throw "This should not happen at all..."

	regionAltered: (start, end) ->
		for i in [end...start]
			b = @protectedCodeBuffer[i]

			if (!b || b == null)
				if (i < start)
					break
				else
					continue
			if (b == @PLACEHOLDER)
				continue

			if (b.handleMemoryRegionChange(start, end))
				@removeProtectedCodeBlockAt(i)
	setByte: (offset, data) ->
		if (@getByte(offset) == data)
			return

		try
			@buffer[offset] = data
		catch e
			@allocateBuffer()
			@buffer[offset] = data
		@regionAltered(offset, offset)

	getByte: (offset) ->
		try
			return @buffer[offset]
		catch e
			@nullReadCount++

			if (@nullReadCount == @ALLOCATION_THRESHOLD)
				@allocateBuffer()
				return @buffer[offset]
			else
				return 0
