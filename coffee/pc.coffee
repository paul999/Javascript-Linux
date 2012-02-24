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
proc = pas = manager = las = Clock = sgm = null


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

		sgm = new SegmentFactory()

		@general = new general()
		proc= new processor()
		Clock = new clock
		try
			manager = new CodeBlockManager
			pas = new PhysicalAddressSpace(manager)
			las = new LinearAddressSpace
		catch e
			@printStackTrace e

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

		# Loading the start files
		document.getElementById("start").disabled = false

	loadedstart: (result) ->
		if (!result)
			log "There had been an error loadeding the files"
			return
		window.pc.start2()

	savememory: (data, address) ->
		log "saving file data at #{address} with length #{data.length}"


		load = 0x10000
		endLoadAddress = 0x100000000 - data.length
		nextBlockStart = (load & pas.INDEX_MASK) + pas.BLOCK_SIZE;
		ep = new EPROMMemory(pas.BLOCK_SIZE, manager)
		ep.load(load & pas.BLOCK_MASK, data, 0, nextBlockStart - load)

		pas.mapMemory(load & pas.INDEX_MASK, ep);

		pas.copyArrayIntoContents(endLoadAddress, data, 0, data.length)

		imageOffset = nextBlockStart - load
		epromOffset = nextBlockStart
		log "Writing to #{epromOffset}"

		while (imageOffset + pas.BLOCK_SIZE) <= data.length
			ep = new EPROMMemory(pas.BLOCK_SIZE, manager)
			ep.load2(data, imageOffset, pas.BLOCK_SIZE)
			log "Writing #{ep} to #{epromOffset}"
			pas.mapMemory(epromOffset, ep)
			epromOffset += pas.BLOCK_SIZE
			imageOffset += pas.BLOCK_SIZE

		if (imageOffset < data.length)
			ep = new EPROMMemory(pas.BLOCK_SIZE, 0, data, imageOffset, data.length - imageOffset, manager)
			log "Writing #{ep} to #{epromOffset}"
			pas.mapMemory(epromOffset, ep)

		return true

	add: (itm) ->
		@items[@count] = itm
		@count++

	start: ->
		@configure()

		loadFile("linuxstart.bin", 0x10000, @loadedstart, @savememory)
	start2: ->

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
		if (!@running)
			return
		@running = false
		@stp = true
		log "STOP!"

		@proc = null
		document.getElementById("stop").disabled = true
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
				@printStackTrace(e)
				@printMemory()
				window.pc.stop()

				throw "STOP!"
	printMemory: () ->
		#f0000
		log "Start dumping..."
		prev = null
		start = 0
		for i in [0...0x500000]
			t = pas.getMemoryBlockAt(i)
			s = t.toString()
			if (prev == null)
				prev = s
				start = i
				continue
			if (prev == s)
				continue
			if (prev != s)
				m = i - 1
				log "Location #{start} to #{m} is #{prev}"
				prev = s
				start = i
				continue
		log "Location #{start} to #{i} is #{prev}"
		log "Dumped"

	printStackTrace: (e) ->
		callstack = new Array()
		isCallstackPopulated = false
		if (e.stack)
			lines = e.stack.split("\n")
			log "Exception trace I got:: "
			for i in [0...lines.length]

				log(lines[i])

			callstack.shift()
			isCallstackPopulated = true
		else if (window.opera && e.message)
			log "b"
			lines = e.message.split('\n')
			for i in [0...lines.length]
				if (lines[i].match(/^\s*[A-Za-z0-9\-_\$]+\(/))
					entry = lines[i]
					if (lines[i+1])
						entry += ' at ' + lines[i+1]
						i++
					callstack.push(entry)
			callstack.shift()
			isCallstackPopulated = true


		if (!isCallstackPopulated)
			log "c"
			currentFunction = arguments.callee.caller
			while (currentFunction)
				fn = currentFunction.toString()
				fname = fn.substring(fn.indexOf("function") + 8, fn.indexOf('')) || 'anonymous'
				callstack.push(fname)
				currentFunction = currentFunction.caller
