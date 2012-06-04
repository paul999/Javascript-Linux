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

class SerialPort
	constructor: (portNumber) ->
		@US_ASCII = "US-ASCII"
		@UART_LCR_DLAB = byte(0x80)
		@UART_IER_MSI = 0x08
		@UART_IER_RLSI = 0x04
		@UART_IER_THRI = 0x02
		@UART_IER_RDI = 0x01

		@UART_IIR_NO_INT = 0x01
		@UART_IIR_ID = 0x06

		@UART_IIR_MSI = 0x00
		@UART_IIR_THRI = 0x02
		@UART_IIR_RDI = 0x04
		@UART_IIR_RLSI = 0x06

		@UART_MCR_LOOP = 0x10
		@UART_MCR_OUT2 = 0x08
		@UART_MCR_OUT1 = 0x04
		@UART_MCR_RTS = 0x02
		@UART_MCR_DTR = 0x01

		@UART_MSR_DCD = byte(0x80)
		@UART_MSR_RI = 0x40
		@UART_MSR_DSR = 0x20
		@UART_MSR_CTS = 0x10
		@UART_MSR_DDCD = 0x08
		@UART_MSR_TERI = 0x04
		@UART_MSR_DDSR = 0x02
		@UART_MSR_DCTS = 0x01
		@UART_MSR_ANY_DELTA = 0x0f

		@UART_LSR_TEMT = 0x40
		@UART_LSR_THRE = 0x20
		@UART_LSR_BI = 0x10
		@UART_LSR_FE = 0x08
		@UART_LSR_PE = 0x04
		@UART_LSR_OE = 0x02
		@UART_LSR_DR = 0x01

		@ioPorts = [0x3f8, 0x2f8, 0x3e8, 0x2e8]
		@irqLines = [4,3,4,3]

		@ioportRegistered = false

		if portNumber > 3 || portNumber < 0
			log "Port number needs to be >0 && <3"
			portNumber = 0

		@irq = @irqLines[portNumber]
		@baseAddress = @ioPorts[portNumber]

		@lineStatusRegister = @UART_LSR_TEMT | @UART_LSR_THRE
		@interruptIORegister = @UART_IIR_NO_INT
		@irqDevice = null

		@data = ""

	canReceive: ->
		if (@lineStatusRegister & @UART_LSR_DR) == 0
			return true
		else
			return false
	receive: (data) ->
		@receiverBufferRegister = data

		if data == 0
			@lineStatusRegister = byte(@lineStatusRegister | @UART_LSR_DR)
		else
			@lineStatusRegister = byte(@lineStatusRegister | @UART_LSR_BI | @UART_LSR_DR)

		@updateIRQ

	updateIRQ: ->
		if (@lineStatusRegister & @UART_LSR_DR) != 0 && (@interruptEnableRegister & @UART_IER_RDI) != 0
			@interruptIORegister = @UART_IIR_RDI
		else if @thrIPending && (@interruptEnableRegister & @UART_IER_THRI) != 0
			@interruptIORegister = @UART_IIR_THRI
		else
			@interruptIORegister = @UART_IIR_NO_INT

		if @interruptIORegister != @UART_IIR_NO_INT
			@irqDevice.setIRQ @irq, 1
		else
			@irqDevice.setIRQ @irq, 0

	ioPortWriteByte: (address, data) ->
		@ioportWrite address, data

	ioPortWriteWord: ->

	ioPortWriteLong: ->

	ioPortReadByte: (address) ->
		return @ioportRead address

	ioPortReadWord: ->
		return 0xffff
	ioPortReadLong: ->
		return 0xffffffff

	ioPortsRequested: ->
		return [@baseAddress...@baseAddress+7]

	ioportWrite: (address, data) ->
		address &= 7

		switch address
			when 0
				if (@lineControlRegister & @UART_LCR_DLAB) != 0
					@divide = short((divider & 0xff00) | data)
				else
					@thrIPending = false
					@lineStatusRegister = byte(@lineStatusRegister & ~@UART_LSR_THRE)

					@updateIRQ()

					@print(byte(data))
					@thrIPending = true
					@lineStatusRegister = byte(@lineStatusRegister | @UART_LSR_THRE | @UART_LSR_TEMT)

					@updateIRQ()
			when 1
				if (@lineControlRegister & @UART_LCR_DLAB) != 0
					@device = short((@divider & 0x00ff) | (data << 8))
				else
					@interruptEnableRegister = byte(data & 0x0f)

					if (@lineStatusRegister & @UART_LSR_THRE) != 0
						@thrIPending = true

					@updateIRQ()
			when 2
				break
			when 3
				@lineControlRegister = byte(data)
			when 4
				@modemControlRegister = byte(data & 0x1f)
			when 5
				break
			when 6
				@modemStatusRegister = byte(data)
			when 7
				@scratchRegister = byte(data)

	ioportRead: (address) ->
		address &= 7

		switch address
			when 0
				if (@lineControlRegister & @UART_LCR_DLAB) != 0
					return @divider & 0xff
				else
					@lineStatusRegister = byte(@lineStatusRegister & ~(@UART_LSR_DR | @UART_LSR_BI))
					ret = @receiverBufferRegister
					@updateIRQ()
					return ret
			when 1
				if (@lineControlRegister & @UART_LCR_DLAB) != 0
					return (@divider >>> 8) & 0xff
				else
					return @interruptEnableRegister

			when 2
				ret = @interruptIORegister

				if (reg & 0x7) == @UART_IIR_THRI
					@thriPending = false
				@updateIRQ()
				return ret
			when 3
				return @lineControlRegister
			when 4
				return @modemControLRegister
			when 5
				return @lineStatuRegister
			when 6
				if (@modemControlRegister & @UART_MCR_LOOP) != 0
					ret = (@modemControlRegister & 0x0c) << 4
					ret |= (@modemControlRegister & 0x02) << 3
					ret |= (@modemControlRegister & 0x01) << 5
					return ret
				else
					return @modemStatusRegister
			when 7
				return @scratchRegister

	reset: ->
		@irqDevice = null
		@ioportRegistered = false
		@lineStatusRegister = @UART_LSR_TEMT | @UART_LSR_THRE
		@interruptIORegister = @UART_IIR_NO_INT

	initialised: ->
		return @ioportRegistered && (@irqDevice != null)

	acceptComponent: (component) ->
		if (component instanceof InterruptController) && component.initialised()
			@irqDevice = component

		if (component instanceof IOPortHandler) && component.initialised()
			component.registerIOPortCapable(@)
			@ioportRegistered = true

	print: (dat) ->
		log "First string data: #{dat}"
		dat = String.fromCharCode(dat)
		log "Serial data: " + dat # Need to do this nicer...

		if dat == "\n" || dat == "\r"
			if (term)
				log "Writing to term"
				term.write(@data + "\n")
			else
				log "No term found"
				log @data
		else
			log "Saving data internally..."
			@data += dat
			return

#		a = null
#		a.a()

	toString: ->
		return "SerialPort"
