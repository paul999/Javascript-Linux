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
					when @MEM_RESET
						addr0 = 0
						seg0 = null
					when @ADDR_MASK16
						addr0 &= 0xffff
					when @EIP_UPDATE
						if !eipUpdated
							eipUpdated = true
							proc.eip += @cumulativeX86Length[position - 1]
					when @ADDR_IB
						addr0 += (byte(@microcodes[position++]))
					when @PUSH_O16_A16
						@push_o16_a16(short(reg0))
					when @LOAD_SEG_SS
						seg0 = proc.ss
					when @LOAD0_AX
						reg0 = proc.eax & 0xffff
					when @ADDR_BP
						addr0 += short(proc.ebp)
					when @LOAD0_IB
						reg0 = @microcodes[position++] & 0xff
					when @LOAD0_MEM_WORD
						reg0 = 0xffff & seg0.getWord(addr0)

					when @STORE1_ESP
						proc.esp = reg1
					when @POP_O16_A16
						reg1 = (proc.esp & ~0xffff) | ((proc.esp + 2) & 0xffff)
						if ((@microcodes[position] == @STORE0_SS))
							proc.eflagsInterruptEnable = false
						reg0 = proc.ss.getWord(proc.esp & 0xffff)

					when @STORE0_AX
						proc.eax = (proc.eax & ~0xffff) | (reg0 & 0xffff)
					when @LOAD0_IW
						reg0 = @microcodes[position++] & 0xffff
					when @LOAD_SEG_DS
						seg0 = proc.ds
					when @STORE0_BX
						proc.ebx = (proc.ebx & ~0xffff) | (reg0 & 0xffff)
					when @SUB
						reg2 = reg0
						reg0 = reg2 - reg1
					when @STORE0_BP
						proc.ebp = (proc.ebp & ~0xffff) | (reg0 & 0xffff)
					when @ADDR_BX
						addr0 += short(proc.ebx)
					when @LOAD0_SP
						reg0 = proc.esp & 0xffff

					when @ADD
						reg2 = reg0
						reg0 = reg2 + reg1
					when @STORE0_MEM_WORD
						seg0.setWord(addr0, short(reg0))
					when @LOAD0_MEM_BYTE
						reg0 = 0xff & seg0.getByte(addr0)
					when @JNZ_O8
						jnz_o8(byte(reg0))
					when @STORE0_AL
						proc.eax = (proc.eax & ~0xff) | (reg0 & 0xff)
					when @LOAD0_BX
						proc.ebx & 0xffff
					when @LOAD1_IB
						reg1 = @microcodes[position++] & 0xff
					when @LOAD1_IW
						reg1 = @microcodes[position++] & 0xffff
					when @CALL_O16_A16
						@call_o16_a16(short(reg0))
					when @STORE0_CX
						proc.ecx = (proc.ecx & ~0xffff) | (reg0 & 0xffff)

					when @LOAD0_CX
						reg0 = proc.ecx & 0xffff
					when @LOAD0_BP
						reg0 = proc.ebp & 0xffff
					when @RET_O16_A16
						@ret_o16_a16()
					when @STORE0_SP
						proc.esp = (proc.esp & ~0xffff) | (reg0 & 0xffff)
					when @LOAD0_AL
						reg0 = proc.eax & 0xff
					when @ADD_O16_FLAGS
						@add_o16_flags(reg0, reg2, reg1)
					when @SUB_O16_FLAGS
						@sub_o16_flags(reg0, reg2, reg1)
					when @STORE0_DS
						proc.ds.setSelector(0xffff & reg0)
					when @LOAD0_DX
						reg0 = proc.edx & 0xffff
					when @BITWISE_FLAGS_O8
						bitwise_flags(byte(reg0))

					when @STORE0_SI
						proc.esi = (proc.esi & ~0xffff) | (reg0 & 0xffff)
					when @XOR
						reg0 ^= reg1
					when @STORE0_DX
						proc.edx = (proc.edx & ~0xffff) | (reg0 & 0xffff)
					when @ADDR_SI
						addr0 += short(proc.esi)
					when @SUB_O8_FLAGS
						@sub_o8_flags(reg0, reg2, reg1)
					when @JZ_O8
						@jz_o8(byte(reg0))
					when @LOAD0_AH
						reg0 = (proc.eax >> 8) & 0xff
					when @STORE0_DI
						proc.edi = (proc.edi & ~0xffff) | (reg0 & 0xffff)
					when @LOAD0_SI
						reg0 = proc.esi & 0xffff
					when @ADDR_IW
						addr0 += short(@microcodes[position++])

					when @BITWISE_FLAGS_O16
						bitwise_flags(short(reg0))
					when @LOAD0_DS
						reg0 = 0xffff & proc.ds.getSelector()
					when @LOAD1_MEM_WORD
						reg1 = 0xffff & seg0.getWord(addr0)
					when @LOAD0_DI
						reg0 = proc.edi & 0xffff
					when @INC
						reg0++
					when @STORE0_ES
						proc.es.setSelector(0xffff & reg0)
					when @INC_O16_FLAGS
						@inc_flags(short(reg0))
					when @AND
						reg0 &= reg1
					when @STORE0_BH
						proc.ebx = (proc.ebx & ~0xff00) | ((reg0 << 8) & 0xff00)
					when @LOAD_SEG_ES
						seg0 = proc.es

					when @STORE0_AH
						proc.eax = (proc.eax & ~0xff00) | ((reg0 << 8) & 0xff00)
					when @LOAD1_CX
						reg1 = proc.ecx & 0xffff
					when @ADD_O8_FLAGS
						add_o8_flags(reg0, reg2, reg1)
					when @LOAD1_AX
						reg1 = proc.eax & 0xffff
					when @LOAD1_BH
						reg1 = (proc.ebx >> 8) & 0xff
					when @LOAD0_BH
						reg0 = (proc.ebx >> 8) & 0xff
					when @STORE0_MEM_BYTE
						seg0.setByte(addr0, byte(reg0))
					when @LOAD0_ES
						reg0 = 0xffff & proc.es.getSelector()
					when @LOAD1_AH
						reg1 = (proc.eax >> 8) & 0xff
					when @ADC
						reg2 = reg0
						reg0 = reg2 + reg1 + (proc.getCarryFlag() ? 1 : 0)

					when @JUMP_O8
						@jump_o8(byte(reg0))
					when @JNC_O8
						@jnc_o8(byte(reg0))
					when @JC_O8
						@jc_o8(byte(reg0))
					when @LOAD1_AL
						reg1 = proc.eax & 0xff
					when @ADC_O16_FLAGS
						@adc_o16_flags(reg0, reg2, reg1)
					when @JUMP_O16
						@jump_o16(short(reg0))
					when @LOAD_SEG_CS
						seg0 = proc.cs
					when @DEC
						reg0--
					when @DEC_O16_FLAGS
						@dec_flags(short(reg0))
					when @LOAD0_ADDR
						reg0 = addr0

					when @SHL
						reg1 &= 0x1f
						reg2 = reg0
						reg0 <<= reg1
					when @STORE0_BL
						proc.ebx = (proc.ebx & ~0xff) | (reg0 & 0xff)
					when @SHL_O16_FLAGS
						@shl_flags(short(reg0), short(reg2), reg1)
					when @LOAD1_BX
						reg1 = proc.ebx & 0xffff
					when @OR
						reg0 |= reg1
					when @STORE1_ES
						proc.es.setSelector(0xffff & reg1)
					when @STORE1_AX
						proc.eax = (proc.eax & ~0xffff) | (reg1 & 0xffff)
					when @LOAD1_DI
						reg1 = proc.edi & 0xffff
					when @LOAD1_MEM_BYTE
						reg1 = 0xff & seg0.getByte(addr0)
					when @JCXZ
						@jcxz(byte(reg0))

					when @LOAD1_SI
						reg1 = proc.esi & 0xffff
					when @STORE1_DS
						proc.ds.setSelector(0xffff & reg1)
					when @LOAD1_CL
						reg1 = proc.ecx & 0xff
					when @JUMP_ABS_O16
						proc.eip = reg0
					when @STORE0_CL
						proc.ecx = (proc.ecx & ~0xff) | (reg0 & 0xff)
					when @ADDR_DI
						addr0 += (short(proc.edi))
					when @SHR
						reg2 = reg0
						reg0 >>>= reg1
					when @SHR_O16_FLAGS
						@shr_flags(short(reg0), reg2, reg1)
					when @JA_O8
						@ja_o8(byte(reg0))
					when @JNA_O8
						@jna_o8(byte(reg0))

