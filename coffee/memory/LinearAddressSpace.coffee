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
# This program is free software you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2 as published by
# the Free Software Foundation.

class PageFaultWrapper
	constructor: (errorCode) ->
		@pageFault = "Iam a exception" + errorCode

	getException: ->
		return pageFault


	fill: ->
		#pageFault.fillInStackTrace
		return
	isAllocated: ->
		return false
	clear: ->
		return
	clear:(start, length) ->
		return
	copyContentsIntoArray: () ->
		@fill()
		throw @pageFault
	copyArrayIntoContents:() ->
		@fill()
		throw @pageFault
	getSize: ->
		return 0
	getByte:(offsets) ->
		@fill()
		throw @pageFault
	getWord:(offset) ->
		@fill()
		throw @pageFault
	getDoubleWord:(offset) ->
		@fill()
		throw @pageFault
	getQuadWord:(offset) ->
		@fill()
		throw @pageFault
	getLowerDoubleQuadWord:(offset) ->
		@fill()
		throw @pageFault
	getUpperDoubleQuadWord:(offset) ->
		@fill()
		throw @pageFault
	setByte:(offset,data) ->
		@fill()
		throw @pageFault
	setWord:(offset, data) ->
		@fill()
		throw @pageFault
	setDoubleWord:(offset, data) ->
		@fill()
		throw @pageFault
	setQuadWord:(offset, data) ->
		@fill()
		throw @pageFault
	setLowerDoubleQuadWord:(offset, data) ->
		@fill()
		throw @pageFault
	setUpperDoubleQuadWord:(offset, data) ->
		@fill()
		throw @pageFault
	executeReal:(cpu, offset) ->
		throw "Cannot execute a Real Mode block in linear memory"
	executeProtected:(cpu, offset) ->
		@fill()
		throw @pageFault
	executeVirtual8086:(cpu, offset) ->
		@fill()
		throw @pageFault
	toString: ->
		return "PF " + @pageFault
	loadInitialContents:() ->
		throw "Not supported yet."

