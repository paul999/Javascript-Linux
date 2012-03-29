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

							proc.eip += @cumulativeX86Length[position - 1]
					when @UNDEFINED
						log "Unknown/undefined OPcode."
						throw ProcessorException.UNDEFINED

					when @MEM_RESET
						addr0 = 0
						seg0 = null

					when @LOAD1_AL
						reg1 = proc.eax

					when @ADD
						reg2 = reg0
						reg0 = reg2 + reg1

					when @LOAD0_MEM_BYTE
						reg0 = 0xff & seg0.getByte(addr0)

					when @STORE0_MEM_BYTE
						seg0.setByte(addr0, reg0)
					when @LOAD0_IW
						reg0 = @microcodes[position++]
					when @LOAD1_IW
						reg1 = @microcodes[position++]
					when @LOAD1_IB
						reg1 = @microcodes[position++]
					when @STORE0_SP
						proc.esp = (proc.esp) | (reg0 )

					when @LOAD0_MEM_WORD
						reg0 = seg0.getWord(addr0)
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
							@push_o16_a32(short(reg0))
						else
							@push_o16_a16(short(reg0))
					when @CALL_O16_A16, @CALL_O16_A32
						if proc.ss.getDefaultSizeFlag()
							@call_o16_a32(reg0)
						else
							@call_o16_a16(reg0)


					when @LOAD0_AX
						reg0 = proc.eax
					when @LOAD0_CX
						reg0 = proc.ecx
					when @LOAD0_DX
						reg0 = proc.edx
					when @LOAD0_BX
						reg0 = proc.ebx
					when @LOAD0_SP
						reg0 = proc.esp
					when @LOAD0_BP
						reg0 = proc.ebp
					when @LOAD0_SI
						reg0 = proc.esi
					when @LOAD0_DI
						reg0 = proc.edi
					when @LOAD1_AX
						 reg1 = proc.eax
					when @LOAD1_CX
						 reg1 = proc.ecx
					when @LOAD1_DX
						 reg1 = proc.edx
					when @LOAD1_BX
						 reg1 = proc.ebx
					when @LOAD1_SP
						 reg1 = proc.esp
					when @LOAD1_BP
						 reg1 = proc.ebp
					when @LOAD1_SI
						 reg1 = proc.esi
					when @LOAD1_DI
						 reg1 = proc.edi

					when @STORE0_AX
						proc.eax = (proc.eax) | (reg0)
					when @STORE0_CX
						proc.ecx = (proc.ecx) | (reg0)
					when @STORE0_DX
						proc.edx = (proc.edx) | (reg0)
					when @STORE0_BX
						proc.ebx = (proc.ebx) | (reg0)
					when @STORE0_SP
						proc.esp = (proc.esp) | (reg0)
					when @STORE0_BP
						proc.ebp = (proc.ebp) | (reg0)
					when @STORE0_SI
						proc.esi = (proc.esi) | (reg0)
					when @STORE0_DI
						proc.edi = (proc.edi) | (reg0)
					when @LOAD0_AL
						 reg0 = proc.eax
					when @LOAD0_CL
						 reg0 = proc.ecx
					when @LOAD0_DL
						 reg0 = proc.edx
					when @LOAD0_BL
						 reg0 = proc.ebx
					when @LOAD0_AH
						 reg0 = (proc.eax >> 8)
					when @LOAD0_CH
						 reg0 = (proc.ecx >> 8)
					when @LOAD0_DH
						 reg0 = (proc.edx >> 8)
					when @LOAD0_BH
						 reg0 = (proc.ebx >> 8)

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

					when @LOAD0_IB
						reg0 = @microcodes[position++]
					when @LOAD0_IW
						reg0 = @microcodes[position++]
					when @LOAD0_ID
						reg0 = @microcodes[position++]

					when @STORE0_AL
						proc.eax = (proc.eax) | (reg0)
					when @STORE0_CL
						proc.ecx = (proc.ecx) | (reg0)
					when @STORE0_DL
						proc.edx = (proc.edx) | (reg0 )
					when @STORE0_BL
						proc.ebx = (proc.ebx) | (reg0)
					when @STORE0_AH
						proc.eax = (proc.eax) | ((reg0 << 8))
					when @STORE0_CH
						proc.ecx = (proc.ecx) | ((reg0 << 8))
					when @STORE0_DH
						proc.edx = (proc.edx) | ((reg0 << 8))
					when @STORE0_BH
						proc.ebx = (proc.ebx) | ((reg0 << 8))

					when @STORE1_AX
						proc.eax = (proc.eax) | (reg1)
					when @STORE1_CX
						proc.ecx = (proc.ecx) | (reg1)
					when @STORE1_DX
						proc.edx = (proc.edx) | (reg1)
					when @STORE1_BX
						proc.ebx = (proc.ebx) | (reg1)
					when @STORE1_SP
						proc.esp = (proc.esp) | (reg1)
					when @STORE1_BP
						proc.ebp = (proc.ebp) | (reg1)
					when @STORE1_SI
						proc.esi = (proc.esi) | (reg1)
					when @STORE1_DI
						proc.edi = (proc.edi) | (reg1)

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
						reg1 = proc.eax
					when @LOAD1_CL
						reg1 = proc.ecx
					when @LOAD1_DL
						reg1 = proc.edx
					when @LOAD1_BL
						reg1 = proc.ebx
					when @LOAD1_AH
						reg1 = (proc.eax >> 8)
					when @LOAD1_CH
						reg1 = (proc.ecx >> 8)
					when @LOAD1_DH
						reg1 = (proc.edx >> 8)
					when @LOAD1_BH
						reg1 = (proc.ebx >> 8)

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

					when @LOAD0_ES
						reg0 = proc.es.getSelector()
					when @LOAD0_CS
						reg0 = proc.cs.getSelector()
					when @LOAD0_SS
						reg0 = proc.ss.getSelector()
					when @LOAD0_DS
						reg0 = proc.ds.getSelector()
					when @LOAD0_FS
						reg0 = proc.fs.getSelector()
					when @LOAD0_GS
						reg0 = proc.gs.getSelector()

					when @STORE1_MEM_BYTE
						seg0.setByte(addr0, reg1)

					when @LOAD1_MEM_BYTE
						reg1 = seg0.getByte(addr0)
					when @LOAD0_MEM_DWORD
						reg0 = seg0.getDoubleWord(addr0)

					when @ADDR_IB #Wrong call?
						addr0 += byte(@microcodes[position++])
					when @ADDR_ID
						addr0 += @microcodes[position++]
					when @LGDT_O16
						proc.gdtr = proc.createDescriptorTableSegment(reg1 & 0x00ffffff, reg0)

					when @LOOP_CX
						@loop_cx(reg0)
					when @STORE0_ES
						proc.es = @loadSegment(reg0)

					when @STORE0_DS
						proc.ds = @loadSegment(reg0)
					when @STORE0_FS
						proc.fs = @loadSegment(reg0)
					when @STORE0_GS
						proc.gs = @loadSegment(reg0)

					when @INC
						reg0++
					when @DEC
						reg0--
					when @LODSB_A16
						@lodsb_a16(seg0)
					when @STC
						proc.setCarryFlagBool(true)

					when @CMPXCHG_O8_FLAGS
						@sub_o8_flags(reg2 - reg1, reg2, reg1)
					when @CMPXCHG_O16_FLAGS
						@sub_o16_flags(reg2 - reg1, reg2, reg1)
					when @CMPXCHG_O32_FLAGS
						@sub_o32_flags((0xffffffff & reg2) - (0xffffffff & reg1), reg2, reg1)

					when @BITWISE_FLAGS_O8
						@bitwise_flags(byte(reg0)) #byte
					when @BITWISE_FLAGS_O16
						@bitwise_flags(short(reg0)) #short
					when @BITWISE_FLAGS_O32
						@bitwise_flags(reg0)

					when @SUB_O8_FLAGS
						@sub_o8_flags(reg0, reg2, reg1) # check, byte? geen comment
					when @SUB_O16_FLAGS
						@sub_o16_flags(reg0, reg2, reg1)
					when @SUB_O32_FLAGS
						@sub_o32_flags(reg0l, reg2, reg1)

					when @ADD_O8_FLAGS
						@add_o8_flags(reg0, reg2, reg1) #check, byte? Geen commment
					when @ADD_O16_FLAGS
						@add_o16_flags(reg0, reg2, reg1)
					when @ADD_O32_FLAGS
						@add_o32_flags(reg0l, reg2, reg1)

					when @ADC_O8_FLAGS
						@adc_o8_flags(reg0, reg2, reg1) #check, byte? Geen comment
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
						@inc_flags_byte(byte(reg0)) #byte
					when @INC_O16_FLAGS
						@inc_flags_short(short(reg0)) #short
					when @INC_O32_FLAGS
						@inc_flags_int(reg0)

					when @DEC_O8_FLAGS
						@dec_flags(byte(reg0)) #byte
					when @DEC_O16_FLAGS
						@dec_flags(short(reg0)) #short
					when @DEC_O32_FLAGS
						@dec_flags(reg0)

					when @SHL_O8_FLAGS
						@shl_flags_byte(byte(reg0), byte(reg2), reg1) #byte, byte
					when @SHL_O16_FLAGS
						@shl_flags_short(short(reg0), short(reg2), reg1) #short, short
					when @SHL_O32_FLAGS
						@shl_flags_int(reg0, reg2, reg1)

					when @SHR_O8_FLAGS
						@shr_flags(byte(reg0), reg2, reg1) #byte
					when @SHR_O16_FLAGS
						@shr_flags(short(reg0), reg2, reg1) #short
					when @SHR_O32_FLAGS
						@shr_flags(reg0, reg2, reg1)

					when @SAR_O8_FLAGS
						@sar_flags(byte(reg0), byte(reg2), reg1) #byte, byte
					when @SAR_O16_FLAGS
						@sar_flags(short(reg0), short(reg2), reg1) #short, short
					when @SAR_O32_FLAGS
						@sar_flags(reg0, reg2, reg1)

					when @SHL
						reg2 = reg0
						reg0 <<= reg1
					when @SHR
						reg2 = reg0
						reg0 >>>= reg1
					when @SAR_O8
						reg2 = reg0
						reg0 = (byte(reg0)) >> reg1 #byte
					when @SAR_O16
						reg2 = reg0
						reg0 = (short(reg0)) >> reg1 #short
					when @SAR_O32
						reg2 = reg0
						reg0 >>= reg1

					when @RCL_O8_FLAGS
						@rcl_o8_flags(reg0, reg1) # Check byte? Geen commentaar
					when @RCL_O16_FLAGS
						@rcl_o16_flags(reg0, reg1)
					when @RCL_O32_FLAGS
						@rcl_o32_flags(reg0l, reg1)

					when @RCR_O8_FLAGS
						@rcr_o8_flags(reg0, reg1, reg2) #check byte? Geen commentaar
					when @RCR_O16_FLAGS
						@rcr_o16_flags(reg0, reg1, reg2)
					when @RCR_O32_FLAGS
						@rcr_o32_flags(reg0l, reg1, reg2)

					when @ROL_O8_FLAGS
						@rol_flags_byte(byte(reg0), reg1)#byte
					when @ROL_O16_FLAGS
						@rol_flags_short(short(reg0), reg1) #short
					when @ROL_O32_FLAGS
						@rol_flags_int(reg0, reg1)

					when @ROR_O8_FLAGS
						@ror_flags(byte(reg0), reg1) #byte
					when @ROR_O16_FLAGS
						@ror_flags(short(reg0), reg1) #short
					when @ROR_O32_FLAGS
						@ror_flags(reg0, reg1)

					when @NEG_O8_FLAGS
						@neg_flags(byte(reg0)) #byte
					when @NEG_O16_FLAGS
						@neg_flags(short(reg0)) #short
					when @NEG_O32_FLAGS
						@neg_flags(reg0)
					when @LOAD0_ADDR
						reg0 = addr0

					when @ADDR_IB
						addr0 += byte((@microcodes[position++])) #byte
					when @ADDR_IW
						addr0 += short(@microcodes[position++]) #short
					when @ADDR_ID
						addr0 += @microcodes[position++]

					when @STORE0_MEM_BYTE
						# controle welke byte?
						seg0.setByte(addr0, byte(reg0)) #byte
					when @STORE0_MEM_WORD
						seg0.setWord(addr0, short(reg0)) #short
					when @STORE0_MEM_DWORD
						seg0.setDoubleWord(addr0, reg0)
					when @STORE0_MEM_QWORD
						seg0.setQuadWord(addr0, reg0) #long



					when @JO_O8
						@jo_o8(byte(reg0)) #byte
					when @JNO_O
						@jno_o8(byte(reg0)) #byte
					when @JC_O8
						@jc_o8(byte(reg0)) #byte
					when @JNC_O
						@jnc_o8(byte(reg0)) #byte
					when @JZ_O8
						@jz_o8(byte(reg0)) #byte
					when @JNZ_O8
						@jnz_o8(byte(reg0)) #byte
					when @JNA_O8
						@jna_o8(byte(reg0)) #byte
					when @JA_O8
						@ja_o8(byte(reg0)) #byte
					when @JS_O8
						@js_o8(byte(reg0)) #byte
					when @JNS_O8
						@jns_o8(byte(reg0)) #byte
					when @JP_O8
						@jp_o8(byte(reg0)) #byte
					when @JNP_O8
						@jnp_o8(byte(reg0)) #byte
					when @JL_O8
						@jl_o8(byte(reg0)) #byte
					when @JNL_O8
						@jnl_o8(byte(reg0)) #byte
					when @JNG_O8
						@jng_o8(byte(reg0)) #byte
					when @JG_O8
						@jg_o8(byte(reg0)) #byte

					when @JO_O16
						@jo_o16(short(reg0)) #short
					when @JNO_O16
						@jno_o16(short(reg0)) #short
					when @JC_O16
						@jc_o16(short(reg0)) #short
					when @JNC_O16
						@jnc_o16(short(reg0)) #short
					when @JZ_O16
						@jz_o16(short(reg0)) #short
					when @JNZ_O16
						@jnz_o16(short(reg0)) #short
					when @JNA_O16
						@jna_o16(short(reg0)) #short
					when @JA_O16
						@ja_o16(short(reg0)) #short
					when @JS_O16
						@js_o16(short(reg0)) #short
					when @JNS_O16
						@jns_o16(short(reg0)) #short
					when @JP_O16
						@jp_o16(short(reg0)) #short
					when @JNP_O16
						@jnp_o16(short(reg0)) #short
					when @JL_O16
						@jl_o16(short(reg0)) #short
					when @JNL_O16
						@jnl_o16(short(reg0)) #short
					when @JNG_O16
						@jng_o16(short(reg0)) #short
					when @JG_O16
						@jg_o16(short(reg0)) #short

					when @JO_O32
						@jo_o32(reg0)
					when @JNO_O3
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
					when @JNP_O3
						@jnp_o32(reg0)
					when @JL_O32
						@jl_o32(reg0)
					when @JNL_O32
						@jnl_o32(reg0)
					when @JNG_O32
						@jng_o32(reg0)
					when @JG_O32
						@jg_o32(reg0)

					when @JUMP_O8
						@jump_o8(byte(reg0))#byte
					when @JUMP_O16
						@jump_o16(short(reg0))#short
					when @JUMP_O32
						jump_o32(reg0)

					when @LOOP_CX
						@loop_cx(reg0)
					when @LOOP_ECX
						@loop_ecx(reg0)
					when @LOOPZ_CX
						@loopz_cx(reg0)
					when @LOOPZ_ECX
						@loopz_ecx(reg0)
					when @LOOPNZ_CX
						@loopnz_cx(reg0)
					when @LOOPNZ_ECX
						@loopnz_ecx(reg0)

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
					when @CLD
						proc.eflagsDirection = false
					when @STD
						proc.eflagsDirection = true
					when @CMC
						proc.setCarryFlagBool(!proc.getCarryFlag())
					when @CLC
						proc.setCarryFlagBool(false)

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

					when @POP_O16_A16, @POP_O16_A32
						if (proc.ss.getDefaultSizeFlag())
							reg1 = proc.esp + 2

							if @microcodes[position] == @STORE0_SS
								proc.eflagsInterruptEnable = false
							reg0 = proc.ss.getWord(proc.esp)
						else
							reg1 = proc.esp | (proc.esp + 2)
							if (@microcodes[position] == @STORE0_SS)
								@proc.eflagsInterruptEnable = false
							reg0 = proc.ss.getWord(proc.esp)
					when @ROL_O8
						reg2 = reg1 & 0x7
						reg0 = (reg0 << reg2) | (reg0 >>> (8 - reg2))
					when @ROL_O16
						reg2 = reg1 & 0xf
						reg0 = (reg0 << reg2) | (reg0 >>> (16 - reg2))
					when @ROL_O32
						reg1 &= 0x1f
						reg0 = (reg0 << reg1) | (reg0 >>> (32 - reg1))

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
					when @RET_O16_A32, @RET_O16_A16
						if (proc.ss.getDefaultSizeFlag())
							@ret_o16_a32()
						else
							@ret_o16_a16()
					when @STI
						if (proc.getIOPrivilegeLevel() >= proc.getCPL())
							proc.eflagsInterruptEnable = true;
							proc.eflagsInterruptEnableSoon = true;
						else
							if ((proc.getIOPrivilegeLevel() < proc.getCPL()) && (proc.getCPL() == 3) && ((proc.getEFlags() & (1 << 20)) == 0))
								proc.eflagsInterruptEnableSoon = true;
							else
								throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, 0, true)
					when @CLI
						if (proc.getIOPrivilegeLevel() >= proc.getCPL())
							proc.eflagsInterruptEnable = false
							proc.eflagsInterruptEnableSoon = false
						else
							if ((proc.getIOPrivilegeLevel() < proc.getCPL()) && (proc.getCPL() == 3) && ((proc.getCR4() & 1) != 0))
								proc.eflagsInterruptEnableSoon = false
							else
								log "IOPL: " + proc.getIOPrivilegeLevel() + " CPL: " + proc.getCPL()
								throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, 0, true)
					when @IDIV_O8
						@idiv_o8(getByte(reg0)) #byte
					when @IDIV_O16
						@idiv_o16(short(reg0)) #short
					when @IDIV_O32
						@idiv_o32(reg0)
					when @JUMP_ABS_O16
						@jump_abs(reg0)

					else
						throw "File: ProtectedModeUBlock: Not added microcode yet? #{@microcodes[position - 1]}"

		catch e
			throw e

		return @executeCount



	push_o16_a16: (value) ->
		if (((0xffff & proc.esp) < 2) && ((0xfff & proc.esp) > 0))
			throw ProcessorException.STACK_SEGMENT_0

		proc.ss.setWord(((0xfff & proc.esp) - 2) & 0xfff, value)
		proc.esp = (proc.esp &~0xffff) | ((proc.esp - 2) & 0xffff)

	call_o16_a32: (target) ->
		tempEIP = (proc.eip + target)
		proc.cs.checkAddress(tempEIP)

		if ((proc.esp < 2) && (proc.esp > 0))
			throw ProcessorException.STACK_SEGMENT_0

		proc.ss.setWord(proc.esp - 2, short(proc.eip))
		proc.esp -= 2

		log "call_o16_a32: EIP update: old EIP: #{proc.eip} offset: #{target} new EIP: #{tempEIP}"
		proc.eip = tempEIP
	call_o16_a16: (target) ->
		tempEIP = proc.eip + target

		proc.cs.checkAddress(tempEIP)

		if (proc.esp < 2)
			throw ProcessorException.STACK_SEGMENT_0

		proc.ss.setWord((proc.esp - 2), short(proc.eip))
		proc.esp = (proc.esp) | (proc.esp - 2)

		log "call_o16_a16: EIP update: old EIP: #{proc.eip} offset: #{target} new EIP: #{tempEIP}"

		proc.eip = tempEIP

	jg_o8: (offset) ->
		if ((!proc.getZeroFlag()) && (proc.getSignFlag() == proc.getOverFlowFlag()))
			@jump_o8(offset)

	loop_cx: (offset) ->
		proc_ecx = (proc.ecx) | (((proc.ecx)-1))
		if ((proc.ecx) != 0)
			@jump_o8(offset)
	jump_o8: (offset) ->
		if (offset == 0)
			return

		tempEIP = proc.eip + offset
