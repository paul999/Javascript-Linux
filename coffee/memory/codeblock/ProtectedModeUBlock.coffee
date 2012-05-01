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
			@parityMap[i] = ((numberOfSetBits(i) & 0x1) == 0)

		@cumulativeX86Length = x86lengths

		if (@cumulativeX86Length.length == 0)
			@x86Count = 0
		else
			count = 1

			for i in [i...@cumulativeX86Length.length]
				if (@cumulativeX86Length[i] > @cumulativeX86Length[i-1])
					count++
			@x86Count = count

	getX86Length: ->
		if (@microcodes.length == 0)
			return 0
		return @cumulativeX86Length[@microcodes.length-1]

	execute: ->

		if (@opcodeCounter && @opcodeCounter != null)
			opcodeCounter.addBlock(@getMicrocodes())

		seg0 = new n()
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

#		log "Going to execute the next microcodes: "

#		for i in [position...@microcodes.length]
#			log @microcodes[i]


		try
			while position < @microcodes.length
				code = @microcodes[position]
				position++
				switch code
					when @EIP_UPDATE
						if (!eipUpdated)
							eipUpdated = true
							proc.incEIP(@cumulativeX86Length[position - 1])
					when @UNDEFINED

						throw ProcessorException.UNDEFINED

					when @MEM_RESET
						addr0 = 0
						seg0 = new n()

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

					when @LOAD0_DR0
						reg0 = proc.getDR0()
					when @LOAD0_DR1
						reg0 = proc.getDR1()
					when @LOAD0_DR2
						reg0 = proc.getDR2()
					when @LOAD0_DR3
						reg0 = proc.getDR3()
					when @LOAD0_DR6
						reg0 = proc.getDR6()
					when @LOAD0_DR7
						reg0 = proc.getDR7()

					when @STORE0_DR0
						proc.setDR0(reg0)
					when @STORE0_DR1
						proc.setDR1(reg0)
					when @STORE0_DR2
						proc.setDR2(reg0)
					when @STORE0_DR3
						proc.setDR3(reg0)
					when @STORE0_DR6
						proc.setDR6(reg0)
					when @STORE0_DR7
						proc.setDR7(reg0)

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
						proc.es = @loadSegment(reg0)

					when @STORE0_SS

						temp = @loadSegment(reg0)
						if (temp instanceof NULL_SEGMENT)
							throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, 0, true)
							proc.ss = temp
							proc.eflagsInterruptEnable = false

					when @STORE0_DS
						proc.ds = @loadSegment(reg0)
					when @STORE0_FS
						proc.fs = @loadSegment(reg0)
					when @STORE0_GS
						proc.gs = @loadSegment(reg0)

					when @STORE1_ES
						proc.es = @loadSegment(reg1)

					when @STORE1_SS

						temp = @loadSegment(reg1)
						if (temp instsanceof NULL_SEGMENT)
							throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, 0, true)
						proc.ss = temp
						proc.eflagsInterruptEnable = false

					when @STORE1_DS
						proc.ds = @loadSegment(reg1)
					when @STORE1_FS
						proc.fs = @loadSegment(reg1)
					when @STORE1_GS
						proc.gs = @loadSegment(reg1)

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
						reg2 = proc.eax & 0xffff
					when @LOAD2_AL
						reg2 = proc.eax & 0xff
					when @LOAD2_CL
						reg2 = proc.ecx & 0xffff
					when @LOAD2_IB
						reg2 = @microcodes[position++] & 0xff

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
						addr0 += (short(proc.eax))
					when @ADDR_CX
						addr0 += (short(proc.ecx))
					when @ADDR_DX
						addr0 += (short(proc.edx))
					when @ADDR_BX
						addr0 += (short(proc.ebx))
					when @ADDR_SP
						addr0 += (short(proc.esp))
					when @ADDR_BP
						addr0 += (short(proc.ebp))
					when @ADDR_SI
						addr0 += (short(proc.esi))
					when @ADDR_DI
						addr0 += (short(proc.edi))

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
						addr0 += (byte(@microcodes[position++]))
					when @ADDR_IW
						addr0 += (short(@microcodes[position++]))
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
						seg0.setQuadWord(addr0, reg0l)

					when @STORE1_MEM_BYTE
						 seg0.setByte(addr0, byte(reg1))
					when @STORE1_MEM_WORD
						 seg0.setWord(addr0, short(reg1))
					when @STORE1_MEM_DWORD
						seg0.setDoubleWord(addr0, reg1)

					when @XOR
						reg0 ^= reg1
					when @AND
						reg0 &= reg1
					when @OR
						 reg0 |= reg1
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
						@mul_o8(reg0)
					when @MUL_O16
						@mul_o16(reg0)
					when @MUL_O32
						@mul_o32(reg0)

					when @IMULA_O8
						@imula_o8(byte(reg0))
					when @IMULA_O16
						@imula_o16(short(reg0))
					when @IMULA_O32
						@imula_o32(reg0)

					when @IMUL_O16
						reg0 = @imul_o16(short(reg0), short(reg1))
					when @IMUL_O32
						reg0 = @imul_o32(reg0, reg1)

					when @DIV_O8
						@div_o8(reg0)
					when @DIV_O16
						@div_o16(reg0)
					when @DIV_O32
						@div_o32(reg0)

					when @IDIV_O8
						@idiv_o8(byte(reg0))
					when @IDIV_O16
						@idiv_o16(short(reg0))
					when @IDIV_O32
						@idiv_o32(reg0)

					when @BSF
						reg0 = @bsf(reg1, reg0)
					when @BSR
						reg0 = @bsr(reg1, reg0)

					when @BT_MEM
						@bt_mem(reg1, seg0, addr0)
					when @BTS_MEM
						@bts_mem(reg1, seg0, addr0)
					when @BTR_MEM
						@btr_mem(reg1, seg0, addr0)
					when @BTC_MEM
						@btc_mem(reg1, seg0, addr0)

					when @BT_O32
						 reg1 &= 0x1f
						 proc.setCarryFlag(reg0, reg1, proc.CY_NTH_BIT_SET)
					when @BT_O16
						 reg1 &= 0xf
						 proc.setCarryFlag(reg0, reg1, proc.CY_NTH_BIT_SET)
					when @BTS_O32
						reg1 &= 0x1f
						proc.setCarryFlag(reg0, reg1, proc.CY_NTH_BIT_SET)
						reg0 |= (1 << reg1)
					when @BTS_O16
						reg1 &= 0xf
						proc.setCarryFlag(reg0, reg1, proc.CY_NTH_BIT_SET)
						reg0 |= (1 << reg1)
					when @BTR_O32
						reg1 &= 0x1f
						proc.setCarryFlag(reg0, reg1, proc.CY_NTH_BIT_SET)
						reg0 &= ~(1 << reg1)
					when @BTR_O16
						reg1 &= 0xf
						proc.setCarryFlag(reg0, reg1, proc.CY_NTH_BIT_SET)
						reg0 &= ~(1 << reg1)
					when @BTC_O32
						reg1 &= 0x1f
						proc.setCarryFlag(reg0, reg1, proc.CY_NTH_BIT_SET)
						reg0 ^= (1 << reg1)
					when @BTC_O16
						reg1 &= 0xf
						proc.setCarryFlag(reg0, reg1, proc.CY_NTH_BIT_SET)
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
						reg1 %= 9
						reg0 |= (proc.getCarryFlag() ? 0x100 : 0)
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
						reg0 |= (proc.getCarryFlag() ? 0x100 : 0)
						reg2 = (proc.getCarryFlag() ^ ((reg0 & 0x80) != 0) ? 1:0)
						reg0 = (reg0 >>> reg1) | (reg0 << (9 - reg1))
					when @RCR_O16
						reg1 &= 0x1f
						reg1 %= 17
						reg2 = (proc.getCarryFlag() ^ ((reg0 & 0x8000) != 0) ? 1:0)
						reg0 |= (proc.getCarryFlag() ? 0x10000 : 0)
						reg0 = (reg0 >>> reg1) | (reg0 << (17 - reg1))

					when @RCR_O32
						reg1 &= 0x1f
						reg0 = (0xffffffff & reg0) | (proc.getCarryFlag() ? 0x100000000 : 0)
						reg2 = (proc.getCarryFlag() ^ ((reg0 & 0x80000000) != 0) ? 1:0)
						reg0 = int(reg0l = (reg0l >>> reg1) | (reg0l << (33 - reg1)))

					when @SHL
						reg2 = reg0
						reg0 <<= reg1
					when @SHR
						reg2 = reg0
						reg0 >>>= reg1
					when @SAR_O8
						reg2 = reg0
						reg0 = (byte(reg0)) >> reg1
					when @SAR_O16
						reg2 = reg0
						reg0 = (short(reg0)) >> reg1
					when @SAR_O32
						reg2 = reg0
						reg0 >>= reg1

					when @SHLD_O16
						i = reg0
						reg2 &= 0x1f
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
							reg0 = (reg1 >>> (reg2 -16)) | (reg0 << (32 - reg2))
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
						@aam(reg0)
					when @AAS
						@aas()

					when @DAA
						@daa()
					when @DAS
						@das()

					when @LAHF
						@lahf()
					when @SAHF
						@sahf()

					when @CLC
						proc.setCarryFlag(false)
					when @STC
						proc.setCarryFlag(true)
					when @CLI
						if (proc.getIOPrivilegeLevel() >= proc.getCPL())
							proc.eflagsInterruptEnable = false
							proc.eflagsInterruptEnableSoon = false
						else
							if ((proc.getIOPrivilegeLevel() < proc.getCPL()) && (proc.getCPL() == 3) && ((proc.getCR4() & 1) != 0))
								proc.eflagsInterruptEnableSoon = false
							else
								log("IOPL=" + proc.getIOPrivilegeLevel() + ", CPL=" + proc.getCPL())
								throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, 0, true)

					when @STI
						if (proc.getIOPrivilegeLevel() >= proc.getCPL())
							proc.eflagsInterruptEnable = true
							proc.eflagsInterruptEnableSoon = true
						else
							if ((proc.getIOPrivilegeLevel() < proc.getCPL()) && (proc.getCPL() == 3) && ((proc.getEFlags() & (1 << 20)) == 0))
								proc.eflagsInterruptEnableSoon = true
							else
								throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, 0, true)

					when @CLD
						proc.eflagsDirection = false
					when @STD
						proc.eflagsDirection = true
					when @CMC
						proc.setCarryFlag(!proc.getCarryFlag())

					when @SIGN_EXTEND_8_16
						reg0 = 0xffff & (byte(reg0))
					when @SIGN_EXTEND_8_32
						reg0 = byte(reg0)
					when @SIGN_EXTEND_16_32
						reg0 = short(reg0)

					when @INC
						reg0++
					when @DEC
						reg0--

					when @HALT
						if (proc.getCPL() != 0)
							throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, 0, true)
						else
							proc.waitForInterrupt()

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

					when @LOOP_CX
						@loop_cx(byte(reg0))
					when @LOOP_ECX
						@loop_ecx(byte(reg0))
					when @LOOPZ_CX
						@loopz_cx(byte(reg0))
					when @LOOPZ_ECX
						@loopz_ecx(byte(reg0))
					when @LOOPNZ_CX
						@loopnz_cx(byte(reg0))
					when @LOOPNZ_ECX
						@loopnz_ecx(byte(reg0))

					when @JUMP_O8
						@jump_o8(byte(reg0))
					when @JUMP_O16
						@jump_o16(short(reg0))
					when @JUMP_O32
						@jump_o32(reg0)

					when @JUMP_ABS_O16
						@jump_abs(reg0)
					when @JUMP_ABS_O32
						@jump_abs(reg0)

					when @JUMP_FAR_O16
						@jump_far(reg0, reg1)
					when @JUMP_FAR_O32
						@jump_far(reg0, reg1)


					when @CALL_O16_A16, @CALL_O16_A32
						if (proc.ss.getDefaultSizeFlag())
							@call_o16_a32(reg0)
						else
							@call_o16_a16(reg0)

					when @CALL_O32_A32, @CALL_O32_A16
						if (proc.ss.getDefaultSizeFlag())
							@call_o32_a32(reg0)
						else
							@call_o32_a16(reg0)

					when @CALL_ABS_O16_A32, @CALL_ABS_O16_A16
						if (proc.ss.getDefaultSizeFlag())
							@call_abs_o16_a32(reg0)
						else
							@call_abs_o16_a16(reg0)


					when @CALL_ABS_O32_A32, @CALL_ABS_O32_A16
						if (proc.ss.getDefaultSizeFlag())
							@call_abs_o32_a32(reg0)
						else
							@call_abs_o32_a16(reg0)

					when @CALL_FAR_O16_A32, @CALL_FAR_O16_A16
						if (proc.ss.getDefaultSizeFlag())
							@call_far_o16_a32(reg0, reg1)
						else
							@call_far_o16_a16(reg0, reg1)

					when @CALL_FAR_O32_A32, @CALL_FAR_O32_A16
						if (proc.ss.getDefaultSizeFlag())
							@call_far_o32_a32(reg0, reg1)
						else
							@call_far_o32_a16(reg0, reg1)

					when @RET_O16_A32, @RET_O16_A16
						if (proc.ss.getDefaultSizeFlag())
							@ret_o16_a32()
						else
							@ret_o16_a16()

					when @RET_O32_A32, @RET_O32_A16
						if (proc.ss.getDefaultSizeFlag())
							@ret_o32_a32()
						else
							@ret_o32_a16()

					when @RET_IW_O16_A32, @RET_IW_O16_A16
						if (proc.ss.getDefaultSizeFlag())
							@ret_iw_o16_a32(short(reg0))
						else
							@ret_iw_o16_a16(short(reg0))

					when @RET_IW_O32_A32, @RET_IW_O32_A16
						if (proc.ss.getDefaultSizeFlag())
							@ret_iw_o32_a32(short(reg0))
						else
							@ret_iw_o32_a16(short(reg0))

					when @RET_FAR_O16_A32, @RET_FAR_O16_A16
						if (proc.ss.getDefaultSizeFlag())
							@ret_far_o16_a32(0)
						else
							@ret_far_o16_a16(0)

					when @RET_FAR_O32_A32, @RET_FAR_O32_A16
						if (proc.ss.getDefaultSizeFlag())
							@ret_far_o32_a32(0)
						else
							@ret_far_o32_a16(0)

					when @RET_FAR_IW_O16_A32, @RET_FAR_IW_O16_A16
						if (proc.ss.getDefaultSizeFlag())
							@ret_far_o16_a32(short(reg0))
						else
							@ret_far_o16_a16(short(reg0))

					when @RET_FAR_IW_O32_A32, @RET_FAR_IW_O32_A16
						if (proc.ss.getDefaultSizeFlag())
							@ret_far_o32_a32(short(reg0))
						else
							@ret_far_o32_a16(short(reg0))

					when @INT_O16_A32, @INT_O16_A16
						proc.handleSoftProtectedModeInterrupt(reg0, @getInstructionLength(position))


					when @INT_O32_A32, @INT_O32_A16
						proc.handleSoftProtectedModeInterrupt(reg0, @getInstructionLength(position))

					when @INT3_O32_A32, @INT3_O32_A16
						proc.handleSoftProtectedModeInterrupt(3, @getInstructionLength(position))

					when @INTO_O32_A32
						if (proc.getOverflowFlag() == true)
							proc.handleSoftProtectedModeInterrupt(4, @getInstructionLength(position))

					when @IRET_O32_A32, @IRET_O32_A16
						if (proc.ss.getDefaultSizeFlag())
							reg0 = @iret_o32_a32()
						else
							reg0 = @iret_o32_a16()

					when @IRET_O16_A32, @IRET_O16_A16
						if (proc.ss.getDefaultSizeFlag())
							reg0 = @iret_o16_a32()
						else
							reg0 = @iret_o16_a16()

					when @SYSENTER
						@sysenter()
					when @SYSEXIT
						@sysexit(reg0, reg1)

					when @IN_O8
						reg0 = @in_o8(reg0)
					when @IN_O16
						reg0 = @in_o16(reg0)
					when @IN_O32
						reg0 = @in_o32(reg0)

					when @OUT_O8
						@out_o8(reg0, reg1)
					when @OUT_O16
						@out_o16(reg0, reg1)
					when @OUT_O32
						@out_o32(reg0, reg1)

					when @CMOVO
						 if (proc.getOverflowFlag())
						 	reg0 = reg1
					when @CMOVNO
						if (!proc.getOverflowFlag())
							reg0 = reg1
					when @CMOVC
						 if (proc.getCarryFlag())
						 	reg0 = reg1
					when @CMOVNC
						if (!proc.getCarryFlag())
							reg0 = reg1
					when @CMOVZ
						 if (proc.getZeroFlag())
						 	reg0 = reg1
					when @CMOVNZ
						if (!proc.getZeroFlag())
							reg0 = reg1
					when @CMOVNA
						if (proc.getCarryFlag() || proc.getZeroFlag())
							reg0 = reg1
					when @CMOVA
						 if ((!proc.getCarryFlag()) && (!proc.getZeroFlag()))
						 	reg0 = reg1
					when @CMOVS
						 if (proc.getSignFlag())
						 	reg0 = reg1
					when @CMOVNS
						if (!proc.getSignFlag())
							reg0 = reg1
					when @CMOVP
						 if (proc.getParityFlag())
						 	reg0 = reg1
					when @CMOVNP
						if (!proc.getParityFlag())
							reg0 = reg1
					when @CMOVL
						 if (proc.getSignFlag() != proc.getOverflowFlag())
						 	reg0 = reg1
					when @CMOVNL
						if (proc.getSignFlag() == proc.getOverflowFlag())
							reg0 = reg1
					when @CMOVNG
						if (proc.getZeroFlag() || (proc.getSignFlag() != proc.getOverflowFlag()))
							reg0 = reg1
					when @CMOVG
						 if ((!proc.getZeroFlag()) && (proc.getSignFlag() == proc.getOverflowFlag()))
						 	reg0 = reg1

					when @SETO
						 reg0 = proc.getOverflowFlag() ? 1 : 0
					when @SETNO
						reg0 = proc.getOverflowFlag() ? 0 : 1
					when @SETC
						 reg0 = proc.getCarryFlag() ? 1 : 0
					when @SETNC
						reg0 = proc.getCarryFlag() ? 0 : 1
					when @SETZ
						 reg0 = proc.getZeroFlag() ? 1 : 0
					when @SETNZ
						reg0 = proc.getZeroFlag() ? 0 : 1
					when @SETNA
						reg0 = proc.getCarryFlag() || proc.getZeroFlag() ? 1 : 0
					when @SETA
						 reg0 = proc.getCarryFlag() || proc.getZeroFlag() ? 0 : 1
					when @SETS
						 reg0 = proc.getSignFlag() ? 1 : 0
					when @SETNS
						reg0 = proc.getSignFlag() ? 0 : 1
					when @SETP
						 reg0 = proc.getParityFlag() ? 1 : 0
					when @SETNP
						reg0 = proc.getParityFlag() ? 0 : 1
					when @SETL
						 reg0 = proc.getSignFlag() != proc.getOverflowFlag() ? 1 : 0
					when @SETNL
						reg0 = proc.getSignFlag() != proc.getOverflowFlag() ? 0 : 1
					when @SETNG
						reg0 = proc.getZeroFlag() || (proc.getSignFlag() != proc.getOverflowFlag()) ? 1 : 0
					when @SETG
						 reg0 = proc.getZeroFlag() || (proc.getSignFlag() != proc.getOverflowFlag()) ? 0  : 1

					when @SALC
						reg0 = proc.getCarryFlag() ? -1 : 0

					when @SMSW
						reg0 = proc.getCR0() & 0xffff
					when @LMSW
						if (proc.getCPL() != 0)
							throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, 0, true)
						proc.setCR0((proc.getCR0() & ~0xe) | (reg0 & 0xe))

					when @CMPXCHG
						if (reg2 == reg0)
							reg0 = reg1
							reg1 = reg2
						else
							reg1 = reg0

					when @CMPXCHG8B
						edxeax = ((proc.edx & 0xffffffff) << 32) | (proc.eax & 0xffffffff)
						if (edxeax == reg0)
							proc.setZeroFlag(true)
							reg0 = ((proc.ecx & 0xffffffff) << 32) | (proc.ebx & 0xffffffff)
						else
							proc.setZeroFlag(false)
							proc.edx = int(reg0 >> 32)
							proc.eax = int(reg0)

					when @BSWAP
						reg0 = @reverseBytes(reg0)

					when @ENTER_O32_A32, @ENTER_O32_A16

						if (proc.ss.getDefaultSizeFlag())
							@enter_o32_a32(reg0, reg1)
						else
							throw new IllegalStateException("need enter_o32_a16")

					when @ENTER_O16_A32, @ENTER_O16_A16
						if (proc.ss.getDefaultSizeFlag())
							@enter_o16_a32(reg0, reg1)
						else
							@enter_o16_a16(reg0, reg1)

					when @LEAVE_O32_A32, @LEAVE_O32_A16

						if (proc.ss.getDefaultSizeFlag())
							@leave_o32_a32()
						else
							@leave_o32_a16()

					when @LEAVE_O16_A32, @LEAVE_O16_A16
						if (proc.ss.getDefaultSizeFlag())
							@leave_o16_a32()
						else
							@leave_o16_a16()

					when @PUSH_O32_A16, @PUSH_O32_A32
						if (proc.ss.getDefaultSizeFlag())
							@push_o32_a32(reg0)
						else
							@push_o32_a16(reg0)

					when @PUSH_O16_A16, @PUSH_O16_A32

						if (proc.ss.getDefaultSizeFlag())
							@push_o16_a32(short(reg0))
						else
							@push_o16_a16(short(reg0))

					when @PUSHF_O32_A16, @PUSHF_O32_A32
						if (proc.ss.getDefaultSizeFlag())
							@push_o32_a32(~0x30000 & reg0)
						else
							@push_o32_a16(~0x30000 & reg0)

					when @PUSHF_O16_A16, @PUSHF_O16_A32

						if (proc.ss.getDefaultSizeFlag())
							@push_o16_a32(short(reg0))
						else
							@push_o16_a16(short(reg0))

					when @POP_O32_A16, @POP_O32_A32
						if (proc.ss.getDefaultSizeFlag())
							reg1 = proc.esp + 4
							if (@microcodes[position] == @STORE0_SS)
								proc.eflagsInterruptEnable = false
								reg0 = proc.ss.getDoubleWord(proc.esp)
						else
							reg1 = (proc.esp & ~0xffff) | ((proc.esp + 4) & 0xffff)
						if (@microcodes[position] == @STORE0_SS)
							proc.eflagsInterruptEnable = false
						reg0 = proc.ss.getDoubleWord(0xffff & proc.esp)

					when @POP_O16_A16, @POP_O16_A32

						if (proc.ss.getDefaultSizeFlag())
							reg1 = proc.esp + 2
							if (@microcodes[position] == @STORE0_SS)
								proc.eflagsInterruptEnable = false
							reg0 = 0xffff & proc.ss.getWord(proc.esp)
						else
							reg1 = (proc.esp & ~0xffff) | ((proc.esp + 2) & 0xffff)
							if (@microcodes[position] == @STORE0_SS)
								proc.eflagsInterruptEnable = false
							reg0 = 0xffff & proc.ss.getWord(0xffff & proc.esp)

					when @POPF_O32_A16, @POPF_O32_A32

						if (proc.ss.getDefaultSizeFlag())
							reg0 = proc.ss.getDoubleWord(proc.esp)
							proc.esp += 4
						else
							reg0 = proc.ss.getDoubleWord(0xffff & proc.esp)
							proc.esp = (proc.esp & ~0xffff) | ((proc.esp + 4) & 0xffff)

						if (proc.getCPL() == 0)
							reg0 = ((proc.getEFlags() & 0x20000) | (reg0 & ~(0x20000 | 0x180000)))
						else
							if (proc.getCPL() > proc.eflagsIOPrivilegeLevel)
								reg0 = ((proc.getEFlags() & 0x23200) | (reg0 & ~(0x23200 | 0x180000)))
							else
								reg0 = ((proc.getEFlags() & 0x23000) | (reg0 & ~(0x23000 | 0x180000)))

					when @POPF_O16_A16, @POPF_O16_A32

						if (proc.ss.getDefaultSizeFlag())
							reg0 = 0xffff & proc.ss.getWord(proc.esp)
							proc.esp += 2
						else
							reg0 = 0xffff & proc.ss.getWord(0xffff & proc.esp)
							proc.esp = (proc.esp & ~0xffff) | ((proc.esp + 2) & 0xffff)
						if (proc.getCPL() != 0)
							if (proc.getCPL() > proc.eflagsIOPrivilegeLevel)
								reg0 = ((proc.getEFlags() & 0x3200) | (reg0 & ~0x3200))
							else
								reg0 = ((proc.getEFlags() & 0x3000) | (reg0 & ~0x3000))


					when @PUSHAD_A32
						if (proc.ss.getDefaultSizeFlag())
							@pushad_a32()
						else
							@pushad_a16()

					when @PUSHAD_A16
						if (proc.ss.getDefaultSizeFlag())
							@pusha_a32()
						else
							@pusha_a16()

					when @POPA_A32, @POPA_A16

						if (proc.ss.getDefaultSizeFlag())
							@popa_a32()
						else
							@popa_a16()

					when @POPAD_A32, @POPAD_A16
						if (proc.ss.getDefaultSizeFlag())
							@popad_a32()
						else
							@popad_a16()

					when @CMPSB_A32
						@cmpsb_a32(seg0)
					when @CMPSW_A32
						@cmpsw_a32(seg0)
					when @CMPSD_A32
						@cmpsd_a32(seg0)
					when @REPE_CMPSB_A16
						@repe_cmpsb_a16(seg0)
					when @REPE_CMPSB_A32
						@repe_cmpsb_a32(seg0)
					when @REPE_CMPSW_A32
						@repe_cmpsw_a32(seg0)
					when @REPE_CMPSD_A32
						@repe_cmpsd_a32(seg0)
					when @REPNE_CMPSB_A32
						@repne_cmpsb_a32(seg0)
					when @REPNE_CMPSW_A32
						@repne_cmpsw_a32(seg0)
					when @REPNE_CMPSD_A32
						@repne_cmpsd_a32(seg0)

					when @INSB_A32
						@insb_a32(reg0)
					when @INSW_A32
						@insw_a32(reg0)
					when @INSD_A32
						@insd_a32(reg0)
					when @REP_INSB_A32
						@rep_insb_a32(reg0)
					when @REP_INSW_A32
						@rep_insw_a32(reg0)
					when @REP_INSD_A32
						@rep_insd_a32(reg0)

					when @LODSB_A16
						@lodsb_a16(seg0)
					when @LODSB_A32
						@lodsb_a32(seg0)
					when @LODSW_A16
						@lodsw_a16(seg0)
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
						rep_movsw_a16(seg0)
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
					when @OUTSB_A32
						@outsb_a32(reg0, seg0)
					when @OUTSW_A32
						@outsw_a32(reg0, seg0)
					when @OUTSD_A32
						@outsd_a32(reg0, seg0)
					when @REP_OUTSB_A32
						@rep_outsb_a32(reg0, seg0)
					when @REP_OUTSW_A32
						@rep_outsw_a32(reg0, seg0)
					when @REP_OUTSD_A32
						@rep_outsd_a32(reg0, seg0)
					when @SCASB_A16
						@scasb_a16(reg0)
					when @SCASB_A32
						@scasb_a32(reg0)
					when @SCASW_A32
						@scasw_a32(reg0)
					when @SCASD_A32
						@scasd_a32(reg0)
					when @REPE_SCASB_A16
						@repe_scasb_a16(reg0)
					when @REPE_SCASB_A32
						@repe_scasb_a32(reg0)
					when @REPE_SCASW_A32
						@repe_scasw_a32(reg0)
					when @REPE_SCASD_A32
						@repe_scasd_a32(reg0)
					when @REPNE_SCASB_A16
						@repne_scasb_a16(reg0)
					when @REPNE_SCASB_A32
						@repne_scasb_a32(reg0)
					when @REPNE_SCASW_A32
						@repne_scasw_a32(reg0)
					when @REPNE_SCASD_A32
						@repne_scasd_a32(reg0)

					when @STOSB_A16
						@stosb_a16(reg0)
					when @STOSB_A32
						@stosb_a32(reg0)
					when @STOSW_A16
						@stosw_a16(reg0)
					when @STOSW_A32
						@stosw_a32(reg0)
					when @STOSD_A16
						@stosd_a16(reg0)
					when @STOSD_A32
						@stosd_a32(reg0)
					when @REP_STOSB_A16
						@rep_stosb_a16(reg0)
					when @REP_STOSB_A32
						@rep_stosb_a32(reg0)
					when @REP_STOSW_A16
						@rep_stosw_a16(reg0)
					when @REP_STOSW_A32
						@rep_stosw_a32(reg0)
					when @REP_STOSD_A16
						@rep_stosd_a16(reg0)
					when @REP_STOSD_A32
						@rep_stosd_a32(reg0)

					when @LGDT_O16
						proc.gdtr = proc.createDescriptorTableSegment(reg1 & 0x00ffffff, reg0)
					when @LGDT_O32
						proc.gdtr = proc.createDescriptorTableSegment(reg1, reg0)
					when @SGDT_O16
						reg1 = proc.gdtr.getBase() & 0x00ffffff
						reg0 = proc.gdtr.getLimit()
					when @SGDT_O32
						reg1 = proc.gdtr.getBase()
						reg0 = proc.gdtr.getLimit()

					when @LIDT_O16
						proc.idtr = proc.createDescriptorTableSegment(reg1 & 0x00ffffff, reg0)
					when @LIDT_O32
						proc.idtr = proc.createDescriptorTableSegment(reg1, reg0)
					when @SIDT_O16
						reg1 = proc.idtr.getBase() & 0x00ffffff
						reg0 = proc.idtr.getLimit()
					when @SIDT_O32
						reg1 = proc.idtr.getBase()
						reg0 = proc.idtr.getLimit()

					when @LLDT
						proc.ldtr = @lldt(reg0)
					when @SLDT
						reg0 = 0xffff & proc.ldtr.getSelector()

					when @LTR
						proc.tss = @ltr(reg0)
					when @STR
						reg0 = 0xffff & proc.tss.getSelector()

					when @VERR
						try
							test = proc.getSegment(reg0 & 0xffff)
							type = test.getType()
							if (((type & ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA) == 0) || (((type & ProtectedModeSegment.TYPE_CODE_CONFORMING) == 0) && ((proc.getCPL() > test.getDPL()) || (test.getRPL() > test.getDPL()))))
								proc.setZeroFlag(false)
							else
								proc.setZeroFlag(((type & ProtectedModeSegment.TYPE_CODE) == 0) || ((type & ProtectedModeSegment.TYPE_CODE_READABLE) != 0))
						catch e
							proc.setZeroFlag(false)


					when @VERW
						try
							test = proc.getSegment(reg0 & 0xffff)
							type = test.getType()
							if (((type & ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA) == 0) || (((type & ProtectedModeSegment.TYPE_CODE_CONFORMING) == 0) && ((proc.getCPL() > test.getDPL()) || (test.getRPL() > test.getDPL()))))
								proc.setZeroFlag(false)
							else
								proc.setZeroFlag(((type & ProtectedModeSegment.TYPE_CODE) == 0) && ((type & ProtectedModeSegment.TYPE_DATA_WRITABLE) != 0))
						catch e
							proc.setZeroFlag(false)

					when @CLTS
						if (proc.getCPL() != 0)
							throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, 0, true)
						proc.setCR3(proc.getCR3() & ~0x4)

					when @INVLPG
						if (proc.getCPL() != 0)
							throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, 0, true)

						proc.linearMemory.invalidateTLBEntry(seg0.translateAddressRead(addr0))

					when @CPUID
						@cpuid()

					when @LAR
						reg0 = @lar(reg0, reg1)
					when @LSL
						reg0 = @lsl(reg0, reg1)

					when @WRMSR
						if (proc.getCPL() != 0)
							throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, 0, true)
						proc.setMSR(reg0, (reg2 & 0xffffffff) | ((reg1 & 0xffffffff) << 32))
					when @RDMSR
						if (proc.getCPL() != 0)
							throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, 0, true)
						msr = proc.getMSR(reg0)
						reg0 = msr
						reg1 = int(msr >>> 32)

					when @RDTSC
						tsc = @rdtsc()
						reg0 = int(tsc)
						reg1 = int(tsc >>> 32)

					when @CMPXCHG_O8_FLAGS
						sub_o8_flags(reg2 - reg1, reg2, reg1)
					when @CMPXCHG_O16_FLAGS
						sub_o16_flags(reg2 - reg1, reg2, reg1)
					when @CMPXCHG_O32_FLAGS
						@sub_o32_flags((0xffffffff & reg2) - (0xffffffff & reg1), reg2, reg1)

					when @BITWISE_FLAGS_O8
						bitwise_flags(byte(reg0))
					when @BITWISE_FLAGS_O16
						bitwise_flags(short(reg0))
					when @BITWISE_FLAGS_O32
						bitwise_flags(reg0)

					when @SUB_O8_FLAGS
						sub_o8_flags(reg0, reg2, reg1)
					when @SUB_O16_FLAGS
						sub_o16_flags(reg0, reg2, reg1)
					when @SUB_O32_FLAGS
						@sub_o32_flags(reg0, reg2, reg1)

					when @ADD_O8_FLAGS
						add_o8_flags(reg0, reg2, reg1)
					when @ADD_O16_FLAGS
						@add_o16_flags(reg0, reg2, reg1)
					when @ADD_O32_FLAGS
						@add_o32_flags(reg0, reg2, reg1)

					when @ADC_O8_FLAGS
						@adc_o8_flags(reg0, reg2, reg1)
					when @ADC_O16_FLAGS
						@adc_o16_flags(reg0, reg2, reg1)
					when @ADC_O32_FLAGS
						@adc_o32_flags(reg0, reg2, reg1)

					when @SBB_O8_FLAGS
						@sbb_o8_flags(reg0, reg2, reg1)
					when @SBB_O16_FLAGS
						@sbb_o16_flags(reg0, reg2, reg1)
					when @SBB_O32_FLAGS
						@sbb_o32_flags(reg0, reg2, reg1)

					when @INC_O8_FLAGS
						@inc_flags(byte(reg0))
					when @INC_O16_FLAGS
						@inc_flags(short(reg0))
					when @INC_O32_FLAGS
						@inc_flags(reg0)

					when @DEC_O8_FLAGS
						@dec_flags(byte(eg0))
					when @DEC_O16_FLAGS
						@dec_flags(short(reg0))
					when @DEC_O32_FLAGS
						@dec_flags(reg0)

					when @SHL_O8_FLAGS
						@shl_flags(byte(reg0), byte(reg2), reg1)
					when @SHL_O16_FLAGS
						@shl_flags(short(reg0), short(reg2), reg1)
					when @SHL_O32_FLAGS
						@shl_flags(reg0, reg2, reg1)

					when @SHR_O8_FLAGS
						shr_flags(byte(reg0), reg2, reg1)
					when @SHR_O16_FLAGS
						shr_flags(short(reg0), reg2, reg1)
					when @SHR_O32_FLAGS
						shr_flags(reg0, reg2, reg1)

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
						@rcl_o32_flags(reg0, reg1)

					when @RCR_O8_FLAGS
						@rcr_o8_flags(reg0, reg1, reg2)
					when @RCR_O16_FLAGS
						@rcr_o16_flags(reg0, reg1, reg2)
					when @RCR_O32_FLAGS
						@rcr_o32_flags(reg0, reg1, reg2)

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


					when @CPL_CHECK
						if (proc.getCPL() != 0)
							throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, 0, true)

					else
						throw "File: ProtectedModeUBlock: Not added microcode yet? #{@microcodes[position - 1]}"

		catch e
			throw e

		return @executeCount

	getInstructionLength: (position) ->
		nextPosition = position - 1 #this makes position point at the microcode that just barfed

		ans = -cumulativeX86Length[nextPosition] # undo the eipUpdate

		for selfPosition in [nextPosition..0]
			if (cumulativeX86Length[selfPosition] != cumulativeX86Length[nextPosition])
				ans += cumulativeX86Length[selfPosition];
		if (ans <= 0)
		    ans = -ans # instruction was first instruction in block
		return ans

	cmpsb_a32: (seg0) ->
		addrOne = proc.esi
		addrTwo = proc.edi

		int dataOne = 0xff & seg0.getByte(addrOne)
		int dataTwo = 0xff & proc.es.getByte(addrTwo)
		if (proc.eflagsDirection)
			addrOne -= 1
			addrTwo -= 1
		else
			addrOne += 1
			addrTwo += 1
		proc.esi = addrOne
		proc.edi = addrTwo

		sub_o8_flags(dataOne - dataTwo, dataOne, dataTwo)


	cmpsw_a32: (seg0) ->
		addrOne = proc.esi
		addrTwo = proc.edi

		dataOne = 0xffff & seg0.getWord(addrOne)
		dataTwo = 0xffff & proc.es.getWord(addrTwo)
		if (proc.eflagsDirection)
			addrOne -= 2
			addrTwo -= 2
		else
			addrOne += 2
			addrTwo += 2

		proc.esi = addrOne
		proc.edi = addrTwo

		sub_o16_flags(dataOne - dataTwo, dataOne, dataTwo)

	cmpsd_a32: (seg0) ->

		addrOne = proc.esi
		addrTwo = proc.edi

		dataOne = seg0.getDoubleWord(addrOne)
		dataTwo = proc.es.getDoubleWord(addrTwo)

		if (proc.eflagsDirection)
			addrOne -= 4
			addrTwo -= 4
		else
			addrOne += 4
			addrTwo += 4

		proc.esi = addrOne
		proc.edi = addrTwo

		sub_o32_flags((0xffffffff & dataOne) - (0xffffffff & dataTwo), dataOne, dataTwo)


	repe_cmpsb_a16: (seg0) ->
		count = 0xFFFF & proc.ecx
		addrOne = 0xFFFF & proc.esi
		addrTwo = 0xFFFF & proc.edi
		used = count != 0
		dataOne = 0
		dataTwo = 0

		try
			if (proc.eflagsDirection)
				while (count != 0)
					#check hardware interrupts
					dataOne = 0xff & seg0.getByte(addrOne)
					dataTwo = 0xff & proc.es.getByte(addrTwo)
					count--
					addrOne -= 1
					addrTwo -= 1
					if (dataOne != dataTwo)
						break
			else
				while (count != 0)
					#check hardware interrupts
					dataOne = 0xff & seg0.getByte(addrOne)
					dataTwo = 0xff & proc.es.getByte(addrTwo)
					count--
					addrOne += 1
					addrTwo += 1
					if (dataOne != dataTwo)
						break
		finally
			@executeCount += ((proc.ecx &0xFFFF)  - count)
			proc.ecx = (proc.ecx & ~0xFFFF)|(count & 0xFFFF)
			proc.esi = (proc.esi & ~0xFFFF)|(addrOne & 0xFFFF)
			proc.edi = (proc.edi & ~0xFFFF)|(addrTwo & 0xFFFF)

			if (used)
				sub_o8_flags(dataOne - dataTwo, dataOne, dataTwo)

	repe_cmpsb_a32: (seg0) ->

		count = proc.ecx
		addrOne = proc.esi
		addrTwo = proc.edi
		used = count != 0
		dataOne = 0
		dataTwo = 0

		try
			if (proc.eflagsDirection)
				while (count != 0)
				# check hardware interrupts
					dataOne = 0xff & seg0.getByte(addrOne)
					dataTwo = 0xff & proc.es.getByte(addrTwo)
					count--
					addrOne -= 1
					addrTwo -= 1
					if (dataOne != dataTwo)
						break;
			else
				while (count != 0)
					#check hardware interrupts
					dataOne = 0xff & seg0.getByte(addrOne)
					dataTwo = 0xff & proc.es.getByte(addrTwo)
					count--
					addrOne += 1
					addrTwo += 1
					if (dataOne != dataTwo)
						break
		finally
			@executeCount += (proc.ecx  - count)
			proc.ecx = count
			proc.esi = addrOne
			proc.edi = addrTwo

			if (used)
				sub_o8_flags(dataOne - dataTwo, dataOne, dataTwo)

	repe_cmpsw_a32: (seg0) ->
		count = proc.ecx
		addrOne = proc.esi
		addrTwo = proc.edi
		used = count != 0
		dataOne = 0
		dataTwo = 0

		try
			if (proc.eflagsDirection)
				while (count != 0)
					#check hardware interrupts
					dataOne = 0xffff & seg0.getWord(addrOne)
					dataTwo = 0xffff & proc.es.getWord(addrTwo)
					count--
					addrOne -= 2
					addrTwo -= 2
					if (dataOne != dataTwo)
						break
			else
				while (count != 0)
					#check hardware interrupts
					dataOne = 0xffff & seg0.getWord(addrOne)
					dataTwo = 0xffff & proc.es.getWord(addrTwo)
					count--
					addrOne += 2
					addrTwo += 2
					if (dataOne != dataTwo)
						break
		finally
			@executeCount += (proc.ecx - count)
			proc.ecx = count
			proc.esi = addrOne
			proc.edi = addrTwo

			if (used)
				sub_o16_flags(dataOne - dataTwo, dataOne, dataTwo)


	repe_cmpsd_a32: (seg0) ->
		count = proc.ecx
		addrOne = proc.esi
		addrTwo = proc.edi
		used = count != 0
		dataOne = 0
		dataTwo = 0

		try
			if (proc.eflagsDirection)
				while (count != 0)
					#check hardware interrupts
					dataOne = seg0.getDoubleWord(addrOne)
					dataTwo = proc.es.getDoubleWord(addrTwo)
					count--
					addrOne -= 4
					addrTwo -= 4
					if (dataOne != dataTwo)
						break
			else
				while (count != 0)
					#check hardware interrupts
					dataOne = seg0.getDoubleWord(addrOne)
					dataTwo = proc.es.getDoubleWord(addrTwo)
					count--
					addrOne += 4
					addrTwo += 4
					if (dataOne != dataTwo)
						break
		finally
			@executeCount += (proc.ecx - count)
			proc.ecx = count
			proc.esi = addrOne
			proc.edi = addrTwo

			if (used)
				sub_o32_flags((0xffffffff & dataOne) - (0xffffffff & dataTwo), dataOne, dataTwo)

	repne_cmpsb_a32: (seg0) ->

		count = proc.ecx
		addrOne = proc.esi
		addrTwo = proc.edi
		used = count != 0
		dataOne = 0
		dataTwo = 0

		try
			if (proc.eflagsDirection)
				while (count != 0)
					#check hardware interrupts
					dataOne = 0xff & seg0.getByte(addrOne)
					dataTwo = 0xff & proc.es.getByte(addrTwo)
					count--
					addrOne -= 1
					addrTwo -= 1
					if (dataOne == dataTwo)
						break

			else
				while (count != 0)
					#check hardware interrupts
					dataOne = 0xff & seg0.getByte(addrOne)
					dataTwo = 0xff & proc.es.getByte(addrTwo)
					count--
					addrOne += 1
					addrTwo += 1
					if (dataOne == dataTwo)
						break
		finally
			@executeCount += (proc.ecx  - count)
			proc.ecx = count
			proc.esi = addrOne
			proc.edi = addrTwo

			if (used)
				sub_o8_flags(dataOne - dataTwo, dataOne, dataTwo)

	repne_cmpsw_a32: (seg0) ->
		count = proc.ecx
		addrOne = proc.esi
		addrTwo = proc.edi
		used = count != 0
		dataOne = 0
		dataTwo = 0
		try
			if (proc.eflagsDirection)
				while (count != 0)
					#check hardware interrupts
					dataOne = 0xffff & seg0.getWord(addrOne)
					dataTwo = 0xffff & proc.es.getWord(addrTwo)
					count--
					addrOne -= 2
					addrTwo -= 2
					if (dataOne == dataTwo)
						break
			else
				while (count != 0)
					#check hardware interrupts
					dataOne = 0xffff & seg0.getWord(addrOne)
					dataTwo = 0xffff & proc.es.getWord(addrTwo)
					count--
					addrOne += 2
					addrTwo += 2
					if (dataOne == dataTwo)
						break
		finally
			@executeCount += (proc.ecx - count)
			proc.ecx = count
			proc.esi = addrOne
			proc.edi = addrTwo

			if (used)
				sub_o16_flags(dataOne - dataTwo, dataOne, dataTwo)

	repne_cmpsd_a32: (seg0) ->
		count = proc.ecx
		addrOne = proc.esi
		addrTwo = proc.edi
		used = count != 0
		dataOne = 0
		dataTwo = 0

		try
			if (proc.eflagsDirection)
				while (count != 0)
					#check hardware interrupts
					dataOne = seg0.getDoubleWord(addrOne)
					dataTwo = proc.es.getDoubleWord(addrTwo)
					count--
					addrOne -= 4
					addrTwo -= 4
					if (dataOne == dataTwo)
						break;
			else
				while (count != 0)
					#check hardware interrupts
					dataOne = proc.es.getDoubleWord(addrOne)
					dataTwo = seg0.getDoubleWord(addrTwo)
					count--
					addrOne += 4
					addrTwo += 4
					if (dataOne == dataTwo)
						break
		finally
			@executeCount += (proc.ecx - count)
			proc.ecx = count
			proc.esi = addrOne
			proc.edi = addrTwo

			if (used)
				sub_o32_flags((0xffffffff & dataOne) - (0xffffffff & dataTwo), dataOne, dataTwo)

	insb_a32: (port) ->
		if (!@checkIOPermissionsByte(port))
			log "denied access to io port #{port}"
			throw ProcessorException.GENERAL_PROTECTION_0

		addr = proc.edi
		proc.es.setByte(addr, byte(proc.ioports.ioPortReadByte(port)))
		if (proc.eflagsDirection)
			addr -= 1
		else
			addr += 1

		proc.edi = addr

	insw_a32: (port) ->
		if (!@checkIOPermissionsShort(port))
			log "denied access to io port #{port}"
			throw ProcessorException.GENERAL_PROTECTION_0

		addr = proc.edi
		proc.es.setWord(addr, short(proc.ioports.ioPortReadWord(port)))
		if (proc.eflagsDirection)
			addr -= 2
		else
			addr += 2

		proc.edi = addr

	insd_a32: (port) ->
		if (!@checkIOPermissionsInt(port))
			log "denied access to io port #{port}"
			throw ProcessorException.GENERAL_PROTECTION_0

		addr = proc.edi
		proc.es.setDoubleWord(addr, proc.ioports.ioPortReadLong(port))
		if (proc.eflagsDirection)
			addr -= 4
		else
			addr += 4

		proc.edi = addr

	rep_insb_a32: (port) ->
		if (!@checkIOPermissionsByte(port))
			log "denied access to io port #{port}"
			throw ProcessorException.GENERAL_PROTECTION_0

		count = proc.ecx
		addr = proc.edi
		@executeCount += count

		try
			if (proc.eflagsDirection)
				while (count != 0)
					#check hardware interrupts
					proc.es.setByte(addr, byte(proc.ioports.ioPortReadByte(port)))
					count--
					addr -= 1

			else
				while (count != 0)
					#check hardware interrupts
					proc.es.setByte(addr, byte(proc.ioports.ioPortReadByte(port)))
					count--
					addr += 1
		finally
			proc.ecx = count
			proc.edi = addr

	rep_insw_a32: (port) ->
		if (!@checkIOPermissionsShort(port))
			log "denied access to io port #{port}"
			throw ProcessorException.GENERAL_PROTECTION_0

		count = proc.ecx
		addr = proc.edi
		@executeCount += count

		try
			if (proc.eflagsDirection)
				while (count != 0)
					#check hardware interrupts
					proc.es.setWord(addr, short(proc.ioports.ioPortReadWord(port)))
					count--
					addr -= 2
			else
				while (count != 0)
					#check hardware interrupts
					proc.es.setWord(addr, short(proc.ioports.ioPortReadWord(port)))
					count--
					addr += 2
		finally
			proc.ecx = count
			proc.edi = addr

	rep_insd_a32: (port) ->
		if (!@checkIOPermissionsShort(port))
			log "denied access to io port #{port}"
			throw ProcessorException.GENERAL_PROTECTION_0

		count = proc.ecx
		addr = proc.edi
		@executeCount += count

		try
			if (proc.eflagsDirection)
				while (count != 0)
					#check hardware interrupts
					proc.es.setDoubleWord(addr, proc.ioports.ioPortReadLong(port))
					count--
					addr -= 4
			else
				while (count != 0)
					#check hardware interrupts
					proc.es.setDoubleWord(addr, proc.ioports.ioPortReadLong(port))
					count--
					addr += 4
		finally
			proc.ecx = count
			proc.edi = addr

	lodsb_a16: (dataSegment) ->
		addr = 0xFFFF & proc.esi ;
		proc.eax = (proc.eax & ~0xff) | (0xff & dataSegment.getByte(addr))

		if (proc.eflagsDirection)
			addr -= 1
		else
			addr += 1

		proc.esi =(proc.esi & ~0xffff) | (0xffff &  addr);


	lodsb_a32: (dataSegment) ->
		addr = proc.esi
		proc.eax = (proc.eax & ~0xff) | (0xff & dataSegment.getByte(addr))

		if (proc.eflagsDirection)
			addr -= 1
		else
			addr += 1

		proc.esi = addr

	lodsw_a16: (dataSegment) ->
		int addr = proc.esi & 0xFFFF;
		proc.eax = (proc.eax & ~0xffff) | (0xffff & dataSegment.getWord(addr))

		if (proc.eflagsDirection)
			addr -= 2
		else
			addr += 2

		proc.esi =(proc.esi & ~0xffff) | (0xffff &  addr)

	lodsw_a32: (dataSegment) ->
		addr = proc.esi
		proc.eax = (proc.eax & ~0xffff) | (0xffff & dataSegment.getWord(addr))

		if (proc.eflagsDirection)
			addr -= 2
		else
			addr += 2

		proc.esi = addr

	lodsd_a32: (dataSegment) ->
		addr = proc.esi
		proc.eax = dataSegment.getDoubleWord(addr)

		if (proc.eflagsDirection)
			addr -= 4
		else
			addr += 4

		proc.esi = addr

	rep_lodsb_a32: (dataSegment) ->
		count = proc.ecx
		addr = proc.esi
		data = proc.eax & 0xff
		@executeCount += count

		try
			if (proc.eflagsDirection)
				while (count != 0)
					#check hardware interrupts
					data = 0xff & dataSegment.getByte(addr)
					count--
					addr -= 1
			else
				while (count != 0)
					#check hardware interrupts
					data = 0xff & dataSegment.getByte(addr)
					count--
					addr += 1
		finally
			proc.eax = (proc.eax & ~0xff) | data
			proc.ecx = count
			proc.esi = addr

	rep_lodsw_a32: (dataSegment) ->
		count = proc.ecx
		addr = proc.esi
		data = proc.eax & 0xffff
		@executeCount += count

		try
			if (proc.eflagsDirection)
				while (count != 0)
					#check hardware interrupts
					data = 0xffff & dataSegment.getWord(addr)
					count--
					addr -= 2
			else
				while (count != 0)
					#check hardware interrupts
					data = 0xffff & dataSegment.getWord(addr)
					count--
					addr += 2
		finally
			proc.eax = (proc.eax & ~0xffff) | data
			proc.ecx = count
			proc.esi = addr


	rep_lodsd_a32: (dataSegment) ->
		count = proc.ecx
		addr = proc.esi
		data = proc.eax
		@executeCount += count

		try
			if (proc.eflagsDirection)
				while (count != 0)
					#check hardware interrupts
					data = dataSegment.getDoubleWord(addr)
					count--
					addr -= 4
			else
				while (count != 0)
					#check hardware interrupts
					data = dataSegment.getDoubleWord(addr)
					count--
					addr += 4
		finally
			proc.eax = data
			proc.ecx = count
			proc.esi = addr

	movsb_a16: (outSegment) ->
		inAddr = proc.edi & 0xffff
		outAddr = proc.esi & 0xffff

		proc.es.setByte(inAddr, outSegment.getByte(outAddr))
		if (proc.eflagsDirection)
			outAddr -= 1
			inAddr -= 1
		else
			outAddr += 1
			inAddr += 1

		proc.edi = (proc.edi & ~0xffff) | (inAddr & 0xffff)
		proc.esi = (proc.esi & ~0xffff) | (outAddr & 0xffff)

	movsw_a16: (outSegment) ->
		inAddr = proc.edi & 0xffff
		outAddr = proc.esi & 0xffff

		proc.es.setWord(inAddr, outSegment.getWord(outAddr))
		if (proc.eflagsDirection)
			outAddr -= 2
			inAddr -= 2
		else
			outAddr += 2
			inAddr += 2

		proc.edi = (proc.edi & ~0xffff) | (inAddr & 0xffff)
		proc.esi = (proc.esi & ~0xffff) | (outAddr & 0xffff)

	movsd_a16: (outSegment) ->
		inAddr = proc.edi & 0xffff
		outAddr = proc.esi & 0xffff

		proc.es.setDoubleWord(inAddr, outSegment.getDoubleWord(outAddr))
		if (proc.eflagsDirection)
			outAddr -= 4
			inAddr -= 4
		else
			outAddr += 4
			inAddr += 4

		proc.edi = (proc.edi & ~0xffff) | (inAddr & 0xffff)
		proc.esi = (proc.esi & ~0xffff) | (outAddr & 0xffff)

	rep_movsb_a16: (outSegment) ->
		count = proc.ecx & 0xffff
		inAddr = proc.edi & 0xffff
		outAddr = proc.esi & 0xffff
		@executeCount += count

		try
			if (proc.eflagsDirection)
				while (count != 0)
					#check hardware interrupts
					proc.es.setByte(inAddr & 0xffff, outSegment.getByte(outAddr & 0xffff))
					count--
					outAddr -= 1
					inAddr -= 1
			else
				while (count != 0)
					#check hardware interrupts
					proc.es.setByte(inAddr & 0xffff, outSegment.getByte(outAddr & 0xffff))
					count--
					outAddr += 1
					inAddr += 1
		finally
			proc.ecx = (proc.ecx & ~0xffff) | (count & 0xffff)
			proc.edi = (proc.edi & ~0xffff) | (inAddr & 0xffff)
			proc.esi = (proc.esi & ~0xffff) | (outAddr & 0xffff)

	rep_movsd_a16: (outSegment) ->
		count = proc.ecx & 0xffff
		inAddr = proc.edi & 0xffff
		outAddr = proc.esi & 0xffff
		@executeCount += count

		try
			if (proc.eflagsDirection)
				while (count != 0)
					#check hardware interrupts
					proc.es.setDoubleWord(inAddr & 0xffff, outSegment.getDoubleWord(outAddr & 0xffff))
					count--
					outAddr -= 4
					inAddr -= 4
			else
				while (count != 0)
					#check hardware interrupts
					proc.es.setDoubleWord(inAddr & 0xffff, outSegment.getDoubleWord(outAddr & 0xffff))
					count--
					outAddr += 4
					inAddr += 4

		finally
			proc.ecx = (proc.ecx & ~0xffff) | (count & 0xffff)
			proc.edi = (proc.edi & ~0xffff) | (inAddr & 0xffff)
			proc.esi = (proc.esi & ~0xffff) | (outAddr & 0xffff)


	movsb_a32: (outSegment) ->

		inAddr = proc.edi
		outAddr = proc.esi

		proc.es.setByte(inAddr, outSegment.getByte(outAddr))
		if (proc.eflagsDirection)
			outAddr -= 1
			inAddr -= 1
		else
			outAddr += 1
			inAddr += 1

		proc.edi = inAddr
		proc.esi = outAddr

	movsw_a32: (outSegment) ->
		inAddr = proc.edi
		outAddr = proc.esi

		proc.es.setWord(inAddr, outSegment.getWord(outAddr))
		if (proc.eflagsDirection)
			outAddr -= 2
			inAddr -= 2
		else
			outAddr += 2
			inAddr += 2

		proc.edi = inAddr
		proc.esi = outAddr

	movsd_a32: (outSegment) ->
		inAddr = proc.edi
		outAddr = proc.esi

		proc.es.setDoubleWord(inAddr, outSegment.getDoubleWord(outAddr))
		if (proc.eflagsDirection)
			outAddr -= 4
			inAddr -= 4
		else
			outAddr += 4
			inAddr += 4

		proc.edi = inAddr
		proc.esi = outAddr

	rep_movsb_a32: (outSegment) ->

		count = proc.ecx
		inAddr = proc.edi
		outAddr = proc.esi
		@executeCount += count

		try
			if (proc.eflagsDirection)
				while (count != 0)
					#check hardware interrupts
					proc.es.setByte(inAddr, outSegment.getByte(outAddr))
					count--
					outAddr -= 1
					inAddr -= 1
			else
				while (count != 0)
					#check hardware interrupts
					proc.es.setByte(inAddr, outSegment.getByte(outAddr))
					count--
					outAddr += 1
					inAddr += 1
		finally
			proc.ecx = count
			proc.edi = inAddr
			proc.esi = outAddr

	rep_movsw_a32: (outSegment) ->
		count = proc.ecx
		inAddr = proc.edi
		outAddr = proc.esi
		@executeCount += count

		try
			if (proc.eflagsDirection)
				while (count != 0)
					#check hardware interrupts
					proc.es.setWord(inAddr, outSegment.getWord(outAddr))
					count--
					outAddr -= 2
					inAddr -= 2

			else
				while (count != 0)
					#check hardware interrupts
					proc.es.setWord(inAddr, outSegment.getWord(outAddr))
					count--
					outAddr += 2
					inAddr += 2
		finally
			proc.ecx = count
			proc.edi = inAddr
			proc.esi = outAddr


	rep_movsd_a32: (outSegment) ->
		count = proc.ecx
		inAddr = proc.edi
		outAddr = proc.esi
		@executeCount += count

		try
			if (proc.eflagsDirection)
				while (count != 0)
					#check hardware interrupts
					proc.es.setDoubleWord(inAddr, outSegment.getDoubleWord(outAddr))
					count--
					outAddr -= 4
					inAddr -= 4
			else
				while (count != 0)
					#check hardware interrupts
					proc.es.setDoubleWord(inAddr, outSegment.getDoubleWord(outAddr))
					count--
					outAddr += 4
					inAddr += 4
		finally
			proc.ecx = count
			proc.edi = inAddr
			proc.esi = outAddr

	outsb_a16: (port, storeSegment) ->

		if (!@checkIOPermissionsByte(port))
			log "denied access to io port #{port}"
			throw ProcessorException.GENERAL_PROTECTION_0

		addr = proc.esi & 0xffff

		proc.ioports.ioPortWriteByte(port, 0xff & storeSegment.getByte(addr))

		if (proc.eflagsDirection)
			addr -= 1
		else
			addr += 1

		proc.esi = (proc.esi & ~0xffff) | (addr & 0xffff)

	outsw_a16: (port, storeSegment) ->

		if (!@checkIOPermissionsShort(port))
			log "denied access to io port #{port}"
			throw ProcessorException.GENERAL_PROTECTION_0

		addr = proc.esi & 0xffff

		proc.ioports.ioPortWriteWord(port, 0xffff & storeSegment.getWord(addr))

		if (proc.eflagsDirection)
			addr -= 2
		else
			addr += 2

		proc.esi = (proc.esi & ~0xffff) | (addr & 0xffff)

	outsd_a16: (port, storeSegment) ->

		if (!@checkIOPermissionsInt(port))
			log "denied access to io port #{port}"
			throw ProcessorException.GENERAL_PROTECTION_0

		addr = proc.esi & 0xffff

		proc.ioports.ioPortWriteLong(port, storeSegment.getDoubleWord(addr))

		if (proc.eflagsDirection)
			addr -= 4
		else
			addr += 4

		proc.esi = (proc.esi & ~0xffff) | (addr & 0xffff)

	rep_outsb_a16: (port, storeSegment) ->
		if (!@checkIOPermissionsByte(port))
			log "denied access to io port #{port}"
			throw ProcessorException.GENERAL_PROTECTION_0

		count = proc.ecx & 0xffff
		addr = proc.esi & 0xffff
		@executeCount += count

		try
			if (proc.eflagsDirection)
				while (count != 0)
					#check hardware interrupts
					proc.ioports.ioPortWriteByte(port, 0xffff & storeSegment.getByte(addr & 0xffff))
					count--
					addr -= 1
			else
				while (count != 0)
					#check hardware interrupts
					proc.ioports.ioPortWriteByte(port, 0xffff & storeSegment.getByte(addr & 0xffff))
					count--
					addr += 1
		finally
			proc.ecx = (proc.ecx & ~0xffff) | (count & 0xffff)
			proc.esi = (proc.esi & ~0xffff) | (addr & 0xffff)

	rep_outsw_a16: (port, storeSegment) ->
		if (!@checkIOPermissionsShort(port))
			log "denied access to io port #{port}"
			throw ProcessorException.GENERAL_PROTECTION_0

		count = proc.ecx & 0xffff
		addr = proc.esi & 0xffff
		@executeCount += count

		try
			if (proc.eflagsDirection)
				while (count != 0)
					#check hardware interrupts
					proc.ioports.ioPortWriteWord(port, 0xffff & storeSegment.getWord(addr & 0xffff))
					count--
					addr -= 2
			else
				while (count != 0)
					#check hardware interrupts
					proc.ioports.ioPortWriteWord(port, 0xffff & storeSegment.getWord(addr & 0xffff))
					count--
					addr += 2
		finally
			proc.ecx = (proc.ecx & ~0xffff) | (count & 0xffff)
			proc.esi = (proc.esi & ~0xffff) | (addr & 0xffff)

	rep_outsd_a16: (port, storeSegment) ->
		if (!@checkIOPermissionsInt(port))
			log "denied access to io port #{port}"
			throw ProcessorException.GENERAL_PROTECTION_0

		count = proc.ecx & 0xffff
		addr = proc.esi & 0xffff
		@executeCount += count

		try
			if (proc.eflagsDirection)
				while (count != 0)
					#check hardware interrupts
					proc.ioports.ioPortWriteLong(port, storeSegment.getDoubleWord(addr & 0xffff))
					count--
					addr -= 4
			else
				while (count != 0)
					#check hardware interrupts
					proc.ioports.ioPortWriteLong(port, storeSegment.getDoubleWord(addr & 0xffff))
					count--
					addr += 4
		finally
			proc.ecx = (proc.ecx & ~0xffff) | (count & 0xffff)
			proc.esi = (proc.esi & ~0xffff) | (addr & 0xffff)

	outsb_a32: (port, storeSegment) ->
		if (!@checkIOPermissionsByte(port))
			log "denied access to io port #{port}"
			throw ProcessorException.GENERAL_PROTECTION_0

		addr = proc.esi

		proc.ioports.ioPortWriteByte(port, 0xff & storeSegment.getByte(addr))

		if (proc.eflagsDirection)
			addr -= 1
		else
			addr += 1

		proc.esi = addr

	outsw_a32: (port, storeSegment) ->
		if (!@checkIOPermissionsShort(port))
			log "denied access to io port #{port}"
			throw ProcessorException.GENERAL_PROTECTION_0

		addr = proc.esi

		proc.ioports.ioPortWriteWord(port, 0xffff & storeSegment.getWord(addr))

		if (proc.eflagsDirection)
			addr -= 2
		else
			addr += 2

		proc.esi = addr

	outsd_a32: (port, storeSegment) ->
		if (!@checkIOPermissionsInt(port))
			log "denied access to io port #{port}"
			throw ProcessorException.GENERAL_PROTECTION_0

		addr = proc.esi

		proc.ioports.ioPortWriteLong(port, storeSegment.getDoubleWord(addr))

		if (proc.eflagsDirection)
			addr -= 4
		else
			addr += 4

		proc.esi = addr

	rep_outsb_a32: (port, storeSegment) ->
		if (!@checkIOPermissionsByte(port))
			log "denied access to io port #{port}"
			throw ProcessorException.GENERAL_PROTECTION_0

		count = proc.ecx
		addr = proc.esi
		@executeCount += count

		try
			if (proc.eflagsDirection)
				while (count != 0)
					#check hardware interrupts
					proc.ioports.ioPortWriteByte(port, 0xffff & storeSegment.getByte(addr))
					count--
					addr -= 1
			else
				while (count != 0)
					#check hardware interrupts
					proc.ioports.ioPortWriteByte(port, 0xffff & storeSegment.getByte(addr))
					count--
					addr += 1
		finally
			proc.ecx = count
			proc.esi = addr

	rep_outsw_a32: (port, storeSegment) ->
		if (!@checkIOPermissionsShort(port))
			log "denied access to io port #{port}"
			throw ProcessorException.GENERAL_PROTECTION_0

		count = proc.ecx
		addr = proc.esi
		@executeCount += count

		try
			if (proc.eflagsDirection)
				while (count != 0)
					#check hardware interrupts
					proc.ioports.ioPortWriteWord(port, 0xffff & storeSegment.getWord(addr))
					count--
					addr -= 2
			else
				while (count != 0)
					#check hardware interrupts
					proc.ioports.ioPortWriteWord(port, 0xffff & storeSegment.getWord(addr))
					count--
					addr += 2
		finally
			proc.ecx = count
			proc.esi = addr

	rep_outsd_a32: (port, storeSegment) ->

		if (!@checkIOPermissionsInt(port))
			log "denied access to io port #{port}"
			throw ProcessorException.GENERAL_PROTECTION_0

		count = proc.ecx
		addr = proc.esi
		@executeCount += count

		try
			if (proc.eflagsDirection)
				while (count != 0)
					#check hardware interrupts
					proc.ioports.ioPortWriteLong(port, storeSegment.getDoubleWord(addr))
					count--
					addr -= 4
			else
				while (count != 0)
					#check hardware interrupts
					proc.ioports.ioPortWriteLong(port, storeSegment.getDoubleWord(addr))
					count--
					addr += 4
		finally
			proc.ecx = count
			proc.esi = addr

	scasb_a16: (data) ->
		addr = 0xFFFF & proc.edi
		input = 0xff & proc.es.getByte(addr)

		if (proc.eflagsDirection)
			addr -= 1
		else
			addr += 1

		proc.edi = (proc.edi & ~0xFFFF) | (0xFFFF & addr)
		sub_o8_flags(data - input, data, input);

	scasb_a32: (data) ->
		addr = proc.edi
		input = 0xff & proc.es.getByte(addr)

		if (proc.eflagsDirection)
			addr -= 1
		else
			addr += 1

		proc.edi = addr
		sub_o8_flags(data - input, data, input)

	scasw_a32: (data) ->
		addr = proc.edi
		input = 0xffff & proc.es.getWord(addr)

		if (proc.eflagsDirection)
			addr -= 2
		else
			addr += 2

		proc.edi = addr
		sub_o16_flags(data - input, data, input)

	scasd_a32: (data) ->

		addr = proc.edi
		input = proc.es.getDoubleWord(addr)

		if (proc.eflagsDirection)
			addr -= 4
		else
			addr += 4

		proc.edi = addr
		sub_o32_flags((0xffffffff & data) - (0xffffffff & input), data, input)

	repe_scasb_a16: (data) ->
		count = 0xffff & proc.ecx
		addr = 0xffff & proc.edi
		used = count != 0
		input = 0

		try
			if (proc.eflagsDirection)
				while (count != 0)
					input = 0xff & proc.es.getByte(addr)
					count--
					addr -= 1
					if (data != input)
						break
			else
				while (count != 0)
					input = 0xff & proc.es.getByte(addr)
					count--
					addr += 1
					if (data != input)
						break

		finally
			@executeCount += ((0xffff & proc.ecx) - count)
			proc.ecx = (proc.ecx & ~0xffff) | (0xffff & count)
			proc.edi = (proc.edi & ~0xffff) | (0xffff & addr)
			if (used)
				sub_o8_flags(data - input, data, input)

	repe_scasb_a32: (data) ->
		count = proc.ecx
		addr = proc.edi
		used = count != 0
		input = 0
		try
			if (proc.eflagsDirection)
				while (count != 0)
					input = 0xff & proc.es.getByte(addr)
					count--
					addr -= 1
					if (data != input)
						break
			else
				while (count != 0)
					input = 0xff & proc.es.getByte(addr)
					count--
					addr += 1
					if (data != input)
						break
		finally
			@executeCount += (proc.ecx - count)
			proc.ecx = count
			proc.edi = addr
			if (used)
				sub_o8_flags(data - input, data, input)

	repe_scasw_a32: (data) ->
		count = proc.ecx
		addr = proc.edi
		used = count != 0
		input = 0

		try
			if (proc.eflagsDirection)
				while (count != 0)
					input = 0xffff & proc.es.getWord(addr)
					count--
					addr -= 2
					if (data != input)
						break
			else
				while (count != 0)
					input = 0xffff & proc.es.getWord(addr)
					count--
					addr += 2
					if (data != input)
						break
		finally
			@executeCount += (proc.ecx - count)
			proc.ecx = count
			proc.edi = addr
			if (used)
				sub_o16_flags(data - input, data, input)

	repe_scasd_a32: (data) ->
		count = proc.ecx
		addr = proc.edi
		used = count != 0
		input = 0

		try
			if (proc.eflagsDirection)
				while (count != 0)
					input = proc.es.getDoubleWord(addr)
					count--
					addr -= 4
					if (data != input)
						break
			else
				while (count != 0)
					input = proc.es.getDoubleWord(addr)
					count--
					addr += 4
					if (data != input)
						break
		finally
			@executeCount += (proc.ecx - count)
			proc.ecx = count
			proc.edi = addr
			if (used)
				sub_o32_flags((0xffffffff & data) - (0xffffffff & input), data, input)

	repne_scasb_a16: (data) ->
		count = 0xFFFF & proc.ecx
		addr = 0xFFFF & proc.edi
		used = count != 0
		input = 0

		try
			if (proc.eflagsDirection)
				while (count != 0)
					input = 0xff & proc.es.getByte(addr)
					count--
					addr -= 1
					if (data == input)
						break
			else
				while (count != 0)
					input = 0xff & proc.es.getByte(addr)
					count--
					addr += 1
					if (data == input)
						break
		finally
			@executeCount += ((proc.ecx & 0xFFFF) - count)
			proc.ecx = (proc.ecx & ~0xFFFF) | (0xFFFF & count)
			proc.edi = (proc.edi & ~0xFFFF) | (0xFFFF & addr)
			if (used)
				sub_o8_flags(data - input, data, input)

	repne_scasb_a32: (data) ->
		count = proc.ecx
		addr = proc.edi
		used = count != 0
		input = 0

		try
			if (proc.eflagsDirection)
				while (count != 0)
					input = 0xff & proc.es.getByte(addr)
					count--
					addr -= 1
					if (data == input)
						break
			else
				while (count != 0)
					input = 0xff & proc.es.getByte(addr)
					count--
					addr += 1
					if (data == input)
						break
		finally
			@executeCount += (proc.ecx - count)
			proc.ecx = count
			proc.edi = addr
			if (used)
				sub_o8_flags(data - input, data, input)

	repne_scasw_a32: (data) ->
		count = proc.ecx
		addr = proc.edi
		used = count != 0
		input = 0

		try
			if (proc.eflagsDirection)
				while (count != 0)
					input = 0xffff & proc.es.getWord(addr)
					count--
					addr -= 2
					if (data == input)
						break
			else
				while (count != 0)
					input = 0xffff & proc.es.getWord(addr)
					count--
					addr += 2
					if (data == input)
						break

		finally
			@executeCount += (proc.ecx - count)
			proc.ecx = count
			proc.edi = addr
			if (used)
				sub_o16_flags(data - input, data, input)

	repne_scasd_a32: (data) ->
		count = proc.ecx
		addr = proc.edi
		used = count != 0
		input = 0

		try
			if (proc.eflagsDirection)
				while (count != 0)
					input = proc.es.getDoubleWord(addr)
					count--
					addr -= 4
					if (data == input)
						break
			else
				while (count != 0)
					input = proc.es.getDoubleWord(addr)
					count--
					addr += 4
					if (data == input)
						break
		finally
			@executeCount += (proc.ecx - count)
			proc.ecx = count
			proc.edi = addr
			if (used)
				sub_o32_flags((0xffffffff & data) - (0xffffffff & input), data, input)

	stosb_a16: (data) ->
		addr = 0xFFFF & proc.edi
		proc.es.setByte(addr, byte(data))

		if (proc.eflagsDirection)
			addr -= 1
		else
			addr += 1

		proc.edi = (proc.edi & ~0xFFFF) | (0xFFFF & addr)

	stosb_a32: (data) ->
		addr = proc.edi
		proc.es.setByte(addr, byte(data))

		if (proc.eflagsDirection)
			addr -= 1
		else
			addr += 1
		proc.edi = addr

	stosw_a16: (data) ->
		addr = 0xFFFF & proc.edi
		proc.es.setWord(addr, short(data))

		if (proc.eflagsDirection)
			addr -= 2
		else
			addr += 2
		proc.edi = (proc.edi & ~0xffff) | (0xFFFF & addr)

	stosw_a32: (data) ->
		addr = proc.edi
		proc.es.setWord(addr, short(data))

		if (proc.eflagsDirection)
			addr -= 2
		else
			addr += 2
		proc.edi = addr

	stosd_a16: (data) ->
		addr = 0xffff & proc.edi
		proc.es.setDoubleWord(addr, data)

		if (proc.eflagsDirection)
			addr -= 4
		else
			addr += 4
		proc.edi = (proc.edi & ~0xffff) | (0xFFFF & addr)

	stosd_a32: (data) ->
		addr = proc.edi
		proc.es.setDoubleWord(addr, data)

		if (proc.eflagsDirection)
			addr -= 4
		else
			addr += 4
		proc.edi = addr

	rep_stosb_a16: (data) ->
		count = 0xFFFF & proc.ecx
		addr = 0xFFFF & proc.edi
		@executeCount += count

		try
			if (proc.eflagsDirection)
				while (count != 0)
					#check hardware interrupts
					proc.es.setByte(addr, byte(data))
					count--
					addr -= 1
			else
				while (count != 0)
					#check hardware interrupts
					proc.es.setByte(addr, byte(data))
					count--
					addr += 1
		finally
			proc.ecx = (proc.ecx & ~0xFFFF) | count
			proc.edi = (proc.edi & ~0xFFFF) | addr

	rep_stosb_a32: (data) ->
		count = proc.ecx
		addr = proc.edi
		@executeCount += count

		try
			if (proc.eflagsDirection)
				while (count != 0)
					#check hardware interrupts
					proc.es.setByte(addr, byte(data))
					count--
					addr -= 1
			else
				while (count != 0)
					#check hardware interrupts
					proc.es.setByte(addr, byte(data))
					count--
					addr += 1
		finally
			proc.ecx = count
			proc.edi = addr

	rep_stosw_a16: (data) ->
		count = 0xFFFF & proc.ecx
		addr = 0xFFFF & proc.edi
		@executeCount += count

		try
			if (proc.eflagsDirection)
				while (count != 0)
					#check hardware interrupts
					proc.es.setWord(addr, short(data))
					count--
					addr -= 2
			else
				while (count != 0)
					#check hardware interrupts
					proc.es.setWord(addr, short(data))
					count--
					addr += 2
		finally
			proc.ecx = (proc.ecx & ~0xFFFF) | (0xFFFF & count)
			proc.edi = (proc.edi & ~0xFFFF) | (0xFFFF & addr)


	rep_stosw_a32: (data) ->
		count = proc.ecx
		addr = proc.edi
		@executeCount += count

		try
			if (proc.eflagsDirection)
				while (count != 0)
					#check hardware interrupts
					proc.es.setWord(addr, short(data))
					count--
					addr -= 2

			else
				while (count != 0)
					#check hardware interrupts
					proc.es.setWord(addr, short(data))
					count--
					addr += 2

		finally
			proc.ecx = count
			proc.edi = addr

	rep_stosd_a16: (data) ->
		count = 0xFFFF & proc.ecx
		addr = 0xFFFF & proc.edi
		@executeCount += count

		try
			if (proc.eflagsDirection)
				while (count != 0)
					#check hardware interrupts
					proc.es.setDoubleWord(addr, data)
					count--
					addr -= 4
			else
				while (count != 0)
					#check hardware interrupts
					proc.es.setDoubleWord(addr, data)
					count--
					addr += 4
		finally
			proc.ecx = (proc.ecx & ~0xFFFF) | (0xFFFF & count)
			proc.edi = (proc.edi & ~0xFFFF) | (0xFFFF & addr)

	rep_stosd_a32: (data) ->
		count = proc.ecx
		addr = proc.edi
		@executeCount += count

		try
			if (proc.eflagsDirection)
				while (count != 0)
					#check hardware interrupts
					proc.es.setDoubleWord(addr, data)
					count--
					addr -= 4
			else
				while (count != 0)
					#check hardware interrupts
					proc.es.setDoubleWord(addr, data)
					count--
					addr += 4
		finally
			proc.ecx = count
			proc.edi = addr

	mul_o8: (data) ->
		x = proc.eax & 0xff

		result = x * data
		proc.eax &= 0xffff0000
		proc.eax |= (result & 0xffff)

		proc.setOverflowFlag1(result, proc.OF_HIGH_BYTE_NZ)
		proc.setCarryFlag1(result, proc.CY_HIGH_BYTE_NZ)

	mul_o16: (data) ->
		x = proc.eax & 0xffff

		result = x * data
		proc.eax = (proc.eax & 0xffff0000) | (0xffff & result)
		result = result >>> 16
		proc.edx = (proc.edx & 0xffff0000) | result

		proc.setOverflowFlag1(result, proc.OF_NZ)
		proc.setCarryFlag1(result, proc.CY_NZ)

	mul_o32: (data) ->
		x = proc.eax & 0xffffffff
		y = 0xffffffff & data

		result = x * y
		proc.eax = int(result)
		result = result >>> 32
		proc.edx = int(result)

		proc.setOverflowFlag1( proc.edx, proc.OF_NZ)
		proc.setCarryFlag1( proc.edx, proc.CY_NZ)

	imula_o8: (data) ->
		al = byte(proc.eax)
		result = al * byte(data)

		proc.eax = (proc.eax & ~0xffff) | (result & 0xffff)

		proc.setOverflowFlag1(result, proc.OF_NOT_BYTE)
		proc.setCarryFlag1(result, proc.CY_NOT_BYTE)

	imula_o16: (data) ->
		ax = short(proc.eax)
		result = ax * data

		proc.eax = (proc.eax & ~0xffff) | (result & 0xffff)
		proc.edx = (proc.edx & ~0xffff) | (result >>> 16)

		# answer too wide for 16-bits?
		proc.setOverflowFlag1(result, proc.OF_NOT_SHORT)
		proc.setCarryFlag1(result, proc.CY_NOT_SHORT)

	imula_o32: (data) ->
		eax = proc.eax
		y = data
		result = eax * y

		proc.eax = int(result)
		proc.edx = int(result >>> 32)

		#answer too wide for 32-bits?
		proc.setOverflowFlag1(result, proc.OF_NOT_INT)
		proc.setCarryFlag1(result, proc.CY_NOT_INT)

	imul_o16: (data0, data1) ->

		result = data0 * data1
		proc.setOverflowFlag1(result, proc.OF_NOT_SHORT)
		proc.setCarryFlag1(result, proc.CY_NOT_SHORT)
		return result

	imul_o32: (data0, data1) ->
		x = data0
		y = data1

		result = x * y
		proc.setOverflowFlag1(result, proc.OF_NOT_INT)
		proc.setCarryFlag1(result, proc.CY_NOT_INT)
		return int(result)

	div_o8: (data) ->

		if (data == 0)
			throw ProcessorException.DIVIDE_ERROR;

		x = (proc.eax & 0xffff)

		result = int(x / data)
		if (result > 0xff)
			throw ProcessorException.DIVIDE_ERROR

		remainder = (x % data) << 8
		proc.eax = (proc.eax & ~0xffff) | (0xff & result) | (0xff00 & remainder)

	div_o16: (data) ->
		if (data == 0)
			throw ProcessorException.DIVIDE_ERROR

		x = (proc.edx & 0xffff)
		x <<= 16
		x |= (proc.eax & 0xffff)

		result = x / data
		if (result > 0xffff)
			throw ProcessorException.DIVIDE_ERROR

		remainder = x % data
		proc.eax = (proc.eax & ~0xffff) | (int)(result & 0xffff)
		proc.edx = (proc.edx & ~0xffff) | (int)(remainder & 0xffff)

	div_o32: (data) ->
		d = 0xffffffff & data

		if (d == 0)
			throw ProcessorException.DIVIDE_ERROR

		temp = proc.edx
		temp <<= 32
		temp |= (0xffffffff & proc.eax)

		r2 = (temp & 1)
		n2 = (temp >>> 1)

		q2 = n2 / d
		m2 = n2 % d

		q = (q2 << 1)
		r = (m2 << 1) + r2

		q += (r / d)
		r %= d
		if (q > 0xffffffff)
			throw ProcessorException.DIVIDE_ERROR

		proc.eax = int(q)
		proc.edx = int(r)

	idiv_o8: (data) ->

		if (data == 0)
			throw ProcessorException.DIVIDE_ERROR

		temp = short(proc.eax)
		result = temp / data
		remainder = temp % data
	#if ((result > Byte.MAX_VALUE) || (result < Byte.MIN_VALUE))
	#    throw ProcessorException.DIVIDE_ERROR;

		proc.eax = (proc.eax & ~0xffff) | (0xff & result) | ((0xff & remainder) << 8)# AH is remainder

	idiv_o16: (data) ->
		if (data == 0)
			throw ProcessorException.DIVIDE_ERROR

		temp = (proc.edx << 16) | (proc.eax & 0xffff)
		result = temp / int(data)
		remainder = temp % data

	#if ((result > Short.MAX_VALUE) || (result < Short.MIN_VALUE))
	#    throw ProcessorException.DIVIDE_ERROR;

		proc.eax = (proc.eax & ~0xffff) | (0xffff & result)# AX is result
		proc.edx = (proc.edx & ~0xffff) | (0xffff & remainder)# DX is remainder

	idiv_o32: (data) ->
		if (data == 0)
			throw ProcessorException.DIVIDE_ERROR

		temp = 0xffffffff & proc.edx << 32
		temp |= (0xffffffff & proc.eax)
		result = temp / data
		#if ((result > Integer.MAX_VALUE) || (result < Integer.MIN_VALUE))
		#    throw ProcessorException.DIVIDE_ERROR;

		remainder = temp % data

		proc.eax =  int(result)# EAX is result
		proc.edx =  int(remainder)#    EDX is remainder

	btc_mem: (offset, segment, address) ->
		address += (offset >>> 3)
		offset &= 0x7

		data = segment.getByte(address)
		segment.setByte(address, byte(data ^ (1 << offset)))
		proc.setCarryFlag(data, offset, proc.CY_NTH_BIT_SET)

	bts_mem: (offset, segment, address) ->
		address += (offset >>> 3)
		offset &= 0x7

		data = segment.getByte(address)
		segment.setByte(address, byte(data | (1 << offset)))
		proc.setCarryFlag(data, offset, proc.CY_NTH_BIT_SET)

	btr_mem: (offset, segment, address) ->
		address += (offset >>> 3)
		offset &= 0x7

		data = segment.getByte(address)
		segment.setByte(address, byte(data & ~(1 << offset)))
		proc.setCarryFlag(data, offset, proc.CY_NTH_BIT_SET)

	bt_mem: (offset, segment, address) ->
		address += (offset >>> 3)
		offset &= 0x7
		proc.setCarryFlag(segment.getByte(address), offset, proc.CY_NTH_BIT_SET)

	bsf: (source, initial) ->
		if (source == 0)
			proc.setZeroFlag(true)
			return initial
		else
			proc.setZeroFlag(false)
			return numberOfTrailingZeros(source)

	bsr: (source, initial) ->
		if (source == 0)
			proc.setZeroFlag(true)
			return initial
		else
			proc.setZeroFlag(false)
			return 31 - numberOfLeadingZeros(source)

	aaa: ->
		if (((proc.eax & 0xf) > 0x9) || proc.getAuxiliaryCarryFlag())
			alCarry = ((proc.eax & 0xff) > 0xf9) ? 0x100 : 0x000
			proc.eax = (0xffff0000 & proc.eax) | (0x0f & (proc.eax + 6)) | (0xff00 & (proc.eax + 0x100 + alCarry))
			proc.setAuxiliaryCarryFlag(true)
			proc.setCarryFlag(true)
		else
			proc.setAuxiliaryCarryFlag(false)
			proc.setCarryFlag(false)
			proc.eax = proc.eax & 0xffffff0f

	aad: (base) ->
		tl = (proc.eax & 0xff)
		th = ((proc.eax >> 8) & 0xff)

		ax1 = th * base
		ax2 = ax1 + tl

		proc.eax = (proc.eax & ~0xffff) | (ax2 & 0xff)


		bitwise_flags(byte(ax2))

		proc.setAuxiliaryCarryFlag2(ax1, ax2, proc.AC_BIT4_NEQ)
		proc.setCarryFlag1(ax2, proc.CY_GREATER_FF)
		proc.setOverflowFlag2(ax2, tl, proc.OF_BIT7_DIFFERENT)

	aam: (base) ->
		tl = 0xff & proc.eax
		if (base == 0)
			throw ProcessorException.DIVIDE_ERROR
		ah = 0xff & (tl / base)
		al = 0xff & (tl % base)
		proc.eax &= ~0xffff
		proc.eax |= (al | (ah << 8))

		proc.setAuxiliaryCarryFlag(false)
		bitwise_flags(byte(al))

	aas: ->
		if (((proc.eax & 0xf) > 0x9) || proc.getAuxiliaryCarryFlag())
			alBorrow = (proc.eax & 0xff) < 6 ? 0x100 : 0x000
			proc.eax = (0xffff0000 & proc.eax) | (0x0f & (proc.eax - 6)) | (0xff00 & (proc.eax - 0x100 - alBorrow))
			proc.setAuxiliaryCarryFlag(true)
			proc.setCarryFlag(true)
		else
			proc.setAuxiliaryCarryFlag(false)
			proc.setCarryFlag(false)
			proc.eax = proc.eax & 0xffffff0f

	daa: ->

		al = proc.eax & 0xff
		if (((proc.eax & 0xf) > 0x9) || proc.getAuxiliaryCarryFlag())
			al += 6
			proc.setAuxiliaryCarryFlag(true)
		else
			proc.setAuxiliaryCarryFlag(false)

		if (((al & 0xff) > 0x9f) || proc.getCarryFlag())
			al += 0x60
			newCF = true
		else
			newCF = false;

		proc.eax = (proc.eax & ~0xff) | (0xff & al)
		bitwise_flags(byte(al))
		proc.setCarryFlag(newCF)


	das: ->
		tempAL = 0xff & proc.eax
		if (((tempAL & 0xf) > 0x9) || proc.getAuxiliaryCarryFlag())
			proc.setAuxiliaryCarryFlag(true)
			proc.eax = (proc.eax & ~0xff) | ((proc.eax - 0x06) & 0xff)
			tempCF = (tempAL < 0x06) || proc.getCarryFlag()

		if ((tempAL > 0x99) || proc.getCarryFlag())
			proc.eax = (proc.eax & ~0xff) | ((proc.eax - 0x60) & 0xff)
			tempCF = true

		bitwise_flags(byte(proc.eax))
		proc.setCarryFlag(tempCF)

	lahf: ->

		result = 0x0200
		if (proc.getSignFlag())
			result |= 0x8000
		if (proc.getZeroFlag())
			result |= 0x4000
		if (proc.getAuxiliaryCarryFlag())
			result |= 0x1000
		if (proc.getParityFlag())
			result |= 0x0400
		if (proc.getCarryFlag())
			result |= 0x0100
		proc.eax &= 0xffff00ff
		proc.eax |= result


	sahf: ->
		ah = (proc.eax & 0xff00)
		proc.setCarryFlag(0 != (ah & 0x0100))
		proc.setParityFlag(0 != (ah & 0x0400))
		proc.setAuxiliaryCarryFlag(0 != (ah & 0x1000))
		proc.setZeroFlag(0 != (ah & 0x4000))
		proc.setSignFlag(0 != (ah & 0x8000))

	jo_o8: (offset) ->
		if (proc.getOverflowFlag())
			@jump_o8(offset)

	jno_o8: (offset) ->
		if (!proc.getOverflowFlag())
			@jump_o8(offset)

	jc_o8: (offset) ->
		if (proc.getCarryFlag())
			@jump_o8(offset)

	jnc_o8: (offset) ->
		if (!proc.getCarryFlag())
			@jump_o8(offset)

	jz_o8: (offset) ->
		if (proc.getZeroFlag())
			@jump_o8(offset)

	jnz_o8: (offset) ->
		if (!proc.getZeroFlag())
			@jump_o8(offset)

	jna_o8: (offset) ->
		if (proc.getCarryFlag() || proc.getZeroFlag())
			@jump_o8(offset)

	ja_o8: (offset) ->
		if ((!proc.getCarryFlag()) && (!proc.getZeroFlag()))
			@jump_o8(offset)

	js_o8: (offset) ->
		if (proc.getSignFlag())
			@jump_o8(offset)

	jns_o8: (offset) ->
		if (!proc.getSignFlag())
			@jump_o8(offset)

	jp_o8: (offset) ->
		if (proc.getParityFlag())
			@jump_o8(offset)

	jnp_o8: (offset) ->
		if (!proc.getParityFlag())
			@jump_o8(offset)

	jl_o8: (offset) ->
		if (proc.getSignFlag() != proc.getOverflowFlag())
			@jump_o8(offset)

	jnl_o8: (offset) ->
		if (proc.getSignFlag() == proc.getOverflowFlag())
			@jump_o8(offset)

	jng_o8: (offset) ->
		if (proc.getZeroFlag() || (proc.getSignFlag() != proc.getOverflowFlag()))
			@jump_o8(offset)

	jg_o8: (offset) ->
		if ((!proc.getZeroFlag()) && (proc.getSignFlag() == proc.getOverflowFlag()))
			@jump_o8(offset)

	jo_o16: (offset) ->
		if (proc.getOverflowFlag())
			@jump_o16(offset)

	jno_o16: (offset) ->
		if (!proc.getOverflowFlag())
			@jump_o16(offset)

	jc_o16: (offset) ->
		if (proc.getCarryFlag())
			@jump_o16(offset)

	jnc_o16: (offset) ->
		if (!proc.getCarryFlag())
			@jump_o16(offset)

	jz_o16: (offset) ->
		if (proc.getZeroFlag())
			@jump_o16(offset)

	jnz_o16: (offset) ->
		if (!proc.getZeroFlag())
			@jump_o16(offset)

	jna_o16: (offset) ->
		if (proc.getCarryFlag() || proc.getZeroFlag())
			@jump_o16(offset)

	ja_o16: (offset) ->
		if ((!proc.getCarryFlag()) && (!proc.getZeroFlag()))
			@jump_o16(offset)

	js_o16: (offset) ->
		if (proc.getSignFlag())
			@jump_o16(offset)

	jns_o16: (offset) ->
		if (!proc.getSignFlag())
			@jump_o16(offset)

	jp_o16: (offset) ->
		if (proc.getParityFlag())
			@jump_o16(offset)

	jnp_o16: (offset) ->
		if (!proc.getParityFlag())
			@jump_o16(offset)

	jl_o16: (offset) ->
		if (proc.getSignFlag() != proc.getOverflowFlag())
			@jump_o16(offset)

	jnl_o16: (offset) ->
		if (proc.getSignFlag() == proc.getOverflowFlag())
			@jump_o16(offset)

	jng_o16: (offset) ->
		if (proc.getZeroFlag() || (proc.getSignFlag() != proc.getOverflowFlag()))
			@jump_o16(offset)

	jg_o16: (offset) ->
		if ((!proc.getZeroFlag()) && (proc.getSignFlag() == proc.getOverflowFlag()))
			@jump_o16(offset)

	jo_o32: (offset) ->
		if (proc.getOverflowFlag())
			@jump_o32(offset)

	jno_o32: (offset) ->
		if (!proc.getOverflowFlag())
			@jump_o32(offset)

	jc_o32: (offset) ->
		if (proc.getCarryFlag())
			@jump_o32(offset)

	jnc_o32: (offset) ->
		if (!proc.getCarryFlag())
			@jump_o32(offset)

	jz_o32: (offset) ->
		if (proc.getZeroFlag())
			@jump_o32(offset)

	jnz_o32: (offset) ->
		if (!proc.getZeroFlag())
			@jump_o32(offset)

	jna_o32: (offset) ->
		if (proc.getCarryFlag() || proc.getZeroFlag())
			@jump_o32(offset)

	ja_o32: (offset) ->
		if ((!proc.getCarryFlag()) && (!proc.getZeroFlag()))
			@jump_o32(offset)

	js_o32: (offset) ->
		if (proc.getSignFlag())
			@jump_o32(offset)

	jns_o32: (offset) ->
		if (!proc.getSignFlag())
			@jump_o32(offset)

	jp_o32: (offset) ->
		if (proc.getParityFlag())
			@jump_o32(offset)

	jnp_o32: (offset) ->
		if (!proc.getParityFlag())
			@jump_o32(offset)

	jl_o32: (offset) ->
		if (proc.getSignFlag() != proc.getOverflowFlag())
			@jump_o32(offset)

	jnl_o32: (offset) ->
		if (proc.getSignFlag() == proc.getOverflowFlag())
			@jump_o32(offset)

	jng_o32: (offset) ->
		if (proc.getZeroFlag() || (proc.getSignFlag() != proc.getOverflowFlag()))
			@jump_o32(offset)

	jg_o32: (offset) ->
		if ((!proc.getZeroFlag()) && (proc.getSignFlag() == proc.getOverflowFlag()))
			@jump_o32(offset)

	jcxz: (offset) ->
		if ((proc.ecx & 0xffff) == 0)
			@jump_o8(offset)

	jecxz: (offset) ->
		if (proc.ecx == 0)
			@jump_o8(offset)

	loop_cx: (offset) ->
		proc.ecx= (proc.ecx & ~0xFFFF) | (((0xFFFF &proc.ecx)-1) & 0xFFFF)
		if ((proc.ecx & 0xFFFF) != 0)
			@jump_o8(offset)

	loop_ecx: (offset) ->
		proc.ecx--
		if (proc.ecx != 0)
			@jump_o8(offset)

	loopz_cx: (offset) ->
		proc.ecx = (proc.ecx & ~0xFFFF) | ((proc.ecx - 1) & 0xFFFF)
		if (proc.getZeroFlag() && ((proc.ecx & 0xFFFF) != 0))
			@jump_o8(offset)

	loopz_ecx: (offset) ->
		proc.ecx--
		if (proc.getZeroFlag() && (proc.ecx != 0))
			@jump_o8(offset)

	loopnz_cx: (offset) ->
		proc.ecx= (proc.ecx & ~0xFFFF) | ((proc.ecx-1) & 0xFFFF)
		if (!proc.getZeroFlag() && ((proc.ecx & 0xFFFF) != 0))
			@jump_o8(offset)

	loopnz_ecx: (offset) ->
		proc.ecx--
		if (!proc.getZeroFlag() && (proc.ecx != 0))
			@jump_o8(offset)

	jump_o8: (offset) ->

		offset = byte(offset)
		if (offset == 0)
			return; #first protected mode throws on a jump 0 (some segment problem?)

		tempEIP = proc.getEIP() + offset
		proc.cs.checkAddress(tempEIP) # check whether eip is outside cs limit
		proc.incEIP(offset)

	jump_o16: (offset) ->
		offset = short(offset)
		tempEIP = (proc.getEIP() + offset) & 0xffff
		proc.cs.checkAddress(tempEIP) # check whether eip is outside cs limit
		proc.setEIP(tempEIP)

	jump_o32: (offset) ->
		offset = int(offset)
		tempEIP = proc.getEIP() + offset
		proc.cs.checkAddress(tempEIP) # check whether eip is outside cs limit
		proc.incEIP(offset)

	jump_abs: (offset) ->
		proc.cs.checkAddress(offset) # check whether eip is outside cs limit
		proc.setEIP(offset)

	jump_far: (targetEIP, targetSelector) ->
		newSegment = proc.getSegment(targetSelector)

		if (newSegment instanceof NULL_SEGMENT)
			throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, 0, true)

		switch (newSegment.getType())
			when 0x05
				log "Task gate not implemented"
				throw new IllegalStateException("Execute Failed")

			when 0x0b, 0x09
				if ((newSegment.getDPL() < proc.getCPL()) || (newSegment.getDPL() < newSegment.getRPL()) )
					throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, targetSelector, true)
				if (!newSegment.isPresent())
					throw new ProcessorException(ProcessorException.Type.NOT_PRESENT, targetSelector, true)
				if (newSegment.getLimit() < 0x67) # large enough to read ?
					throw new ProcessorException(ProcessorException.Type.TASK_SWITCH, targetSelector, true)
				if ((newSegment.getType() & 0x2) != 0) # busy ? if yes,error
					throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, targetSelector, true)

				newSegment.getByte(0) # new TSS paged into memory ?
				proc.tss.getByte(0) # old TSS paged into memory ?

				esSelector = 0xFFFF & newSegment.getWord(72)# // read new registers
				csSelector = 0xFFFF & newSegment.getWord(76)
				ssSelector = 0xFFFF & newSegment.getWord(80)
				dsSelector = 0xFFFF & newSegment.getWord(84)
				fsSelector = 0xFFFF & newSegment.getWord(88)
				gsSelector = 0xFFFF & newSegment.getWord(92)
				ldtSelector = 0xFFFF & newSegment.getWord(96)

				if((ldtSelector & 0x4) !=0) # not in gdt
					throw new ProcessorException(ProcessorException.Type.TASK_SWITCH, ldtSelector, true)

				proc.gdtr.checkAddress((ldtSelector & ~0x7) + 7 ) # check ldtr is valid

				if(proc.readSupervisorByte(proc.gdtr, ((ldtSelector & ~0x7) + 5 )& 0xF) != 2) # not a ldt entry
					throw new ProcessorException(ProcessorException.Type.TASK_SWITCH, ldtSelector, true)

				newLdtr = proc.getSegment(ldtSelector) # get new ldt

				if ((esSelector & 0x4) != 0) # check es descriptor is in memory
					newLdtr.checkAddress((esSelector & ~0x7) + 7)
				else
					proc.gdtr.checkAddress((esSelector & ~0x7) + 7)

				if ((csSelector & 0x4) != 0) # check cs descriptor is in memory
					newLdtr.checkAddress((csSelector & ~0x7) + 7)
				else
					proc.gdtr.checkAddress((csSelector & ~0x7) + 7)

				if ((ssSelector & 0x4) != 0) # check ss descriptor is in memory
					newLdtr.checkAddress((ssSelector & ~0x7) + 7)
				else
					proc.gdtr.checkAddress((ssSelector & ~0x7) + 7)

				if ((dsSelector & 0x4) != 0) # check ds descriptor is in memory
					newLdtr.checkAddress((dsSelector & ~0x7) + 7)
				else
					proc.gdtr.checkAddress((dsSelector & ~0x7) + 7)

				if ((fsSelector & 0x4) != 0) # check fs descriptor is in memory
					newLdtr.checkAddress((fsSelector & ~0x7) + 7)
				else
					proc.gdtr.checkAddress((fsSelector & ~0x7) + 7)

				if ((gsSelector & 0x4)!=0) # check gs descriptor is in memory
					newLdtr.checkAddress((gsSelector & ~0x7) + 7)
				else
					proc.gdtr.checkAddress((gsSelector & ~0x7) + 7)

				proc.setSupervisorDoubleWord(proc.gdtr, (proc.tss.getSelector() & ~0x7) + 4, ~0x200 & proc.readSupervisorDoubleWord(proc.gdtr, (proc.tss.getSelector() & ~0x7) + 4)) # clear busy bit of current tss
				proc.tss.saveCPUState(cpu)

				proc.setSupervisorDoubleWord(proc.gdtr, (targetSelector & ~0x7) + 4, 0x200 | proc.readSupervisorDoubleWord(proc.gdtr, (targetSelector & ~0x7) + 4)) #  set busy bit of new tss

				proc.setCR0(proc.getCR0() | 0x8) # set TS flag in CR0;
				proc.tss = newSegment
				proc.tss.restoreCPUState(cpu)
				proc.cs.checkAddress(proc.getEIP())

				return
			when 0x0c # Call Gate
				log "Call gate not implemented"
				throw new IllegalStateException("Execute Failed")
			when 0x18, 0x19, 0x1a, 0x1b
				if ((newSegment.getRPL() != proc.getCPL()) || (newSegment.getDPL() > proc.getCPL()))
					throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, targetSelector, true)
				if (!newSegment.isPresent())
					throw new ProcessorException(ProcessorException.Type.NOT_PRESENT, targetSelector, true)

				newSegment.checkAddress(targetEIP)
				newSegment.setRPL(proc.getCPL())
				proc.cs = newSegment
				proc.setEIP(targetEIP)
				return

			when 0x1c, 0x1d, 0x1e, 0x1f
				if (newSegment.getDPL() > proc.getCPL())
					throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, targetSelector, true)

				if (!newSegment.isPresent())
					throw new ProcessorException(ProcessorException.Type.NOT_PRESENT, targetSelector, true)

				newSegment.checkAddress(targetEIP)
				newSegment.setRPL(proc.getCPL())
				proc.cs = newSegment
				proc.setEIP(targetEIP)
				return

			else
				# not a valid segment descriptor for a jump
				log "Invalid segment type"
				throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, targetSelector, true)

	call_o32_a32: (target) ->
		tempEIP = proc.getEIP() + target

		proc.cs.checkAddress(tempEIP)

		if ((proc.esp < 4) && (proc.esp > 0))
			throw ProcessorException.STACK_SEGMENT_0

		proc.ss.setDoubleWord(proc.esp - 4, proc.getEIP() )
		proc.esp -= 4

		proc.setEIP(tempEIP)

	call_o16_a16: (target) ->
		tempEIP = 0xFFFF & (proc.getEIP() + target)

		proc.cs.checkAddress(tempEIP)

		if ((0xffff & proc.esp) < 2)
			throw ProcessorException.STACK_SEGMENT_0

		proc.ss.setWord((proc.esp - 2) & 0xffff, (short) (0xFFFF & proc.getEIP()))
		proc.esp = (proc.esp & ~0xffff) | ((proc.esp - 2) & 0xffff)

		proc.setEIO(tempEIP)

	call_o16_a32: (target) ->
		tempEIP = 0xFFFF & (proc.getEIP() + target)

		proc.cs.checkAddress(tempEIP)

		if ((proc.esp < 2) && (proc.esp > 0))
			throw ProcessorException.STACK_SEGMENT_0

		proc.ss.setWord(proc.esp - 2, short(0xFFFF & proc.getEIP()))
		proc.esp -= 2

		proc.getEIP(tempEIP)

	call_o32_a16: (target) ->
		tempEIP = proc.getEIP() + target

		proc.cs.checkAddress(tempEIP)

		if ((0xffff & proc.esp) < 4)
			throw ProcessorException.STACK_SEGMENT_0

		proc.ss.setDoubleWord((proc.esp - 4) & 0xffff, proc.getEIP())
		proc.esp = (proc.esp & ~0xffff) | ((proc.esp - 4) & 0xffff)

		proc.getEIP(tempEIP)

	call_abs_o16_a16: (target) ->
		proc.cs.checkAddress(target & 0xFFFF)

		if ((proc.esp & 0xffff) < 2)
			throw ProcessorException.STACK_SEGMENT_0

		proc.ss.setWord((proc.esp - 2) & 0xffff, short(0xFFFF & proc.getEIP()))
		proc.esp = (proc.esp & ~0xffff) | ((proc.esp - 2) & 0xffff)

		proc.setEIP(target & 0xFFFF)

	call_abs_o16_a32: (target) ->
		proc.cs.checkAddress(target & 0xFFFF)

		if ((proc.esp < 2) && (proc.esp > 0))
			throw ProcessorException.STACK_SEGMENT_0

		proc.ss.setWord(proc.esp - 2, short(0xFFFF & proc.getEIP()))
		proc.esp -= 2

		proc.getEIP(target & 0xFFFF)

	call_abs_o32_a32: (target) ->
		proc.cs.checkAddress(target)

		if ((proc.esp < 4) && (proc.esp > 0))
			throw ProcessorException.STACK_SEGMENT_0

		proc.ss.setDoubleWord(proc.esp - 4, proc.getEIP())
		proc.esp -= 4

		proc.getEIP(target)

	call_abs_o32_a16: (target) ->
		proc.cs.checkAddress(target)

		if ((proc.esp & 0xffff) < 4)
			throw ProcessorException.STACK_SEGMENT_0

		proc.ss.setDoubleWord((proc.esp - 4) & 0xffff, proc.getEIP())
		proc.esp = (proc.esp & ~0xffff) | ((proc.esp - 4) & 0xffff)

		proc.getEIP(target)

	call_far_o16_a32: (targetEIP, targetSelector) ->
		newSegment = proc.getSegment(targetSelector)
		if (newSegment == SegmentFactory.NULL_SEGMENT)
			throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, 0, true);

		switch (newSegment.getType())
			when 0x01, 0x03
				log "16-bit TSS not implemented"
				throw new IllegalStateException("Execute Failed")
			when 0x04
				if ((newSegment.getRPL() > proc.getCPL()) || (newSegment.getDPL() < proc.getCPL()))
					throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, targetSelector, true)
				if (!newSegment.isPresent())
					throw new ProcessorException(ProcessorException.Type.NOT_PRESENT, targetSelector, true)

				ProtectedModeSegment.GateSegment gate = newSegment

				targetSegmentSelector = gate.getTargetSegment()

				targetSegment
				try
					targetSegment = proc.getSegment(targetSegmentSelector)
				catch e
					throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, targetSegmentSelector, true)

				if (targetSegment == NULL_SEGMENT)
					throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, 0, true)

				if (targetSegment.getDPL() > proc.getCPL())
					throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, targetSelector, true)

				switch (targetSegment.getType())


					when 0x18, 0x19, 0x1a, 0x1b
						if (!targetSegment.isPresent())
							throw new ProcessorException(ProcessorException.Type.NOT_PRESENT, targetSegmentSelector, true)

						if (targetSegment.getDPL() < proc.getCPL())
							log "16-bit call gate: jump to more privileged segment not implemented"
							throw new IllegalStateException("Execute Failed")

						else if (targetSegment.getDPL() == proc.getCPL())
							log "16-bit call gate: jump to same privilege segment not implemented"
							throw new IllegalStateException("Execute Failed")

						else
							throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, targetSegmentSelector, true);

					when 0x1c, 0x1d, 0x1e, 0x1f
						if (!targetSegment.isPresent())
							throw new ProcessorException(ProcessorException.Type.NOT_PRESENT, targetSegmentSelector, true);

						log "16-bit call gate: jump to same privilege conforming segment not implemented"
						throw new IllegalStateException("Execute Failed")

					else
						throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, targetSegmentSelector, true)
			when 0x05
				log "Task gate not implemented"
				throw new IllegalStateException("Execute Failed")
			when 0x09, 0x0b
				log "TSS not implemented"
				throw new IllegalStateException("Execute Failed")
			when 0x0c
				log "Call gate not implemented"
				throw new IllegalStateException("Execute Failed")
			when 0x18, 0x19, 0x1a, 0x1b
				if ((newSegment.getRPL() > proc.getCPL()) || (newSegment.getDPL() != proc.getCPL()))
					throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, targetSelector, true)
				if (!newSegment.isPresent())
					throw new ProcessorException(ProcessorException.Type.NOT_PRESENT, targetSelector, true)

				if ((proc.esp < 4) && (proc.esp > 0))
					throw ProcessorException.STACK_SEGMENT_0

				newSegment.checkAddress(targetEIP&0xFFFF)

				proc.ss.setWord(proc.esp - 2, short(0xFFFF & proc.cs.getSelector()))
				proc.ss.setWord(proc.esp - 4, short(0xFFFF & proc.getEIP()))
				proc.esp -= 4

				proc.cs = newSegment
				proc.cs.setRPL(proc.getCPL())
				proc.setEIP(targetEIP & 0xFFF)
				return

			when 0x1c, 0x1d, 0x1e, 0x1f
				log "Conforming code segment not implemented"
				throw new IllegalStateException("Execute Failed")

			else
				log "Invalid segment type {0,number,integer}", Integer.valueOf(newSegment.getType())
				throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, targetSelector, true)

	call_far_o16_a16: (targetEIP, targetSelector) ->
		if ((targetSelector & 0xfffc) == 0)
			throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, 0, true)

		newSegment = proc.getSegment(targetSelector)

		if (newSegment == SegmentFactory.NULL_SEGMENT)
			throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, 0, true)

		switch (newSegment.getType())
			when 0x01, 0x03
				log "16-bit TSS not implemented"
				throw new IllegalStateException("Execute Failed")
			when 0x04
				if ((newSegment.getDPL() < newSegment.getRPL()) || (newSegment.getDPL() < proc.getCPL()))
					throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, targetSelector & 0xfffc, true)
				if (!newSegment.isPresent())
					throw new ProcessorException(ProcessorException.Type.NOT_PRESENT, targetSelector & 0xfffc, true)

				gate = newSegment

				targetSegmentSelector = gate.getTargetSegment()

				if ((targetSegmentSelector & 0xfffc) == 0)
					throw new ProcessorException(ProcessorException.Type.NOT_PRESENT, 0, true)

				try
					targetSegment = proc.getSegment(targetSegmentSelector)
				catch e
					throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, targetSegmentSelector & 0xfffc, true)

				if (targetSegment == NULL_SEGMENT)
					throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, targetSegmentSelector & 0xfffc, true)

				if ((targetSegment.getDPL() > proc.getCPL()) || (targetSegment.isSystem()) || ((targetSegment.getType() & 0x18) == 0x10))
					throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, targetSegmentSelector & 0xfffc, true)

				if (!targetSegment.isPresent())
					throw new ProcessorException(ProcessorException.Type.NOT_PRESENT, targetSegmentSelector & 0xfffc, true)

				switch (targetSegment.getType())
					when 0x18, 0x19, 0x1a, 0x1b

						if (targetSegment.getDPL() < proc.getCPL())

							newStackSelector = 0
							newESP = 0

							if ((proc.tss.getType() & 0x8) != 0)
								tssStackAddress = (targetSegment.getDPL() * 8) + 4
								if ((tssStackAddress + 7) > proc.tss.getLimit())
									throw new ProcessorException(ProcessorException.Type.TASK_SWITCH, proc.tss.getSelector(), true)

								isSup = proc.linearMemory.isSupervisor()
								try
									proc.linearMemory.setSupervisor(true)
									newStackSelector = 0xffff & proc.tss.getWord(tssStackAddress + 4)
									newESP = proc.tss.getDoubleWord(tssStackAddress)
								finally
									proc.linearMemory.setSupervisor(isSup)

							else
								tssStackAddress = (targetSegment.getDPL() * 4) + 2
								if ((tssStackAddress + 4) > proc.tss.getLimit())
									throw new ProcessorException(ProcessorException.Type.TASK_SWITCH, proc.tss.getSelector(), true)
								newStackSelector = 0xffff & proc.tss.getWord(tssStackAddress + 2)
								newESP = 0xffff & proc.tss.getWord(tssStackAddress)


							if ((newStackSelector & 0xfffc) == 0)
								throw new ProcessorException(ProcessorException.Type.TASK_SWITCH, 0, true)

							newStackSegment = null
							try
								newStackSegment = proc.getSegment(newStackSelector)
							catch e
								throw new ProcessorException(ProcessorException.Type.TASK_SWITCH, newStackSelector, true)

							if (newStackSegment.getRPL() != targetSegment.getDPL())
								throw new ProcessorException(ProcessorException.Type.TASK_SWITCH, newStackSelector & 0xfffc, true)

							if ((newStackSegment.getDPL() != targetSegment.getDPL()) || ((newStackSegment.getType() & 0x1a) != 0x12))
								throw new ProcessorException(ProcessorException.Type.TASK_SWITCH, newStackSelector & 0xfffc, true)

							if (!(newStackSegment.isPresent()))
								throw new ProcessorException(ProcessorException.Type.NOT_PRESENT, newStackSelector & 0xfffc, true)

							parameters = gate.getParameterCount() & 0x1f
							if ((newStackSegment.getDefaultSizeFlag() && (proc.esp < 8 + 2 * parameters) && (proc.esp > 0)) || !newStackSegment.getDefaultSizeFlag() && ((proc.esp & 0xffff) < 8 + 2 * parameters))
								throw ProcessorException.STACK_SEGMENT_0

							targetOffset = 0xffff & gate.getTargetOffset()

							returnSS = proc.ss.getSelector()
							oldStack = proc.ss

							if (proc.ss.getDefaultSizeFlag())
								returnESP = proc.esp
							else
								returnESP = proc.esp & 0xffff
							oldCS = proc.cs.getSelector()
							int oldEIP
							if (proc.cs.getDefaultSizeFlag())
								oldEIP = proc.getEIP()
							else
								oldEIP = proc.getEIP() & 0xffff
							proc.ss = newStackSegment
							proc.esp = newESP
							proc.ss.setRPL(targetSegment.getDPL())

							if (proc.ss.getDefaultSizeFlag())
								proc.esp -= 2
								proc.ss.setWord(proc.esp, short(returnSS))
								proc.esp -= 2
								proc.ss.setWord(proc.esp, short(returnESP))

								for i in [0..parameters]
									proc.esp -= 2
									proc.ss.setWord(proc.esp, oldStack.getWord(returnESP + 2*parameters - 2*i -2))

								proc.esp -= 2
								proc.ss.setWord(proc.esp, short(oldCS))
								proc.esp -= 2
								proc.ss.setWord(proc.esp, short(oldEIP))
							else
								proc.esp = (proc.esp & ~0xffff) | ((proc.esp - 2) & 0xffff)
								proc.ss.setWord(proc.esp & 0xffff, short(returnSS))
								proc.esp = (proc.esp & ~0xffff) | ((proc.esp - 2) & 0xffff)
								proc.ss.setWord(proc.esp & 0xffff, short(returnESP))

								for i in [0..parameters]
									proc.esp = (proc.esp & ~0xffff) | ((proc.esp - 2) & 0xffff)
									proc.ss.setWord(proc.esp & 0xffff, oldStack.getWord((returnESP + 2*parameters - 2*i -2) & 0xffff))

								proc.esp = (proc.esp & ~0xffff) | ((proc.esp - 2) & 0xffff)
								proc.ss.setWord(proc.esp & 0xffff, short(oldCS))
								proc.esp = (proc.esp & ~0xffff) | ((proc.esp - 2) & 0xffff)
								proc.ss.setWord(proc.esp & 0xffff, short(oldEIP))

							targetSegment.checkAddress(targetOffset)
							proc.cs = targetSegment
							proc.setEIP(targetOffset)
							proc.setCPL(proc.ss.getDPL())
							proc.cs.setRPL(proc.getCPL())

						else if (targetSegment.getDPL() == proc.getCPL())
							log "16-bit call gate: jump to same privilege segment not implemented"
							throw new IllegalStateException("Execute Failed")
						else
							throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, targetSegmentSelector, true)

					when 0x1c, 0x1d, 0x1e, 0x1f
						log "16-bit call gate: jump to same privilege conforming segment not implemented"
						throw new IllegalStateException("Execute Failed")

					else
						throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, targetSegmentSelector, true)

			when 0x05
				log "Task gate not implemented"
				throw new IllegalStateException("Execute Failed")
			when 0x09, 0x0b
				log "TSS not implemented"
				throw new IllegalStateException("Execute Failed")
			when 0x0c
				log "Call gate not implemented"
				throw new IllegalStateException("Execute Failed")
			when 0x18, 0x19, 0x1a, 0x1b
				if ((proc.esp < 4) && (proc.esp > 0))
					throw ProcessorException.STACK_SEGMENT_0

				newSegment.checkAddress(targetEIP&0xFFFF)

				if (proc.ss.getDefaultSizeFlag())
					tempESP = proc.esp
				else
					tempESP = proc.esp & 0xffff

				proc.ss.setWord((tempESP - 2), short(0xFFFF & proc.cs.getSelector()))
				proc.ss.setWord((tempESP - 4), short(0xFFFF & proc.getEIP()))
				proc.esp = (proc.esp & ~0xFFFF) | ((proc.esp-4) & 0xFFFF)

				proc.cs = newSegment
				proc.cs.setRPL(proc.getCPL())
				proc.setEIP( targetEIP & 0xFFFF)
				return
			when 0x1c, 0x1d, 0x1e, 0x1f
				log "Conforming code segment not implemented"
				throw new IllegalStateException("Execute Failed")
			else
				log "Invalid segment type ",
				throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, targetSelector, true)

	call_far_o32_a32: (targetEIP, targetSelector) ->
		newSegment = proc.getSegment(targetSelector)
		if (newSegment instanceof NULL_SEGMENT)
			throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, 0, true)

		switch (newSegment.getType())
			when 0x01, 0x03
				log "16-bit TSS not implemented"
				throw new IllegalStateException("Execute Failed")
			when 0x04

				if ((newSegment.getRPL() > proc.getCPL()) || (newSegment.getDPL() < proc.getCPL()))
					throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, targetSelector, true)
				if (!newSegment.isPresent())
					throw new ProcessorException(ProcessorException.Type.NOT_PRESENT, targetSelector, true)

				gate = newSegment

				targetSegmentSelector = gate.getTargetSegment()

				try
					targetSegment = proc.getSegment(targetSegmentSelector)
				catch e
					throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, targetSegmentSelector, true)

				if (targetSegment instanceof NULL_SEGMENT)
					throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, 0, true)

				if (targetSegment.getDPL() > proc.getCPL())
					throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, targetSelector, true)

				switch (targetSegment.getType())
					when 0x18, 0x19, 0x1a, 0x1b
						if (!targetSegment.isPresent())
							throw new ProcessorException(ProcessorException.Type.NOT_PRESENT, targetSegmentSelector, true)

						if (targetSegment.getDPL() < proc.getCPL())
							log "16-bit call gate: jump to more privileged segment not implemented"
							throw new IllegalStateException("Execute Failed")
						else if (targetSegment.getDPL() == proc.getCPL())
							log "16-bit call gate: jump to same privilege segment not implemented"
							throw new IllegalStateException("Execute Failed")
						else
							throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, targetSegmentSelector, true)
					when 0x1c, 0x1d, 0x1e, 0x1f
						if (!targetSegment.isPresent())
							throw new ProcessorException(ProcessorException.Type.NOT_PRESENT, targetSegmentSelector, true)

						log "16-bit call gate: jump to same privilege conforming segment not implemented"
						throw new IllegalStateException("Execute Failed")
					else
						throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, targetSegmentSelector, true)

			when 0x05
				log "Task gate not implemented"
				throw new IllegalStateException("Execute Failed")
			when 0x09, 0x0b
				log "TSS not implemented"
				throw new IllegalStateException("Execute Failed")
			when 0x0c
				log "Call gate not implemented"
				throw new IllegalStateException("Execute Failed")
			when 0x18, 0x19, 0x1a, 0x1b
				if ((newSegment.getRPL() > proc.getCPL()) || (newSegment.getDPL() != proc.getCPL()))
					throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, targetSelector, true)
				if (!newSegment.isPresent())
					throw new ProcessorException(ProcessorException.Type.NOT_PRESENT, targetSelector, true)

				if ((proc.esp < 8) && (proc.esp > 0))
					throw ProcessorException.STACK_SEGMENT_0

				newSegment.checkAddress(targetEIP)

				proc.ss.setDoubleWord(proc.esp - 4, proc.cs.getSelector())
				proc.ss.setDoubleWord(proc.esp - 8, proc.getEIP())
				proc.esp -= 8

				proc.cs = newSegment
				proc.cs.setRPL(proc.getCPL())
				proc.setEIP(targetEIP)
				return

			when 0x1c, 0x1d, 0x1e, 0x1f
				log "Conforming code segment not implemented"
				throw new IllegalStateException("Execute Failed")
			else
				log "Invalid segment type "
				throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, targetSelector, true)

	call_far_o32_a16: (targetEIP, targetSelector) ->
		newSegment = proc.getSegment(targetSelector)
		if (newSegment instanceof NULL_SEGMENT)
			throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, 0, true)

		switch (newSegment.getType())
			when 0x01, 0x03
				log "16-bit TSS not implemented"
				throw new IllegalStateException("Execute Failed")
			when 0x04
				if ((newSegment.getRPL() > proc.getCPL()) || (newSegment.getDPL() < proc.getCPL()))
					throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, targetSelector, true)
				if (!newSegment.isPresent())
					throw new ProcessorException(ProcessorException.Type.NOT_PRESENT, targetSelector, true)

				gate = newSegment

				targetSegmentSelector = gate.getTargetSegment()

				try
					targetSegment = proc.getSegment(targetSegmentSelector)
				catch e
					throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, targetSegmentSelector, true)

				if (targetSegment instanceof NULL_SEGMENT)
					throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, 0, true)

				if (targetSegment.getDPL() > proc.getCPL())
					throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, targetSelector, true)

				switch (targetSegment.getType())
					when 0x18, 0x19, 0x1a, 0x1b
						if (!targetSegment.isPresent())
							throw new ProcessorException(ProcessorException.Type.NOT_PRESENT, targetSegmentSelector, true)

						if (targetSegment.getDPL() < proc.getCPL())
							log "16-bit call gate: jump to more privileged segment not implemented"
							throw new IllegalStateException("Execute Failed")
						else if (targetSegment.getDPL() == proc.getCPL())
							log "16-bit call gate: jump to same privilege segment not implemented"
							throw new IllegalStateException("Execute Failed")
						else
							throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, targetSegmentSelector, true)

					when 0x1c, 0x1d, 0x1e, 0x1f
						if (!targetSegment.isPresent())
							throw new ProcessorException(ProcessorException.Type.NOT_PRESENT, targetSegmentSelector, true)

						log "16-bit call gate: jump to same privilege conforming segment not implemented"
						throw new IllegalStateException("Execute Failed")

					else
						throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, targetSegmentSelector, true)
			when 0x05
				log "Task gate not implemented"
				throw new IllegalStateException("Execute Failed")
			when 0x09, 0x0b
				log "TSS not implemented"
				throw new IllegalStateException("Execute Failed")
			when 0x0c
				log "Call gate not implemented"
				throw new IllegalStateException("Execute Failed")
			when 0x18, 0x19, 0x1a, 0x1b
				if ((newSegment.getRPL() > proc.getCPL()) || (newSegment.getDPL() != proc.getCPL()))
					throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, targetSelector, true)
				if (!newSegment.isPresent())
					throw new ProcessorException(ProcessorException.Type.NOT_PRESENT, targetSelector, true)

				if ((proc.esp & 0xffff) < 8)
					throw ProcessorException.STACK_SEGMENT_0

				newSegment.checkAddress(targetEIP)

				proc.ss.setDoubleWord((proc.esp - 4) & 0xffff, proc.cs.getSelector())
				proc.ss.setDoubleWord((proc.esp - 8) & 0xffff, proc.getEIP())
				proc.esp = (proc.esp & ~0xffff) | ((proc.esp - 8) & 0xffff)

				proc.cs = newSegment
				proc.cs.setRPL(proc.getCPL())
				proc.setEIP(targetEIP)
				return
			when 0x1c, 0x1d, 0x1e, 0x1f
				log "Conforming code segment not implemented"
				throw new IllegalStateException("Execute Failed")

			else
				log "Invalid segment type"
				throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, targetSelector, true)

	ret_o16_a32: ->
	# TODO:  supposed to throw SS exception
	# "if top 6 bytes of stack not within stack limits"
		proc.setEIP(proc.ss.getWord(proc.esp) & 0xffff)
		proc.esp = proc.esp + 2

	ret_o16_a16: ->
	# TODO:  supposed to throw SS exception
	# "if top 6 bytes of stack not within stack limits"
		proc.setEIP(proc.ss.getWord(proc.esp & 0xffff) & 0xffff)
		proc.esp = (proc.esp & ~0xffff) | ((proc.esp + 2) & 0xffff)

	ret_o32_a32: ->
	# TODO:  supposed to throw SS exception
	# "if top 6 bytes of stack not within stack limits"
		proc.setEIP(proc.ss.getDoubleWord(proc.esp))
		proc.esp = proc.esp + 4

	ret_o32_a16: ->
	# TODO:  supposed to throw SS exception
	# "if top 6 bytes of stack not within stack limits"
		proc.setEIP(proc.ss.getDoubleWord(0xffff & proc.esp))
		proc.esp = (proc.esp & ~0xffff) | ((proc.esp + 4) & 0xffff)

	ret_iw_o16_a32: (offset) ->
		@ret_o16_a32()
		proc.esp += short(offset) #check short

	ret_iw_o16_a16: (offset) ->
		@ret_o16_a16()
		proc.esp = (proc.esp & ~0xffff) | (((proc.esp & 0xFFFF) + short(offset)) & 0xffff) # check short

	ret_iw_o32_a32: (offset) ->
		@ret_o32_a32()
		proc.esp += short(offset)

	ret_iw_o32_a16: (offset) ->
		@ret_o32_a16()
		proc.esp = (proc.esp & ~0xffff) | (((proc.esp & 0xFFFF) + short(offset)) & 0xffff)

	ret_far_o16_a16: (stackdelta) ->
		try
			proc.ss.checkAddress((proc.esp + 3) & 0xFFFF)
		catch e
			throw ProcessorException.STACK_SEGMENT_0

		tempEIP = 0xFFFF & proc.ss.getWord(proc.esp & 0xFFFF)
		tempCS = 0xFFFF & proc.ss.getWord((proc.esp + 2) & 0xFFFF)

		if ((tempCS & 0xfffc) == 0)
			throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, 0, true)

		returnSegment = proc.getSegment(tempCS)
		if (returnSegment instanceof NULL_SEGMENT)
			throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, 0, true)

		if (returnSegment.getRPL() < proc.getCPL())
			log("RPL too small in far ret: RPL=" + returnSegment.getRPL() + ", CPL=" + proc.getCPL() + ", new CS=" + tempCS)
			throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, tempCS, true)

		switch (returnSegment.getType())
			when 0x18, 0x19, 0x1a, 0x1b
				if (!(returnSegment.isPresent()))
					throw new ProcessorException(ProcessorException.Type.NOT_PRESENT, tempCS, true)

				if (returnSegment.getRPL() > proc.getCPL())
					#OUTER PRIVILEGE-LEVEL
					try
						proc.ss.checkAddress((proc.esp + 7 + stackdelta) & 0xFFFF)
					catch e
						throw ProcessorException.STACK_SEGMENT_0

					returnESP = 0xffff & proc.ss.getWord((proc.esp + 4 + stackdelta) & 0xFFFF)
					newSS = 0xffff & proc.ss.getWord((proc.esp + 6 + stackdelta) & 0xFFFF)

					if ((newSS & 0xfffc) == 0)
						throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, 0, true)

					returnStackSegment = proc.getSegment(newSS)

					if ((returnStackSegment.getRPL() != returnSegment.getRPL()) || ((returnStackSegment.getType() & 0x12) != 0x12) || (returnStackSegment.getDPL() != returnSegment.getRPL()))
						throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, newSS & 0xfffc, true)

					if (!returnStackSegment.isPresent())
						throw new ProcessorException(ProcessorException.Type.STACK_SEGMENT, newSS & 0xfffc, true)

					returnSegment.checkAddress(tempEIP)

					proc.setEIP(tempEIP)
					proc.cs = returnSegment

					proc.ss = returnStackSegment
					proc.esp = returnESP + stackdelta

					proc.setCPL(proc.cs.getRPL())

					try
						if ((((proc.es.getType() & (ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA | ProtectedModeSegment.TYPE_CODE)) == ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA) || ((proc.es.getType() & (ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA | ProtectedModeSegment.TYPE_CODE | ProtectedModeSegment.TYPE_CODE_CONFORMING)) == (ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA | ProtectedModeSegment.TYPE_CODE))) && (proc.getCPL() > proc.es.getDPL()))
					# can't use lower dpl data segment at higher cpl
							log("Setting ES to NULL in ret far")
							proc.es = NULL_SEGMENT
					catch e
						log "."

					try
						if ((((proc.ds.getType() & (ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA | ProtectedModeSegment.TYPE_CODE)) == ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA) || ((proc.ds.getType() & (ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA | ProtectedModeSegment.TYPE_CODE | ProtectedModeSegment.TYPE_CODE_CONFORMING)) == (ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA | ProtectedModeSegment.TYPE_CODE))) && (proc.getCPL() > proc.ds.getDPL()))
							# can't use lower dpl data segment at higher cpl
							log("Setting DS to NULL in ret far")
							proc.ds = NULL_SEGMENT
					catch e
						log "."

					try
						if ((((proc.fs.getType() & (ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA | ProtectedModeSegment.TYPE_CODE)) == ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA) || ((proc.fs.getType() & (ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA | ProtectedModeSegment.TYPE_CODE | ProtectedModeSegment.TYPE_CODE_CONFORMING)) == (ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA | ProtectedModeSegment.TYPE_CODE))) && (proc.getCPL() > proc.fs.getDPL()))
							# can't use lower dpl data segment at higher cpl
							log("Setting FS to NULL in ret far")
							proc.fs = NULL_SEGMENT
					catch e
						log "."

					try
						if ((((proc.gs.getType() & (ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA | ProtectedModeSegment.TYPE_CODE)) == ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA) || ((proc.gs.getType() & (ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA | ProtectedModeSegment.TYPE_CODE | ProtectedModeSegment.TYPE_CODE_CONFORMING)) == (ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA | ProtectedModeSegment.TYPE_CODE))) && (proc.getCPL() > proc.gs.getDPL()))
							# can't use lower dpl data segment at higher cpl
							System.out.println("Setting GS to NULL in ret far")
							proc.gs = NULL_SEGMENT
					catch e
				else
					#SAME PRIVILEGE-LEVEL
					returnSegment.checkAddress(tempEIP)

					proc.esp = (proc.esp & ~0xFFFF)| ((proc.esp + 4 + stackdelta) &0xFFFF)
					proc.setEIP(tempEIP)
					proc.cs = returnSegment
			when 0x1c, 0x1d, 0x1e, 0x1f
				if (returnSegment.getDPL() > returnSegment.getRPL())
					throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, tempCS, true)

				if (!(returnSegment.isPresent()))
					throw new ProcessorException(ProcessorException.Type.NOT_PRESENT, tempCS, true)

				if (returnSegment.getRPL() > proc.getCPL())
					#OUTER PRIVILEGE-LEVEL
					#proc.esp += 8;
					log "Conforming outer privilege level not implemented"
					throw new IllegalStateException("Execute Failed")
				else
					#SAME PRIVILEGE-LEVEL
					returnSegment.checkAddress(tempEIP)

					proc.esp = (proc.esp & ~0xFFFF)| ((proc.esp + 4 + stackdelta) &0xFFFF)
					proc.setEIP(tempEIP)
					proc.cs = returnSegment
			else
				throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, tempCS, true)

	ret_far_o16_a32: (stackdelta) ->
		try
			proc.ss.checkAddress(proc.esp + 3)
		catch e
			throw ProcessorException.STACK_SEGMENT_0

		tempEIP = 0xFFFF & proc.ss.getWord(proc.esp)
		tempCS = 0xFFFF & proc.ss.getWord(proc.esp + 2)

		returnSegment = proc.getSegment(tempCS)

		if (returnSegment instanceof NULL_SEGMENT)
			throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, 0, true)

		switch (returnSegment.getType())
			when 0x18, 0x19, 0x1a, 0x1b
				if (returnSegment.getRPL() < proc.getCPL())
					throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, tempCS, true)

				if (!(returnSegment.isPresent()))
					throw new ProcessorException(ProcessorException.Type.NOT_PRESENT, tempCS, true)

				if (returnSegment.getRPL() > proc.getCPL())
					#OUTER PRIVILEGE-LEVEL
					#proc.esp += 8;
					log "Non-conforming outer privilege level not implemented"
					throw new IllegalStateException("Execute Failed")
				else
					#SAME PRIVILEGE-LEVEL
					returnSegment.checkAddress(tempEIP)

					proc.esp = proc.esp + 4 + stackdelta
					proc.setEIP(tempEIP)
					proc.cs = returnSegment

			when 0x1c, 0x1d, 0x1e, 0x1f

				if (returnSegment.getRPL() < proc.getCPL())
					throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, tempCS, true)

				if (returnSegment.getDPL() > returnSegment.getRPL())
					throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, tempCS, true)

				if (!(returnSegment.isPresent()))
					throw new ProcessorException(ProcessorException.Type.NOT_PRESENT, tempCS, true)

				if (returnSegment.getRPL() > proc.getCPL())
					#OUTER PRIVILEGE-LEVEL
					#proc.esp += 8
					log "Conforming outer privilege level not implemented"
					throw new IllegalStateException("Execute Failed")
				else
					#SAME PRIVILEGE-LEVEL
					returnSegment.checkAddress(tempEIP & 0xFFFF)

					proc.esp = proc.esp + 4 + stackdelta
					proc.setEIP(0xFFFF & tempEIP)
					proc.cs = returnSegment

			else
				throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, tempCS, true)

	ret_far_o32_a16: (stackdelta) ->
		try
			proc.ss.checkAddress((proc.esp + 7) & 0xFFFF)
		catch e
			throw ProcessorException.STACK_SEGMENT_0


		tempEIP = proc.ss.getDoubleWord(proc.esp & 0xFFFF)
		tempCS = 0xffff & proc.ss.getDoubleWord((proc.esp + 4) & 0xFFFF)

		returnSegment = proc.getSegment(tempCS)

		if (returnSegment instanceof NULL_SEGMENT)
			throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, 0, true)

		switch (returnSegment.getType())
			when 0x18, 0x19, 0x1a, 0x1b
				if (returnSegment.getRPL() < proc.getCPL())
					throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, tempCS, true)

				if (!(returnSegment.isPresent()))
					throw new ProcessorException(ProcessorException.Type.NOT_PRESENT, tempCS, true)

				if (returnSegment.getRPL() > proc.getCPL())
					#OUTER PRIVILEGE-LEVEL
					#proc.esp += 8
					log "Non-conforming outer privilege level not implemented"
					throw new IllegalStateException("Execute Failed")
				else
					#SAME PRIVILEGE-LEVEL
					returnSegment.checkAddress(tempEIP)

					proc.esp = (proc.esp & ~0xFFFF)| ((proc.esp + 8 + stackdelta) &0xFFFF)
					proc.setEIP(tempEIP)
					proc.cs = returnSegment

			when 0x1c, 0x1d, 0x1e, 0x1f
				if (returnSegment.getRPL() < proc.getCPL())
					throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, tempCS, true)

				if (returnSegment.getDPL() > returnSegment.getRPL())
					throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, tempCS, true)

				if (!(returnSegment.isPresent()))
					throw new ProcessorException(ProcessorException.Type.NOT_PRESENT, tempCS, true)

				if (returnSegment.getRPL() > proc.getCPL())
					#OUTER PRIVILEGE-LEVEL
					#proc.esp += 8
					log "Conforming outer privilege level not implemented"
					throw new IllegalStateException("Execute Failed")
				else
					#SAME PRIVILEGE-LEVEL
					returnSegment.checkAddress(tempEIP)

					proc.esp = (proc.esp & ~0xFFFF)| ((proc.esp + 8 + stackdelta) &0xFFFF)
					proc.setEIP(tempEIP)
					proc.cs = returnSegment

			else
				throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, tempCS, true)

	iretToVirtual8086Mode16BitAddressing: (newCS, newEIP, newEFlags) ->
		try
			proc.ss.checkAddress((proc.esp + 23) & 0xffff)
		catch e
			throw ProcessorException.STACK_SEGMENT_0

		proc.cs = SegmentFactory.createVirtual8086ModeSegment(proc.linearMemory, newCS, true)
		proc.setEIP(newEIP & 0xffff)
		int newESP = proc.ss.getDoubleWord(proc.esp & 0xffff)
		int newSS = 0xffff & proc.ss.getDoubleWord((proc.esp + 4) & 0xffff)
		proc.es = SegmentFactory.createVirtual8086ModeSegment(proc.linearMemory, 0xffff & proc.ss.getDoubleWord((proc.esp + 8) & 0xffff), false)
		proc.ds = SegmentFactory.createVirtual8086ModeSegment(proc.linearMemory, 0xffff & proc.ss.getDoubleWord((proc.esp + 12) & 0xffff), false)
		proc.fs = SegmentFactory.createVirtual8086ModeSegment(proc.linearMemory, 0xffff & proc.ss.getDoubleWord((proc.esp + 16) & 0xffff), false)
		proc.gs = SegmentFactory.createVirtual8086ModeSegment(proc.linearMemory, 0xffff & proc.ss.getDoubleWord((proc.esp + 20) & 0xffff), false)
		proc.ss = SegmentFactory.createVirtual8086ModeSegment(proc.linearMemory, newSS, false)
		proc.esp = newESP
		proc.setCPL(3)

		return newEFlags

	iret32ProtectedMode16BitAddressing: (newCS, newEIP, newEFlags) ->
		returnSegment = proc.getSegment(newCS)

		if (returnSegment instanceof NULL_SEGMENT)
			throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, 0, true)

		switch (returnSegment.getType())
			when 0x18, 0x19, 0x1a, 0x1b
				if (returnSegment.getRPL() < proc.getCPL())
					throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, newCS, true)

				if (!(returnSegment.isPresent()))
					throw new ProcessorException(ProcessorException.Type.NOT_PRESENT, newCS, true)

				if (returnSegment.getRPL() > proc.getCPL())
					try
						proc.ss.checkAddress((proc.esp + 7) & 0xFFFF)
					catch e
						throw ProcessorException.STACK_SEGMENT_0


					returnESP = proc.ss.getDoubleWord((proc.esp)&0xFFFF)
					newSS = 0xffff & proc.ss.getDoubleWord((proc.esp + 4)&0xFFFF)

					returnStackSegment = proc.getSegment(newSS)

					if ((returnStackSegment.getRPL() != returnSegment.getRPL()) || ((returnStackSegment.getType() & 0x12) != 0x12) || (returnStackSegment.getDPL() != returnSegment.getRPL()))
						throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, newSS, true)

					if (!returnStackSegment.isPresent())
						throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, newSS, true)

					returnSegment.checkAddress(newEIP)

					#proc.esp += 20; #includes the 12 from earlier
					proc.setEIP(newEIP)
					proc.cs = returnSegment

					proc.ss = returnStackSegment
					proc.esp = returnESP

					int eflags = proc.getEFlags()
					eflags &= ~0x254dd5
					eflags |= (0x254dd5 & newEFlags)
					#overwrite: all; preserve: if, iopl, vm, vif, vip

					if (proc.getCPL() <= proc.eflagsIOPrivilegeLevel)
						eflags &= ~0x200
						eflags |= (0x200 & newEFlags)
						#overwrite: all; preserve: iopl, vm, vif, vip

					if (proc.getCPL() == 0)
						eflags &= ~0x1a3000
						eflags |= (0x1a3000 & newEFlags)
						#overwrite: all;

					#			proc.setEFlags(eflags);

					proc.setCPL(proc.cs.getRPL())

					try
						if ((((proc.es.getType() & (ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA | ProtectedModeSegment.TYPE_CODE)) == ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA) || ((proc.es.getType() & (ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA | ProtectedModeSegment.TYPE_CODE | ProtectedModeSegment.TYPE_CODE_CONFORMING)) == (ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA | ProtectedModeSegment.TYPE_CODE))) && (proc.getCPL() > proc.es.getDPL()))
							proc.es = NULL_SEGMENT
					catch e
						log "exp"


					try
						if ((((proc.ds.getType() & (ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA | ProtectedModeSegment.TYPE_CODE)) == ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA) || ((proc.ds.getType() & (ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA | ProtectedModeSegment.TYPE_CODE | ProtectedModeSegment.TYPE_CODE_CONFORMING)) == (ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA | ProtectedModeSegment.TYPE_CODE))) && (proc.getCPL() > proc.ds.getDPL()))
							proc.ds = NULL_SEGMENT
					catch e
						log "exp"

					try
						if ((((proc.fs.getType() & (ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA | ProtectedModeSegment.TYPE_CODE)) == ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA) || ((proc.fs.getType() & (ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA | ProtectedModeSegment.TYPE_CODE | ProtectedModeSegment.TYPE_CODE_CONFORMING)) == (ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA | ProtectedModeSegment.TYPE_CODE))) && (proc.getCPL() > proc.fs.getDPL()))
							proc.fs = NULL_SEGMENT
					catch e
						log "exp"

					try
						if ((((proc.gs.getType() & (ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA | ProtectedModeSegment.TYPE_CODE)) == ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA) || ((proc.gs.getType() & (ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA | ProtectedModeSegment.TYPE_CODE | ProtectedModeSegment.TYPE_CODE_CONFORMING)) == (ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA | ProtectedModeSegment.TYPE_CODE))) && (proc.getCPL() > proc.gs.getDPL()))
							proc.gs = NULL_SEGMENT
					catch e
						log "exp"

					return eflags
				else
					#SAME PRIVILEGE-LEVEL
					returnSegment.checkAddress(newEIP)

					# 		    proc.esp = (proc.esp & ~0xFFFF) | ((proc.esp+12)&0xFFFF)
					proc.cs = returnSegment
					proc.setEIP(newEIP)

					#Set EFlags
					eflags = proc.getEFlags()

					eflags &= ~0x254dd5
					eflags |= (0x254dd5 & newEFlags)

					if (proc.getCPL() <= proc.eflagsIOPrivilegeLevel)
						eflags &= ~0x200
						eflags |= (0x200 & newEFlags)

					if (proc.getCPL() == 0)
						eflags &= ~0x1a3000
						eflags |= (0x1a3000 & newEFlags)

					#  			proc.setEFlags(eflags);
					return eflags

			when 0x1c, 0x1d, 0x1e, 0x1f
				if (returnSegment.getRPL() < proc.getCPL())
					throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, newCS, true)

				if (returnSegment.getDPL() > returnSegment.getRPL())
					throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, newCS, true)

				if (!(returnSegment.isPresent()))
					throw new ProcessorException(ProcessorException.Type.NOT_PRESENT, newCS, true)

				if (returnSegment.getRPL() > proc.getCPL())
					#OUTER PRIVILEGE-LEVEL
					log "Conforming outer privilege level not implemented"
					throw new IllegalStateException("Execute Failed")
				else
					#SAME PRIVILEGE-LEVEL
					log "Conforming same privilege level not implemented"
					throw new IllegalStateException("Execute Failed")
			else
				log "Invalid segment type "
				throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, newCS, true)

	iret_o32_a16: ->

		if (proc.eflagsNestedTask)
			return iretFromTask()
		else
			try
				proc.ss.checkAddress((proc.esp + 11) & 0xffff)
			catch e
				throw ProcessorException.STACK_SEGMENT_0

			tempEIP = proc.ss.getDoubleWord(proc.esp & 0xFFFF)
			tempCS = 0xffff & proc.ss.getDoubleWord((proc.esp + 4) & 0xFFFF)
			tempEFlags = proc.ss.getDoubleWord((proc.esp + 8) & 0xFFFF)
			proc.esp = (proc.esp & ~0xffff) | ((proc.esp + 12) & 0xffff)

			if (((tempEFlags & (1 << 17)) != 0) && (proc.getCPL() == 0))
				return iretToVirtual8086Mode16BitAddressing(tempCS, tempEIP, tempEFlags)
			else
				return iret32ProtectedMode16BitAddressing(tempCS, tempEIP, tempEFlags)

	iretFromTask: ->
		throw new IllegalStateException("Execute Failed")


	iretToVirtual8086Mode32BitAddressing: (newCS, newEIP, newEFlags) ->
		try
			proc.ss.checkAddress(proc.esp + 23)
		catch e
			throw ProcessorException.STACK_SEGMENT_0

		if (newEIP > 0xfffff)
			throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION,0,true)

		proc.cs = SegmentFactory.createVirtual8086ModeSegment(proc.linearMemory, newCS, true)
		proc.setEIP(newEIP & 0xffff)
		int newESP = proc.ss.getDoubleWord(proc.esp)
		int newSS = 0xffff & proc.ss.getDoubleWord(proc.esp + 4)
		proc.es = SegmentFactory.createVirtual8086ModeSegment(proc.linearMemory, 0xffff & proc.ss.getDoubleWord(proc.esp + 8), false)
		proc.ds = SegmentFactory.createVirtual8086ModeSegment(proc.linearMemory, 0xffff & proc.ss.getDoubleWord(proc.esp + 12), false)
		proc.fs = SegmentFactory.createVirtual8086ModeSegment(proc.linearMemory, 0xffff & proc.ss.getDoubleWord(proc.esp + 16), false)
		proc.gs = SegmentFactory.createVirtual8086ModeSegment(proc.linearMemory, 0xffff & proc.ss.getDoubleWord(proc.esp + 20), false)
		proc.ss = SegmentFactory.createVirtual8086ModeSegment(proc.linearMemory, newSS, false)
		proc.esp = newESP
		proc.setCPL(3)

		return newEFlags

	iret32ProtectedMode32BitAddressing: (newCS, newEIP, newEFlags) ->
		returnSegment = proc.getSegment(newCS)

		if (returnSegment instanceof NULL_SEGMENT)
			throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, 0, true)

		switch (returnSegment.getType())
			when 0x18, 0x19, 0x1a, 0x1b
				if (returnSegment.getRPL() < proc.getCPL())
					throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, newCS, true)

				if (!(returnSegment.isPresent()))
					throw new ProcessorException(ProcessorException.Type.NOT_PRESENT, newCS, true)

				if (returnSegment.getRPL() > proc.getCPL())
					#OUTER PRIVILEGE-LEVEL
					try
						proc.ss.checkAddress(proc.esp + 7)
					catch e
						throw ProcessorException.STACK_SEGMENT_0


					returnESP = proc.ss.getDoubleWord(proc.esp)
					tempSS = 0xffff & proc.ss.getDoubleWord(proc.esp + 4)

					returnStackSegment = proc.getSegment(tempSS)

					if ((returnStackSegment.getRPL() != returnSegment.getRPL()) || ((returnStackSegment.getType() & 0x12) != 0x12) || (returnStackSegment.getDPL() != returnSegment.getRPL()))
						throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, tempSS, true)

					if (!returnStackSegment.isPresent())
						throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, tempSS, true)

					returnSegment.checkAddress(newEIP)

					#proc.esp += 20; //includes the 12 from earlier
					proc.setEIP(newEIP)
					proc.cs = returnSegment

					proc.ss = returnStackSegment
					proc.esp = returnESP

					eflags = proc.getEFlags()
					eflags &= ~0x254dd5
					eflags |= (0x254dd5 & newEFlags)
					#overwrite: all; preserve: if, iopl, vm, vif, vip

					if (proc.getCPL() <= proc.eflagsIOPrivilegeLevel)
						eflags &= ~0x200
						eflags |= (0x200 & newEFlags)
						#overwrite: all; preserve: iopl, vm, vif, vip

					if (proc.getCPL() == 0)
						eflags &= ~0x1a3000
						eflags |= (0x1a3000 & newEFlags)
						#overwrite: all;
					# 			proc.setEFlags(eflags);

					proc.setCPL(proc.cs.getRPL())

					try
						if ((((proc.es.getType() & (ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA | ProtectedModeSegment.TYPE_CODE)) == ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA) || ((proc.es.getType() & (ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA | ProtectedModeSegment.TYPE_CODE | ProtectedModeSegment.TYPE_CODE_CONFORMING)) == (ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA | ProtectedModeSegment.TYPE_CODE))) && (proc.getCPL() > proc.es.getDPL()))
							proc.es = NULL_SEGMENT
					catch e
						log "exp"

					try
						if ((((proc.ds.getType() & (ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA | ProtectedModeSegment.TYPE_CODE)) == ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA) || ((proc.ds.getType() & (ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA | ProtectedModeSegment.TYPE_CODE | ProtectedModeSegment.TYPE_CODE_CONFORMING)) == (ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA | ProtectedModeSegment.TYPE_CODE))) && (proc.getCPL() > proc.ds.getDPL()))
							proc.ds = NULL_SEGMENT
					catch e
						log "exp"

					try
						if ((((proc.fs.getType() & (ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA | ProtectedModeSegment.TYPE_CODE)) == ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA) || ((proc.fs.getType() & (ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA | ProtectedModeSegment.TYPE_CODE | ProtectedModeSegment.TYPE_CODE_CONFORMING)) == (ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA | ProtectedModeSegment.TYPE_CODE))) && (proc.getCPL() > proc.fs.getDPL()))
							proc.fs = NULL_SEGMENT
					catch e
						log "exp"

					try
						if ((((proc.gs.getType() & (ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA | ProtectedModeSegment.TYPE_CODE)) == ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA) || ((proc.gs.getType() & (ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA | ProtectedModeSegment.TYPE_CODE | ProtectedModeSegment.TYPE_CODE_CONFORMING)) == (ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA | ProtectedModeSegment.TYPE_CODE))) && (proc.getCPL() > proc.gs.getDPL()))
							proc.gs = NULL_SEGMENT
					catch e
						log "exp"

					return eflags
				else
					#SAME PRIVILEGE-LEVEL
					returnSegment.checkAddress(newEIP)

					proc.cs = returnSegment
					proc.setEIP(newEIP)

					#Set EFlags
					eflags = proc.getEFlags()

					eflags &= ~0x254dd5
					eflags |= (0x254dd5 & newEFlags)

					if (proc.getCPL() <= proc.eflagsIOPrivilegeLevel)
						eflags &= ~0x200
						eflags |= (0x200 & newEFlags)

					if (proc.getCPL() == 0)
						eflags &= ~0x1a3000
						eflags |= (0x1a3000 & newEFlags)
					#  			proc.setEFlags(eflags)
					return eflags

			when 0x1c, 0x1d, 0x1e, 0x1f
				if (returnSegment.getRPL() < proc.getCPL())
					throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, newCS, true)

				if (returnSegment.getDPL() > returnSegment.getRPL())
					throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, newCS, true)

				if (!(returnSegment.isPresent()))
					throw new ProcessorException(ProcessorException.Type.NOT_PRESENT, newCS, true)

				if (returnSegment.getRPL() > proc.getCPL())
					#OUTER PRIVILEGE-LEVEL
					log "Conforming outer privilege level not implemented"
					throw new IllegalStateException("Execute Failed")
				else
					#SAME PRIVILEGE-LEVEL
					returnSegment.checkAddress(newEIP)
					proc.setEIP(newEIP)
					proc.cs = returnSegment #do descriptor as well
					proc.setCarryFlag((newEFlags & 1) != 0)
					proc.setParityFlag((newEFlags & (1 << 2)) != 0)
					proc.setAuxiliaryCarryFlag((newEFlags & (1 << 4)) != 0)
					proc.setZeroFlag((newEFlags & (1 << 6)) != 0)
					proc.setSignFlag((newEFlags & (1 <<  7)) != 0)
					proc.eflagsTrap = ((newEFlags & (1 <<  8)) != 0)
					proc.eflagsDirection = ((newEFlags & (1 << 10)) != 0)
					proc.setOverflowFlag((newEFlags & (1 << 11)) != 0)
					proc.eflagsNestedTask = ((newEFlags & (1 << 14)) != 0)
					proc.eflagsResume = ((newEFlags & (1 << 16)) != 0)
					proc.eflagsAlignmentCheck = ((newEFlags & (1 << 18)) != 0) #do we need to call checkAlignmentChecking()?
					proc.eflagsID = ((newEFlags & (1 << 21)) != 0)
					if (proc.getCPL() <= proc.eflagsIOPrivilegeLevel)
						proc.eflagsInterruptEnableSoon = proc.eflagsInterruptEnable = ((newEFlags & (1 <<  9)) != 0)
					if (proc.getCPL() == 0)
						proc.eflagsIOPrivilegeLevel = ((newEFlags >> 12) & 3)
						proc.eflagsVirtual8086Mode = ((newEFlags & (1 << 17)) != 0)
						proc.eflagsVirtualInterrupt = ((newEFlags & (1 << 19)) != 0)
						proc.eflagsVirtualInterruptPending = ((newEFlags & (1 << 20)) != 0)

				return newEFlags

			else
				log "Invalid segment type"
				throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, newCS, true)

	iret_o32_a32: ->
		if (proc.eflagsNestedTask)
			return @iretFromTask()
		else
			try
				proc.ss.checkAddress(proc.esp + 11)
			catch e
				throw ProcessorException.STACK_SEGMENT_0

			tempEIP = proc.ss.getDoubleWord(proc.esp)
			tempCS = 0xffff & proc.ss.getDoubleWord(proc.esp + 4)
			tempEFlags = proc.ss.getDoubleWord(proc.esp + 8)
			proc.esp += 12

			if (((tempEFlags & (1 << 17)) != 0) && (proc.getCPL() == 0))
				return @iretToVirtual8086Mode32BitAddressing(tempCS, tempEIP, tempEFlags)
			else
				return @iret32ProtectedMode32BitAddressing(tempCS, tempEIP, tempEFlags)

	iret_o16_a16: ->
		if (proc.eflagsNestedTask)
			return iretFromTask()
		else
			try
				proc.ss.checkAddress((proc.esp + 5) & 0xffff)
			catch e
				throw ProcessorException.STACK_SEGMENT_0

			tempEIP = 0xffff & proc.ss.getWord(proc.esp & 0xFFFF)
			tempCS = 0xffff & proc.ss.getWord((proc.esp + 2) & 0xFFFF)
			tempEFlags = 0xffff & proc.ss.getWord((proc.esp + 4) & 0xFFFF)
			proc.esp = (proc.esp & ~0xffff) | ((proc.esp + 6) & 0xffff)

			return @iret16ProtectedMode16BitAddressing(tempCS, tempEIP, tempEFlags)

	iret_o16_a32: ->
		if (proc.eflagsNestedTask)
			return iretFromTask()
		else
			try
				proc.ss.checkAddress(proc.esp + 5)
			catch e
				throw ProcessorException.STACK_SEGMENT_0

			tempEIP = 0xffff & proc.ss.getWord(proc.esp)
			tempCS = 0xffff & proc.ss.getWord(proc.esp + 4)
			tempEFlags = 0xffff & proc.ss.getWord(proc.esp + 8)
			proc.esp += 12

			return @iret16ProtectedMode32BitAddressing(tempCS, tempEIP, tempEFlags)

	iret16ProtectedMode16BitAddressing: (newCS, newEIP, newEFlags) ->
		returnSegment = proc.getSegment(newCS)

		if (returnSegment instanceof NULL_SEGMENT)
			throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, 0, true)

		switch (returnSegment.getType())

			when 0x18, 0x19, 0x1a, 0x1b

				if (returnSegment.getRPL() < proc.getCPL())
					throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, newCS, true)

				if (!(returnSegment.isPresent()))
					throw new ProcessorException(ProcessorException.Type.NOT_PRESENT, newCS, true)

				if (returnSegment.getRPL() > proc.getCPL())
					#OUTER PRIVILEGE-LEVEL
					try
						proc.ss.checkAddress((proc.esp + 3) & 0xFFFF)
					catch e
						throw ProcessorException.STACK_SEGMENT_0


					returnESP = 0xffff & proc.ss.getWord(proc.esp & 0xFFFF)
					newSS = 0xffff & proc.ss.getWord((proc.esp + 2) & 0xFFFF)

					returnStackSegment = proc.getSegment(newSS)

					if ((returnStackSegment.getRPL() != returnSegment.getRPL()) || ((returnStackSegment.getType() & 0x12) != 0x12) || (returnStackSegment.getDPL() != returnSegment.getRPL()))
						throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, newSS, true)

					if (!returnStackSegment.isPresent())
						throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, newSS, true)

					returnSegment.checkAddress(newEIP)

					#proc.esp += 20; //includes the 12 from earlier
					proc.setEIP(newEIP)
					proc.cs = returnSegment

					proc.ss = returnStackSegment
					proc.esp = returnESP

					int eflags = proc.getEFlags()
					eflags &= ~0x4dd5
					eflags |= (0x4dd5 & newEFlags)
					#overwrite: all; preserve: if, iopl, vm, vif, vip

					if (proc.getCPL() <= proc.eflagsIOPrivilegeLevel)
						eflags &= ~0x200
						eflags |= (0x200 & newEFlags)
						#overwrite: all; preserve: iopl, vm, vif, vip

					if (proc.getCPL() == 0)
						eflags &= ~0x3000
						eflags |= (0x3000 & newEFlags)
						#overwrite: all;

					# 			proc.setEFlags(eflags);

					proc.setCPL(proc.cs.getRPL())

					try
						if ((((proc.es.getType() & (ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA | ProtectedModeSegment.TYPE_CODE)) == ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA) || ((proc.es.getType() & (ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA | ProtectedModeSegment.TYPE_CODE | ProtectedModeSegment.TYPE_CODE_CONFORMING)) == (ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA | ProtectedModeSegment.TYPE_CODE))) && (proc.getCPL() > proc.es.getDPL()))
							proc.es = NULL_SEGMENT
					catch e
						log "exp"

					try
						if ((((proc.ds.getType() & (ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA | ProtectedModeSegment.TYPE_CODE)) == ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA) || ((proc.ds.getType() & (ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA | ProtectedModeSegment.TYPE_CODE | ProtectedModeSegment.TYPE_CODE_CONFORMING)) == (ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA | ProtectedModeSegment.TYPE_CODE))) && (proc.getCPL() > proc.ds.getDPL()))
							proc.ds = NULL_SEGMENT
					catch e
						log "exp"

					try
						if ((((proc.fs.getType() & (ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA | ProtectedModeSegment.TYPE_CODE)) == ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA) || ((proc.fs.getType() & (ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA | ProtectedModeSegment.TYPE_CODE | ProtectedModeSegment.TYPE_CODE_CONFORMING)) == (ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA | ProtectedModeSegment.TYPE_CODE))) && (proc.getCPL() > proc.fs.getDPL()))
							proc.fs = NULL_SEGMENT
					catch e
						log "exp"


					try
						if ((((proc.gs.getType() & (ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA | ProtectedModeSegment.TYPE_CODE)) == ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA) || ((proc.gs.getType() & (ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA | ProtectedModeSegment.TYPE_CODE | ProtectedModeSegment.TYPE_CODE_CONFORMING)) == (ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA | ProtectedModeSegment.TYPE_CODE))) && (proc.getCPL() > proc.gs.getDPL()))
							proc.gs = NULL_SEGMENT
					catch e
						log "exp"


					return eflags
				else
					#SAME PRIVILEGE-LEVEL
					returnSegment.checkAddress(newEIP)

					proc.cs = returnSegment
					proc.setEIP(newEIP)

					#Set EFlags
					int eflags = proc.getEFlags()

					eflags &= ~0x4dd5
					eflags |= (0x4dd5 & newEFlags)

					if (proc.getCPL() <= proc.eflagsIOPrivilegeLevel)
						eflags &= ~0x200
						eflags |= (0x200 & newEFlags)

					if (proc.getCPL() == 0)
						eflags &= ~0x3000;
						eflags |= (0x3000 & newEFlags)

					#  			proc.setEFlags(eflags);
					return eflags
			when 0x1c, 0x1d, 0x1e, 0x1f
				if (returnSegment.getRPL() < proc.getCPL())
					throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, newCS, true)

				if (returnSegment.getDPL() > returnSegment.getRPL())
					throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, newCS, true)

				if (!(returnSegment.isPresent()))
					throw new ProcessorException(ProcessorException.Type.NOT_PRESENT, newCS, true)

				if (returnSegment.getRPL() > proc.getCPL())
					#OUTER PRIVILEGE-LEVEL
					log "Conforming outer privilege level not implemented"
					throw new IllegalStateException("Execute Failed")
				else
					#SAME PRIVILEGE-LEVEL
					log "Conforming same privilege level not implemented"
					throw new IllegalStateException("Execute Failed")
			else
				log "Invalid segment type "
				throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, newCS, true)

	iret16ProtectedMode32BitAddressing: (newCS, newEIP, newEFlags) ->
		returnSegment = proc.getSegment(newCS)

		if (returnSegment instanceof NULL_SEGMENT)
			throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, 0, true)

		switch (returnSegment.getType())
			when 0x18, 0x19, 0x1a, 0x1b
				if (returnSegment.getRPL() < proc.getCPL())
					throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, newCS, true)

				if (!(returnSegment.isPresent()))
					throw new ProcessorException(ProcessorException.Type.NOT_PRESENT, newCS, true)

				if (returnSegment.getRPL() > proc.getCPL())
					#OUTER PRIVILEGE-LEVEL
					try
						proc.ss.checkAddress(proc.esp + 3)
					catch e
						throw ProcessorException.STACK_SEGMENT_0

					returnESP = 0xffff & proc.ss.getWord(proc.esp)
					tempSS = 0xffff & proc.ss.getWord(proc.esp + 2)

					returnStackSegment = proc.getSegment(tempSS)

					if ((returnStackSegment.getRPL() != returnSegment.getRPL()) || ((returnStackSegment.getType() & 0x12) != 0x12) || (returnStackSegment.getDPL() != returnSegment.getRPL()))
						throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, tempSS, true)

					if (!returnStackSegment.isPresent())
						throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, tempSS, true)

					returnSegment.checkAddress(newEIP)

					#proc.esp += 20; //includes the 12 from earlier
					proc.setEIP(newEIP)
					proc.cs = returnSegment

					proc.ss = returnStackSegment
					proc.esp = returnESP

					eflags = proc.getEFlags()
					eflags &= ~0x4dd5
					eflags |= (0x4dd5 & newEFlags)
					#overwrite: all; preserve: if, iopl, vm, vif, vip

					if (proc.getCPL() <= proc.eflagsIOPrivilegeLevel)
						eflags &= ~0x200
						eflags |= (0x200 & newEFlags)
						#overwrite: all; preserve: iopl, vm, vif, vip

					if (proc.getCPL() == 0)
						eflags &= ~0x3000
						eflags |= (0x3000 & newEFlags)
						#overwrite: all;

					# 			proc.setEFlags(eflags);

					proc.setCPL(proc.cs.getRPL())

					try
						if ((((proc.es.getType() & (ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA | ProtectedModeSegment.TYPE_CODE)) == ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA) || ((proc.es.getType() & (ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA | ProtectedModeSegment.TYPE_CODE | ProtectedModeSegment.TYPE_CODE_CONFORMING)) == (ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA | ProtectedModeSegment.TYPE_CODE))) && (proc.getCPL() > proc.es.getDPL()))
							proc.es = NULL_SEGMENT
					catch e
						log "exp"

					try
						if ((((proc.ds.getType() & (ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA | ProtectedModeSegment.TYPE_CODE)) == ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA) || ((proc.ds.getType() & (ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA | ProtectedModeSegment.TYPE_CODE | ProtectedModeSegment.TYPE_CODE_CONFORMING)) == (ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA | ProtectedModeSegment.TYPE_CODE))) && (proc.getCPL() > proc.ds.getDPL()))
							proc.ds = NULL_SEGMENT
					catch e
						log "exp"

					try
						if ((((proc.fs.getType() & (ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA | ProtectedModeSegment.TYPE_CODE)) == ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA) || ((proc.fs.getType() & (ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA | ProtectedModeSegment.TYPE_CODE | ProtectedModeSegment.TYPE_CODE_CONFORMING)) == (ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA | ProtectedModeSegment.TYPE_CODE))) && (proc.getCPL() > proc.fs.getDPL()))
							proc.fs = NULL_SEGMENT
					catch e
						log "exp"

					try
						if ((((proc.gs.getType() & (ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA | ProtectedModeSegment.TYPE_CODE)) == ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA) || ((proc.gs.getType() & (ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA | ProtectedModeSegment.TYPE_CODE | ProtectedModeSegment.TYPE_CODE_CONFORMING)) == (ProtectedModeSegment.DESCRIPTOR_TYPE_CODE_DATA | ProtectedModeSegment.TYPE_CODE))) && (proc.getCPL() > proc.gs.getDPL()))
							proc.gs = NULL_SEGMENT
					catch e
						log "exp"

					return eflags
				else
					#SAME PRIVILEGE-LEVEL
					returnSegment.checkAddress(newEIP)

					proc.cs = returnSegment
					proc.setEIP(newEIP)

					#Set EFlags
					int eflags = proc.getEFlags()

					eflags &= ~0x4dd5
					eflags |= (0x4dd5 & newEFlags)

					if (proc.getCPL() <= proc.eflagsIOPrivilegeLevel)
						eflags &= ~0x200
						eflags |= (0x200 & newEFlags)

					if (proc.getCPL() == 0)
						eflags &= ~0x3000
						eflags |= (0x3000 & newEFlags)

					# 			proc.setEFlags(eflags);
					return eflags
			when 0x1c, 0x1d, 0x1e, 0x1f
				if (returnSegment.getRPL() < proc.getCPL())
					throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, newCS, true)

				if (returnSegment.getDPL() > returnSegment.getRPL())
					throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, newCS, true)

				if (!(returnSegment.isPresent()))
					throw new ProcessorException(ProcessorException.Type.NOT_PRESENT, newCS, true)

				if (returnSegment.getRPL() > proc.getCPL())
					#OUTER PRIVILEGE-LEVEL
					log "Conforming outer privilege level not implemented"
					throw new IllegalStateException("Execute Failed");
				else
					#SAME PRIVILEGE-LEVEL
					log "Conforming same privilege level not implemented"
					throw new IllegalStateException("Execute Failed")

			else
				log "Invalid segment type "
				throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, newCS, true)

	sysenter: ->
		csSelector = int(proc.getMSR(proc.SYSENTER_CS_MSR))
		if (csSelector == 0)
			throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, 0, true)
		proc.eflagsInterruptEnable = proc.eflagsInterruptEnableSoon = false
		proc.eflagsResume = false

		proc.cs = SegmentFactory.createProtectedModeSegment(proc.linearMemory, csSelector & 0xfffc, 0x00cf9b000000ffff)
		proc.setCPL(0)
		proc.ss = SegmentFactory.createProtectedModeSegment(proc.linearMemory, (csSelector + 8) & 0xfffc, 0x00cf93000000ffff)

		proc.esp = int(proc.getMSR(proc.SYSENTER_ESP_MSR))
		proc.setEIP(int(proc.getMSR(proc.SYSENTER_EIP_MSR)))

	sysexit: (esp, eip) ->
		int csSelector= int(proc.getMSR(proc.SYSENTER_CS_MSR))
		if (csSelector == 0)
			throw ProcessorException.GENERAL_PROTECTION_0
		if (proc.getCPL() != 0)
			throw ProcessorException.GENERAL_PROTECTION_0

		proc.cs = SegmentFactory.createProtectedModeSegment(proc.linearMemory, (csSelector + 16) | 0x3, 0x00cffb000000ffff)
		proc.setCPL(3)
		proc.ss = SegmentFactory.createProtectedModeSegment(proc.linearMemory, (csSelector + 24) | 0x3, 0x00cff3000000ffff)
		proc.correctAlignmentChecking(proc.ss)

		proc.esp = esp
		proc.setEIP(eip)

	in_o8: (port) ->
		if (@checkIOPermissionsByte(port))
			return 0xff & proc.ioports.ioPortReadByte(port)
		else
			log "denied access to io port #{port}"
			throw ProcessorException.GENERAL_PROTECTION_0;

	in_o16: (port) ->
		if (@checkIOPermissionsShort(port))
			return 0xffff & proc.ioports.ioPortReadWord(port)
		else
			log "denied access to io port #{port}"
			throw ProcessorException.GENERAL_PROTECTION_0

	in_o32: (port) ->
		if (@checkIOPermissionsInt(port))
			return proc.ioports.ioPortReadLong(port)
		else
			log "denied access to io port #{port}"
			throw ProcessorException.GENERAL_PROTECTION_0

	out_o8: (port, data) ->
		if (@checkIOPermissionsByte(port))
			proc.ioports.ioPortWriteByte(port, 0xff & data)
		else
			log "denied access to io port #{port}"
			throw ProcessorException.GENERAL_PROTECTION_0

	out_o16: (port, data) ->
		if (@checkIOPermissionsShort(port))
			proc.ioports.ioPortWriteWord(port, 0xffff & data)
		else
			log "denied access to io port #{port}"
			throw ProcessorException.GENERAL_PROTECTION_0

	out_o32: (port, data) ->
		if (@checkIOPermissionsInt(port))
			proc.ioports.ioPortWriteLong(port, data)
		else
			log "denied access to io port #{port}"
			throw ProcessorException.GENERAL_PROTECTION_0

	enter_o16_a16: (frameSize, nestingLevel) ->
		nestingLevel %= 32

		tempESP = 0xFFFF & proc.esp
		tempEBP = 0xFFFF & proc.ebp

		if (nestingLevel == 0)
			if ((tempESP < (2 + frameSize)) && (tempESP > 0))
				throw ProcessorException.STACK_SEGMENT_0
		else
			if ((tempESP < (2 + frameSize + 2 * nestingLevel)) && (tempESP > 0))
				throw ProcessorException.STACK_SEGMENT_0

		tempESP -= 2
		proc.ss.setWord(tempESP, short(tempEBP))

		frameTemp = tempESP

		if (nestingLevel > 0)
			while (--nestingLevel != 0)
				tempEBP -= 2
				tempESP -= 2
				proc.ss.setWord(tempESP, short(0xFFFF & proc.ss.getWord(tempEBP)))

			tempESP -= 2
			proc.ss.setWord(tempESP, short(frameTemp))


		proc.ebp = (proc.ebp & ~0xFFFF)| (0xFFFF & frameTemp)
		proc.esp = (proc.esp & ~0xFFFF)| (0xFFFF & (frameTemp - frameSize - 2*nestingLevel))

	enter_o16_a32: (frameSize, nestingLevel) ->
		nestingLevel %= 32

		tempESP = proc.esp
		tempEBP = proc.ebp

		if (nestingLevel == 0)
			if ((tempESP < (2 + frameSize)) && (tempESP > 0))
				throw ProcessorException.STACK_SEGMENT_0
		else
			if ((tempESP < (2 + frameSize + 2 * nestingLevel)) && (tempESP > 0))
				throw ProcessorException.STACK_SEGMENT_0

		tempESP -= 2
		proc.ss.setWord(tempESP, short(tempEBP))

		frameTemp = tempESP

		if (nestingLevel > 0)
			tmpLevel = nestingLevel
			while (--tmpLevel != 0)
				tempEBP -= 2
				tempESP -= 2
				proc.ss.setWord(tempESP, proc.ss.getWord(tempEBP));

			tempESP -= 2
			proc.ss.setWord(tempESP, short(frameTemp))

		proc.ebp = frameTemp
		proc.esp = frameTemp - frameSize -2*nestingLevel

	enter_o32_a32: (frameSize, nestingLevel) ->
		nestingLevel %= 32

		tempESP = proc.esp
		tempEBP = proc.ebp

		if (nestingLevel == 0)
			if ((tempESP < (4 + frameSize)) && (tempESP > 0))
				throw ProcessorException.STACK_SEGMENT_0
		else
			if ((tempESP < (4 + frameSize + 4 * nestingLevel)) && (tempESP > 0))
				throw ProcessorException.STACK_SEGMENT_0

		tempESP -= 4
		proc.ss.setDoubleWord(tempESP, tempEBP)

		frameTemp = tempESP

		int tmplevel = nestingLevel
		if (nestingLevel != 0)
			while (--tmplevel != 0)
				tempEBP -= 4
				tempESP -= 4
				proc.ss.setDoubleWord(tempESP, proc.ss.getDoubleWord(tempEBP))

			tempESP -= 4
			proc.ss.setDoubleWord(tempESP, frameTemp)

		proc.ebp = frameTemp
		proc.esp = frameTemp - frameSize - 4*nestingLevel

	leave_o32_a16: ->
		proc.ss.checkAddress(proc.ebp & 0xffff)
		tempESP = proc.ebp & 0xffff
		tempEBP = proc.ss.getDoubleWord(tempESP)
		proc.esp = (proc.esp & ~0xffff) | ((tempESP + 4) & 0xffff)
		proc.ebp = tempEBP


	leave_o32_a32: ->
		proc.ss.checkAddress(proc.ebp)
		tempESP = proc.ebp
		tempEBP = proc.ss.getDoubleWord(tempESP)
		proc.esp = tempESP + 4
		proc.ebp = tempEBP

	leave_o16_a16: ->
		proc.ss.checkAddress(proc.ebp & 0xffff)
		tempESP = proc.ebp & 0xffff
		tempEBP = 0xffff & proc.ss.getWord(tempESP)
		proc.esp = (proc.esp & ~0xffff) | ((tempESP + 2) & 0xffff)
		proc.ebp = (proc.ebp & ~0xffff) | tempEBP

	leave_o16_a32: ->
		proc.ss.checkAddress(proc.ebp)
		int tempESP = proc.ebp
		int tempEBP = 0xffff & proc.ss.getWord(tempESP)
		proc.esp = tempESP + 2
		proc.ebp = (proc.ebp & ~0xffff) | tempEBP

	push_o32_a32: (value) ->
		if ((proc.esp < 4) && (proc.esp > 0))
			throw ProcessorException.STACK_SEGMENT_0

		proc.ss.setDoubleWord(proc.esp - 4, int(value))
		proc.esp -= 4

	push_o32_a16: (value) ->
		if (((0xffff & proc.esp) < 4) && ((0xffff & proc.esp) > 0))
			throw ProcessorException.STACK_SEGMENT_0;

		proc.ss.setDoubleWord((proc.esp - 4) & 0xffff, value);
		proc.esp = (proc.esp & ~0xffff) | ((proc.esp - 4) & 0xffff);

	push_o16_a32: (value) ->
		if ((proc.esp < 2) && (proc.esp > 0))
			throw ProcessorException.STACK_SEGMENT_0

		proc.ss.setWord(proc.esp - 2, short(value))
		proc.esp -= 2

	push_o16_a16: (value) ->
		if (((0xffff & proc.esp) < 2) && ((0xffff & proc.esp) > 0))
			throw ProcessorException.STACK_SEGMENT_0

		proc.ss.setWord(((0xFFFF & proc.esp) - 2) & 0xffff, short(value))
		proc.esp = (proc.esp & ~0xffff) | ((proc.esp - 2) & 0xffff)

	pushad_a32: ->
		offset = proc.esp
		temp = proc.esp
		if ((offset < 32) && (offset > 0))
			throw ProcessorException.STACK_SEGMENT_0

		offset -= 4
		proc.ss.setDoubleWord(offset, proc.eax)
		offset -= 4
		proc.ss.setDoubleWord(offset, proc.ecx)
		offset -= 4
		proc.ss.setDoubleWord(offset, proc.edx)
		offset -= 4
		proc.ss.setDoubleWord(offset, proc.ebx)
		offset -= 4
		proc.ss.setDoubleWord(offset, temp)
		offset -= 4
		proc.ss.setDoubleWord(offset, proc.ebp)
		offset -= 4
		proc.ss.setDoubleWord(offset, proc.esi)
		offset -= 4
		proc.ss.setDoubleWord(offset, proc.edi)

		proc.esp = offset

	pushad_a16: ->
		offset = 0xFFFF & proc.esp
		temp = 0xFFFF & proc.esp
		if ((offset < 32) && (offset > 0))
			throw ProcessorException.STACK_SEGMENT_0

		offset -= 4
		proc.ss.setDoubleWord(offset, proc.eax)
		offset -= 4
		proc.ss.setDoubleWord(offset, proc.ecx)
		offset -= 4
		proc.ss.setDoubleWord(offset, proc.edx)
		offset -= 4
		proc.ss.setDoubleWord(offset, proc.ebx)
		offset -= 4
		proc.ss.setDoubleWord(offset, temp)
		offset -= 4
		proc.ss.setDoubleWord(offset, proc.ebp)
		offset -= 4
		proc.ss.setDoubleWord(offset, proc.esi)
		offset -= 4
		proc.ss.setDoubleWord(offset, proc.edi)

		proc.esp = (proc.esp & ~0xFFFF) | (0xFFFF & offset)

	pusha_a32: ->
		offset = proc.esp
		temp = proc.esp
		if ((offset < 16) && (offset > 0))
			throw ProcessorException.STACK_SEGMENT_0

		offset -= 2
		proc.ss.setWord(offset, short(0xffff & proc.eax))
		offset -= 2
		proc.ss.setWord(offset, short(0xffff & proc.ecx))
		offset -= 2
		proc.ss.setWord(offset, short(0xffff & proc.edx))
		offset -= 2
		proc.ss.setWord(offset, short(0xffff & proc.ebx))
		offset -= 2
		proc.ss.setWord(offset, short(0xffff & temp))
		offset -= 2
		proc.ss.setWord(offset, short(0xffff & proc.ebp))
		offset -= 2
		proc.ss.setWord(offset, short(0xffff & proc.esi))
		offset -= 2
		proc.ss.setWord(offset, short(0xffff & proc.edi))

		proc.esp = (proc.esp & ~0xffff) | (offset & 0xffff)

	pusha_a16: ->
		offset = 0xFFFF & proc.esp
		temp = 0xFFFF & proc.esp
		if ((offset < 16) && (offset > 0))
			throw ProcessorException.STACK_SEGMENT_0

		offset -= 2
		proc.ss.setWord(offset,short(proc.eax))
		offset -= 2
		proc.ss.setWord(offset,short(proc.ecx))
		offset -= 2
		proc.ss.setWord(offset,short(proc.edx))
		offset -= 2
		proc.ss.setWord(offset,short(proc.ebx))
		offset -= 2
		proc.ss.setWord(offset,short(temp))
		offset -= 2
		proc.ss.setWord(offset,short(proc.ebp))
		offset -= 2
		proc.ss.setWord(offset,short(proc.esi))
		offset -= 2
		proc.ss.setWord(offset,short(proc.edi))

		proc.esp = (proc.esp & ~0xffff) | (0xFFFF & offset)

	popa_a16: ->
		offset = 0xFFFF & proc.esp

		#Bochs claims no checking need on POPs
		#if (offset + 16 >= proc.ss.limit)
		#    throw ProcessorException.STACK_SEGMENT_0;

		newedi = (proc.edi & ~0xffff) | (0xffff & proc.ss.getWord(offset))
		offset += 2
		newesi = (proc.esi & ~0xffff) | (0xffff & proc.ss.getWord(offset))
		offset += 2
		newebp = (proc.ebp & ~0xffff) | (0xffff & proc.ss.getWord(offset))
		offset += 4 # yes - skip an extra 2 bytes in order to skip ESP

		newebx = (proc.ebx & ~0xffff) | (0xffff & proc.ss.getWord(offset))
		offset += 2
		newedx = (proc.edx & ~0xffff) | (0xffff & proc.ss.getWord(offset))
		offset += 2
		newecx = (proc.ecx & ~0xffff) | (0xffff & proc.ss.getWord(offset))
		offset += 2
		neweax = (proc.eax & ~0xffff) | (0xffff & proc.ss.getWord(offset))
		offset += 2

		proc.edi = newedi
		proc.esi = newesi
		proc.ebp = newebp
		proc.ebx = newebx
		proc.edx = newedx
		proc.ecx = newecx
		proc.eax = neweax

		proc.esp = (proc.esp & ~0xffff) | (offset & 0xffff)

	popad_a16: ->
		offset = 0xFFFF &proc.esp

		#Bochs claims no checking need on POPs
		#if (offset + 16 >= proc.ss.limit)
		#    throw ProcessorException.STACK_SEGMENT_0;

		newedi = proc.ss.getDoubleWord(offset)
		offset += 4
		newesi = proc.ss.getDoubleWord(offset)
		offset += 4
		newebp = proc.ss.getDoubleWord(offset)
		offset += 8#  yes - skip an extra 4 bytes in order to skip ESP

		newebx = proc.ss.getDoubleWord(offset)
		offset += 4
		newedx = proc.ss.getDoubleWord(offset)
		offset += 4
		newecx = proc.ss.getDoubleWord(offset)
		offset += 4
		neweax = proc.ss.getDoubleWord(offset)
		offset += 4

		proc.edi = newedi
		proc.esi = newesi
		proc.ebp = newebp
		proc.ebx = newebx
		proc.edx = newedx
		proc.ecx = newecx
		proc.eax = neweax

		proc.esp = (proc.esp & ~0xffff) | (offset & 0xffff)

	popa_a32: ->
		offset = proc.esp

		#Bochs claims no checking need on POPs
		#if (offset + 16 >= proc.ss.limit)
		#    throw ProcessorException.STACK_SEGMENT_0;

		newedi = (proc.edi & ~0xffff) | (0xffff & proc.ss.getWord(offset))
		offset += 2
		newesi = (proc.esi & ~0xffff) | (0xffff & proc.ss.getWord(offset))
		offset += 2
		newebp = (proc.ebp & ~0xffff) | (0xffff & proc.ss.getWord(offset))
		offset += 4# yes - skip an extra 2 bytes in order to skip ESP

		newebx = (proc.ebx & ~0xffff) | (0xffff & proc.ss.getWord(offset))
		offset += 2
		newedx = (proc.edx & ~0xffff) | (0xffff & proc.ss.getWord(offset))
		offset += 2
		newecx = (proc.ecx & ~0xffff) | (0xffff & proc.ss.getWord(offset))
		offset += 2
		neweax = (proc.eax & ~0xffff) | (0xffff & proc.ss.getWord(offset))
		offset += 2

		proc.edi = newedi
		proc.esi = newesi
		proc.ebp = newebp
		proc.ebx = newebx
		proc.edx = newedx
		proc.ecx = newecx
		proc.eax = neweax

		proc.esp = offset

	popad_a32: ->
		offset = proc.esp

		#Bochs claims no checking need on POPs
		#if (offset + 16 >= proc.ss.limit)
		#    throw ProcessorException.STACK_SEGMENT_0;

		newedi = proc.ss.getDoubleWord(offset)
		offset += 4
		newesi = proc.ss.getDoubleWord(offset)
		offset += 4
		newebp = proc.ss.getDoubleWord(offset)
		offset += 8# yes - skip an extra 4 bytes in order to skip ESP

		newebx = proc.ss.getDoubleWord(offset)
		offset += 4
		newedx = proc.ss.getDoubleWord(offset)
		offset += 4
		newecx = proc.ss.getDoubleWord(offset)
		offset += 4
		neweax = proc.ss.getDoubleWord(offset)
		offset += 4

		proc.edi = newedi
		proc.esi = newesi
		proc.ebp = newebp
		proc.ebx = newebx
		proc.edx = newedx
		proc.ecx = newecx
		proc.eax = neweax

		proc.esp = offset

	lar: (selector, original) ->
		if ((selector & 0xFFC) == 0)

			proc.setZeroFlag(false)
			return original

		offset = selector & 0xfff8

		#allow all normal segments
		# and available and busy 32 bit  and 16 bit TSS (9, b, 3, 1)
		# and ldt and tsk gate (2, 5)
		# and 32 bit and 16 bit call gates (c, 4)
		valid = [false, true, true, true,true, true, false, false,false, true, false, true,true, false, false, false,true, true, true, true,true, true, true, true,true, true, true, true,true, true, true, true]

		if ((selector & 0x4) != 0)
			descriptorTable = proc.ldtr
		else
			descriptorTable = proc.gdtr

		if ((offset + 7) > descriptorTable.getLimit())
			proc.setZeroFlag(false)
			return original

		descriptor = proc.readSupervisorDoubleWord(descriptorTable, offset + 4)
		type = (descriptor & 0x1f00) >> 8
		dpl = (descriptor & 0x6000) >> 13
		rpl = (selector & 0x3)

		conformingCode = ProtectedModeSegment.TYPE_CODE | ProtectedModeSegment.TYPE_CODE_CONFORMING
		if ((((type & conformingCode) != conformingCode) && ((proc.getCPL() > dpl) || (rpl > dpl))) || !valid[type])
			proc.setZeroFlag(false)
			return original
		else
			proc.setZeroFlag(true)
			return descriptor & 0x00FFFF00

	lsl: (selector, original) ->
		offset = selector & 0xfff8

		valid = [false, true, true, true,true, true, false, false,false, true, false, true,true, false, false, false,true, true, true, true,true, true, true,true,true, true, true, true,true, true, true, true]

		if ((selector & 0x4) != 0)
			descriptorTable = proc.ldtr
		else
			descriptorTable = proc.gdtr

		if ((offset + 8) > descriptorTable.getLimit())
			proc.setZeroFlag(false)
			return original

		segmentDescriptor = proc.readSupervisorDoubleWord(descriptorTable, offset + 4)

		type = (segmentDescriptor & 0x1f00) >> 8
		dpl = (segmentDescriptor & 0x6000) >> 13
		rpl = (selector & 0x3)
		conformingCode = ProtectedModeSegment.TYPE_CODE | ProtectedModeSegment.TYPE_CODE_CONFORMING
		if ((((type & conformingCode) != conformingCode) && ((proc.getCPL() > dpl) || (rpl > dpl))) || !valid[type])
			proc.setZeroFlag(false)
			return original

		if ((selector & 0x4) != 0) # ldtr or gtdr
			lowsize = proc.readSupervisorWord(proc.ldtr, offset)
		else
			lowsize = proc.readSupervisorWord(proc.gdtr, offset)

		size = (segmentDescriptor & 0xf0000) | (lowsize & 0xFFFF)

		if ((segmentDescriptor & 0x800000) != 0) # granularity ==1
			size = (size << 12) | 0xFFF

		proc.setZeroFlag(true)
		return size

	lldt: (selector) ->
		selector &= 0xffff

		if (selector == 0)
			return NULL_SEGMENT

		newSegment = proc.getSegment(selector & ~0x4)
		if (newSegment.getType() != 0x02)
			throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, selector, true)

		if (!(newSegment.isPresent()))
			throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, selector, true)

		return newSegment

	ltr: (selector) ->
		if ((selector & 0x4) != 0) #must be gdtr table
			throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, selector, true)

		tempSegment = proc.getSegment(selector)

		if ((tempSegment.getType() != 0x01) && (tempSegment.getType() != 0x09))
			throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, selector, true)

		if (!(tempSegment.isPresent()))
			throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, selector, true)

		descriptor = proc.readSupervisorQuadWord(proc.gdtr, (selector & 0xfff8)) | (0x1 << 41) # set busy flag in segment descriptor
		proc.setSupervisorQuadWord(proc.gdtr, selector & 0xfff8, descriptor)

		#reload segment
		return proc.getSegment(selector)

	cpuid: ->
		switch (proc.eax)
			when 0x00
				proc.eax = 0x02
				proc.ebx = 0x756e6547 # "Genu", with G in the low nibble of BL
				proc.edx = 0x49656e69 # "ineI", with i in the low nibble of DL
				proc.ecx = 0x6c65746e # "ntel", with n in the low nibble of CL
			when 0x01
				proc.eax = 0x00000633 # Pentium II Model 8 Stepping 3
				proc.ebx = 8 << 8 #not implemented (should be brand index)
				proc.ecx = 0

				int features = 0
	#			features |= 0x01 #Have an FPU;
				features |= (1<< 8)  # Support CMPXCHG8B instruction
				features |= (1<< 4)  # implement TSC
				features |= (1<< 5)  # support RDMSR/WRMSR
				#features |= (1<<23)  # support MMX
				#features |= (1<<24)  # Implement FSAVE/FXRSTOR instructions.
				features |= (1<<15)  # Implement CMOV instructions.
				#features |= (1<< 9)   # APIC on chip
				#features |= (1<<25)  # support SSE
				features |= (1<< 3)  # Support Page-Size Extension (4M pages)
				features |= (1<<13)  # Support Global pages.
				#features |= (1<< 6)  # Support PAE.
				features |= (1<<11) # SYSENTER/SYSEXIT
				proc.edx = features
			else
				proc.eax = 0x410601
				proc.ebx = 0
				proc.ecx = 0
				proc.edx = 0


	rdtsc: ->

		if ((proc.getCPL() == 0) || ((proc.getCR4() & 0x4) == 0))
			return proc.getClockCount()
		else
			throw ProcessorException.GENERAL_PROTECTION_0

	adc_o32_flags: (result, operand1, operand2) ->
		carry = (proc.getCarryFlag() ? 1 : 0)
		result = (0xffffffff & operand1) + (0xffffffff & operand2) + carry

		if (proc.getCarryFlag() && (operand2 == 0xffffffff))
			arithmetic_flags_o32(result, operand1, operand2)
			proc.setOverflowFlag(false)
			proc.setCarryFlag(true)
		else
			proc.setOverflowFlag(int(result), operand1, operand2, proc.OF_ADD_INT)
			arithmetic_flags_o32(result, operand1, operand2)

	adc_o16_flags: (result, operand1, operand2) ->
		if (proc.getCarryFlag() && (operand2 == 0xffff))
			arithmetic_flags_o16(result, operand1, operand2)
			proc.setOverflowFlag(false)
			proc.setCarryFlag(true)
		else
			proc.setOverflowFlag(result, operand1, operand2, proc.OF_ADD_SHORT)
			arithmetic_flags_o16(result, operand1, operand2)

	adc_o8_flags: (result, operand1, operand2) ->
		if (proc.getCarryFlag() && (operand2 == 0xff))
			arithmetic_flags_o8(result, operand1, operand2)
			proc.setOverflowFlag(false)
			proc.setCarryFlag(true)
		else
			proc.setOverflowFlag(result, operand1, operand2, proc.OF_ADD_BYTE)
			arithmetic_flags_o8(result, operand1, operand2)

	dec_flags: (result, type = "") ->
		if (type == "")
			throw new IllegalStateException("Execute Failed")

		proc.setZeroFlag(result)
		proc.setParityFlag(result)
		proc.setSignFlag(result)

		if (type == "short")
			proc.setOverflowFlag(result, proc.OF_MAX_SHORT);
		else if (type == "byte")
			proc.setOverflowFlag(result, proc.OF_MAX_BYTE);
		else if (type == "int")
			proc.setOverflowFlag(result, proc.OF_MAX_INT);

		proc.setAuxiliaryCarryFlag(result, proc.AC_LNIBBLE_MAX);

	inc_flags: (result, type = "") ->
		if (type == "")
			throw new IllegalStateException("Execute Failed")

		proc.setZeroFlag(result)
		proc.setParityFlag(result)
		proc.setSignFlag(result)

		if (type == "short")
			proc.setOverflowFlag(result, proc.OF_MIN_SHORT)
		else if (type == "byte")
			proc.setOverflowFlag(result, proc.OF_MIN_BYTE)
		else if (type == "int")
			proc.setOverflowFlag(result, proc.OF_MIN_INT)
		proc.setAuxiliaryCarryFlag(result, proc.AC_LNIBBLE_ZERO)

	shl_flags: (result, initial, count, type = "") ->
		if (count > 0)
			if (type == "")
				throw new IllegalStateException("Execute Failed")
			else if (type == "byte")
				initial = byte(initial)
				result = byte(result)
				proc.setCarryFlag(initial, count, proc.CY_SHL_OUTBIT_BYTE)
			else if (type == "short")
				initial = short(initial)
				result = short(result)
				proc.setCarryFlag(initial, count, proc.CY_SHL_OUTBIT_SHORT)
			else if (type == "int")
				proc.setCarryFlag(initial, count, proc.CY_SHL_OUTBIT_INT)

			if (count == 1)
				proc.setOverflowFlag(result, proc.OF_BIT7_XOR_CARRY)

			proc.setZeroFlag(result)
			proc.setParityFlag(result)
			proc.setSignFlag(result)

	sar_flags: (result, initial, count, type = "") ->
		if (count > 0)
			if (type == "")
				throw new IllegalStateException("Execute Failed")
			else if (type == "byte")
				initial = byte(initial)
				result = byte(result)
			else if (type == "short")
				initial = short(initial)
				result = short(result)

			proc.setCarryFlag(initial, count, proc.CY_SHR_OUTBIT)

			if (count == 1)
				proc.setOverflowFlag(false)

			proc.setZeroFlag(result)
			proc.setParityFlag(result)
			proc.setSignFlag(result)

	rol_flags: (result, count, type = "") ->
		if (type == "")
			throw new IllegalStateException("Execute Failed")
		else if (type == "byte")
			result = byte(result)
		else if (type == "short")
			result = short(result)
		if (count > 0)
			proc.setCarryFlag(result, proc.CY_LOWBIT)
			if (count == 1)
				proc.setOverflowFlag(result, proc.OF_BIT7_XOR_CARRY)

	ror_flags: (result, count, type = "") ->
		if (count > 0)
			if (type == "")
				throw new IllegalStateException("Execute Failed")
			else if (type == "byte")
				result = byte(result)
				proc.setCarryFlag(result, proc.CY_HIGHBIT_BYTE)
			else if (type == "short")
				result = short(result)
				proc.setCarryFlag(result, proc.CY_HIGHBIT_SHORT)
			else if (type == "int")
				proc.setCarryFlag(result, proc.CY_HIGHBIT_INT)

			proc.setCarryFlag(result, proc.CY_LOWBIT)

			if (count == 1)
				proc.setOverflowFlag(result, proc.OF_BIT6_XOR_CARRY)

	rcl_o8_flags: (result, count) ->
		if (count > 0)
			proc.setCarryFlag(byte(result), proc.CY_OFFENDBIT_BYTE)
			if (count == 1)
				proc.setOverflowFlag(byte(result), proc.OF_BIT7_XOR_CARRY)

	rcl_o16_flags: (result, count) ->
		if (count > 0)
			proc.setCarryFlag(short(result), proc.CY_OFFENDBIT_SHORT)
			if (count == 1)
				proc.setOverflowFlag(short(result), proc.OF_BIT15_XOR_CARRY)

	rcl_o32_flags: (result, count) ->
		if (count > 0)
			proc.setCarryFlag(int(result), proc.CY_OFFENDBIT_INT)
			if (count == 1)
				proc.setOverflowFlag(int(result), proc.OF_BIT31_XOR_CARRY)

	rcr_o8_flags: (result, count, overflow) ->
		if (count > 0)
			proc.setCarryFlag(result, proc.CY_OFFENDBIT_BYTE)
			if (count == 1)
				proc.setOverflowFlag(overflow > 0)

	rcr_o16_flags: (result, count, overflow) ->
		if (count > 0)
			proc.setCarryFlag(result, proc.CY_OFFENDBIT_SHORT)
			if (count == 1)
				proc.setOverflowFlag(overflow > 0)

	rcr_o32_flags: (result, count, overflow) ->
		if (count > 0)
			proc.setCarryFlag(result, proc.CY_OFFENDBIT_INT)
			if (count == 1)
				proc.setOverflowFlag(overflow > 0)

	neg_flags: (result, type = "") ->
		proc.setCarryFlag(result, proc.CY_NZ)

		if (type == "")
			throw new IllegalStateException("Execute Failed")
		else if (type == "short")
			result = short(result)
			proc.setOverflowFlag(result, proc.OF_MIN_SHORT)
		else if (type == "int")
			result = int(result)
			proc.setOverflowFlag(result, proc.OF_MIN_INT)
		else if (type == "byte")
			result = byte(result)
			proc.setOverflowFlag(result, proc.OF_MIN_BYTE)

		proc.setAuxiliaryCarryFlag(result, proc.AC_LNIBBLE_NZERO)
		proc.setZeroFlag(result)
		proc.setParityFlag(result)
		proc.setSignFlag(result)

	loadSegment: (selector) ->
		selector &= 0xffff
		if (selector < 0x4)
			return NULL_SEGMENT

		s = proc.getSegment(selector)
		if (!s.isPresent())
			throw new ProcessorException(ProcessorException.Type.NOT_PRESENT, 0xc, true)
		return s

	checkIOPermissionsByte: (ioportAddress) ->
		if (proc.getCPL() <= proc.eflagsIOPrivilegeLevel)
			return true

		ioPermMapBaseAddress = 0xffff & proc.tss.getWord(102)
		try
			ioPermMapByte = byte(proc.tss.getByte(ioPermMapBaseAddress + (ioportAddress >>> 3)))
			return (ioPermMapByte & (0x1 << (ioportAddress & 0x7))) == 0
		catch p
			if (p instanceof ProcessorException && p.getType() == Type.GENERAL_PROTECTION)
				return false
			throw p

	checkIOPermissionsShort: (ioportAddress) ->
		if (proc.getCPL() <= proc.eflagsIOPrivilegeLevel)
			return true

		ioPermMapBaseAddress = 0xffff & proc.tss.getWord(102)
		try
			ioPermMapShort = short(proc.tss.getWord(ioPermMapBaseAddress + (ioportAddress >>> 3)))
			return (ioPermMapShort & (0x3 << (ioportAddress & 0x7))) == 0
		catch p
			if (p instanceof ProcessorException && p.getType() == Type.GENERAL_PROTECTION)
				return false
			throw p

	checkIOPermissionsInt: (ioportAddress) ->
		if (proc.getCPL() <= proc.eflagsIOPrivilegeLevel)
			return true

		ioPermMapBaseAddress = 0xffff & proc.tss.getWord(102)
		try
			ioPermMapShort = short(proc.tss.getWord(ioPermMapBaseAddress + (ioportAddress >>> 3)))
			return (ioPermMapShort & (0xf << (ioportAddress & 0x7))) == 0
		catch p
			if (p instanceof ProcessorException && p.getType() == Type.GENERAL_PROTECTION)
				return false
			throw p

	###
	//borrowed from the j2se api as not in midp
	static int numberOfTrailingZeros(int i) {
	// HD, Figure 5-14
	int y;
	if (i == 0) return 32;
	int n = 31;
	y = i <<16; if (y != 0) { n = n -16; i = y; }
	y = i << 8; if (y != 0) { n = n - 8; i = y; }
	y = i << 4; if (y != 0) { n = n - 4; i = y; }
	y = i << 2; if (y != 0) { n = n - 2; i = y; }
	return n - ((i << 1) >>> 31);
	}

	static int numberOfLeadingZeros(int i) {
	// HD, Figure 5-6
	if (i == 0)
	    return 32;
	int n = 1;
	if (i >>> 16 == 0) { n += 16; i <<= 16; }
	if (i >>> 24 == 0) { n +=  8; i <<=  8; }
	if (i >>> 28 == 0) { n +=  4; i <<=  4; }
	if (i >>> 30 == 0) { n +=  2; i <<=  2; }
	n -= i >>> 31;
	return n;
	}

	static int reverseBytes(int i) {
	return ((i >>> 24)           ) |
	       ((i >>   8) &   0xFF00) |
	       ((i <<   8) & 0xFF0000) |
	       ((i << 24));
	}
	###