class LinearAddressSpace extends AddressSpace
	@PF_NOT_PRESENT_RU = new PageFaultWrapper(4)
	@PF_NOT_PRESENT_RS = new PageFaultWrapper(0)
	@PF_NOT_PRESENT_WU = new PageFaultWrapper(6)
	@PF_NOT_PRESENT_WS = new PageFaultWrapper(2)


	@PF_PROTECTION_VIOLATION_RU = new PageFaultWrapper(5)
	@PF_PROTECTION_VIOLATION_WU = new PageFaultWrapper(7)
	@PF_PROTECTION_VIOLATION_WS = new PageFaultWrapper(3)

	@FOUR_M = 0x01
	@FOUR_K = 0x00

	@baseAddress = 0
	@lastAddress = 0
	@pagingDisabled = true
	@globalPagesEnabled = false
	@writeProtectedUserPages = false
	@pageSizeExtensions = false

	constructor: ->
		console.log "create LinearAddressSpacce"

		super

		@nonGlobalPAges = new Int32Array()

		@pageSize = new Int32Array(@INDEX_SIZE)
		@readUserIndex = new Int32Array(@INDEX_SIZE)
		@readSupervisorIndex = new Int32Array(@INDEX_SIZE)
		@writeUserIndex = new Int32Array(@INDEX_SIZE)
		@writeSuperVisorIndex = new Int32Array(@INDEX_SIZE)
		@readIndex = new Int32Array(@INDEX_SIZE)
		@writeIndex = new Int32Array(@INDEX_SIZE)

		for i in [0..@INDEX_SIZE - 1]
			@pageSize[i] = @FOUR_K

	executeVirtual8086: (cpu, offset) ->

		console.log "executeVirtual8086 @ linear"
		memory = @getReadMemoryBlockAt(offset)

		try
			tmp = memory.executeVirtual8086(cpu, offset & @BLOCK_MASK)
		catch e
			console.log "Nope"

		if (!tmp)
			memory = @validateTLBEntryRead(offset) # Memory object was null
		else
			return tmp

		try
			tmp = memory.executeVirtual8086(cpu, offset & @BLOCK_MASK)
		catch e
			cpu.handleProtectedModeException(e)
			return 1


	getReadMemoryBlockAt: (offset) ->
		return @getReadIndexValue(offset >>> @INDEX_SHIFT)

	getReadIndexValue: (index) ->
		console.log "Get data of " + index
		if (@readIndex[index] != "undefined")
			return @readIndex[index]
		else
			@createReadIndex()
			return @readIndex[index]

	#TODO: Check if this is OK and works
	createReadIndex: ->
		throw "Error, should not happen"

	validateTLBEntryRead: (offset) ->
		idx = offset >>> @INDEX_SHIFT

		if (@pagingDisabled)
			@setReadIndexValue(idx, @target.getReadMemoryBlockAt(offset))
			return readIndex[idx]

		@lastAddress = offset

		directoryAddress = @baseAddres | (0xFFC & (offset >>> 20))
		directoryRawBits = @target.getDoubleWord(directoryAddress)


		directoryPresent (0x1 & directoryRawBits) != 0

		if (!directoryPresent)
			if (@isSupervisor)
				return @PF_NOT_PRESENT_RS
			else
				return @PF_NOT_RESENT_RU

		directoryGlobal = @globalPagesEnabled && ((0x100 & directoryRawBits) != 0)
		directoryUser = (0x4 & directoryRawBits) != 0
		directoryIs4MegPage = ((0x80 & directoryRawBits) != 0) && @pageSizeExtensions

		if (directoryIs4MegPage)
			if (!directoryUser && !@isSupervisor)
				return @PF_PROTECTION_VIOLATION_RU

			if ((directoryRawBits & 0x20) == 0)
				directoryRawBits |= 0x20
				@target.setDoubleWord(directoryAddress, directoryRawBits)

			fourMegPageStartAddress = 0xFFC00000 & directoryRawBits

			if (!@pageCacheEnabled)
				return @target.getReadMemoryBlockAt(fourMegPageStartAddress | (offset & 0x3FFFFF))


			tableIndex = (0xFFC00000 & offset) >>> 12

			for i in [0..1023]
				m = target.getReadMemoryBlockAt(fourMegPageStartAddress)
				fourMegPageStartAddress += @BLOCK_SIZE
				@pageSize[@tableIndex] = @FOUR_M

				@setReadIndexValue(@tableIndex++, m)

				if (directoryGlobal)
					continue
				@nonGlobalPages.add(i)
			return @readIndex[idx]
		else
			directoryBaseAddress = directoryRawBits & 0xFFFFF000

			tableAddress = directoryBaseAddress | ((offset >>> 10) & 0xFFC)
			tableRawBits = @target.getDoubleWord(tableAddress)

			tablePresent = (0x1 & tableRawBits) != 0

			if (!tablePresent)
				if (@isSupervisor)
					return @PF_NOT_PRESENT_RS
				else
					return @PF_NOT_PRESENT_RU

			tableGlobal = @globalPagesEnabled && ((0x100 & tableRawBits) != 0)
			tableUser = (0x4 & tableRawBits) != 0

			pageIsUser = tableUser && directoryUser
			if (!pageIsUser && !@isSupervisor)
				return @PF_PROTECTION_VIOLATION_RU

			if ((tableRawBits & 0x20) == 0)
				tableRawBits |= 0x20
				@target.setDoubleWord(tableAddress, tableRawBits)
			foutKStartAddress = tableRawBits & 0xFFFFF000

			if (!@pageCacheEnabled)
				return @target.getReadMemoryBlockAr(fourKStartAddress)

			pageSize[idx] = @FOUR_K
			if(!@tableGlobal)
				@nonGlobalPages.add(idx)
			@setReadIndexValue(idx, @target.getReadMemoryBlockAt(fourKStartAddress))

			return @readIndex[idx]

	type: ->
		"LinearAddresSpace"
	initialised: ->
		if (@target && @target != null)
			return true
		return false

	acceptComponent: (component, type="error") ->
		if (!type || type == null || type == "error")
			throw "BC break"

		if (type == "PhysicalAddressSpace")
			console.log "Got a  PhysicalAddressSpace"
			@target = component
