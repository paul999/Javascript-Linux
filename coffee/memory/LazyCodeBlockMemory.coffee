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
		@PLACEHOLDER = new BlankCodeBlock()
		@realCodeBuffer = new Array()
		@protectedCodeBuffer = new Array()
		@ALLOCATION_THRESHOLD = 10
		@buffer = new Array(4096)#new Int32Array(4096)
		@nullReadCount = 0


	toString: () ->
		"LazyCodeBlockMemory"

	getSize: ->
		return 4096
	initialised: ->
		return true

	copyArrayIntoContents: (address, buf, offset, len) ->



		try
			#@buffer = arraycopy(buf, offset, @buffer, address, len)

			if (@buffer.length > 4096)
				throw new LengthIncorrectError("Length: #{@buffer.length} max 4096")
#			if typeof buf == "string"
#				for i in [0...buf.length]
#					@buffer[i] = buf.charCodeAt(i)
#					address++
		catch e
			throw e
			@allocateBuffer()
			@buffer = arraycopy(buf, offset, @buffer, address, len)
		@regionAltered(address, address + len - 1)

		# Dump saved contents...
#		log "Dump saved value: Length: " + @buffer.length
#		log "Data result: " + arraycopy(buf, offset, @buffer, address, len).length
#		for i in [0...@buffer.length]
#			log "@buffer[#{i}]=#{@buffer[i]}"
#		throw "Die"

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
#			throw e
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

	executeProtected: (cpu, offset) ->
		x86Count = 0
		ip = proc.getInstructionPointer()

		offset = ip & pas.BLOCK_MASK

		log "Offset: #{offset}"
		block = @getProtectedModeCodeBlockAt(offset)
		log "BLock result: #{block}"

		try
			try
				x86Count += block.execute()
			catch e
				block = manager.getProtectedModeCodeBlockAt(@, offset, proc.cs.getDefaultSizeFlag())
				log "Replacement block: #{block}"
				@setProtectedCodeBlockAt(offset, block)
				x86Count += block.execute()
		catch e
			if (e instanceof CodeBlockReplacementException)
				block = e.getReplacement()
				protectedCodeBuffer[offset] = block
				x86Count += block.execute()
			else
				throw e
		return x86Count

	getProtectedModeCodeBlockAt: (offset) ->
		try
			return @protectedCodeBuffer[offset]
		catch e
			@constructProtectedCodeBlocksArray()
			return @protectedCodeBuffer[offset]

	setProtectedCodeBlockAt: (offset, block) ->
		@removeProtectedCodeBlockAt(offset)

		if (block == null)
			return

		@protectedCodeBuffer[offset] = block

		len = block.getX86Length()

		for i in [offset+1...offset+len]
			if (!@protectedCodeBuffer[i] || @protectedCodeBuffer[i] == null)
				@protectedCodeBuffer[i] = @PLACEHOLDER

	removeProtectedCodeBlockAt: (offset) ->

		b = @protectedCodeBuffer[offset]

		if (!b || b == null || b == @PLACEHOLDER)
			return

		len = b.getX86Length()

		for i in [offset+1...offset+len]
			if (@protectedCodeBuffer[i] == @PLACEHOLDER)
				@protectedCodeBuffer[i] = null

		for i in [offset+len-1...0]
			if (@protectedCodeBuffer[i] == null)
				if (i < offset)
					break
				else
					continue
			if (@protectedCodeBuffer[i] == @PLACEHOLDER)
				continue

			bb = @protectedCodeBuffer[i]
			len = bb.getX86Length()

			for j in [i+1...i+len]
				if (@protectedCodeBuffer[j] == null)
					@protectedCodeBuffer[j] = @PLACEHOLDER


class BlankCodeBlock
	getX86Length: ->
		return 0
	getX86Count: ->
		return 0

	execute: ->
		throw "Cant execute code on Blankcodeblock"

	handleMemoryRegionChange: ->
		return false
	getString: ->
		return " -- Blank --"