# Vanaf hier is uit executeFull
					when @UNDEFINED
						throw ProcessorException.UNDEFINED

					when @MEM_RESET
						addr0 = 0
						seg0 = null

					when @LOAD0_EAX
						reg0 = proc.eax
					when @LOAD0_ECX
						reg0 = proc.ecx
					when @LOAD0_EDX
						reg0 = proc.edx
					when @LOAD0_EBX
						reg0 = proc.ebx
					when @LOAD0_ESP
						reg0 = proc.esp
					when @LOAD0_EBP
						reg0 = proc.ebp
					when @LOAD0_ESI
						reg0 = proc.esi
					when @LOAD0_EDI
						reg0 = proc.edi

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

					when @LOAD1_EAX
						reg1 = proc.eax
					when @LOAD1_ECX
						reg1 = proc.ecx
					when @LOAD1_EDX
						reg1 = proc.edx
					when @LOAD1_EBX
						reg1 = proc.ebx
					when @LOAD1_ESP
						reg1 = proc.esp
					when @LOAD1_EBP
						reg1 = proc.ebp
					when @LOAD1_ESI
						reg1 = proc.esi
					when @LOAD1_EDI
						reg1 = proc.edi

					when @STORE1_EAX
						proc.eax = reg1
					when @STORE1_ECX
						proc.ecx = reg1
					when @STORE1_EDX
						proc.edx = reg1
					when @STORE1_EBX
						proc.ebx = reg1
					when @STORE1_ESP
						proc.esp = reg1
					when @STORE1_EBP
						proc.ebp = reg1
					when @STORE1_ESI
						proc.esi = reg1
					when @STORE1_EDI
						proc.edi = reg1

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

					when @LOAD1_AX
						reg1 = proc.eax & 0xffff
					when @LOAD1_CX
						reg1 = proc.ecx & 0xffff
					when @LOAD1_DX
						reg1 = proc.edx & 0xffff
					when @LOAD1_SP
						reg1 = proc.esp & 0xffff
					when @LOAD1_BP
						reg1 = proc.ebp & 0xffff
					when @LOAD1_SI
						reg1 = proc.esi & 0xffff
					when @LOAD1_DI
						reg1 = proc.edi & 0xffff

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

					when @STORE0_AL
						proc.eax = (proc.eax & ~0xff) | (reg0 & 0xff)
					when @STORE0_CL
						proc.ecx = (proc.ecx & ~0xff) | (reg0 & 0xff)
					when @STORE0_DL
						proc.edx = (proc.edx & ~0xff) | (reg0 & 0xff)
					when @STORE0_AH
						proc.eax = (proc.eax & ~0xff00) | ((reg0 << 8) & 0xff00)
					when @STORE0_CH
						proc.ecx = (proc.ecx & ~0xff00) | ((reg0 << 8) & 0xff00)
					when @STORE0_DH
						proc.edx = (proc.edx & ~0xff00) | ((reg0 << 8) & 0xff00)
					when @STORE0_BH
						proc.ebx = (proc.ebx & ~0xff00) | ((reg0 << 8) & 0xff00)

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

					when @STORE1_AL
						proc.eax = (proc.eax & ~0xff) | (reg1 & 0xff)
					when @STORE1_CL
						proc.ecx = (proc.ecx & ~0xff) | (reg1 & 0xff)
					when @STORE1_DL
						proc.edx = (proc.edx & ~0xff) | (reg1 & 0xff)
					when @STORE1_BL
						proc.ebx = (proc.ebx & ~0xff) | (reg1 & 0xff)
					when @STORE1_AH
						proc.eax = (proc.eax & ~0xff00) | ((reg1 << 8) & 0xff00)
					when @STORE1_CH
						proc.ecx = (proc.ecx & ~0xff00) | ((reg1 << 8) & 0xff00)
					when @STORE1_DH
						proc.edx = (proc.edx & ~0xff00) | ((reg1 << 8) & 0xff00)
					when @STORE1_BH
						proc.ebx = (proc.ebx & ~0xff00) | ((reg1 << 8) & 0xff00)

					when @LOAD0_CR0
						reg0 = proc.getCR0()
					when @LOAD0_CR2
						reg0 = proc.getCR2()
					when @LOAD0_CR3
						reg0 = proc.getCR3()
					when @LOAD0_CR4
						reg0 = proc.getCR4()

					when @STORE0_CR0
						proc.setCR0(reg0)
					when @STORE0_CR2
						proc.setCR2(reg0)
					when @STORE0_CR3
						proc.setCR3(reg0)
					when @STORE0_CR4
						proc.setCR4(reg0)

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

					when @STORE0_ES
						proc.es.setSelector(0xffff & reg0)
					when @STORE0_CS
						proc.cs.setSelector(0xffff & reg0)
					when @STORE0_SS
						proc.ss.setSelector(0xffff & reg0)
					when @STORE0_DS
						proc.ds.setSelector(0xffff & reg0)
						log("RM DS segment load, limit = " + proc.ds.getLimit() + ", base=" + proc.ds.getBase())

					when @STORE0_FS
						proc.fs.setSelector(0xffff & reg0)
					when @STORE0_GS
						proc.gs.setSelector(0xffff & reg0)

					when @STORE1_CS
						proc.cs.setSelector(0xffff & reg1)
					when @STORE1_SS
						proc.ss.setSelector(0xffff & reg1)
					when @STORE1_DS
						proc.ds.setSelector(0xffff & reg1)
					when @STORE1_FS
						proc.fs.setSelector(0xffff & reg1)
					when @STORE1_GS
						proc.gs.setSelector(0xffff & reg1)

					when @STORE0_FLAGS
						proc.setEFlags((proc.getEFlags() & ~0xffff) | (reg0 & 0xffff))
					when @STORE0_EFLAGS
						proc.setEFlags(reg0)

					when @LOAD0_FLAGS
						reg0 = 0xffff & proc.getEFlags()
					when @LOAD0_EFLAGS
						reg0 = proc.getEFlags()

					when @LOAD0_IB
						reg0 = @microcodes[position++] & 0xff
					when @LOAD0_IW
						reg0 = @microcodes[position++] & 0xffff
					when @LOAD0_ID
						reg0 = @microcodes[position++]

					when @LOAD1_IB
						reg1 = @microcodes[position++] & 0xff
					when @LOAD1_IW
						reg1 = @microcodes[position++] & 0xffff
					when @LOAD1_ID
						reg1 = @microcodes[position++]

					when @LOAD2_EAX
						reg2 = proc.eax
					when @LOAD2_AX
						reg2 = 0xffff & proc.eax
					when @LOAD2_AL
						reg2 = 0xff & proc.eax
					when @LOAD2_CL
						reg2 = 0xff & proc.ecx
					when @LOAD2_IB
						reg2 = 0xff & @microcodes[position++]

					when @LOAD_SEG_ES
						seg0 = proc.es
					when @LOAD_SEG_CS
						seg0 = proc.cs
					when @LOAD_SEG_SS
						seg0 = proc.ss
					when @LOAD_SEG_DS
						seg0 = proc.ds
					when @LOAD_SEG_FS
						seg0 = proc.fs
					when @LOAD_SEG_GS
						seg0 = proc.gs

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
						addr0 += short(proc.eax)
					when @ADDR_CX
						addr0 += short(proc.ecx)
					when @ADDR_DX
						addr0 += short(proc.edx)
					when @ADDR_BX
						addr0 += short(proc.ebx)
					when @ADDR_SP
						addr0 += short(proc.esp)
					when @ADDR_BP
						addr0 += short(proc.ebp)
					when @ADDR_SI
						addr0 += short(proc.esi)
					when @ADDR_DI
						addr0 += short(proc.edi)

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

					when @ADDR_IB
						addr0 += byte(@microcodes[position++])
					when @ADDR_IW
						addr0 += short(@microcodes[position++])
					when @ADDR_ID
						addr0 += @microcodes[position++]

					when @ADDR_MASK16
						addr0 &= 0xffff

					when @ADDR_uAL
						addr0 += 0xff & proc.eax

					when @LOAD0_ADDR
						reg0 = addr0

					when @LOAD0_MEM_BYTE
						 reg0 = 0xff & seg0.getByte(addr0)
					when @LOAD0_MEM_WORD
						 reg0 = 0xffff & seg0.getWord(addr0)
					when @LOAD0_MEM_DWORD
						reg0 = seg0.getDoubleWord(addr0)
					when @LOAD0_MEM_QWORD
						reg0l = seg0.getQuadWord(addr0)

					when @LOAD1_MEM_BYTE
						 reg1 = 0xff & seg0.getByte(addr0)
					when @LOAD1_MEM_WORD
						 reg1 = 0xffff & seg0.getWord(addr0)
					when @LOAD1_MEM_DWORD
						reg1 = seg0.getDoubleWord(addr0)

					when @STORE0_MEM_BYTE
						 seg0.setByte(addr0, byte(reg0))
					when @STORE0_MEM_WORD
						 seg0.setWord(addr0, short(reg0))
					when @STORE0_MEM_DWORD
						seg0.setDoubleWord(addr0, reg0)
					when @STORE0_MEM_QWORD
						seg0.setQuadWord(addr0, reg0)

					when @STORE1_MEM_BYTE
						 seg0.setByte(addr0, byte(reg1))
					when @STORE1_MEM_WORD
						 seg0.setWord(addr0, short(reg1))
					when @STORE1_MEM_DWORD
						seg0.setDoubleWord(addr0, reg1)

					when @JUMP_FAR_O16
						jump_far_o16(reg0, reg1)
					when @JUMP_FAR_O32
						jump_far_o32(reg0, reg1)

					when @JUMP_ABS_O16
						proc.eip = reg0

					when @CALL_FAR_O16_A16
						call_far_o16_a16(reg0, reg1)
					when @CALL_FAR_O16_A32
						call_far_o16_a32(reg0, reg1)

					when @CALL_FAR_O32_A16
						call_far_o32_a16(reg0, reg1)
					when @CALL_FAR_O32_A32
						call_far_o32_a32(reg0, reg1)

					when @CALL_ABS_O16_A16
						call_abs_o16_a16(reg0)
					when @CALL_ABS_O16_A32
						call_abs_o16_a32(reg0)
					when @CALL_ABS_O32_A16
						call_abs_o32_a16(reg0)
					when @CALL_ABS_O32_A32
						call_abs_o32_a32(reg0)

					when @JUMP_O8
						jump_o8(byte(reg0))
					when @JUMP_O16
						jump_o16(short(reg0))
					when @JUMP_O32
						jump_o32(reg0)

					when @INT_O16_A16
						int_o16_a16(reg0)
					when @INT3_O16_A16
						int3_o16_a16()

					when @IRET_O16_A16
						reg0 = iret_o16_a16() #returns flags

					when @IN_O8
						 reg0 = 0xff & proc.ioports.ioPortReadByte(reg0)
					when @IN_O16
						reg0 = 0xffff & proc.ioports.ioPortReadWord(reg0)
					when @IN_O32
						reg0 = proc.ioports.ioPortReadLong(reg0)

					when @OUT_O8
						 proc.ioports.ioPortWriteByte(reg0, reg1)
					when @OUT_O16
						proc.ioports.ioPortWriteWord(reg0, reg1)
					when @OUT_O32
						proc.ioports.ioPortWriteLong(reg0, reg1)

					when @CMOVNS
						if (!proc.getSignFlag())
							reg0 = reg1

					when @XOR
						reg0 ^= reg1
					when @AND
						reg0 &= reg1
					when @NOT
						reg0 = ~reg0

					when @SUB
						reg2 = reg0
						reg0 = reg2 - reg1
					when @SBB
						reg2 = reg0

						reg0 = reg2 - (reg1 + (proc.getCarryFlag() ? 1 : 0))
					when @ADD
						reg2 = reg0
						reg0 = reg2 + reg1
					when @ADC
						reg2 = reg0
						reg0 = reg2 + reg1 + (proc.getCarryFlag() ? 1 : 0)
					when @NEG
						reg0 = -reg0

					when @MUL_O8
						mul_o8(reg0)
					when @MUL_O16
						mul_o16(reg0)
					when @MUL_O32
						mul_o32(reg0)

					when @IMULA_O8
						imula_o8(byte(reg0))
					when @IMULA_O16
						imula_o16(short(reg0))
					when @IMULA_O32
						imula_o32(reg0)

					when @IMUL_O16
						reg0 = imul_o16(short(reg0), short(reg1))
					when @IMUL_O32
						reg0 = imul_o32(reg0, reg1)

					when @DIV_O8
						div_o8(reg0)
					when @DIV_O16
						div_o16(reg0)
					when @DIV_O32
						div_o32(reg0)

					when @IDIV_O8
						idiv_o8(byte(reg0))
					when @IDIV_O16
						idiv_o16(short(reg0))
					when @IDIV_O32
						idiv_o32(reg0)

					when @BSF
						reg0 = bsf(reg1, reg0)
					when @BSR
						reg0 = bsr(reg1, reg0)

					when @BT_MEM
						bt_mem(reg1, seg0, addr0)
					when @BTS_MEM
						bts_mem(reg1, seg0, addr0)
					when @BTR_MEM
						btr_mem(reg1, seg0, addr0)
					when @BTC_MEM
						btc_mem(reg1, seg0, addr0)

					when @BT_O32
						 reg1 &= 0x1f
						 proc.setCarryFlag(reg0, reg1, Processor.CY_NTH_BIT_SET)
					when @BT_O16
						 reg1 &= 0xf
						 proc.setCarryFlag(reg0, reg1, Processor.CY_NTH_BIT_SET)
					when @BTS_O32
						reg1 &= 0x1f
						proc.setCarryFlag(reg0, reg1, Processor.CY_NTH_BIT_SET)
						reg0 |= (1 << reg1)
					when @BTS_O16
						reg1 &= 0xf
						proc.setCarryFlag(reg0, reg1, Processor.CY_NTH_BIT_SET)
						reg0 |= (1 << reg1)
					when @BTR_O32
						reg1 &= 0x1f
						proc.setCarryFlag(reg0, reg1, Processor.CY_NTH_BIT_SET)
						reg0 &= ~(1 << reg1)
					when @BTR_O16
						reg1 &= 0xf
						proc.setCarryFlag(reg0, reg1, Processor.CY_NTH_BIT_SET)
						reg0 &= ~(1 << reg1)
					when @BTC_O32
						reg1 &= 0x1f
						proc.setCarryFlag(reg0, reg1, Processor.CY_NTH_BIT_SET)
						reg0 ^= (1 << reg1)
					when @BTC_O16
						reg1 &= 0xf
						proc.setCarryFlag(reg0, reg1, Processor.CY_NTH_BIT_SET)
						reg0 ^= (1 << reg1)

					when @ROL_O8
						 reg2 = reg1 & 0x7
						 reg0 = (reg0 << reg2) | (reg0 >>> (8 - reg2))
					when @ROL_O16
						reg2 = reg1 & 0xf
						reg0 = (reg0 << reg2) | (reg0 >>> (16 - reg2))
					when @ROL_O32
						reg1 &= 0x1f
						reg0 = (reg0 << reg1) | (reg0 >>> (32 - reg1))

					when @ROR_O8
						 reg1 &= 0x7
						 reg0 = (reg0 >>> reg1) | (reg0 << (8 - reg1))
					when @ROR_O16
						reg1 &= 0xf
						reg0 = (reg0 >>> reg1) | (reg0 << (16 - reg1))
					when @ROR_O32
						reg1 &= 0x1f
						reg0 = (reg0 >>> reg1) | (reg0 << (32 - reg1))

					when @RCL_O8
						reg1 &= 0x1f
						reg1 %= 9; reg0 |= (proc.getCarryFlag() ? 0x100 : 0)
						reg0 = (reg0 << reg1) | (reg0 >>> (9 - reg1))
					when @RCL_O16
						reg1 &= 0x1f
						reg1 %= 17
						reg0 |= (proc.getCarryFlag() ? 0x10000 : 0)
						reg0 = (reg0 << reg1) | (reg0 >>> (17 - reg1))
					when @RCL_O32
						reg1 &= 0x1f
						reg0l = (0xffffffff & reg0) | (proc.getCarryFlag() ? 0x100000000 : 0)
						reg0 = int((reg0l = (reg0l << reg1) | (reg0l >>> (33 - reg1))))

					when @RCR_O8
						reg1 &= 0x1f
						reg1 %= 9
						reg0 |= (proc.getCarryFlag() ? 0x100 : 0);
						reg2 = (proc.getCarryFlag() ^ ((reg0 & 0x80) != 0) ? 1 : 0)
						reg0 = (reg0 >>> reg1) | (reg0 << (9 - reg1))

					when @RCR_O16
						reg1 &= 0x1f
						reg1 %= 17
						reg2 = (proc.getCarryFlag() ^ ((reg0 & 0x8000) != 0) ? 1 : 0);
						reg0 |= (proc.getCarryFlag() ? 0x10000:0)
						reg0 = (reg0 >>> reg1) | (reg0 << (17 - reg1))

					when @RCR_O32
						reg1 &= 0x1f
						reg0l = (0xffffffff & reg0) | (proc.getCarryFlag() ? 0x100000000:0);
						reg2 = (proc.getCarryFlag() ^ ((reg0 & 0x80000000) != 0) ? 1:0);
						reg0 = (reg0l = (reg0l >>> reg1) | (reg0l << (33 - reg1)));


					when @SHR
						reg1 &= 0x1f
						reg2 = reg0
						reg0 >>>= reg1
					when @SAR_O8
						reg1 &= 0x1f
						reg2 = reg0
						reg0 = byte(reg0) >> reg1
					when @SAR_O16
						reg1 &= 0x1f
						reg2 = reg0
						reg0 = short(reg0) >> reg1
					when @SAR_O32
						reg1 &= 0x1f
						reg2 = reg0
						reg0 >>= reg1

					when @SHLD_O16
						i = reg0;
						reg2 &= 0x1f;
						if (reg2 < 16)
							reg0 = (reg0 << reg2) | (reg1 >>> (16 - reg2))
							reg1 = reg2
							reg2 = i
						else
							i = (reg1 & 0xFFFF) | (reg0 << 16)
							reg0 = (reg1 << (reg2 - 16)) | ((reg0 & 0xFFFF) >>> (32 - reg2))
							reg1 = reg2 - 15
							reg2 = i >> 1

					when @SHLD_O32
						i = reg0
						reg2 &= 0x1f
						if (reg2 != 0)
							reg0 = (reg0 << reg2) | (reg1 >>> (32 - reg2))
						reg1 = reg2
						reg2 = i

					when @SHRD_O16
						i = reg0
						reg2 &= 0x1f
						if (reg2 < 16)
							reg0 = (reg0 >>> reg2) | (reg1 << (16 - reg2))
							reg1 = reg2
							reg2 = i
						else

							i = (reg0 & 0xFFFF) | (reg1 << 16)
							reg0 = (reg1 >>> (reg2 - 16)) | (reg0 << (32 - reg2))
							reg1 = reg2
							reg2 = i

					when @SHRD_O32
						i = reg0
						reg2 &= 0x1f
						if (reg2 != 0)
							reg0 = (reg0 >>> reg2) | (reg1 << (32 - reg2))
						reg1 = reg2
						reg2 = i


					when @CWD
						if ((proc.eax & 0x8000) == 0)
							proc.edx &= 0xffff0000
						else
							proc.edx |= 0x0000ffff
					when @CDQ
						if ((proc.eax & 0x80000000) == 0)
							proc.edx = 0
						else
							proc.edx = -1

					when @AAA
						@aaa()
					when @AAD
						@aad(reg0)
					when @AAM
						reg0 = @aam(reg0)
					when @AAS
						@aas()

					when @DAA
						@daa()
					when @DAS
						@das()

					when @BOUND_O16

						lower = short(reg0)
						upper = short(reg0 >> 16)
						index = short(reg1)
						if ((index < lower) || (index > (upper + 2)))
							throw ProcessorException.BOUND_RANGE

					when @LAHF
						@lahf()
					when @SAHF
						@sahf()

					when @CLC
						proc.setCarryFlag(false)
					when @STC
						proc.setCarryFlag(true)
					when @CLI
						proc.eflagsInterruptEnable = proc.eflagsInterruptEnableSoon = false
					when @STI
						proc.eflagsInterruptEnableSoon = true
					when @CLD
						proc.eflagsDirection = false
					when @STD
						proc.eflagsDirection = true
					when @CMC
						proc.setCarryFlag(proc.getCarryFlag() ^ true)

					when @CALL_O16_A16
						@call_o16_a16(short(reg0))
					when @CALL_O32_A16
						@call_o32_a16(reg0)

					when @RET_O16_A16
						@ret_o16_a16()
					when @RET_O32_A16
						@ret_o32_a16()

					when @RET_IW_O16_A16
						@ret_iw_o16_a16(short(reg0))

					when @RET_FAR_O16_A16
						@ret_far_o16_a16()
					when @RET_FAR_IW_O16_A16
						@ret_far_iw_o16_a16(short(reg0))
					when @ENTER_O16_A16
						@enter_o16_a16(reg0, reg1)
					when @LEAVE_O16_A16
						@leave_o16_a16()

					when @PUSH_O16_A16
						@push_o16_a16(short(reg0))
					when @PUSH_O32_A16
						@push_o32_a16(reg0)
					when @PUSH_O32_A32
						@push_o32_a32(reg0)

					when @PUSHF_O16_A16
						@push_o16_a16(short(reg0))
					when @PUSHF_O32_A16
						@push_o32_a16(~0x30000 & reg0)

					when @POP_O16_A16
						reg1 = (proc.esp & ~0xffff) | ((proc.esp + 2) & 0xffff)
						if ((@microcodes[position] == @STORE0_SS))
							proc.eflagsInterruptEnable = false
						reg0 = proc.ss.getWord(proc.esp & 0xffff)

					when @POP_O16_A32
						reg1 = (proc.esp + 2)
						if ((@microcodes[position] == @STORE0_SS))
							proc.eflagsInterruptEnable = false
						reg0 = proc.ss.getWord(proc.esp)

					when @POP_O32_A16
						reg1 = (proc.esp & ~0xffff) | ((proc.esp + 4) & 0xffff)
						if ((@microcodes[position] == @STORE0_SS))
							proc.eflagsInterruptEnable = false
						reg0 = proc.ss.getDoubleWord(proc.esp & 0xffff)

					when @POP_O32_A32
						reg1 = (proc.esp & ~0xffff) | ((proc.esp + 4) & 0xffff)
						if ((@microcodes[position] == @STORE0_SS))
							proc.eflagsInterruptEnable = false
						reg0 = proc.ss.getDoubleWord(proc.esp & 0xffffffff)

					when @POPF_O16_A16
						reg0 = proc.ss.getWord(proc.esp & 0xffff)
						proc.esp = (proc.esp & ~0xffff) | ((proc.esp + 2) & 0xffff)

					when @POPF_O32_A16
						reg0 = (proc.getEFlags() & 0x20000) | (proc.ss.getDoubleWord(proc.esp & 0xffff) & ~0x1a0000)
						proc.esp = (proc.esp & ~0xffff) | ((proc.esp + 4) & 0xffff)

					when @PUSHA_A16
						@pusha_a16()
					when @PUSHAD_A16
						@pushad_a16()

					when @POPA_A16
						@popa_a16()
					when @POPAD_A16
						@popad_a16()

					when @SIGN_EXTEND_8_16
						reg0 = 0xffff & byte(reg0)
					when @SIGN_EXTEND_8_32
						reg0 = byte(reg0)
					when @SIGN_EXTEND_16_32
						reg0 = short(reg0)

					when @CMPSB_A16
						@cmpsb_a16(seg0)
					when @CMPSW_A16
						@cmpsw_a16(seg0)
					when @CMPSD_A16
						@cmpsd_a16(seg0)
					when @REPE_CMPSB_A16
						@repe_cmpsb_a16(seg0)
					when @REPE_CMPSW_A16
						@repe_cmpsw_a16(seg0)
					when @REPE_CMPSD_A16
						@repe_cmpsd_a16(seg0)

					when @INSB_A16
						@insb_a16(reg0)
					when @INSW_A16
						@insw_a16(reg0)
					when @INSD_A16
						@insd_a16(reg0)
					when @REP_INSB_A16
						@rep_insb_a16(reg0)
					when @REP_INSW_A16
						@rep_insw_a16(reg0)
					when @REP_INSD_A16
						@rep_insd_a16(reg0)

					when @LODSB_A16
						@lodsb_a16(seg0)
					when @LODSW_A16
						@lodsw_a16(seg0)
					when @LODSD_A16
						@lodsd_a16(seg0)
					when @REP_LODSB_A16
						@rep_lodsb_a16(seg0)
					when @REP_LODSW_A16
						@rep_lodsw_a16(seg0)
					when @REP_LODSD_A16
						@rep_lodsd_a16(seg0)
					when @LODSB_A32
						@lodsb_a32(seg0)
					when @LODSW_A32
						@lodsw_a32(seg0)
					when @LODSD_A32
						@lodsd_a32(seg0)
					when @REP_LODSB_A32
						@rep_lodsb_a32(seg0)
					when @REP_LODSW_A32
						@rep_lodsw_a32(seg0)
					when @REP_LODSD_A32
						@rep_lodsd_a32(seg0)

					when @MOVSB_A16
						@movsb_a16(seg0)
					when @MOVSW_A16
						@movsw_a16(seg0)
					when @MOVSD_A16
						@movsd_a16(seg0)
					when @REP_MOVSB_A16
						@rep_movsb_a16(seg0)
					when @REP_MOVSW_A16
						@rep_movsw_a16(seg0)
					when @REP_MOVSD_A16
						@rep_movsd_a16(seg0)
					when @MOVSB_A32
						@movsb_a32(seg0)
					when @MOVSW_A32
						@movsw_a32(seg0)
					when @MOVSD_A32
						@movsd_a32(seg0)
					when @REP_MOVSB_A32
						@rep_movsb_a32(seg0)
					when @REP_MOVSW_A32
						@rep_movsw_a32(seg0)
					when @REP_MOVSD_A32
						@rep_movsd_a32(seg0)

					when @OUTSB_A16
						@outsb_a16(reg0, seg0)
					when @OUTSW_A16
						@outsw_a16(reg0, seg0)
					when @OUTSD_A16
						@outsd_a16(reg0, seg0)
					when @REP_OUTSB_A16
						@rep_outsb_a16(reg0, seg0)
					when @REP_OUTSW_A16
						@rep_outsw_a16(reg0, seg0)
					when @REP_OUTSD_A16
						@rep_outsd_a16(reg0, seg0)

					when @SCASB_A16
						@scasb_a16(reg0)
					when @SCASW_A16
						@scasw_a16(reg0)
					when @SCASD_A16
						@scasd_a16(reg0)
					when @REPE_SCASB_A16
						@repe_scasb_a16(reg0)
					when @REPE_SCASW_A16
						@repe_scasw_a16(reg0)
					when @REPE_SCASD_A16
						repe_scasd_a16(reg0)
					when @REPNE_SCASB_A16
						@repne_scasb_a16(reg0)
					when @REPNE_SCASW_A16
						@repne_scasw_a16(reg0)
					when @REPNE_SCASD_A16
						@repne_scasd_a16(reg0)

					when @STOSB_A16
						@stosb_a16(reg0)
					when @STOSW_A16
						@stosw_a16(reg0)
					when @STOSD_A16
						@stosd_a16(reg0)
					when @REP_STOSB_A16
						@rep_stosb_a16(reg0)
					when @REP_STOSW_A16
						@rep_stosw_a16(reg0)
					when @REP_STOSD_A16
						@rep_stosd_a16(reg0)
					when @STOSB_A32
						@stosb_a32(reg0)
					when @STOSW_A32
						@stosw_a32(reg0)
					when @STOSD_A32
						@stosd_a32(reg0)
					when @REP_STOSB_A32
						@rep_stosb_a32(reg0)
					when @REP_STOSW_A32
						@rep_stosw_a32(reg0)
					when @REP_STOSD_A32
						@rep_stosd_a32(reg0)

					when @LOOP_ECX
						proc.ecx--
						if (proc.ecx != 0)
							@jump_o8(byte(reg0))
					when @LOOP_CX
						proc.ecx = (proc.ecx & ~0xffff) | ((proc.ecx - 1) & 0xffff)
						if ((0xffff & proc.ecx) != 0)
							@jump_o8(byte(reg0))
					when @LOOPZ_ECX
						proc.ecx--
						if ((proc.ecx != 0) && proc.getZeroFlag())
							@jump_o8(byte(reg0))
					when @LOOPZ_CX
						proc.ecx = (proc.ecx & ~0xffff) | ((proc.ecx - 1) & 0xffff)
						if (((0xffff & proc.ecx) != 0) && proc.getZeroFlag())
							@jump_o8(byte(reg0))
					when @LOOPNZ_ECX
						proc.ecx--
						if ((proc.ecx != 0) && !proc.getZeroFlag())
							@jump_o8(byte(reg0))
					when @LOOPNZ_CX
						proc.ecx = (proc.ecx & ~0xffff) | ((proc.ecx - 1) & 0xffff)
						if (((0xffff & proc.ecx) != 0) && !proc.getZeroFlag())
							@jump_o8(byte(reg0))

					when @JO_O8
						 @jo_o8(byte(reg0))
					when @JNO_O8
						@jno_o8(byte(reg0))
					when @JC_O8
						@jc_o8(byte(reg0))
					when @JNC_O8
						@jnc_o8(byte(reg0))
					when @JZ_O8
						@jz_o8(byte(reg0))
					when @JNZ_O8
						@jnz_o8(byte(reg0))
					when @JNA_O8
						@jna_o8(byte(reg0))
					when @JA_O8
						@ja_o8(byte(reg0))
					when @JS_O8
						@js_o8(byte(reg0))
					when @JNS_O8
						@jns_o8(byte(reg0))
					when @JP_O8
						@jp_o8(byte(reg0))
					when @JNP_O8
						@jnp_o8(byte(reg0))
					when @JL_O8
						@jl_o8(byte(reg0))
					when @JNL_O8
						@jnl_o8(byte(reg0))
					when @JNG_O8
						@jng_o8(byte(reg0))
					when @JG_O8
						@jg_o8(byte(reg0))

					when @JO_O16
						@jo_o16(short(reg0))
					when @JNO_O16
						@jno_o16(short(reg0))
					when @JC_O16
						@jc_o16(short(reg0))
					when @JNC_O16
						@jnc_o16(short(reg0))
					when @JZ_O16
						@jz_o16(short(reg0))
					when @JNZ_O16
						@jnz_o16(short(reg0))
					when @JNA_O16
						@jna_o16(short(reg0))
					when @JA_O16
						@ja_o16(short(reg0))
					when @JS_O16
						@js_o16(short(reg0))
					when @JNS_O16
						@jns_o16(short(reg0))
					when @JP_O16
						@jp_o16(short(reg0))
					when @JNP_O16
						@jnp_o16(short(reg0))
					when @JL_O16
						@jl_o16(short(reg0))
					when @JNL_O16
						@jnl_o16(short(reg0))
					when @JNG_O16
						@jng_o16(short(reg0))
					when @JG_O16
						@jg_o16(short(reg0))


					when @JO_O32
						@jo_o32(reg0)
					when @JNO_O32
						@jno_o32(reg0)
					when @JC_O32
						@jc_o32(reg0)
					when @JNC_O32
						@jnc_o32(reg0)
					when @JZ_O32
						@jz_o32(reg0)
					when @JNZ_O32
						@jnz_o32(reg0)
					when @JNA_O32
						@jna_o32(reg0)
					when @JA_O32
						@ja_o32(reg0)
					when @JS_O32
						@js_o32(reg0)
					when @JNS_O32
						@jns_o32(reg0)
					when @JP_O32
						@jp_o32(reg0)
					when @JNP_O32
						@jnp_o32(reg0)
					when @JL_O32
						@jl_o32(reg0)
					when @JNL_O32
						@jnl_o32(reg0)
					when @JNG_O32
						@jng_o32(reg0)
					when @JG_O32
						@jg_o32(reg0)

					when @JCXZ
						@jcxz(byte(reg0))
					when @JECXZ
						@jecxz(byte(reg0))

					when @INC
						reg0++
					when @DEC
						reg0--

					when @HALT
						proc.waitForInterrupt()

					when @RDTSC
						tsc = proc.getClockCount()
						reg0 = tsc
						reg1 = (tsc >>> 32)
					when @WRMSR
						proc.setMSR(reg0, (reg2 & 0xffffffff) | ((reg1 & 0xffffffff) << 32))
					when @RDMSR
						msr = proc.getMSR(reg0)
						reg0 = msr
						reg1 = int(msr >>> 32)

					when @SETO
						 reg0 = proc.getOverflowFlag() ? 1:0
					when @SETNO
						reg0 = proc.getOverflowFlag() ? 0:1
					when @SETC
						 reg0 = proc.getCarryFlag() ? 1:0
					when @SETNC
						reg0 = proc.getCarryFlag() ? 0:1
					when @SETZ
						 reg0 = proc.getZeroFlag() ? 1:0
					when @SETNZ
						reg0 = proc.getZeroFlag() ? 0:1
					when @SETNA
						reg0 = proc.getCarryFlag() || proc.getZeroFlag() ? 1:0
					when @SETA
						 reg0 = proc.getCarryFlag() || proc.getZeroFlag() ? 0:1
					when @SETS
						 reg0 = proc.getSignFlag() ? 1:0
					when @SETNS
						reg0 = proc.getSignFlag() ? 0:1
					when @SETP
						 reg0 = proc.getParityFlag() ? 1:0
					when @SETNP
						reg0 = proc.getParityFlag() ? 0:1
					when @SETL
						 reg0 = proc.getSignFlag() != proc.getOverflowFlag() ? 1:0
					when @SETNL
						reg0 = proc.getSignFlag() != proc.getOverflowFlag() ? 0:1
					when @SETNG
						reg0 = proc.getZeroFlag() || (proc.getSignFlag() != proc.getOverflowFlag()) ? 1:0
					when @SETG
						 reg0 = proc.getZeroFlag() || (proc.getSignFlag() != proc.getOverflowFlag()) ? 0:1

					when @SALC
						reg0 = proc.getCarryFlag() ? -1:0
					when @CPL_CHECK
						break

					when @SMSW
						reg0 = proc.getCR0() & 0xffff
					when @LMSW
						proc.setCR0((proc.getCR0() & ~0xf) | (reg0 & 0xf))

					when @LGDT_O16
						proc.gdtr = proc.createDescriptorTableSegment(reg1 & 0x00ffffff, reg0)
					when @LGDT_O32
						proc.gdtr = proc.createDescriptorTableSegment(reg1, reg0)
					when @LIDT_O16
						proc.idtr = proc.createDescriptorTableSegment(reg1 & 0x00ffffff, reg0)
					when @LIDT_O32
						proc.idtr = proc.createDescriptorTableSegment(reg1, reg0)

					when @SGDT_O16
						reg0 = proc.gdtr.getLimit()
						reg1 = 0x00ffffff & proc.gdtr.getBase()
					when @SGDT_O32
						reg0 = proc.gdtr.getLimit()
						reg1 = proc.gdtr.getBase()
					when @SIDT_O16
						reg0 = proc.idtr.getLimit()
						reg1 = 0x00ffffff & proc.idtr.getBase()
					when @SIDT_O32
						reg0 = proc.idtr.getLimit()
						reg1 = proc.idtr.getBase()

					when @CPUID
						@cpuid()

					when @CLTS
						proc.setCR3(proc.getCR3() & ~0x4)

					when @BITWISE_FLAGS_O8
						bitwise_flags(byte(reg0))
					when @BITWISE_FLAGS_O16
						bitwise_flags(short(reg0))
					when @BITWISE_FLAGS_O32
						bitwise_flags(reg0)

					when @SUB_O8_FLAGS
						@sub_o8_flags(reg0, reg2, reg1)
					when @SUB_O16_FLAGS
						@sub_o16_flags(reg0, reg2, reg1)
					when @SUB_O32_FLAGS
						@sub_o32_flags(reg0l, reg2, reg1)

					when @REP_SUB_O8_FLAGS
						@rep_sub_o8_flags(reg0, reg2, reg1)
					when @REP_SUB_O16_FLAGS
						@rep_sub_o16_flags(reg0, reg2, reg1)
					when @REP_SUB_O32_FLAGS
						@rep_sub_o32_flags(reg0, reg2, reg1)

					when @ADD_O8_FLAGS
						add_o8_flags(reg0, reg2, reg1)
					when @ADD_O16_FLAGS
						add_o16_flags(reg0, reg2, reg1)
					when @ADD_O32_FLAGS
						add_o32_flags(reg0l, reg2, reg1)

					when @ADC_O8_FLAGS
						@adc_o8_flags(reg0, reg2, reg1)
					when @ADC_O16_FLAGS
						@adc_o16_flags(reg0, reg2, reg1)
					when @ADC_O32_FLAGS
						@adc_o32_flags(reg0l, reg2, reg1)

					when @SBB_O8_FLAGS
						@sbb_o8_flags(reg0, reg2, reg1)
					when @SBB_O16_FLAGS
						@sbb_o16_flags(reg0, reg2, reg1)
					when @SBB_O32_FLAGS
						@sbb_o32_flags(reg0l, reg2, reg1)

					when @INC_O8_FLAGS
						@inc_flags(byte(reg0))
					when @INC_O16_FLAGS
						@inc_flags(short(reg0))
					when @INC_O32_FLAGS
						@inc_flags(reg0)

					when @DEC_O8_FLAGS
						@dec_flags(byte(reg0))
					when @DEC_O16_FLAGS
						@dec_flags(short(reg0))
					when @DEC_O32_FLAGS
						@dec_flags(reg0)

					when @SHL_O8_FLAGS
						@shl_flags(byte(reg0), byte(reg2), reg1)
					when @SHL_O32_FLAGS
						@shl_flags(reg0, reg2, reg1)

					when @SHR_O8_FLAGS
						@shr_flags(byte(reg0), reg2, reg1)
					when @SHR_O16_FLAGS
						@shr_flags(short(reg0), reg2, reg1)
					when @SHR_O32_FLAGS
						@shr_flags(reg0, reg2, reg1)

					when @SAR_O8_FLAGS
						@sar_flags(byte(reg0), byte(reg2), reg1)
					when @SAR_O16_FLAGS
						@sar_flags(short(reg0), short(reg2), reg1)
					when @SAR_O32_FLAGS
						@sar_flags(reg0, reg2, reg1)

					when @RCL_O8_FLAGS
						@rcl_o8_flags(reg0, reg1)
					when @RCL_O16_FLAGS
						@rcl_o16_flags(reg0, reg1)
					when @RCL_O32_FLAGS
						@rcl_o32_flags(reg0l, reg1)

					when @RCR_O8_FLAGS
						@rcr_o8_flags(reg0, reg1, reg2)
					when @RCR_O16_FLAGS
						@rcr_o16_flags(reg0, reg1, reg2)
					when @RCR_O32_FLAGS
						@rcr_o32_flags(reg0l, reg1, reg2)

					when @ROL_O8_FLAGS
						@rol_flags(byte(reg0), reg1)
					when @ROL_O16_FLAGS
						@rol_flags(short(reg0), reg1)
					when @ROL_O32_FLAGS
						@rol_flags(reg0, reg1)

					when @ROR_O8_FLAGS
						@ror_flags(byte(reg0), reg1)
					when @ROR_O16_FLAGS
						@ror_flags(short(reg0), reg1)
					when @ROR_O32_FLAGS
						@ror_flags(reg0, reg1)

					when @NEG_O8_FLAGS
						@neg_flags(byte(reg0))
					when @NEG_O16_FLAGS
						@neg_flags(short(reg0))
					when @NEG_O32_FLAGS
						@neg_flags(reg0)

					else
						throw "Possible missing microcode: #{mc}"
		catch e
			if (e instanceof ProcessorException)

			else
				throw e

	push_o16_a16: (data) ->
		data = short(data)
		if (((proc.esp & 0xffff) < 2) && ((proc.esp & 0xffff) > 0))
			throw ProcessorException.STACK_SEGMENT_0

		offset = (proc.esp - 2) & 0xffff
		proc.ss.setWord(offset, data)
		proc.esp = (proc.esp & ~0xffff) | offset

	jump_o8: (offset) ->
		offset = byte(offset)
		proc.eip += offset

		if ((proc.eip & 0xffff0000) != 0)
#			proc.eip -= offset
			log "Hier (Wat niet hoort...). Offset: #{offset} new eip :#{proc.eip}"
#			throw ProcessorException.GENERAL_PROTECTION_0


	jump_o16: (offset) ->
		proc.eip = (proc.eip + short(offset)) & 0xffff
