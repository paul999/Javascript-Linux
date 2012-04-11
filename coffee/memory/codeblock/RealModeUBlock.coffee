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
		@eipUpdated = false

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
						reg0 = @microcodes[position++]
					when @STORE0_SP
						proc.esp = (proc.esp) | (reg0)
					when @LOAD0_MEM_WORD
						reg0 = seg0.getWord(addr0)
					when @LOAD1_AX
						reg1 = proc.eax
					when @ADD
						reg2 = reg0
						reg0 = reg2 + reg1
					when @STORE0_MEM_WORD
						seg0.setWord(addr0, reg0)
					when @MEM_RESET
						addr0 = 0
						seg0 = null
					when @LOAD0_CX
						reg0 = proc.ecx
					when @PUSH_O16_A16
						@push_o16_a16(reg0)
					when @CALL_O16_A16
						@call_o16_a16(reg0)
					when @LOAD0_BX
						reg0 = proc.ebx
					when @LOAD0_AX
						reg0 = proc.eax
					when @LOAD0_MEM_BYTE
						try
							reg0 = 0xff & seg0.getByte(addr0)
						catch e
							log "Load, Geen seg0?"
							log e
					when @LOAD1_AL
						reg1 = proc.eax
					when @STORE0_MEM_BYTE
						try
							seg0.setByte(addr0, reg0) #check.
						catch e
							log "Store, Geen seg0?"
							log e
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
					when @ADD_O8_FLAGS
						@add_o8_flags(reg0, reg2, reg1)
					when @OR
						reg0 |= reg1
					when @STORE0_AX
						proc.eax = (proc.eax) | (reg0)
					when @BITWISE_FLAGS_O16
						@bitwise_flags(reg0) #check was short
					when @LOAD0_AL
						reg0 = proc.eax
					when @LOAD1_BH
						reg1 = (proc.ebx >> 8)
					when @STORE0_AL
						proc.eax = (proc.eax) | (reg0)
					when @LOAD0_DX
						reg0 = proc.edx

					when @OUTSW_A16
						@outsw_a16(reg0, seg0)
					when @LOAD_SEG_SS
						seg0 = proc.ss
					when @ADDR_BP
						addr0 += (proc.ebp) #check, was short.
					when @ADDR_IB
						addr0 += byte(@microcodes[position++]) #check.
					when @LOAD1_CH
						reg1 = (proc.ecx >> 8)
					when @LOAD0_IB
						reg0 = @microcodes[position++]
					when @JNC_O8
						@jnc_o8(byte(reg0)) #check
					when @ADDR_DI
						addr0 += (proc.edi) #short
					when @LOAD1_DH
						reg1 = (proc.edx >> 8)
					when @JZ_O8
						@jz_o8(byte(reg0)) #byte
					when @JNS_O8
						@jns_o8(byte(reg0))
					when @JC_O8
						@jc_o8(byte(reg0))
					when @LOAD1_AH
						reg1 = (proc.eax >> 8)
					when @LOAD1_IW
						reg1 = @microcodes[position++]
					when @SUB
						reg2 = reg0
						reg0 = reg2 - reg1
					when @SUB_O16_FLAGS
						@sub_o16_flags(reg0, reg2, reg1)
					when @DAS
						@das()
					when @LOAD_SEG_FS
						seg0 = proc.fs
					when @AND
						reg0 &= reg1
					when @BITWISE_FLAGS_O8
						@bitwise_flags(byte(reg0))
					when @OUTSB_A16
						@outsb_a16(reg0, seg0)
					when @LOAD0_MEM_DWORD
						reg0 = seg0.getDoubleWord(addr0)
#					when @BOUND_O16
						#geen idee nog...

