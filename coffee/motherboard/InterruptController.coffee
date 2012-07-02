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

class InterruptController
	constructor: ->
		@master = null
		@slave = null
		@ioportRegistrered = false
		@cpuFound = false

		@master = new InterruptControllerElement(true, @)
		@slave = new InterruptControllerElement(false, @)

	reset: ->
		@master.reset()
		@slave.reset()

		@ioportRegistrered = false
		@cpuFound = false

	configure: ->
		log "configure InterruptController"

	toString: ->
		"Intel i8259 Programmable Interrupt Controller"

	initialised: ->
		return (@cpuFound && @ioportRegistrered);

	acceptComponent: (component) ->
		if (component instanceof processor)
			@cpuFound = true

		if ((component instanceof IOPortHandler) && component.initialised())
			component.registerIOPortCapable(@)
			@ioportRegistrered = true

	updateIRQ: ->
		slaveIRQ = masterIRQ = null

		slaveIRQ = @slave.getIRQ()

		if (slaveIRQ >= 0)
			@master.setIRQ(2,1)
			@master.setIRQ(2,0)


		masterIRQ = @master.getIRQ()
		if (masterIRQ >= 0)
			proc.raiseInterrupt()


	setIRQ: (irqNumber, level) ->
		number = irqNumber >>> 3

		switch number
			when 0
				@master.setIRQ(irqNumber & 7, level)
			when 1
				@slave.setIRQ(irqNumber & 7, level)
			else
				return
		@updateIRQ()

	cpuGetInterrupt: ->
		masterIRQ = slaveIRQ = 0
		masterIRQ = @master.getIRQ()

		if (masterIRQ >= 0)
			@master.intAck(masterIRQ)

			if (masterIRQ == 2)
				slaveIRQ  = getIRQ()
				if (slaveIRQ >= 0)
					@slave.intAck(slaveIRQ)
				else
					slaveIRQ = 7
				@updateIRQ()
				return @slave.irqBase + slaveIRQ
			else
				@updateIRQ()
				return @master.irqBase + masterIRQ
		else
			masterIRQ = 7
			@updateIRQ()
			return @master.irqBase + masterIRQ

	ioPortsRequested: () ->
		data = new Array()

		tmp = @master.ioPortsRequested()
		index = 0

		for i in [0...tmp.length]
			data[index] = tmp[i]
			index++

		tmp = @slave.ioPortsRequested()

		for i in [0...tmp.length]
			data[index] = tmp[i]
			index++
		return data

	ioPortReadByte: (address) ->
		log "ioport read #{address}"
		switch address
			when 0x20, 0x21
				return 0xff & @master.ioPortRead(address)
			when 0xa0, 0xa1
				return 0xff & @slave.ioPortRead(address)
			when 0x4d0
				return 0xff & @master.elcrRead()
			when 0xfd1
				return 0xff & @slave.elcrRead()
			else
				return 0
	ioPortReadWord: (address) ->
		return (0xff & @ioPortReadByte(address)) | (0xff00 & (@ioPortReadByte(address + 1) << 8))

	ioPortReadLong: (address) ->
		return (0xffff & @ioPortReadWord(address)) | (0xffff0000 & (@ioPortReadWord(address + 2) << 16))


	ioPortWriteByte: (address, data) ->
		log "ioport write #{address}"
		switch address
			when 0x20, 0x21
				if (@master.ioPortWrite(address, data))
					@updateIRQ()
			when 0xa0, 0xa1
				if (@slave.ioPortWrite(address, data))
					@updateIRQ()

			when 0x4d0
				@master.elcrWrite(data)
			when 0x4d1
				@slave.elcrWrite(data)

	masterPollCode: ->
		@master.interruptServiceRegister &= ~(1 << 2)
		@master.intteruptRequestRegister &= ~(1 << 2)
