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
class pc
	constructor: ->
		console.log "pc.create"
		@items = new Array()
		@count = 0
		@configured = false
		@started = false

		@general = new general

		@manager = new CodeBlockManager
		@PhysicalAddressSpace = new PhysicalAddressSpace(@manager)
		@LinearAddressSpace = new LinearAddressSpace
		@add(@PhysicalAddressSpace)
		@add(@LinearAddressSpace)

		@add(new cpu)
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

	stop: ->

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