#		short lower = (short)reg0;
#		short upper = (short)(reg0 >> 16);
#		short index = (short)reg1;
#		if ((index < lower) || (index > (upper + 2)))
#		    throw ProcessorException.BOUND_RANGE;
						log "BOUND"

					when @UNDEFINED
						break
					when @IMUL_O16
						reg0 = @imul_o16(reg0, reg1) #short
					when @LOAD0_DL
						reg0 = proc.edx
					when @ADDR_IW
						addr0 += (@microcodes[position++]) #short
					when @CLC
						proc.setCarryFlagBool(false)
					when @LOAD1_DL
						reg1 = proc.edx
					when @LOAD1_CL
						reg1 = proc.ecx
					when @LOAD1_BL
						reg1 = proc.ebx
					when @ADC
						reg2 = reg0
						reg0 = reg2 + reg1 + (proc.getCarryFlag() ? 1 : 0)
					when @ADC_O8_FLAGS
						@adc_o8_flags(reg0, reg2, reg1)
					when @SBB
						reg2 = reg0
						reg0 = reg2 - (reg1 + (proc.getCarryFlag() ? 1 : 0))
					when @SBB_O8_FLAGS
						@sbb_o8_flags(reg0, reg2, reg1)
					when @XOR
						reg0 ^= reg1
					when @INC
						reg0++
					when @STORE0_BX
						proc.ebx = (proc.ebx) | (reg0)
					when @INC_O16_FLAGS
						@inc_flagsShort(reg0) #short
					when @LOAD0_CS
						reg0 = proc.cs.getSelector()
					when @STORE0_CX
						proc.ecx = (proc.ecx) | (reg0)
					when @JNP_O8
						@jnp_o8(byte(reg0))
					when @LOAD0_ESI
						reg0 = proc.esi
					when @LOAD0_ES
						reg0 = proc.es.getSelector()
					when @LOAD1_IB
						reg1 = @microcodes[position++]
					when @LOAD0_BL
						reg0 = proc.ebx
					when @STORE0_BL
						proc.ebx = (proc.ebx) | (reg0)
					when @LOAD0_CL
						reg0 = proc.ecx
					when @STORE0_CL
						proc.ecx = (proc.ecx) | (reg0)
					when @CWD
						if ((proc.eax & 0x8000) == 0)
							proc.edx &= 0xffff0000
						else
							proc.edx |= 0x0000ffff
					when @LOAD0_AH
						reg0 = (proc.eax >> 8)
					when @STORE0_AH
						proc.eax = (proc.eax) | ((reg0 << 8))
					when @INT3_O16_A16
						@int3_o16_a16()
					when @LOAD0_BP
						reg0 = proc.ebp

					when @LOAD0_SP
						reg0 = proc.esp
					when @STORE0_BP
						proc.ebp = (proc.ebp) | (reg0)
					when @LOAD0_SI
						reg0 = proc.esi
					when @LOAD0_DH
						reg0 = (proc.edx >> 8)
					when @STORE0_DH
						proc.edx = (proc.edx) | ((reg0 << 8))
					when @STORE0_DL
						proc.edx = (proc.edx) | (reg0)
					when @STORE1_MEM_BYTE
						seg0.setByte(addr0, byte(reg1))
					when @LOAD1_MEM_BYTE
						reg1 = seg0.getByte(addr0)
					when @LOAD0_SS
						reg0 = proc.ss.getSelector()
					when @ADDR_ID
						addr0 += @microcodes[position++]
					when @LOAD1_MEM_DWORD
						reg1 = seg0.getDoubleWord(addr0)
					when @LGDT_O16
						proc.gdtr = proc.createDescriptorTableSegment(reg1 & 0x00ffffff, reg0)
					when @LOAD1_DX
						reg1 = proc.edx
					when @STORE0_DX
						proc.edx = (proc.edx) | (reg0)
					when @STORE1_AX
						proc.eax = (proc.eax) | (reg1)
					when @LOOP_CX
						proc.ecx = (proc.ecx) | ((proc.ecx - 1))
						if ((proc.ecx) != 0)
							@jump_o8(byte(reg0))
					when @STORE0_DS
						proc.ds.setSelector(reg0)
					when @STORE0_ES
						proc.es.setSelector(reg0)
					when @STORE0_FS
						proc.fs.setSelector(reg0)
					when @STORE0_GS
						proc.gs.setSelector(reg0)
					when @STORE0_SS
						proc.ss.setSelector(reg0)
					when @LOAD0_ADDR
						reg0 = addr0
					when @STORE0_DI
						proc.edi = (proc.edi) | (reg0)
					when @SUB_O8_FLAGS
						@sub_o8_flags(reg0, reg2, reg1)
					when @LOAD1_DI
						reg1 = proc.edi
					when @STORE0_SI
						proc.esi = (proc.esi) | (reg0)
					when @LOAD0_BH
						reg0 = (proc.ebx >> 8)
					when @STORE0_BH
						proc.ebx = (proc.ebx) | ((reg0 << 8))
					when @SAR_O16
						reg1 &= 0x1f
						reg2 = reg0
						reg0 = (reg0) >> reg1
					when @SAR_O16_FLAGS
						@sar_flags(reg0, reg2, reg1) #short 0 en 2
					when @SHR
						reg2 = reg0
						reg0 >>>= reg1
					when @SHR_O16_FLAGS
						@shr_flags_short(reg0, reg2, reg1)
					when @LOAD0_ID
						reg0 = @microcodes[position++]
					when @STORE0_MEM_DWORD
						seg0.setDoubleWord(addr0, reg0)
					when @LOOPNZ_CX
						proc.ecx = (proc.ecx) | ((proc.ecx - 1))
						if (((proc.ecx) != 0) && !proc.getZeroFlag())
							@jump_o8(byte(reg0))
					when @LOAD1_CX
						reg1 = proc.ecx
					when @AAM
						reg0 = @aam(reg0)
					when @JUMP_O16
						@jump_o16(reg0) #short
					when @LOOPZ_CX
						proc.ecx = (proc.ecx) | ((proc.ecx - 1))
						if (((proc.ecx) != 0) && proc.getZeroFlag())
							@jump_o8(byte(reg0))
					when @REP_STOSW_A16
						@rep_stosw_a16(reg0)
					when @CLD
						proc.eflagsDirection = false
					when @REP_MOVSW_A16
						@rep_movsw_a16(seg0)
					when @IN_O16
						reg0 = proc.ioports.ioPortReadWord(reg0)
					when @IN_O8
						reg0 = proc.ioports.ioPortReadByte(reg0)
					when @LOAD0_DI
						reg0 = proc.edi
