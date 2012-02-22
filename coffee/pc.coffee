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

SYS_RAM_SIZE = 1024 * 1024 * 5
# Pas: PhysicalAddressSpace
# Las: LinearAddressSpace
proc = pas = manager = las = null


class pc
	constructor: ->
		log "pc.construct"
	create: ->
		log "pc.create"
		@items = new Array()
		@count = 0
		@configured = false
		@started = false

		@INSTRUCTIONS_BETWEEN_INTERRUPTS = 1
		@stp = false

		@general = new general()
		proc= new processor()

		manager = new CodeBlockManager
		pas = new PhysicalAddressSpace(manager)
		las = new LinearAddressSpace
		@add(pas)
		@add(las)

		@add(proc)
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
				log "stop"
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
		log "PC stopped"

	updateMHz: () ->
		log "updateMHz"
		return

	stop: ->
		@running = false
		@stp = true
		log "STOP!"

		alert("stop")

		@proc = null


	_configure: ->
		init = true
		for part in @items

			if (part.initialised())
				continue

			for inner in @items
				log "acceptComponent on " + part
				part.acceptComponent(inner)

			init &= part.initialised()
		return init
	configure: ->
		if (@configured)
			throw "Already configured"

		count = 1
		init = @_configure()

		log "Init: " + init

		while !init && count < 100
			log "init loop"
			init = @_configure()
			count++

		if (!init)
			errors = "PC >> Component configuration errors\n"

			for hwc in @items
				if (!hwc.initialised())
					errors += "component " + hwc + " not configured\n"

			log errors
			alert errors
			return false
		@configured = true

	execute: ->
#		log "PC execute"
		if (!proc.isProtectedMode())
			throw "Only protected Mode is supported."
		if (proc.isVirtual8086Mode())
			throw "Virtual8086 Mode is not supported."

		return @executeProtected()

	executeReal: ->
		throw "Real mode is not supported"

	executeProtected: ->
		x86Count = 0
		clockx86Count = 0
		nextClockCheck = @INSTRUCTIONS_BETWEEN_INTERRUPTS

		try
			for i in [0...100]
				block = las.executeProtected(proc, proc.getInstructionPointer())
				x86Count += block
				clockx86Count += block

				if (x86Count > nextClockCheck)
					nextClockCheck = x86Count + @INSTRUCTIONS_BETWEEN_INTERRUPTS
					proc.processProtectedModeInterrupts(clockx86Count)
					clockx86Count = 0


			return x86Count
		catch e
			if (e instanceof ProcessorException)
				proc.handleProtectedModeException(e)
			else
				throw e