#		proc.cs.checkAddress(tempEIP) #results in errors...

		log "jump_o8: EIP update: old EIP: #{proc.eip} offset: #{offset} new EIP: #{tempEIP}"

		proc.eip = tempEIP
	jump_o16: (offset) ->
		tempEIP = (proc.eip + offset)
		proc.cs.checkAddress(tempEIP)

		log "jump_o16: EIP update: old EIP: #{proc.eip} offset: #{offset} new EIP: #{tempEIP}"

		proc.eip = tempEIP

	lodsb_a16: (segMent) ->
		addr = proc.esi
		proc.eax = (proc.eax) | (segMent.getByte(addr))
		if (proc.eFlagsDirection)
			addr -= 1
		else
			addr += 1

		proc.esi = (proc.esi) | (addr)

	loadSegment: (selector) ->
#		selector &= 0xffff

		if (selector < 0x4)
			return sgm.NULL_SEGMENT

		s = proc.getSegment(selector)

		if (!s.isPresent())
			throw new ProcessorException(ProcessorException.Type.NOT_PRESENT, 0xc, true)
		return s

	bitwise_flags: (result) ->
		proc.setOverflowFlagBool(false)
		proc.setCarryFlagBool(false)
		proc.setZeroFlagBool(result)
		proc.setParityFlagBool(result)
		proc.setSignFlagBool(result)

	arithmetic_flags_o8: (result, operand1, operand2) ->
		proc.setZeroFlagBool(result)
		proc.setParityFlagBool(result)
		proc.setSignFlagBool(result)

		proc.setCarryFlag1(result, proc.CY_TWIDDLE_FF)
		proc.setAuxiliaryCarryFlag3(operand1, operand2, result, proc.AC_XOR)


	arithmetic_flags_o16: (result, operand1, operand2) ->
		proc.setZeroFlagBool(short(result))
		proc.setParityFlagBool(result)
		proc.setSignFlagBool(short(result))

		proc.setCarryFlag1(result, proc.CY_TWIDDLE_FFFF)
		proc.setAuxiliaryCarryFlag3(operand1, operand2, result, proc.AC_XOR)

	arithmetic_flags_o32: (result, operand1, operand2) ->
		proc.setZeroFlagBool(result)
		proc.setParityFlagBool(result)
		proc.setSignFlagBool(result)

		proc.setCarryFlag1(result, proc.CY_TWIDDLE_FFFFFFFF)
		proc.setAuxiliaryCarryFlag3(operand1, operand2, result, proc.AC_XOR)

	add_o32_flags: (result, operand1, operand2) ->
		result = (0xffffffff & operand1) + (0xffffffff & operand2)

		@arithmetic_flags_o32(result, operand1, operand2)
		proc.setOverflowFlag3(result, operand1, operand2, proc.OF_ADD_INT)

	add_o16_flags: (result, operand1, operand2) ->
		@arithmetic_flags_o16(result, operand1, operand2)
		proc.setOverflowFlag3(result, operand1, operand2, proc.OF_ADD_SHORT)

	add_o8_flags: (result, operand1, operand2) ->
		@arithmetic_flags_o8(result, operand1, operand2)
		proc.setOverflowFlag3(result, operand1, operand2, proc.OF_ADD_BYTE)

	adc_o32_flags: (result, operand1, operand2) ->
		carry = proc.getCarryFlag() ? 1 : 0

		result = (0xffffffff & operand1) + (0xffffffff & operand2) + carry

		if proc.getCarryFlag() && operand2 == 0xffffffff
			@arithmetic_flags_o32(result, operand1, operand2)
			proc.setOverflowFlagBool(false)
			proc.setCarryFlagBool(true)
		else
			proc.setOverFlowFlag3(result, operand1, operand2, proc.OF_ADD_INT)
			@arithmetic_flags_o32(result, operand1, operand2)


	adc_o16_flags: (result, operand1, operand2) ->
		if (proc.getCarryFlag() && operand2 == 0xffff)
			@arithmetic_flags_o16(result, operand1, operand2)
			proc.setOverflowFlag(false)
			proc.setCarryFlagBool(true)
		else
			proc.setOverflowFlag3(result, operand1, operand2, proc.OF_ADD_SHORT)
			@arithmetic_flags_o16(result, operand1, operand2)

	adc_o8_flags: (result, operand1, operand2) ->
		if (proc.getCarryFlag() && operand2 == 0xff)
			@arithmetic_flags_o8(result, operand1, operand2)
			proc.setOverflowFlagBook(false)
			proc.setCarryFlagBool(true)
		else
			proc.setOverflowFlag3(result, operand1, operand2, proc.OF_ADD_BYTE)
			@arithmetic_flags_o8(result, operand1, operand2)

	sub_o32_flags: (result, operand1, operand2) ->
		result = (0xffffffff & operand1) - (0xffffffff & operand2)

		@arithmetic_flags_o32(result, operand1, operand2)
		proc.setOverflowFlag3(result, operand1, operand2, proc.OF_SUB_INT)

	sub_o16_flags: (result, operand1, operand2) ->
		@arithmetic_flags_o16(result, operand1, operand2)
		proc.setOverflowFlag3(result, operand1, operand2, proc.OF_SUB_SHORT)

	sub_o8_flags: (result, operand1, operand2) ->
		@arithmetic_flags_o8(result, operand1, operand2)
		proc.setOverflowFlag3(result, operand1, operand2, proc.OF_SUB_BYTE)

	sbb_o32_flags: (result, operand1, operand2) ->
		carry = (proc.getCarryFlag() ? 1 : 0)

		result = (0xffffffff & operand1) - ((0xffffffff & operand2) + carry)

		proc.setOverflowFlag3(result, operand1, operand2, proc.OF_SUB_INT)
		@arithmetic_flags_o32(result, operand1, operand2)

	sbb_o16_flags: (result, operand1, operand2) ->
		proc.setOverflowFlag3(result, operand1, operand2, proc.OF_SUB_SHORT)
		@arithmetic_flags_o16(result, operand1, operand2)

	sbb_o8_flags: (result, operand1, operand2) ->
		proc.setOverflowFlag3(result, operand1, operand2, proc.OF_SUB_BYTE)
		@arithmetic_flags_o8(result, operand1, operand2)

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

	sar_flags: (result, initial, count) ->
		if (count > 0)
			proc.setCarryFlag2(initial, count, proc.CY_SHR_OUTBIT)

			if (count == 1)
				proc.setOverflowFlagBool(false)

			proc.setSignFlagBool(result)
			proc.setZeroFlagBool(result)
			proc.setParityFlagBool(result)

	shr_flags: (result, initial, count) ->

		if (count > 0)
			proc.setCarryFlag2(initial, count, proc.CY_SHR_OUTBIT);

			if (count == 1)
				proc.setOverflowFlag2(result, initial, proc.OF_BIT7_DIFFERENT)

			proc.setZeroFlagBool(result)
			proc.setParityFlagBool(result)
			proc.setSignFlagBool(result)

	loop_cx: (offset) ->
		proc.ecx= (proc.ecx) | (((proc.ecx)-1))
		if ((proc.ecx) != 0)
			@jump_o8(offset)

	loop_ecx: (offset) ->
		proc.ecx--
		if (proc.ecx != 0)
			@jump_o8(offset)

	loopz_cx: (offset) ->
		proc.ecx = (proc.ecx) | ((proc.ecx - 1))
		if (proc.getZeroFlag() && ((proc.ecx) != 0))
			@jump_o8(offset)

	loopz_ecx: (offset) ->
		proc.ecx--
		if (proc.getZeroFlag() && (proc.ecx != 0))
			@jump_o8(offset)

	loopnz_cx: (offset) ->
		proc.ecx= (proc.ecx) | ((proc.ecx-1))
		if (!proc.getZeroFlag() && ((proc.ecx) != 0))
			@jump_o8(offset)

	loopnz_ecx: (offset) ->
		proc.ecx--
		if (!proc.getZeroFlag() && (proc.ecx != 0))
			@jump_o8(offset)

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

	aam: (base) ->
		tl = proc.eax
		if (base == 0)
			throw ProcessorException.DIVIDE_ERROR
		ah = (tl / base)
		al = (tl % base)
		proc.eax |= (al | (ah << 8))

		proc.setAuxiliaryCarryFlagBool(false)
		@bitwise_flags(al)

	# Volgende methode zijn bij omzetten allemaal zelfde geworden, wat niet klopt.
	stosb_a16: (data) ->
		addr = proc.edi
		proc.es.setByte(addr, data) #byte

		if (proc.eflagsDirection)
			addr -= 1
		else
			addr += 1

		proc.edi = (proc.edi) | (addr) #todo, bitwise operator hier nodig?

	stosb_a32: (data) ->
		addr = proc.edi
		proc.es.setByte(addr, data) #byte

		if (proc.eflagsDirection)
			addr -= 1
		else
			addr += 1

		proc.edi = addr

	stosw_a16: (data) ->
		addr = proc.edi
		proc.es.setWord(addr, short(data)) #short

		if (proc.eflagsDirection)
			addr -= 2
		else
			addr += 2

		proc.edi = (proc.edi) | (addr) #bitwise?

	stosw_a32: (data) ->
		addr = proc.edi
		proc.es.setWord(addr, short(data)) #short

		if (proc.eflagsDirection)
			addr -= 2
		else
			addr += 2

		proc.edi = addr

	stosd_a16: (data) ->
		addr = proc.edi #bitwise
		proc.es.setDoubleWord(addr, data)

		if (proc.eflagsDirection)
			addr -= 4
		else
			addr += 4

		proc.edi = (proc.edi) | (addr) #bitwise

	stosd_a32: (data) ->
		addr = proc.edi
		proc.es.setDoubleWord(addr, data)

		if (proc.eflagsDirection)
			addr -= 4
		else
			addr += 4

		proc.edi = addr

	rep_stosb_a16: (data) ->
		count = proc.ecx
		addr = proc.edi
		@executeCount += count

		if (proc.eflagsDirection)
			while (count != 0)
				proc.es.setByte(addr, data) #byte
				count--
				addr -= 1
		else
			while (count != 0)

				proc.es.setByte(addr, data) #byte
				count--
				addr += 1

		proc.ecx = (proc.ecx) | count
		proc.edi = (proc.edi) | addr

	rep_stosb_a32: (data) ->
		count = proc.ecx
		addr = proc.edi
		@executeCount += count

		if (proc.eflagsDirection)
			while (count != 0)
				proc.es.setByte(addr, data) #byte
				count--
				addr -= 1
		else
			while (count != 0)
				proc.es.setByte(addr, data) #byte
				count--
				addr += 1

		proc.ecx = count
		proc.edi = addr

	rep_stosw_a16: (data) ->
		count = 0xFFFF & proc.ecx
		addr = 0xFFFF & proc.edi
		@executeCount += count

		log "Count: #{count}, data: #{data}, addr: #{addr}, dir: #{proc.eflagsDirection}"

		if (proc.eflagsDirection)
			while (count != 0)
				log "count: #{count}, addr: #{addr}"
				proc.es.setWord(addr, short(data)) #short
				count--
				addr -= 2
		else
			while (count != 0)
				proc.es.setWord(addr, short(data)) #SHORT
				count--
				addr += 2

		proc.ecx = (proc.ecx & ~0xFFFF) | (0xFFFF & count)
		proc.edi = (proc.edi & ~0xFFFF) | (0xFFFF & addr)

	rep_stosw_a32: (data) ->
		count = proc.ecx
		addr = proc.edi
		@executeCount += count

		if (proc.eflagsDirection)
			while (count != 0)
				proc.es.setWord(addr, short(data)) #short
				count--
				addr -= 2
		else
			while (count != 0)
				proc.es.setWord(addr, short(data)) #short
				count--
				addr += 2

		proc.ecx = count
		proc.edi = addr

	rep_stosd_a16: (data) ->
		count = proc.ecx
		addr = proc.edi
		@executeCount += count

		if (proc.eflagsDirection)
			while (count != 0)
				proc.es.setDoubleWord(addr, data)
				count--
				addr -= 4
		else
			while (count != 0)
				proc.es.setDoubleWord(addr, data)
				count--
				addr += 4

		proc.ecx = (proc.ecx) | (count)
		proc.edi = (proc.edi) | (addr)

	rep_stosd_a32: (data) ->
		count = proc.ecx
		addr = proc.edi
		@executeCount += count

		if (proc.eflagsDirection)
			while (count != 0)
				proc.es.setDoubleWord(addr, data)
				count--
				addr -= 4
		else
			while (count != 0)
				proc.es.setDoubleWord(addr, data)
				count--
				addr += 4

		proc.ecx = count
		proc.edi = addr


	rep_movsw_a16: (segment) ->
		count = Math.abs(proc.ecx)
		inAddr = proc.edi
		outAddr = proc.esi
		@executeCount += count

		log "Count: #{count}, inAddr: #{inAddr}, outAddr: #{outAddr}, dir: #{proc.eflagsDirection}"

		if (proc.eflagsDirection)
			while (count != 0)
				proc.es.setWord(inAddr, segment.getWord(outAddr))
				count--
				outAddr -= 2
				inAddr -= 2
		else
			while (count != 0)
				proc.es.setWord(inAddr, segment.getWord(outAddr))
				count--
				outAddr += 2
				inAddr += 2
		proc.ecx = (proc.ecx) | (count)
		proc.edi = (proc.edi) | (inAddr)
		proc.esi = (proc.esi) | (outAddr)

	shl_flags_short: (result, inital, count) ->
		@_shl_flags(result, inital, count, proc.CY_SHL_OUTBIT_SHORT)

	shl_flags_byte: (result, inital, count) ->
		@_shl_flags(result, inital, count, proc.CY_SHL_OUTBIT_BYTE)

	shl_flags_int: (result, inital, count) ->
		@_shl_flags(result, inital, count, proc.CY_SHL_OUTBIT_INT)


	_shl_flags: (result, initial, count, type) ->
		if (count > 0)
			proc.setCarryFlag2(initial, count, type)

			if (count == 1)
				proc.setOverflowFlag1(result, proc.OF_BIT15_XOR_CARRY)

			proc.setZeroFlagBool(result)
			proc.setParityFlagBool(result)
			proc.setSignFlagBool(result)

	daa: ->
		al = proc.eax

		newCF

		if (((proc.eax & 0xf) > 0x9) || proc.getAuxiliaryCarryFlag())
			al += 6
			proc.setAuxiliaryCarryFlagBool(true)
		else
			proc.setAuxiliaryCarryFlagBool(false)

		if (((al) > 0x9f) || proc.getCarryFlag())
			al+= 0x60
			newCF = true
		else
			newCF = false

		proc.eax = (proc.eax) | al
		@bitwise_flags(al)
		proc.setCarryFlagBool(newCF)

	das: ->
		tempCF = false
		tempAL = proc.eax

		if (((tempAL & 0xf) > 0x9) || proc.getAuxiliaryCarryFlag())
			proc.setAuxiliaryCarryFlagBool(true)
			proc.eax = (proc.eax) | (proc.eax - 0x06) #bitwise
			tempCF = (tempAL < 0x06) || proc.getCarryFlag()

		if (tempAL > 0x99) || proc.getCarryFlag()
			proc.eax = proc.eax | (proc.eax - 0x60)
			tempCF = true

		@bitwise_flags(byte(proc.eax))
		proc.setCarryFlagBool(tempCF)

	_rol_flags: (result, count, type) ->
		if (count > 0)
			proc.setCarryFlag1(result, proc.CY_LOWBIT)

			if (count == 1)
				proc.setOverflowFlag1(result, type)

	rol_flags_int: (result, count) ->
		@_rol_flags(result, count, proc.OF_BIT31_XOR_CARRY)


	rol_flags_byte: (result, count) ->
		@_rol_flags(result, count, proc.OF_BIT7_XOR_CARRY)

	rol_flags_short: (result, count) ->
		@_rol_flags(result, count, proc.OF_BIT15_XOR_CARRY)
	ret_o16_a16: ->
		nw = proc.ss.getWord(proc.esp)

		log "EIP upd: old: #{proc.eip}, new: #{nw}"

		proc.eip = nw

		proc.esp = (proc.esp) | (proc.esp + 2)

	idiv_o8: (data) ->
		if (data == 0)
			throw ProcessorException.DEVIDE_ERROR

		temp = short(proc.eax)
		result = temp / data
		remainder = temp % data

#		if ((result > Byte.MAX_VALUE) || (result < Byte.MIN_VALUE))
#			throw ProcessorException.DIVIDE_ERROR;

		proc.eax = (proc.eax) | result | (remainder << 8) #check extra bitwise

	idiv_o16: (data) ->
		if (data == 0)
			throw ProcessorException.DIVIDE_ERROR

		temp = (proc.edx << 16) | proc.eax#bit
		result = temp / data
		remainder = temp % data

		proc.eax = (proc.eax) | result #bit (2 keer)
		proc.edx = proc.edx | remainder

	idiv_o32: (data) ->
		if (data == 0)
			throw ProcessorException.DIVIDE_ERROR

		temp = (proc.edx) << 32
		temp |= proc.eax
		result = temp / data
		remainder = temp % data

		proc.eax = result
		proc.edx = remainder

	jump_abs: (offset) ->
		proc.cs.checkAddress(offset);

		log "jump_abs EIP update: old EIP #{proc.eip} new EIP: #{offset}"

		proc.eip = offset
