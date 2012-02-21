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

class DMAController
	constructor: (@highPageEnable, @primary) ->
		console.log "DMA create with HighPageEnable #{highPageEnable} and primary #{primary}"
		@pagePortList0 = 0x1
		@pagePortList1 = 0x2
		@pagePortList2 = 0x3
		@pagePortList3 = 0x7
		@pagePortList = [@pagePortList0, @pagePortList1, @PagePortList2, @PagePortList3]
		@COMMAND_MEMORY_TO_MEMORY = 0x01
		@COMMAND_ADDRESS_HOLD = 0x02
		@COMMAND_CONTROLLER_DISABLE = 0x04
		@COMMAND_COMPRESS_TIMING = 0x08
		@COMMAND_CYCLIC_PRIORITY = 0x10
		@COMMAND_EXTENDED_WRITE = 0x20
		@COMMAND_DREQ_SENSE_LOW = 0x40
		@COMMAND_DACK_SENSE_LOW = 0x80
		@COMMAND_NOT_SUPPORTED = @COMMAND_MEMORY_TO_MEMORY | @COMMAND_ADDRESS_HOLD | @COMMAND_COMPRESSED_TIMING | @COMMAND_CYCLIC_PRIORITY | @COMMAND_EXTENDED_WRITE | @COMMAND_DREQ_SENSE_LOW | @COMMAND_DACK_SENSE_LOW
		@ADDRESS_READ_STATUS = 0x8
		@ADDRESS_READ_MASK = 0xf
		@ADDRESS_WRITE_COMMAND = 0x8
		@ADDRESS_WRITE_REQUEST = 0x9
		@ADDRESS_WRITE_MASK_BIT = 0xa
		@ADDRESS_WRITE_MODE = 0xb
		@ADDRESS_WRITE_FLIPFLOP = 0xc
		@ADDRESS_WRITE_CLEAR = 0xd
		@ADDRESS_WRITE_CLEAR_MASK = 0xe
		@ADDRESS_WRITE_MASK = 0xf

		@ioportRegistrered = false
		@dShift = primary ? 0 : 1
		@ioBase = primary ? 0x00 : 0x0c
		@pageLowBase = primary ? 0x80 : 0x88
		tmp = primary ? 0x480 : 0x488
		@pageHighBase = @highPageEnable ? tmp : -1
		@controllerNumber = primary ? 0 : 1

		@channels = new Int32Array()
		@channels = [-1, 2, 3, 1, -1, -1, -1, 0]

		@dmaChannels = new Array(4)
		for num in [0...5]
			@dmaChannels[num] = new dmaChannel()
		@reset()

	reset: ->
		for ch in @dmaChannels
			ch.reset()
		@writeController(0x0d << @dShift, 0)

		memory = null
		@ioportRegistrered = false

	writeChannel: (portNumber, data) ->
		port = (portNumber >>> @dShift) & 0x0f
		channelNumber = port >>> 1

		r = dmaChannels[channelNumber]

		if (getFlipFlop())
			if ((port & 1) == 0) # orgineel DMACHannel.ADDRESS
				r.baseAddress = (r.baseAddress & 0xff) | ((data << 8) & 0xff00)
			else
				r.baseWordCount = (r.baseWordCount & 0xff) | ((data << 8) & 0xff00)
			initChannel(channelNumber)
		else if ((port & 1) == 0) #orgineel DMAChanel.ADDRESS
			r.baseAddress = (r.baseAddress & 0xff00) | (data & 0xff)
		else
			r.baseWordCount = (r.baseWordCount & 0xff00) | (data & 0xff)


	writeController: (portNumber, data) ->
		port = (portNumber >> @dShift) & 0x0f

		if port == @ADDRESS_WRITE_COMMAND
			if ((data != 0) && ((data & CMD_NOT_SUPPORTED) != 0))
				""
			else
				@command = data
		else if (port == @ADDRESS_WRITE_REQUEST)
			channelNumber = data & 3

			if ((data & 4) == 0)
				@status &= ~(1 << (channelNumber + 4))
			else
				@status |= 1 << (channelNumber +4)

			@status &= ~(1 << channelNumber)
			@runTransfers()
		else if (port == @ADDRESS_WRITE_MASK_BIT)
			if ((data & 0x04) != 0)
				@mask |= 1 << (data & 3)
			else
				@mask &= ~(1 << (data & 3))
				runTransfers()
		else if (port == @ADDRESS_WRITE_MODE)
			#Orgineel: private static final int MODE_CHANNEL_SELECT = 0x03
			channelNumber = data & 0x03
			@dmaChannels[channelNumber].mode = data
		else if (port == @ADDRESS_WRITE_FLIPFLOP)
			@flipFlop = false
		else if (port == @ADDRESS_WRITE_CLEAR)
			@flipFlop = false
			@mask = ~0
			@status = 0
			@command = 0
		else if (port == @ADDRESS_WRITE_CLEAR_MASK)
			@mask = 0
			@runTransfers()
		else if (port == @ADDRESS_WRITE_MASK)
			@mask = data
			@runTransfers()
		else
			console.log "did not understand #{port}"
	writePageLow: (portNumber, data) ->
		channelNumber = int @channels[portNumber & 7]

		if (channelNumber != -1)
			@dmaChannels[channelNummber].pageLow = 0xff & data
		""
	writePageHigh: (portNumber, data) ->
		channelNumber = int @channels[portNumber & 7]

		if (channelNumber != -1)
			@dmaChannels[channelNumber].pageHigh = 0x7f & data
		""
	readChannel: (portNumber) ->
		port = int (portNumber >>> dShift) & 0x0f
		channelNumber = int port >>> 1
		registerNumber = int port & 1

		r = @dmaChannels[channelNumber]

		direction = ((r.mode & 0x20) == 0) ? 1  : -1

		flipflop = getFlipFlop()

		if (registerNumber != 0)
			val = (r.baseWordCount << @dShift) - r.currentWordCount
		else
			val = r.currentAddress + r.currentWordCount * direction

		(val >>> (dShift + (flipflop ? 0x8 : 0x0))) & 0xff
	readController: (portNumber) ->
		port = int (portNumber >>> @dShift) & 0x0f

		if (port == @ADDRESS_READ_STATUS)
			val = status
			@status &= 0xf0
		else if (port == @ADDRESS_READ_MASK)
			val = mask
		else
			val = 0
		val

	readPageLow: (portNumber) ->
		channelNumber = int @channels[portNumber & 7]

		if (channelNumber == -1)
			-1
		else
			@dmaChannels[channelNumber].pageLow

	readPageHigh: (portNumber) ->
		channelNumber = int @channels[portNumber & 7]

		if (channelNumber != -1)
			@dmaChannels[channelNumber].pageHigh
		else
			-1

	ioPortWriteByte: (address, data) ->
		swit = ((address - @ioBase) >>> @dShift)

		switch swit
			when 0x0, 0x1, 0x2, 0x3, 0x4, 0x5, 0x6, 0x7 then @writeChannel(address, data)
			when 0x8, 0x9, 0xa, 0xb, 0xc, 0xd, 0xe, 0xf then @writeController(address, data)
			else

		swit = address - @pageLowBase
		if (swit == @pagePortList0 || swit == @pagePortList1 || swit == @pagePortList2 || swit == @pagePortList3)
			writePageLow(address, data)
		else
			swit = address - @pageHighBase
			if (swit == @pagePortList0 || swit == @pagePortList1 || swit == @pagePortList2 || swit == @pagePortList3)
				writePageHigh(address, data)
	ioPortWriteWord: (address, data) ->
		@ioPortWriteByte(address, data)
		@ioPortWriteByte(address + 1, data >>> 8)

	ioPortWriteLong: (address, data) ->
		@ioPortWriteWord(address, data)
		@ioPortWriteWord(address + 2, data >>> 16)

	ioPortsRequested: () ->


		if (@pageHighBase >= 0)
			temp = new Int32Array(16 + (2 * pagePortList.length))
		else
			temp = new Int32Array(16 + pagePortList.length)
		j = 0
		for k in [0...8]
			temp[j++] = @ioBase + (i << @dShift)

		for k in [0...pagePortList.length]
			temp[j++] = pageLowBase + pagePortList[i]
			if (pageHighBase >= 0)
				temp[j++] = pageHighBase + pagePortList[i]

		for k in [0...8]
			temp[j++] = @ioBase + ((i+8) << @dShift)
		temp

	getFlipFlop: () ->
		ff = @flipFlop
		@flipFlop = !ff
		ff

	initChannel: (channelNumber) ->
		r = @dmaChannels[channelNumber]
		r.currentAddress = r.baseAddress << @dShift
		r.currentWordCount = 0

	numberOfTrailingZeros: (i) ->
		if (i == 0)
			return 32

		n = 31

		y = i << 16
		if (y != 0)
			n = n - 16
			i = y

		y = i << 8
		if (y != 0)
			n = n - 8
			i = y

		y = i << 4
		if (y != 0)
			n = n - 4
			i = y

		y = i << 2
		if (y != 0)
			n = n - 2
			i = y

		n - ((i << 1) >>> 31)

	runTransfers: () ->
		value = ~@mask & (@status >>> 4) & 0xf

		if (value == 0)
			return

		while value != 0
			channel = numberOfTrailingZeros(value)

			if (channel < 4)
				@dmaChannels[channel].run()
			else
				break
			value &= ~(1 << channel)
		return
	getChannelMode: (channel) ->
		@dmaChannels[channel].mode

	holdDmaRequest: (channel) ->
		@status |= 1 << (channel + 4)
		@runTransfers()

	releaseDmaRequest: (channel) ->
		@status &= ~(1 << (channel + 4))

	registerChannel: (channel, device) ->
		@dmaChannels[channel].transferDevice = device

	initialised: () ->
		tmp = ((@memory != null) && @ioportRegistered)

		if (tmp == undefined)
			tmp = false

		console.log "DMA -> initialised: " + tmp
		return tmp

	updated: ->
		@memory.updated() && @ioportRegistered

	acceptComponent: (component) ->
		console.log "accept component: " + component

		if (component instanceof PhysicalAddressSpace)
			console.log "Got PhysicalAddressSpace"
			@memory = component
		else if (component instanceof IOPortHandler)
			component.registerIOPortCapable(this)
			@ioportRegistered = true
		return

	toString: () ->
		"DMA Controller [element " + @dShift + "]"

	configure: ->
		console.log "DMA start"

