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

class PhysicalAddressSpace extends AddressSpace
	constructor: (@manager) ->
		console.log "create PhysicalAddressSpace"
		super()

		@GATEA20_MASK = 0xffefffff
		@QUICK_INDEX_SIZE = @PC_RAM_SIZE >>> @INDEX_SHIFT
		@TOP_INDEX_BITS = (32 - @INDEX_SHIFT) / 2
		@BOTTOM_INDEX_BITS = 32 - @INDEX_SHIFT - @TOP_INDEX_BITS
		@TOP_INDEX_SHIFT = 32 - @TOP_INDEX_BITS
		@TOP_INDEX_SIZE = 1 << @TOP_INDEX_BITS
		@TOP_INDEX_MASK = @TOP_INDEX_SIZE - 1
		@BOTTOM_INDEX_SHIFT = 32 - @TOP_INDEX_BITS - @BOTTOM_INDEX_BITS
		@BOTTOM_INDEX_SIZE = 1 << @BOTOTM_INDEX_BITS
		@BOTTOM_INDEX_MASK = @BOTTOM_INDEX_SIZE - 1
		@UNCONNECTED = new UnconnectedMemoryBlock()

		@quickNona20MaskedIndex = new Array(@QUICK_INDEX_SIZE); #Check if this is actually a array.
		@clearArray(@quickNonA20MaskedIndex, @UNCONNECTED)
		@quickA20MaskedIndex = new Array(@QUICK_INDEX_SIZE)
		@clearArray(@quickNonA20MaskedIndex, @UNCONNECTED)

#		@nona20MaskedIndex = [][] #TODO: Check for syntax
#		@a20MaskedIndex = [][]

		@initialiseMemory()
		@setGateA20State(false)

	type: ->
		"PhysicalAddressSpace"
	initialised: ->
		return true

class UnconnectedMemoryBlock
	constructor: ->
		console.log "create UnconnectedMemoryBlock"

	isAllocated: ->
		return false
	clear: ->
		return
	copyContentsIntoArray: ->
		return
	copyArrayIntoContents: ->
		throw "Cannot load array into unconnected memory block"

	getSize: ->
		return

	getByte: ->
		return -1

	getWord: ->
		return -1

	getDoubleWord: ->
		return -1
	getQuardWord: ->
		return -1

	getLowerQuardWord: ->
		return -1

	getLoweverDoubleQuardWord: ->
		return -1

	setByte: ->
		return

	setWord: ->
		return
	setDoubleWord: ->
		return

	setQuadWord: ->
		return

	setLowerDoubleQuardWord: ->
		return

	setUpperDoubleQuardWord: ->
		return

	executeReal: (cpu, offset) ->
		throw "Trying to execute in Unconnected Block @ 0x" + offset
	executeProtected: (cpu, offset) ->
		@executeReal(cpu, offset)
	executeVirtual8086: (cpu, offset) ->
		@executeReal(cpu, offset)

	toString: ->
		"Unconnected Memory"

	loadInititalContents: () ->
		return
