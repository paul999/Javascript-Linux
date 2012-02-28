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

class ProtectedModeUBlock extends MicrocodeSet

	constructor: (@microcodes, x86lengths) ->
		super()

		@parityMap = new Array(256)

		for i in [0...@parityMap.length]
			@parityMap[i] = ((@NumberOfSetBits(i) & 0x1) == 0)

		@cumulativeX86Length = x86lengths

		if (@cumulativeX86Length.length == 0)
			@x86Count = 0
		else
			count = 1

			for i in [i...@cumulativeX86Length.length]
				if (@cumulativeX86Length[i] > @cumulativeX86Length[i-1])
					count++
			@x86Count = count

	NumberOfSetBits: (i) ->
		i = i - ((i >> 1) & 0x55555555)
		i = (i & 0x33333333) + ((i >> 2) & 0x33333333)
		return (((i + (i >> 4)) & 0x0F0F0F0F) * 0x01010101) >> 24

	getX86Length: ->
		if (@microcodes.length == 0)
			return 0
		return @cumulativeX86Length[@microcodes.length-1]

	execute: ->

		if (@opcodeCounter && @opcodeCounter != null)
			opcodeCounter.addBlock(@getMicrocodes())

		seg0 = null
		seg0 = proc.ecx
		addr0 = 0
		reg0 = 0
		reg1 = 0
		reg2 = 0
		reg0l = 0
		freg0 = 0.0
		greg1 = 0.0
		@executeCount = @x86Count
		eipUpdated = false
		position = 0

#		log "Going to execute the next microcodes: "

#		for i in [position...@microcodes.length]
#			log @microcodes[i]


		try
			while position < @microcodes.length
#				log "Executing microcode: " + @microcodes[position]
				switch @microcodes[position]
					when @EIP_UPDATE
						if (!eipUpdated)
							eipUpdated = true
							proc.eip += @cumulativeX86Length[position]
					when @UNDEFINED
						log "Unknown/undefined OPcode."
						throw ProcessorException.UNDEFINED

					when @MEM_RESET
						addr0 = 0
						seg0 = null

					when @LOAD1_AL
						reg1 = proc.eax & 0xff

					when @ADD
						reg2 = reg0
						reg0 = reg2 + reg1
						log "Add: #{reg1} new value: #{reg0}"

					when @LOAD0_MEM_BYTE
						reg0 = 0xff & seg0.getByte(addr0)

					when @STORE0_MEM_BYTE
						seg0.setByte(addr0, reg0)
					else
						throw "Not added opcode yet? #{@microcodes[position]}"
				position++
		catch e
			throw e

		return @executeCount