class dmaChannel
	constructor: () ->
		console.log "create dmaChannel"
		@MODE_CHANNEL_SELECT = 0x03
		@MODE_ADDRESS_INCREMENT = 0x20
		@ADDRESS = 0
		@COUNT = 1



	readMemory: (buffer, offset, position, length) ->
		address = (@pageHigh << 24) | (@pageLow << 16) | @currentAddress

		if ((mode & @MODE_ADDRESS_INCREMENT) != 0)
			console.log "read in address decrement mode"
			throw "Not supported"
			memory.copyContentsIntoArray(address - position - length, buffer, offset, length)

			right = offset + length - 1

			for left in left < right
				right--
				temp = buffer[left]
				buffer[left] = buffer[right]
				buffer[right] = temp
			return
		else
			memory.copyContentsIntoArray(address + position, buffer, offset, length)
			return

	writeMemory: (buffer, offset, position, length)->
		address = (@pageHigh << 24) | (@pageLow << 16) | @currentAddress

		if ((mode & @MODE_ADDRESS_INCREMENT) != 0)
			console.log "write in address decrement mode"
			throw "not supported"
		else
			memory.copyArrayIntoContents(address + position, buffer, offset, length)

	run: () ->
		console.log "dmaChannel -> run (" + @controllerNumber + ")"
		n = transferDevice.handleTransfer(this, @currentWordCount, (@baseWordCount + 1) << @controllerNumber)
		currentWordCount = n
		return

	reset: () ->
		@transferDevice = null
		@currentAddress = @currentWordCount = @mode = 0
		@baseAddress = @baseWordCount = 0
		@pageLow = @pageHigh = @dack = @eop = 0