#					when @LOAD0_DR7
#						reg0 = proc.getDR7() #komt van protected.

					when @SBB_O16_FLAGS
						@sbb_o16_flags(reg0, reg2, reg1)
#					when @SLDT
#						reg0 = proc.ldtr.getSelector() # alleen protected?
					when @CALL_ABS_O16_A16
						@call_abs_o16_a16(reg0)
					when @INC_O8_FLAGS
						@inc_flags_byte(byte(reg0))
					when @INC_O16_FLAGS
						@inc_flags_short(short(reg0))
					when @INC_O32_FLAGS
						@inc_flags_int(reg0)

					when @CLC
						proc.setCarryFlagBool(false)
					when @STC
						proc.setCarryFlagBool(true)
					when @STI
						proc.eflagsInterruptEnableSoon = true
					when @CLI
						proc.eflagsInterruptEnable = proc.eflagsInterruptEnableSoon = false
					when @STD
						proc.eflagsDirection = true

					when @LOAD0_AH
						reg0 = (proc.eax >> 8)
					when @LOAD0_CH
						reg0 = (proc.ecx >> 8)
					when @LOAD0_DH
						reg0 = (proc.edx >> 8)
					when @LOAD0_BH
						reg0 = (proc.ebx >> 8)

					when @STORE0_AH
						proc.eax = (proc.eax) | ((reg0 << 8))
					when @STORE0_CH
						proc.ecx = (proc.ecx) | ((reg0 << 8))
					when @STORE0_DH
						proc.edx = (proc.edx) | ((reg0 << 8))
					when @STORE0_BH
						proc.ebx = (proc.ebx) | ((reg0 << 8))

					when @SIGN_EXTEND_8_16
						reg0 = 0xffff & byte(reg0)
					when @SIGN_EXTEND_8_32
						reg0 = byte(reg0)
					when @SIGN_EXTEND_16_32
						reg0 = short(reg0)

					when @LOAD1_MEM_WORD
						reg1 = seg0.getWord(addr0)

					when @CALL_FAR_O16_A16
						@call_far_o16_a16(reg0, reg1)


					else
						throw "Possible missing microcode: #{mc}"
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
		old = proc.eip
		proc.eip = proc.eip + target

		log "Eip: #{old} Target: #{target} new EIP: #{proc.eip}"

	adc_o16_flags: (result, operand1, operand2) ->
		if (proc.getCarryFlag() && (operand2 = 0xffff))
			@arithmetic_flags_o16(result, operand1, operand2)
			proc.setOverflagFlagBool(false)
			proc.setCarryFlagBool(true)
		else
			proc.setOverflowFlag3(result, operand1, operand2, proc.OF_ADD_SHORT)
			@arithmetic_flags_o16(result, operand1, operand2)
	add_o16_flags: (result, operand1, operand2) ->
		@arithmetic_flags_o16(result, operand1, operand2)
		proc.setOverflowFlag3(result, operand1, operand2, proc.OF_ADD_SHORT)

	arithmetic_flags_o16: (result, operand1, operand2) ->
		proc.setZeroFlagInt(result)
		proc.setParityFlagInt(result)
		proc.setSignFlagInt(result)

		proc.setCarryFlag1(result, proc.CY_TWIDDLE_FFFF)
		proc.setAuxiliaryCarryFlag3(operand1, operand2, result, proc.AC_XOR)

	add_o8_flags: (result, operand1, operand2) ->
		@arithmetic_flags_o8(result, operand1, operand2)
		proc.setOverflowFlag3(result, operand1, operand2, proc.OF_ADD_BYTE)

	arithmetic_flags_o8: (result, operand1, operand2) ->
		proc.setZeroFlagInt(result)
		proc.setParityFlagInt(result)
		proc.setSignFlagInt(result)

		proc.setCarryFlag1(result, proc.CY_TWIDDLE_FF)
		proc.setAuxiliaryCarryFlag3(operand1, operand2, result, proc.AC_XOR)

	bitwise_flags: (result) ->
		proc.setOverflowFlagBool(false)
		proc.setCarryFlagBool(false)
		proc.setZeroFlagInt(result)
		proc.setParityFlagInt(result)
		proc.setSignFlagInt(result)
	outsw_a16: (port, storeSegment) ->
		addr = proc.esi & 0xffff

		if (!port)
			throw "Port is undefined: #{port}"

		proc.ioports.ioPortWriteWord(port, 0xffff & storeSegment.getWord(addr))

		if (proc.eflagsDirection)
			addr -= 2
		else
			addr += 2

		proc.esi = (proc.esi & ~0xffff) | (addr & 0xffff)
	jnc_o8: (offset) ->
		if (!proc.getCarryFlag())
			@jump_o8(offset)

	jump_o8: (offset) ->
		proc.eip += offset

