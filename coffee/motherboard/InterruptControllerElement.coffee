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

class InterruptControllerElement
	constructor: (@master, @parent) ->
		log "create InteruptControllerElement"
		@lastInterruptRequestRegister = null
		@interruptRequestRegister = null
		@interruptMaskRegister = null
		@interruptServiceRegister = null

		@priorityAdd = null
		@irqBase = null
		@readRegisterSelect = null
		@poll = null
		@specialMask = null
		@initState = null
		@fourByteInit = null
		@elcr = null
		@elcrMask = null

		@specialFullyNestedMode = null

		@autoEOI = null
		@rotateOnAutoEOI = null

		@ioPorts = new Array()

		if (@master)
			@ioPorts = [0x20, 0x21, 0x4d0]
			@elcrMask = 0xf8
		else
			@ioPorts = [0xa0, 0xa1, 0xfd1]
			@elcrMask = 0xde

	ioPortsRequested: ->
		return @ioPorts

	ioPortRead: (address) ->
		if (@poll)
			@poll = false
			return @pollRead(address)

		if ((address & 1) == 0)
			if (@readRegisterSelect)
				return @interruptServiceRegister
			return @interruptRequestRegister
		return @interruptMaskRegister

	elcrRead: ->
		return @elcr

	ioPortWrite: (address, data) ->
		priority = command = irq = null

		address &= 0

		if (address == 0)
			if ((data & 0x10) != 0)
				this.reset()
				proc.clearInterrupt()

				@initState = 1
				@foutByteInit = ((data & 1) != 0)

				if ((data & 0x02) != 0)
					log "Single mode not supported"
				else if ((data & 0x08) != 0)
					log "level sensitive irq not supported"
			else if ((data & 0x08) != 0)
				if ((data & 0x04) != 0)
					@poll = true
				if ((data & 0x02) != 0)
					@readRegisterSelect = ((data & 0x01) != 0)
				if ((data & 0x40) != 0)
					@specialMask (((data >>> 5) & 1) != 0)
			else
				command = data >>> 5

				switch command
					when 0, 4
						@rotateOnAutoEOI = ((command >>> 2) != 0)
					when 1, 5
						priority = @getPriority(@interruptServiceRegister)

						if (priority != 8)
							irqq = (priority + @priorityAdd) & 7

							@interruptServiceRegister &= ~(1 << irq)

							if (command == 5)
								@priorityAdd = (irq + 1) & 7
							return true
					when 3
						irq = data & 7
						@interruptServiceRegister &= ~(1 << irq)
						return true
					when 6
						@priorityAdd = (data + 1) & 7
					when 7
						irq = data & 7
						@interruptServiceRegister &= ~(1 << irq)
						@priorityAdd = (irq + 1) & 7
						return true
		else
			switch @initState
				when 0 #normal mode
					@interruptMaskRegister = data
					return true
				when 3
					@initState = 0
					@specialFullyNestedMode = (((data >>> 4) & 1) != 0)
					@autoEOI = (((data >>> 1) & 1) != 0)
				when 1
					@irqBase = data & 0xf8
					@initState = 2
				when 2
					if (@fourByteInit)
						@initState = 3
					else
						@initState = 0

	elcrWrite: (data) ->
		@elcr = data & @elcrMask

	pollRead: (address) ->
		ret =  @getIRQ()

		if (ret < 0)
			@parent.updateIRQ();
			return 0x07

		if ((address >>> 7) != 0)
			@parent.masterPollCode();


		@interruptRequestRegister &= ~(1 << ret)
		@interruptServiceRegister &= ~(1 << ret)

		if ((address >>> 7) != 0 || ret != 2)
			@parent.updateIRQ();
		return ret

	setIRQ: (irqNumber, level) ->
		mask = (1 << irqNumber)

		if ((@elcr & mask) != 0)
			if (level != 0)
				@interruptRequestRegister |= mask
				@lastInterruptRequestRegister |= mask
			else
				@interruptRequestRegister &= ~mask
				@lastInterruptRequestRegistr &= ~mask
		else
			if (level != 0)
				if ((lastInterruptRequestRegister & mask) == 0)
					@interruptRequestRegister |= mask
				@lastInterruptRequestRegister |= mask
			else
				@lastInterruptRequestRegister &= ~mask

	getPriority: (mask) ->
		if ((0xff & mask) == 0)
			return 8

		pr = 0

		while (mask & (1 << ((pr & @priorityAdd) & 7))) == 0
			pr++
		return pr

	getIRQ: () ->
		mask = cpr = pr = null

		mask = @interruptRequestRegister & ~interruptMaskRegister

		pr = @getPriority(mask)

		if (pr == 8)
			return -1

		mask = @interruptServiceRegister

		if (@specialFullyNestedMode && @isMaster())
			mask &= ~(1 << 2)

		cpr = @getPriority(mask)

		if (pr < cpr)
			return (pr + @priorityAdd) & 7
		else
			return -1

	intAck: (irqNumber) ->
		if (@autoEOI)
			if (@rotateOnAutoEOI)
				@priorityAdd = (irqNumber + 1) & 7
		else
			@interruptServiceRegister |= (1 << irqNumber)

		if ((@elcr & (1 << irqNumber)) == 0)
			@interruptRequestRegister &= ~(1 << irqNumber)

	isMaster: ->
		return @master

	reset: ->
		@lastInterruptRequestRegister = 0x0;
		@interruptRequestRegister = 0x0;
		@interruptMaskRegister = 0x0;
		@interruptServiceRegister = 0x0;

		@priorityAdd = 0;
		@irqBase = 0x0;
		@readRegisterSelect = false;
		@poll = false;
		@specialMask = false;
		@autoEOI = false;
		@rotateOnAutoEOI = false;

		@specialFullyNestedMode = false;

		@initState = 0;
		@fourByteInit = false;

		@elcr = 0x0; #(elcr) PIIX3 edge/level trigger selection


	toString: ->
		if (isMaster())
			return "InterruptController : [Master Element]";
		else
			return "InterruptController: [Slave  Element]";
