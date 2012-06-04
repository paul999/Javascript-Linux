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

class Segment
	constructor: ->
		@TYPE_ACCESSED = 0x1
		@TYPE_CODE = 0x8
		@TYPE_DATA_WRITABLE = 0x2
		@TYPE_DATA_EXPAND_DOWN = 0x4
		@TYPE_CODE_READABLE = 0x2
		@TYPE_CODE_CONFIRMMING = 0x4

	setAddressSpace: () ->

	getByte: (offset) ->
		return pc.getMemoryOffset(8, @translateAddressRead(offset))

	getWord: (offset) ->
		tm = pc.getMemoryOffset(16, @translateAddressRead(offset))

		if (isNaN(tm))
			log "getMemoryOffset returned wrong value? #{tm}, address: #{@translateAddressRead(offset)}"

		return tm

	getDoubleWord: (offset) ->
		return pc.getMemoryOffset(32, @translateAddressRead(offset))

	getQuadWord: (offset) ->
		tmp = @translateAddressRead(offset)

		result = 0xFFFFFFFF & @memory.getDoubleWord(tmp)
		tmp = @translateAddressRead(offset + 4)
		result |= ((@memory.getDoubleWord(tmp)) << 32)
		return result

	setByte: (offset, data) ->
		if offset == 12240
			log "Writing B to 12240 with " + data
		pc.setMemory(8, @translateAddressRead(offset), data)

	setWord: (offset, data) ->
		if offset == 12240
			log "Writing W to 12240 with " + data
		pc.setMemory(16, @translateAddressRead(offset), data)

	setDoubleWord: (offset, data) ->
		if offset == 12240
			log "Writing D to 12240 with " + data
		pc.setMemory(32, @translateAddressRead(offset), data)

	setQuadWord: (offset, data) ->
		tmp = @translateAddressWrite(offset)
		@setDoubleWord(tmp, data)
		tmp = @translateAddressWrite(offset + 4)
		@setDoubleWord(tmp, (data >>> 32))
