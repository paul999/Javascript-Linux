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

SYS_RAM_SIZE = 1024 * 1024 * 32
proc = manager = Clock = sgm = term = null

class PC
	constructor: ->
		log "pc.construct"
		proc = null
		sgm = null
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
#		@add(new GateA20Handler()) #Needed?, Yes

#		@add(new Keyboard)

		# Loading the start files

		@resetMemory()

		try

			if (!term || term.closed) && !!Terminal
				tmp = {x: 220, y: 70, termDiv: 'termDiv', bgColor: '#232e45', greeting: '', wrapping: true}
				#handler: termHandler, exitHandler: termExitHandler,
				term = new Terminal(tmp)
				term.open()

				window.mainPane = document.getElementById('mainPane')

				if (mainPane)
					mainPane.className = 'lh15 dimmed'
		catch e
			log "Could not open Term. Running tests?"
		document.getElementById("start").disabled = false

		return true

	saveMemory: (data, len, address) =>
		log "saving file data at #{address} with length #{data.length}"

		if typeof data == "string"
			for i in [0...len]
				rs = parseInt(data.charCodeAt(i))

				if (isNaN(rs))
					rs = null
				addr = address + i

				if (!@setMemory(8, addr, parseInt(rs)))
					throw new MemoryOutOfBound()
		else
			for i in [0...len]
				rs = parseInt(data[i])

				if (isNaN(rs))
					rs = null
				addr = address + i

				if (!@setMemory(8, addr, parseInt(rs)))
					throw new MemoryOutOfBound()

		return true

	add: (itm) ->
		@items[@count] = itm
		@count++

	start: ->
		@create()
		@configure()

		if (!@configured)
			return

		data = window.start
		@saveMemory(data, data.length, 0x10000)
		data = window.kernel
		@saveMemory(data, data.length, 0x00100000)

		st = "console=ttyS0 root=/dev/hda ro init=/sbin/init notsc=1"
		loc = 0xf800 #& 0xff
		for i in [0...st.length]
			if (!window.pc.setMemory(8, loc+i, (st.charCodeAt(i) & 0xff)))
				throw new memoryOutOfBound()
			loc++

		@running = true


		COUNTDOWN = 10000000
		COUNTDOWN = 1000
		markTime = 0#System.currentTimeMillis()
		execCount = COUNTDOWN
		totalExec = 0

		while @running
			if (@stp)
				log "stop"
				break

			execCount -= @execute()
			execCount -= 1
			if (execCount > 0)
				continue

			totalExec += (COUNTDOWN - execCount)
			execCount = COUNTDOWN
			if (@updateMHz(markTime, totalExec))
				markTime = 0 #System.currentTimeMillis()
				totalExec = 0
#				return

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
			prot = proc.isProtectedMode()
			for i in [0...100]

				block = manager.getCodeBlockAt(proc.getInstructionPointer(), proc.cs.getDefaultSizeFlag())

				block = block.execute()
				x86Count += block
				clockx86Count += block

				if (x86Count > nextClockCheck)
					nextClockCheck = x86Count + @INSTRUCTIONS_BETWEEN_INTERRUPTS

					if (prot)
						proc.processProtectedModeInterrupts(clockx86Count)
					else
						proc.processRealModeInterrupts(clockx86Count)
					clockx86Count = 0


			return x86Count
		catch e
			if (e instanceof ProcessorException)
				proc.handleProtectedModeException(e)
			else
				@printStackTrace(e)
				window.pc.stop()

				throw e
	getMemoryLength: (type = "") ->
		if (!type || type == "" || type == 8)
			return @mem.byteLength
		type /= 2
		return @mem.byteLength / type

	getMemoryOffset: (type = "", offset = null) =>
		if !offset || offset == null
			return false
		switch type
#			when ""
#				tmp = @mem[offset]
			when 8
				tmp = @mem8[offset]
			when 16
				tmp = @mem16[offset]
			when 32
				tmp = @mem32[offset]
			else
				return false
		if (tmp == null || tmp == 'undefined' || isNaN(tmp))
			log "getMemoryOffset: read null/undefined (type; #{type}, offset: #{offset}"

		tmp = parseInt tmp
		return tmp

	setMemory: (type = "err", offset = "err", data = "err") =>

		if (type == "err" || offset == "err" || data == "err")
			log "Set memory requires 3 parameters"
			return false

		if !(@ instanceof PC)
			log "Running setMemory from window?"
			return window.pc.setMemory(type, offset, data)

		if ((!offset && offset != 0) || (data == null || data == 'undefined'))
			log "Set memory missing offset/data: #{offset} #{data}"
			tmp = null
			tmp.getError()
			return false

		len = @getMemoryLength(type, offset)
		if (!len)
			log "Memory returned a zero length."
		if (offset > len)
			log "Set memory length error: len: #{len} offset: #{offset} result: " + (offset > len)
			tmp.getError()
			return false

		switch type
			when ""
				return false
			when 8
				@mem8[offset] = data
			when 16
				@mem16[offset] = data
			when 32
				@mem32[offset] = data
			else
				return false
		return true
	resetMemory: =>
		@mem = new ArrayBuffer(SYS_RAM_SIZE + 16);
		@mem8 = new Uint8Array(@mem, 0, SYS_RAM_SIZE + 16);
		@mem16 = new Uint16Array(@mem, 0, (SYS_RAM_SIZE + 16) / 2);
		@mem32 = new Int32Array(@mem, 0, (SYS_RAM_SIZE + 16) / 4);


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
