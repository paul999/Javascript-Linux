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

#TODO: Controleer of coffeescript/javascript references gebruikt
# of vars kopieert.

SYS_RAM_SIZE = 1024

class pc
	@INSTRUCTIONS_BETWEEN_INTERRUPTS = 1
	@stp = false
	constructor: ->
		console.log "pc.create"
		@items = new Array()
		@count = 0
		@configured = false
		@started = false

		@general = new general()
		@proc= new processor()

		@manager = new CodeBlockManager
		@PhysicalAddressSpace = new PhysicalAddressSpace(@manager)
		@LinearAddressSpace = new LinearAddressSpace
		@add(@PhysicalAddressSpace)
		@add(@LinearAddressSpace)

		@add(@proc)
		@add(new IOPortHandler)
		@add(new InterruptController)
		@add(new DMAController(false, true))
		@add(new DMAController(false, false))
		@add(new RTC(0x70, 8))
		@add(new IntervalTimer(0x40, 0))
#		@add(new GateA20Handler()) #Needed?

#		@add(new Keyboard)
	add: (itm) ->
		@items[@count] = itm
		@count++
	start: ->
		@configure()

		@running = true


		COUNTDOWN = 10000000
		COUNTDOWN = 1000
		markTime = 0#System.currentTimeMillis()
		execCount = COUNTDOWN
		totalExec = 0
		while @running
			if (@stp)
				console.log "stop"
				return

			execCount -= @execute()
			execCount -= 1
			if (execCount > 0)
				continue

			totalExec += (COUNTDOWN - execCount)
			execCount = COUNTDOWN
			if (@updateMHz(markTime, totalExec))
				markTime = 0 #System.currentTimeMillis()
				totalExec = 0
				return



		@stop()
		console.log "PC stopped"

	updateMHz: () ->
		console.log "updateMHz"
		return

	stop: ->
		@running = false
		@stp = true
		console.log "STOP!"

		alert("stop")

		@proc = null


	_configure: ->
		init = true
		for part in @items

			if (part.initialised())
				continue

			for inner in @items
				console.log "acceptComponent on " + part
				part.acceptComponent(inner, inner.type())

			init &= part.initialised()
		return init
	configure: ->
		if (@configured)
			throw "Already configured"

		count = 1
		init = @_configure()

		while init == false && count < 100
			init = @_configure()
			count++

		if (!init)
			errors = "PC >> Component configuration errors\n"

			for hwc in @items
				if (!hwc.initialised())
					errors += "component " + hwc.toString() + " not configured\n"

			console.log errors
			alert errors
			return false

	execute: ->
#		console.log "PC execute"
		return @executeVirtual8086()
#		if (processor.isProtectedMode())
#			if (processor.isVirtual8086Mode())
#				return executeVirtual8086()
#			else
#				return executeProtected()
#
#		else
#			return executeReal()
	executeVirtual8086: ->
		x86Count = 0
		clockx86Count = 0
		nextClockCheck = @INSTRUCTIONS_BETWEEN_INTERRUPTS

		for i in [0..99]
			block = 0
			#block = @linearAddr.executeVirtual8086(@proc, @proc.getInstructionPointer())

			x86Count += block
			clockx86Count += block

			if (x86Count > nextClockCheck)
				nextClockCheck = x86Count + @INSTRUCTIONS_BETWEEN_INTERRUPTS
				proc.processVirtual8086Modeinterrupts(clockx86Count)
				clockx86Count = 0

		return x86Count
