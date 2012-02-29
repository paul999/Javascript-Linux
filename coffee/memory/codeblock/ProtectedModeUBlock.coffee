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
					when @LOAD0_IW
						reg0 = @microcodes[position++] & 0xffff
					when @LOAD1_IW
						reg1 = @microcodes[position++] & 0xffff
					when @STORE0_SP
						proc.esp = (proc.esp & ~0xffff) | (reg0 & 0xffff)

					when @LOAD0_MEM_WORD
						reg0 = 0xffff & seg0.getWord(addr0)
					when @LOAD_SEG_DS
						log "Loaded a seg0"
						seg0 = proc.ds
						log proc.ds
						log seg0
					when @ADDR_BX
						addr0 += proc.ebx
					when @ADDR_SI
						addr0 += proc.esi
					when @ADDR_MASK16
						addr0 &= 0xffff
					when @SUB_O16_FLAGS
						@sub_o16_flags(reg0, reg2, reg1)


					when @STORE0_MEM_WORD
						seg0.setWord(addr0, reg0)

					when @PUSH_O16_A16, @PUSH_O16_A32
						if (proc.ss.getDefaultSizeFlag())
							@push_o16_a32(reg0)
						else
							@push_o16_a16(reg0)
					when @CALL_O16_A16, @CALL_O16_A32
						if proc.ss.getDefaultSizeFlag()
							@call_o16_a32(reg0)
						else
							@call_o16_a32(reg0)


					when @LOAD0_AX
						reg0 = proc.eax & 0xffff
					when @LOAD0_CX
						reg0 = proc.ecx & 0xffff
					when @LOAD0_DX
						reg0 = proc.edx & 0xffff
					when @LOAD0_BX
						reg0 = proc.ebx & 0xffff
					when @LOAD0_SP
						reg0 = proc.esp & 0xffff
					when @LOAD0_BP
						reg0 = proc.ebp & 0xffff
					when @LOAD0_SI
						reg0 = proc.esi & 0xffff
					when @LOAD0_DI
						reg0 = proc.edi & 0xffff
					when @LOAD1_AX
						 reg1 = proc.eax & 0xffff
					when @LOAD1_CX
						 reg1 = proc.ecx & 0xffff
					when @LOAD1_DX
						 reg1 = proc.edx & 0xffff
					when @LOAD1_BX
						 reg1 = proc.ebx & 0xffff
					when @LOAD1_SP
						 reg1 = proc.esp & 0xffff
					when @LOAD1_BP
						 reg1 = proc.ebp & 0xffff
					when @LOAD1_SI
						 reg1 = proc.esi & 0xffff
					when @LOAD1_DI
						 reg1 = proc.edi & 0xffff


					else
						throw "File: ProtectedModeUBlock: Not added opcode yet? #{@microcodes[position]}"
				position++
		catch e
			throw e

		return @executeCount

	push_o16_a16: (value) ->
		if (((0xffff & proc.esp) < 2) && ((0xfff & proc.esp) > 0))
			throw ProcessorException.STACK_SEGMENT_0

		proc.ss.setWord(((0xfff & proc.esp) - 2) & 0xfff, value)
		proc.esp = (proc.esp &~0xffff) | ((proc.esp - 2) & 0xffff)

	call_o16_a32: (target) ->
		tempEIP = 0xffff * (proc.eip + target)
		proc.cs.checkAddress(tempEIP)

		if ((cpu.esp < 2) && (cpu.esp > 0))
			throw ProcessorException.STACK_SEGMENT_0

		proc.ss.setWord(cpu.esp - 2, (0xffff & proc.eip))
		proc.esp -= 2
		proc.eip = tempEIP