#		if (proc.eip & 0xffff0000) != 0
#			proc.eip -= offset
#			throw ProcessorException.GENERAL_PROTECTION_0

	jz_o8: (offset) ->
		if (!proc.getZeroFlag())
			@jump_o8(offset)

	jns_o8: (offset) ->
		if (!proc.getSignFlag())
			@jump_o8(offset)

	sub_o16_flags: (result, operand1, operand2) ->
		@arithmetic_flags_o16(result, operand1, operand2)
		proc.setOverflowFlag3(result, operand1, operand2, proc.OF_SUB_SHORT)

	das: ->
		tempCF = false

		tempAL = 0xff & proc.eax

		if (((tempAL & 0xf) > 0x9) || proc.getAuxiliaryCarryFlag())
			proc.setAuxiliaryCarryFlagBool(true)
			proc.eax = (proc.eax & ~0xff) | ((proc.eax - 0x06) & 0xff)
			tempCF = ( tempAL < 0x06) || proc.getCarryFlag()
		if (tempAL > 0x99) || proc.getCarryFlag()
			proc.eax = (proc.eax & ~0xff) | ((proc.eax - 0x60) & 0xff)
			tempCF = true
		proc.setOverflowFlagBool(false)
		proc.setZeroFlagInt(proc.eax)
		proc.setParityFlagInt(proc.eax)
		proc.setSignFlagInt(proc.eax)

		proc.setCarryFlagBool(tempCF)

	jc_o8: (offset)	 ->
		if (proc.getCarryFlag())
			@jump_o8(offset)

	outsb_a16: (port, storeSegment) ->
		addr = proc.esi & 0xffff

		proc.ioports.ioPortWriteByte(port, 0xff & storeSegment.getByte(addr))

		if (proc.eflagsDirection)
			addr -= 1
		else
			addr += 1

		proc.esi = (proc.esi & ~0xffff) | (addr & 0xffff)

	imul_o16: (data0, data1) ->
		result = data0 * data1
		proc.setOverflowFlag1(result, proc.OF_NOT_SHORT)
		proc.setCarryFlag1(result, proc.CY_NOT_SHORT)
		return result

	adc_o8_flags: (result, operand1, operand2) ->
		if (proc.getCarryFlag() && operand2 == 0xff)
			@arithmetic_flags_o8(result, operand1, operand2)
			proc.setOverflowFlagBool(false)
			proc.setCarryFlagBool(true)
		else
			proc.setOverflowFlag3(result, operand1, operand2, proc.OF_ADD_BYTE)
			@arithmetic_flags_o8(result, operand1, operand2)

	sbb_o8_flags: (result, operand1, operand2) ->
		proc.setOverflowFlag3(result, operand1, operand2, proc.OF_SUB_BYTE)
		@arithmetic_flags_o8(result, operand1, operand2)

	inc_flagsShort: (result) ->
		proc.setZeroFlagBool(result)
		proc.setParityFlagBool(result)
		proc.setSignFlagBool(result)
		proc.setOverflowFlag1(result, proc.OF_MIN_SHORT)
		proc.setAuxiliaryCarryFlag1(result, proc.AC_LNIBBLE_ZERO)

	jnp_o8: (offset) ->
		if (!proc.getParityFlag())
			@jump_o8(offset)

	int3_o16_a16: ->
		vector = 3

		if (((proc.esp & 0xffff) < 6) && ((proc.esp & 0xffff) > 0))
			throw new IllegalStateException("SS Processor Exception Thrown in \"handleInterrupt(#{vector})\"")

		proc.esp = (proc.esp & 0xffff0000) | (0xffff & (proc.esp - 2))
		eflags = proc.getEFlags() & 0xffff
		proc.ss.setWord(proc.esp & 0xffff, eflags) #short
		proc.eflagsInterruptEnable = false
		proc.eflagsInterruptEnableSoon = false
		proc.eflagsTrap = false
		proc.eflagsAlignmentCheck = false
		proc.esp = (proc.esp & 0xffff0000) | (0xffff & (proc.esp - 2))
		proc.ss.setWord(proc.esp & 0xffff, proc.cs.getSelector()) #short
		proc.esp = (proc.esp & 0xffff0000) | (0xffff & (proc.esp - 2))
		proc.ss.setWord(proc.esp & 0xffff, proc.eip) #short

		proc.eip = 0xffff & proc.idtr.getWord(4*vector)
		proc.cs.setSelector(0xffff & proc.idtr.getWord(4*vector+2))

	sub_o8_flags: (result, operand1, operand2) ->
		@arithmetic_flags_o8(result, operand1, operand2)
		proc.setOverflowFlag3(result, operand1, operand2, proc.OF_SUB_BYTE)

	sar_flags: (result, initial, count) ->
		if (count > 0)
			proc.setCarryFlag2(initial, count, proc.CY_SHR_OUTBIT)

			if (count == 1)
				proc.setOverflowFlagBool(false)

			proc.setSignFlagBool(result)
			proc.setZeroFlagBool(result)
			proc.setParityFlagBool(result)
	shr_flags_short: (result, initial, count) ->
		if count > 0
			proc.setCarryFlag2(initial, count, proc.CY_SHR_OUTBIT)

			if count == 1
				proc.setOverflowFlag2(result, initial, proc.OF_BIT15_DIFFERENT)

			proc.setZeroFlagBool(result)
			proc.setParityFlagBool(result)
			proc.setSignFlagBool(result)
	aam: (base) ->
		tl = proc.eax

		if base == 0
			throw ProcessorException.DIVIDE_ERROR

		ah = (tl / base)
		al = (tl % base)
		proc.eax |= (al | (ah << 8))

		proc.setAuxiliaryCarryFlagBool(false)

		return al
	jump_o16: (offset) ->
		log "Jump. Old: #{proc.eip}, offset: #{offset} new " + (proc.eip + offset)
		proc.eip += offset

	rep_stosw_a16: (data) ->
		count = proc.ecx
		addr = proc.edi

		@executeCount += count

		if proc.eflagsDirection
			while count != 0
				proc.es.setWord(addr, data) #short
				count--
				addr -= 2
		else
			while count != 0
				proc.es.setWord(addr, data) #short
				count--
				addr += 2
		proc.ecx = proc.ecx | count
		proc.edi = proc.edi | addr

	rep_movsw_a16: (segment) ->
		count = proc.ecx
		inAddr = proc.edi
		outAddr = proc.esi
		@executeCount += count

		if (proc.eflagsDirection)
			while count != 0
				dt = segment.getWord(outAddr)

