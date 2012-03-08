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
#		seg0 = proc.ecx
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

		log "Going to execute the next microcodes: "

		for i in [position...@microcodes.length]
			log @microcodes[i]


		try
			while position < @microcodes.length
				code = @microcodes[position]
				log "Microcode: #{code}"
				position++
				switch code
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

					when @LOAD0_MEM_BYTE
						reg0 = 0xff & seg0.getByte(addr0)

					when @STORE0_MEM_BYTE
						seg0.setByte(addr0, reg0)
					when @LOAD0_IW
						reg0 = @microcodes[position++] & 0xffff
					when @LOAD1_IW
						reg1 = @microcodes[position++] & 0xffff
					when @LOAD1_IB
						reg1 = @microcodes[position++] & 0xff
					when @STORE0_SP
						proc.esp = (proc.esp & ~0xffff) | (reg0 & 0xffff)

					when @LOAD0_MEM_WORD
						log "Segment: " + seg0
						reg0 = 0xffff & seg0.getWord(addr0)
					when @LOAD_SEG_DS
						seg0 = proc.ds
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

					when @STORE0_AX
						proc.eax = (proc.eax & ~0xffff) | (reg0 & 0xffff)
					when @STORE0_CX
						proc.ecx = (proc.ecx & ~0xffff) | (reg0 & 0xffff)
					when @STORE0_DX
						proc.edx = (proc.edx & ~0xffff) | (reg0 & 0xffff)
					when @STORE0_BX
						proc.ebx = (proc.ebx & ~0xffff) | (reg0 & 0xffff)
					when @STORE0_SP
						proc.esp = (proc.esp & ~0xffff) | (reg0 & 0xffff)
					when @STORE0_BP
						proc.ebp = (proc.ebp & ~0xffff) | (reg0 & 0xffff)
					when @STORE0_SI
						proc.esi = (proc.esi & ~0xffff) | (reg0 & 0xffff)
					when @STORE0_DI
						proc.edi = (proc.edi & ~0xffff) | (reg0 & 0xffff)
					when @LOAD0_AL
						 reg0 = proc.eax & 0xff
					when @LOAD0_CL
						 reg0 = proc.ecx & 0xff
					when @LOAD0_DL
						 reg0 = proc.edx & 0xff
					when @LOAD0_BL
						 reg0 = proc.ebx & 0xff
					when @LOAD0_AH
						 reg0 = (proc.eax >> 8) & 0xff
					when @LOAD0_CH
						 reg0 = (proc.ecx >> 8) & 0xff
					when @LOAD0_DH
						 reg0 = (proc.edx >> 8) & 0xff
					when @LOAD0_BH
						 reg0 = (proc.ebx >> 8) & 0xff

					when @LOAD0_IB
						reg0 = @microcodes[position++] & 0xff
					when @LOAD0_IW
						reg0 = @microcodes[position++] & 0xffff
					when @LOAD0_ID
						reg0 = @microcodes[position++]

					when @STORE0_AL
						proc.eax = (proc.eax & ~0xff) | (reg0 & 0xff)
					when @STORE0_CL
						proc.ecx = (proc.ecx & ~0xff) | (reg0 & 0xff)
					when @STORE0_DL
						proc.edx = (proc.edx & ~0xff) | (reg0 & 0xff)
					when @STORE0_BL
						proc.ebx = (proc.ebx & ~0xff) | (reg0 & 0xff)
					when @STORE0_AH
						proc.eax = (proc.eax & ~0xff00) | ((reg0 << 8) & 0xff00)
					when @STORE0_CH
						proc.ecx = (proc.ecx & ~0xff00) | ((reg0 << 8) & 0xff00)
					when @STORE0_DH
						proc.edx = (proc.edx & ~0xff00) | ((reg0 << 8) & 0xff00)
					when @STORE0_BH
						proc.ebx = (proc.ebx & ~0xff00) | ((reg0 << 8) & 0xff00)

					when @STORE1_AX
						proc.eax = (proc.eax & ~0xffff) | (reg1 & 0xffff)
					when @STORE1_CX
						proc.ecx = (proc.ecx & ~0xffff) | (reg1 & 0xffff)
					when @STORE1_DX
						proc.edx = (proc.edx & ~0xffff) | (reg1 & 0xffff)
					when @STORE1_BX
						proc.ebx = (proc.ebx & ~0xffff) | (reg1 & 0xffff)
					when @STORE1_SP
						proc.esp = (proc.esp & ~0xffff) | (reg1 & 0xffff)
					when @STORE1_BP
						proc.ebp = (proc.ebp & ~0xffff) | (reg1 & 0xffff)
					when @STORE1_SI
						proc.esi = (proc.esi & ~0xffff) | (reg1 & 0xffff)
					when @STORE1_DI
						proc.edi = (proc.edi & ~0xffff) | (reg1 & 0xffff)

					when @STORE0_EAX
						 proc.eax = reg0
					when @STORE0_ECX
						 proc.ecx = reg0
					when @STORE0_EDX
						 proc.edx = reg0
					when @STORE0_EBX
						 proc.ebx = reg0
					when @STORE0_ESP
						 proc.esp = reg0
					when @STORE0_EBP
						 proc.ebp = reg0
					when @STORE0_ESI
						 proc.esi = reg0
					when @STORE0_EDI
						 proc.edi = reg0


					when @LOAD1_AL
						reg1 = proc.eax & 0xff
					when @LOAD1_CL
						reg1 = proc.ecx & 0xff
					when @LOAD1_DL
						reg1 = proc.edx & 0xff
					when @LOAD1_BL
						reg1 = proc.ebx & 0xff
					when @LOAD1_AH
						reg1 = (proc.eax >> 8) & 0xff
					when @LOAD1_CH
						reg1 = (proc.ecx >> 8) & 0xff
					when @LOAD1_DH
						reg1 = (proc.edx >> 8) & 0xff
					when @LOAD1_BH
						reg1 = (proc.ebx >> 8) & 0xff

					when @JG_O8
						@jg_o8(reg0)

					when @XOR
						reg0 ^= reg1
					when @AND
						reg0 &= reg1
					when @OR
						reg0 |= reg1
					when @NOT
						reg0 = ~reg0

					when @ADDR_REG1
						  addr0 += reg1
					when @ADDR_2REG1
						 addr0 += (reg1 << 1)
					when @ADDR_4REG1
						 addr0 += (reg1 << 2)
					when @ADDR_8REG1
						 addr0 += (reg1 << 3)

					when @ADDR_EAX
						 addr0 += proc.eax
					when @ADDR_ECX
						 addr0 += proc.ecx
					when @ADDR_EDX
						 addr0 += proc.edx
					when @ADDR_EBX
						 addr0 += proc.ebx
					when @ADDR_ESP
						 addr0 += proc.esp
					when @ADDR_EBP
						 addr0 += proc.ebp
					when @ADDR_ESI
						 addr0 += proc.esi
					when @ADDR_EDI
						 addr0 += proc.edi

					when @ADDR_AX
						 addr0 += (proc.eax)
					when @ADDR_CX
						 addr0 += (proc.ecx)
					when @ADDR_DX
						 addr0 += (proc.edx)
					when @ADDR_BX
						 addr0 += (proc.ebx)
					when @ADDR_SP
						 addr0 += (proc.esp)
					when @ADDR_BP
						 addr0 += (proc.ebp)
					when @ADDR_SI
						 addr0 += (proc.esi)
					when @ADDR_DI
						 addr0 += (proc.edi)

					when @ADDR_2EAX
						 addr0 += (proc.eax << 1)
					when @ADDR_2ECX
						 addr0 += (proc.ecx << 1)
					when @ADDR_2EDX
						 addr0 += (proc.edx << 1)
					when @ADDR_2EBX
						 addr0 += (proc.ebx << 1)
					when @ADDR_2ESP
						 addr0 += (proc.esp << 1)
					when @ADDR_2EBP
						 addr0 += (proc.ebp << 1)
					when @ADDR_2ESI
						 addr0 += (proc.esi << 1)
					when @ADDR_2EDI
						 addr0 += (proc.edi << 1)

					when @ADDR_4EAX
						 addr0 += (proc.eax << 2)
					when @ADDR_4ECX
						 addr0 += (proc.ecx << 2)
					when @ADDR_4EDX
						 addr0 += (proc.edx << 2)
					when @ADDR_4EBX
						 addr0 += (proc.ebx << 2)
					when @ADDR_4ESP
						 addr0 += (proc.esp << 2)
					when @ADDR_4EBP
						 addr0 += (proc.ebp << 2)
					when @ADDR_4ESI
						 addr0 += (proc.esi << 2)
					when @ADDR_4EDI
						 addr0 += (proc.edi << 2)

					when @ADDR_8EAX
						 addr0 += (proc.eax << 3)
					when @ADDR_8ECX
						 addr0 += (proc.ecx << 3)
					when @ADDR_8EDX
						 addr0 += (proc.edx << 3)
					when @ADDR_8EBX
						 addr0 += (proc.ebx << 3)
					when @ADDR_8ESP
						 addr0 += (proc.esp << 3)
					when @ADDR_8EBP
						 addr0 += (proc.ebp << 3)
					when @ADDR_8ESI
						 addr0 += (proc.esi << 3)
					when @ADDR_8EDI
						 addr0 += (proc.edi << 3)

					when @LOAD0_ES
						reg0 = 0xffff & proc.es.getSelector()
					when @LOAD0_CS
						reg0 = 0xffff & proc.cs.getSelector()
					when @LOAD0_SS
						reg0 = 0xffff & proc.ss.getSelector()
					when @LOAD0_DS
						reg0 = 0xffff & proc.ds.getSelector()
					when @LOAD0_FS
						reg0 = 0xffff & proc.fs.getSelector()
					when @LOAD0_GS
						reg0 = 0xffff & proc.gs.getSelector()



					when @STORE1_MEM_BYTE
						seg0.setByte(addr0, reg1)

					when @LOAD1_MEM_BYTE
						reg1 = 0xff & seg0.getByte(addr0)
					when @LOAD0_MEM_DWORD
						reg0 = seg0.getDoubleWord(addr0)

					when @ADDR_IB #Wrong call?
						addr0 += getBytes(@microcodes[position++])
					when @ADDR_ID
						addr0 += @microcodes[position++]
					when @LGDT_O16
						proc.gdtr = proc.createDescriptorTableSegment(reg1 & 0x00ffffff, reg0)

					when @LOOP_CX
						@loop_cx(reg0)
					when @STORE0_ES
						proc.es = @loadSegment(reg0)

					when @INC
						reg0++
					when @DEC
						reg0--
					when @LODSB_A16
						@lodsb_a16(seg0)
					when @STC
						proc.setCarryFlag(true)
					else
						throw "File: ProtectedModeUBlock: Not added opcode yet? #{@microcodes[position]}"

		catch e
			throw e

		return @executeCount



	push_o16_a16: (value) ->
		if (((0xffff & proc.esp) < 2) && ((0xfff & proc.esp) > 0))
			throw ProcessorException.STACK_SEGMENT_0

		proc.ss.setWord(((0xfff & proc.esp) - 2) & 0xfff, value)
		proc.esp = (proc.esp &~0xffff) | ((proc.esp - 2) & 0xffff)

	call_o16_a32: (target) ->
		tempEIP = 0xffff & (proc.eip + target)
		proc.cs.checkAddress(tempEIP)

		if ((proc.esp < 2) && (proc.esp > 0))
			throw ProcessorException.STACK_SEGMENT_0

		proc.ss.setWord(proc.esp - 2, (0xffff & proc.eip))
		proc.esp -= 2
		proc.eip = tempEIP
	jg_o8: (offset) ->
		if ((!proc.getZeroFlag()) && (proc.getSignFlag() == proc.getOverFlowFlag()))
			@jump_o8(offset)

	loop_cx: (offset) ->
		proc_ecx = (proc.ecx & ~0xffff) | (((0xffff &proc.ecx)-1) & 0xffff)
		if ((proc.ecx & 0xffff) != 0)
			@jump_o8(offset)
	jump_o8: (offset) ->
		if (offset == 0)
			return

		tempEIP = proc.eip + offset
#		proc.cs.checkAddress(tempEIP) #results in errors...

		proc.eip = tempEIP
	lodsb_a16: (segMent) ->
		addr = 0xffff & proc.esi
		proc.eax = (proc.eax & 0xff) | (0xff & segMent.getByte(addr))
		if (proc.eFlagsDirection)
			addr -= 1
		else
			addr += 1

		proc.esi = (proc.esi & ~0xffff) | (0xffff & addr)

	loadSegment: (selector) ->
		selector &= 0xffff

		if (selector < 0x4)
			return sgm.NULL_SEGMENT

		s = proc.getSegment(selector)

		if (!s.isPresent())
			throw new ProcessorException(ProcessorException.Type.NOT_PRESENT, 0xc, true)
		return s
