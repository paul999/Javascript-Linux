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
proc = manager = Clock = sgm = null
mem = mem8 = mem16 = mem32 = null


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
		catch e
			@printStackTrace e
			throw e

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

		mem = new ArrayBuffer(SYS_RAM_SIZE);
		mem8 = new Uint8Array(mem, 0, SYS_RAM_SIZE);
		mem16 = new Uint16Array(mem, 0, SYS_RAM_SIZE / 2);
		mem32 = new Int32Array(mem, 0, SYS_RAM_SIZE / 4);

		document.getElementById("start").disabled = false

	loadedstart: (result) ->
		if (!result)
			log "There had been an error loadeding the files"
			return

			#
		#loadFile("vmlinux-3.0.4-simpleblock.bin", 0x00100000, window.pc.loadedstart2, window.pc.savememory)
		window.pc.start2()

	loadedstart2: (result) ->
		if (!result)
			log "There had been an error loadeding the files"
			return
		window.pc.start2()

	savememory: (data, len, address) ->
		log "saving file data at #{address} with length #{data.length}"

		log "Value1: "  + parseInt(rs)

		for i in [0...len]
			rs = parseInt(data.charCodeAt(i))

			if (isNaN(rs))
				rs = null

#			log "Going to write to buffer[#{address}] #{rs}"

			mem8[address + i] = parseInt(rs)


#		load = address
#		endLoadAddress = 0x100000000 - data.length
#		nextBlockStart = (load & pas.INDEX_MASK);
#		nulldata = address - nextBlockStart
#		log "nextBlockStart: #{nextBlockStart} number: #{nulldata}"

#		for i in [0...nulldata]
#			data = "0#{data}"
#		ep = new EPROMMemory(pas.BLOCK_SIZE, manager)
#		ep.load(load & pas.BLOCK_MASK, data, 0, nextBlockStart - load)

#		pas.mapMemory(load & pas.INDEX_MASK, ep);

#		pas.copyArrayIntoContents(endLoadAddress, data, 0, data.length)

#		imageOffset = 0
#		epromOffset = nextBlockStart
#		log "Writing to #{epromOffset}"
#		written = 0

#		while (written) <= data.length
#			ep = new EPROMMemory(pas.BLOCK_SIZE, manager)
#			ep.load2(data, imageOffset, pas.BLOCK_SIZE)
#			log "Writing #{ep} to #{epromOffset}"
#			pas.mapMemory(epromOffset, ep)
#			epromOffset += pas.BLOCK_SIZE
#			imageOffset += pas.BLOCK_SIZE
#			written += pas.BLOCK_SIZE

#		throw "die"
		return true

	add: (itm) ->
		@items[@count] = itm
		@count++

	start: ->
		@create()
		@configure()

		loadFile("linuxstart.bin", 0x100000, @loadedstart, @savememory)
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
		throw "blargh"
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
				block = manager.getProtectedModeCodeBlockAt(proc.getInstructionPointer(), proc.cs.getDefaultSizeFlag())
				block = block.execute()
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
				window.pc.stop()

				throw "STOP!"

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
			log "No call stack?"
			log e
			currentFunction = arguments.callee.caller
			while (currentFunction)
				fn = currentFunction.toString()
				fname = fn.substring(fn.indexOf("function") + 8, fn.indexOf('')) || 'anonymous'
				callstack.push(fname)
				currentFunction = currentFunction.caller