#				if (!dt)
#					log "Got a 'null/undefined/false' value from segment: #{dt}, addr: #{outAddr}"

				proc.es.setWord(inAddr, dt)
				count--
				outAddr -= 2
				inAddr -= 2

		else
			while count != 0
				dt = segment.getWord(outAddr)

#				if (!dt)
#					log "Got a 'null/undefined/false' value from segment: #{dt}, addr: #{outAddr}"

				proc.es.setWord(inAddr, dt)
				count--
				outAddr += 2
				inAddr += 2
		proc.ecx = proc.ecx | count
		proc.edi = proc.edi | inAddr
		proc.esi = proc.esi | outAddr

	sbb_o16_flags: (result, operand1, operand2) ->
		proc.setOverflowFlag3(result, operand1, operand2, proc.OF_SUB_SHORT)
		@arithmetic_flags_o16(result, operand1, operand2)

	call_abs_o16_a16: (target) ->
		if ((proc.esp < 2) && (proc.esp > 0))
			throw ProcessorException.STACK_SEGMENT_0

		proc.ss.setWord(proc.esp - 2, short(proc.eip))

		proc.esp -= 2
		proc.eip = target
	inc_flags_int: (result) ->
		@_inc_flags(result, proc.OF_MIN_INT)

	inc_flags_short: (result) ->
		@_inc_flags(result, proc.OF_MIN_SHORT)

	inc_flags_byte: (result) ->
		@_inc_flags(result, proc.OF_MIN_BYTE)

	_inc_flags: (result, type) ->
		proc.setZeroFlagBool(result)
		proc.setParityFlagBool(result)
		proc.setSignFlagBool(result)
		proc.setOverflowFlag1(result, type)
		proc.setAuxiliaryCarryFlag1(result, proc.AC_LNIBBLE_ZERO)

	call_far_o16_a16: (targetEIP, targetSelector) ->

		if (proc.esp < 4 && proc.esp > 0)
			throw ProcessorException.STACK_SEGMENT_0

		proc.ss.setWord(proc.esp - 2, short(proc.cs.getSelector()))
		proc.ss.setWord(proc.esp - 4, short(proc.eip))

		proc.esp = (proc.esp) | (proc.esp - 4)

		log "oldEIP: #{proc.eip} targetEIP: #{targetEIP} targetSelector: #{targetSelector}"

		proc.eip = targetEIP
		proc.cs.setSelector(targetSelector)
