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
		throw new IllegalStateException("Cannot execute a Real Mode block in linear memory")
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
	constructor: ->
		log "create LinearAddressSpace"

		super

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

		@nonGlobalPages = new Array()

		@pageSize = new Array(@INDEX_SIZE)
		@readUserIndex = new Array(@INDEX_SIZE)
		@readSupervisorIndex = new Array(@INDEX_SIZE)
		@writeUserIndex = new Array(@INDEX_SIZE)
		@writeSuperVisorIndex = new Array(@INDEX_SIZE)
		@readIndex = new Array(@INDEX_SIZE)
		@writeIndex = new Array(@INDEX_SIZE)

		for i in [0...@INDEX_SIZE]
			@pageSize[i] = @FOUR_K

	executeVirtual8086: (cpu, offset) ->

		log "executeVirtual8086 @ linear (What should not happen, as we dont support virtual8086...)"

		throw "virtual8086 is not supported"

	executeProtected: (cpu, offset) ->

		log "executeProtected @linear " + offset
		memory = @getReadMemoryBlockAt(offset)

		try
			tmp = memory.executeProtected(cpu, offset & @BLOCK_MASK)
		catch e
			log "Memory error"
		log "Memory result: #{tmp}"

		if (!tmp || tmp == null)
			log "tmp was false"
			memory = @validateTLBEntryRead(offset)
		else
			return tmp


		try
			tmp = memory.executeProtected(cpu, offset & @BLOCK_MASK)
		catch e
			if (e instanceof ProcessorException)
				log "ProcessorException"
				cpu.handleProtectedModeException(e)
			else if (e instanceof IllegalStateException)
				log "Current eip = " + cpu.eip + " Exception " + e
				throw e

			else
				log "Got a exception I didnt expect: " + e
				throw e
			return 1

	getReadMemoryBlockAt: (offset) ->
#		log "linear getReadMemoryBlockAt " + offset
		return @getReadIndexValue(offset >>> @INDEX_SHIFT)

	getReadIndexValue: (index) ->
#		log "Get data of " + index
		if (@readIndex[index])
			return @readIndex[index]
		else
			@createReadIndex()
			return @readIndex[index]

	#TODO: Check if this is OK and works
	createReadIndex: ->
		if (@isSupervisor)
			@readIndex = @readSupervisorIndex = new Array(@INDEX_SIZE)
		else
			@readIndex = @readUserIndex = new Array(@INDEX_SIZE)

	setReadIndexValue: (index, value) ->
		try
#			log "readIndex[#{index}] = #{value}"
			@readIndex[index] = value
#			log "readIndex[#{index}] = #{@readIndex[index]}"
		catch e
#			log "CreateIndex did not exists"
			@createReadIndex()
			@readIndex[index] = value

	validateTLBEntryRead: (offset) ->
		idx = offset >>> @INDEX_SHIFT
#		log "validateTLBEntryRead(" + offset + ") IDX returned: " + idx

		if (@pagingDisabled)
			tmp = @target.getReadMemoryBlockAt(offset)
#			log "Paging disabled, got data: " + tmp
			@setReadIndexValue(idx, tmp)
			return @readIndex[idx]

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

			for i in [0...1024]
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

	toString: ->
		"LinearAddressSpace"

	initialised: ->
		if (@target && @target != null)
			return true
		return false

	acceptComponent: (component) ->
		if (component instanceof PhysicalAddressSpace)
			log "Got a  PhysicalAddressSpace"
			@target = component
	reset: ->
		log "Reset linearAddressSpace"
		@flush()

		@baseAddress = 0
		@lastAddress = 0
		@pagingDisabled = true
		@globalPagesEnabled = false
		@writeProtectUserPages = false
		@pageSizeExtensions = false

		@readUserIndex = null
		@writeUserIndex = null
		@readSupervisorIndex = null
		@writeSupervisorIndex = null

	flush: ->
		for i in [0...@INDEX_SIZE]
			@pageSize[i] = @FOUR_K

		@nonGlobalPages = new Array()

		@readUserIndex = null
		@writeUserIndex = null
		@readSupervisorIndex = null
		@writeSupervisorIndex = null
