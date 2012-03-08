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

class RealModeUBlock extends MicrocodeSet
	constructor: (@microcodes, x86lengths) ->
		super()
		@transferSeg0 = null
		@transferAddr0 = 0
		@transferReg0 = 0
		@transferReg1 = 0
		@transferReg2 = 0
		@transferEipUpdated = false
		@transferPosition = 0
		@transferFReg0 = 0
		@transferFReg1 = 0

		@uCodeXferReg0 = 0
		@uCodeXferReg1 = 0
		@ucodeXferReg2 = 0

		@uCodeXferLoaded = false

		@cumulativeX86Length = x86lengths

		if (@cumulativeX86Length.length == 0)
			@x86Count = 0
		else
			count = 1

			for i in [1...@cumulativeX86Length.length]
				if @cumulativeX86Length[i] > @cumulativeX86Length[i-1]
					count++

			x86Count = count
	getX86Count: ->
		return @x86Count

	execute: ->
		seg0 = null
		addr0 = 0
		reg0 = 0
		reg1 = 0
		reg2 = 0
		reg0l = 0

		freg0 = 0
		freg1 = 0

		executeCount = @getX86Count()
		eipUpdated = false

		position = 0

		try
			while (position < @microcodes.length)
				if @uCodeXferLoaded
					@uCodeXferLoaded = false
					reg0 = @uCodeXferReg0
					reg1 = @uCodeXferReg1
					reg2 = @uCodeXferReg2
				mc = @microcodes[position++]
				switch (mc)
					when @EIP_UPDATE
						if !@eipUpdated
							@eipUpdated = true
							proc.eip += @cumulativeX86Length[position - 1]
					when @LOAD0_IW
						reg0 = @microcodes[position++] & 0xffff
					when @STORE0_SP
						proc.esp = (proc.esp & ~0xffff) | (reg0 & 0xffff)
					when @LOAD0_MEM_WORD
						reg0 = 0xffff & seg0.getWord(addr0)
					when @LOAD1_AX
						reg1 = proc.eax & 0xffff
					when @ADD
						reg2 = reg0
						reg0 = reg2 + reg1
					when @STORE0_MEM_WORD
						seg0.setWord(addr0, reg0)
					when @MEM_RESET
						addr0 = 0
						seg0 = null
					when @LOAD0_CX
						reg0 = proc.ecx & 0xffff
					when @PUSH_O16_A16
						@push_o16_a16(reg0)
					when @CALL_O16_A16
						@call_o16_a16(reg0)
					when @LOAD0_BX
						reg0 = proc.ebx & 0xffff
					when @LOAD0_AX
						reg0 = proc.eax & 0xffff
					when @LOAD0_MEM_BYTE
						try
							reg0 = 0xff & seg0.getByte(addr0)
						catch e
							log "Geen seg0?"
					when @LOAD1_AL
						reg1 = proc.eax & 0xff
					when @STORE0_MEM_BYTE
						try
							seg0.setByte(addr0, reg0) #check.
						catch e
							log "Geen seg0?"
					when @ADC_O16_FLAGS
						@adc_o16_flags(reg0, reg2, reg1)
					when @LOAD_SEG_DS
						seg0 = proc.ds
					when @ADDR_BX
						addr0 += (proc.ebx) #Check (Was short)
					when @ADDR_SI
						addr0 += (proc.esi) #check was short
					when @ADDR_MASK16
						addr0 &= 0xffff
					when @ADD_O16_FLAGS
						@add_o16_flags(reg0, reg2, reg1)
					else
						log "Possible missing microcode: #{mc}"
						@executefull()
		catch e
			if (e instanceof ProcessorException)

			else
				throw e
	push_o16_a16: (data) ->
		if ((proc.esp & 0xffff) < 2) && ((proc.esp & 0xffff) > 0)
			throw ProcessorException.STACK_SEGMENT_0

		offset = (proc.esp - 2) & 0xffff
		proc.ss.setWord(offset, data)

		proc.esp = (proc.esp & ~0xffff) | offset

	call_o16_a16: (target) ->
		if ((proc.esp & 0xffff) < 2) && ((proc.esp & 0xffff) > 0)
			throw ProcessorException.STACK_SEGMENT_0

		offset = (proc.esp - 2) & 0xffff

		proc.ss.setWord(offset, proc.eip)
		proc.esp = (proc.esp & 0xffff0000) | offset
		proc.eip = (proc.eip + target) & 0xffff #?

	adc_o16_flags: (result, operand1, operand2) ->
		if (proc.getCarryFlag() && (operand2 = 0xffff))
			@arithmetic_flags_o16(result, operand1, operand2)
			proc.setOverflagFlag(false)
			proc.setCarryFlag(true)
		else
			proc.setOverflowFlag(result, operand1, operand2, PC.OF_ADD_SHORT)
			@arithmetic_flags_o16(result, operand1, operand2)
	add_o16_flags: (result, operand1, operand2) ->
		@arithmetic_flags_o16(result, operand1, operand2)
		proc.setOverflowFlag(result, operand1, operand2, PC.OF_ADD_SHORT)

	arithmetic_flags_o16: (result, operand1, operand2) ->
		proc.setZeroFlag(result)
		proc.setParityFlag(result)
		proc.setSignFlag(result)

		proc.setCarryFlag(result, PC.CY_TWIDDLE_FFFF)
		proc.setAuxiliaryCarryFlag(operand1, operand2, result, PC.AC_XOR)
