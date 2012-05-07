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
# This program is free software you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2 as published by
# the Free Software Foundation.


class processor
	constructor: () ->
		log "Processor created"

		@STATE_VERSION = 1
		@STATE_MINOR_VERSION = 0

		@IPS = 50000000 #CPU speed
		@IFLAGS_HARDWARE_INTERRUPT = 0x1
		@IFLAGS_PROCESSOR_EXCEPTION = 0x2
		@IFLAGS_RESET_REQUEST = 0x4
		@IFLAGS_IOPL_MASK = 3 << 12

		@CR0_PROTECTION_ENABLE = 0x1
		@CR0_MONITOR_COPROCESS = 0x2
		@CR0_FPU_EMULATOR = 0x4 # We have no FPU?
		@CR0_TASK_SWITCHED = 0x8
		@CR0_NUMERIC_ERROR = 0x20
		@CR0_WRITE_PROTECT = 0x10000
		@CR0_ALIGNMENT_MASK = 0x40000
		@CR0_NOT_WRITETHROUGH = 0x20000000
		@CR0_CACHE_DISABLE = 0x40000000
		@CR0_PAGING = 0x80000000

		@CR3_PAGE_CACHE_DISABLE = 0x10
		@CR3_PAGE_WRITERS_TRANSPARENT = 0x8

		@CR4_VIRTUAL8086_MODE_EXTENSIONS = 0x1
		@CR4_PROTECTED_MODE_VIRTUAL_INTERRUPTS = 0x2
		@CR4_TIME_STAMP_DISABLE = 0x4
		@CR4_DEBUGGING_EXTENSIONS = 0x8
		@CR4_PAGE_SIZE_EXTENSIONS = 0x10
		@CR4_PHYSICAL_ADDRESS_EXTENSION = 0x20
		@CR4_MACHINE_CHECK_ENABLE = 0x40
		@CR4_PAGE_GLOBAL_ENABLE = 0x80
		@CR4_PERFORMANCE_MONITORING_COUNTER_ENABLE = 0x100
		@CR4_OS_SUPPORT_FXSAVE_FXSTORE = 0x200
		@CR4_OS_SUPPORT_UNMASKED_SIMD_EXCEPTIONS = 0x400

		@SYSENTER_CS_MSR = 0x174
		@SYSENTER_ESP_MSR = 0x175
		@SYSENTER_EIP_MSR = 0x176


		@AC_XOR = 1
		@AC_BIT4_NEQ = 2
		@AC_LNIBBLE_MAX = 3
		@AC_LNIBBLE_ZERO = 4
		@AC_LNIBBLE_NZERO = 5

		@OF_NZ = 1
		@OF_NOT_BYTE = 2
		@OF_NOT_SHORT = 3
		@OF_NOT_INT = 4

		@OF_LOW_WORD_NZ = 5
		@OF_HIGH_BYTE_NZ = 6

		@OF_BIT6_XOR_CARRY = 7
		@OF_BIT7_XOR_CARRY = 8
		@OF_BIT14_XOR_CARRY = 9
		@OF_BIT15_XOR_CARRY = 10
		@OF_BIT30_XOR_CARRY = 11
		@OF_BIT31_XOR_CARRY = 12

		@OF_BIT7_DIFFERENT = 13
		@OF_BIT15_DIFFERENT = 14
		@OF_BIT31_DIFFERENT = 15

		@OF_MAX_BYTE = 16
		@OF_MAX_SHORT = 17
		@OF_MAX_INT = 18

		@OF_MIN_BYTE = 19
		@OF_MIN_SHORT = 20
		@OF_MIN_INT = 21

		@OF_ADD_BYTE = 22
		@OF_ADD_SHORT = 23
		@OF_ADD_INT = 24

		@OF_SUB_BYTE = 25
		@OF_SUB_SHORT = 26
		@OF_SUB_INT = 27

		@CY_NZ = 1
		@CY_NOT_BYTE = 2
		@CY_NOT_SHORT = 3
		@CY_NOT_INT = 4

		@CY_LOW_WORD_NZ = 5
		@CY_HIGH_BYTE_NZ = 6

		@CY_NTH_BIT_SET = 7

		@CY_GREATER_FF = 8

		@CY_TWIDDLE_FF = 9
		@CY_TWIDDLE_FFFF = 10
		@CY_TWIDDLE_FFFFFFFF = 11

		@CY_SHL_OUTBIT_BYTE = 12
		@CY_SHL_OUTBIT_SHORT = 13
		@CY_SHL_OUTBIT_INT = 14

		@CY_SHR_OUTBIT = 15

		@CY_LOWBIT = 16

		@CY_HIGHBIT_BYTE = 17
		@CY_HIGHBIT_SHORT = 18
		@CY_HIGHBIT_INT = 19

		@CY_OFFENDBIT_BYTE = 20
		@CY_OFFENDBIT_SHORT = 21
		@CY_OFFENDBIT_INT = 22

		@parityMap = new Array(256)

		for i in [0...@parityMap.length]
			@parityMap[i] = ((numberOfSetBits(i) & 0x1) == 0)

	toString: ->
		return "Processor"

	getEFlags: ->
		result = 0x2
		if (@getCarryFlag())
			result |= 0x1
		if (@getParityFlag())
			result |= 0x4
		if (@getAuxiliaryCarryFlag())
			result |= 0x10
		if (@getZeroFlag())
			result |= 0x40
		if (@getSignFlag())
			result |= 0x80
		if (@eflagsTrap)
			result |= 0x100
		if (@eflagsInterruptEnable)
			result |= 0x200
		if (@eflagsDirection)
			result |= 0x400
		if (@getOverflowFlag())
			result |= 0x800
			result |= (@eflagsIOPrivilegeLevel << 12)
		if (@eflagsNestedTask)
			result |= 0x4000
		if (@eflagsResume)
			result |= 0x10000
		if (@eflagsVirtual8086Mode)
			result |= 0x20000
		if (@eflagsAlignmentCheck)
			result |= 0x40000
		if (@eflagsVirtualInterrupt)
			result |= 0x80000
		if (@eflagsVirtualInterruptPending)
			result |= 0x100000
		if (@eflagsID)
			result |= 0x200000

		log "result eflags: #{result}"

		return result


	setEFlags: (eflags)->

		# TODO:  check that there aren't flags which can't be set this way!
		@setCarryFlag((eflags & 1 ) != 0)
		@setParityFlag((eflags & (1 << 2)) != 0)
		@setAuxiliaryCarryFlag((eflags & (1 << 4)) != 0)
		@setZeroFlag((eflags & (1 << 6)) != 0)
		@setSignFlag((eflags & (1 <<  7)) != 0)

		@eflagsTrap = ((eflags & (1 <<  8)) != 0)
		@eflagsInterruptEnableSoon = @eflagsInterruptEnable = ((eflags & (1 <<  9)) != 0)
		@eflagsDirection = ((eflags & (1 << 10)) != 0)
		@setOverflowFlag((eflags & (1 << 11)) != 0)
		@eflagsIOPrivilegeLevel = ((eflags >> 12) & 3)
		@eflagsNestedTask = ((eflags & (1 << 14)) != 0)
		@eflagsResume = ((eflags & (1 << 16)) != 0)

		@eflagsVirtualInterrupt = ((eflags & (1 << 19)) != 0)
		@eflagsVirtualInterruptPending = ((eflags & (1 << 20)) != 0)
		@eflagsID = ((eflags & (1 << 21)) != 0)

		if (@eflagsAlignmentCheck != ((eflags & (1 << 18)) != 0))
			@eflagsAlignmentCheck = ((eflags & (1 << 18)) != 0)
			@checkAlignmentChecking()


		if (@eflagsVirtual8086Mode != ((eflags & (1 << 17)) != 0))
			@eflagsVirtual8086Mode = ((eflags & (1 << 17)) != 0)
			if (@eflagsVirtual8086Mode)
				throw "Trying to switch to unsuported Virtual8086 Mode. ModeSwitchException.VIRTUAL8086_MODE_EXCEPTION"
			else
				throw "ModeSwitchException.PROTECTED_MODE_EXCEPTION"

	raiseInterrupt: ->
		@interruptFlags |= @IFLAGS_HARDWARE_INTERRUPT

	clearInterrupt: ->
		@interruptFlags &= ~IFLAGS_HARDWARE_INTERRUPT

	waitForInterrupt: ->
		while ((@interruptFlags & @IFLAGS_HARDWARE_INTERRUPT) == 0)
			Clock.updateNowAndProcess()

		if (@isProtectedMode())
			if (@isVirtual8086Mode())
				throw "Virtual8086 Mode is not supported"
			else
				@processProtectedModeInterrupts(0)
		else
			throw "Real mode is not supported"


	requestReset: ->
		@interruptFlags |= @IFLAGS_RESET_REQUEST

	isProtectedMode: ->
		return (@cr0 & @CR0_PROTECTION_ENABLE) == 1

	isVirtual8086Mode: ->
		log "isVirtual8086: " + @eflagsVirtual8086Mode
		return @eflagsVirtual8086Mode

	getInstructionPointer: ->
		tmp = @cs.translateAddressRead(@getEIP())

		if (isNaN(tmp) || isNaN(@getEIP()))
			throw new LengthIncorrectError("EIP cant be NaN. Value: " + @getEIP())

		return tmp

	reset: ->
		log "Resetting CPU"
		@resetTime = 0 #TODO: Get reset time in JS
		@eax = @ebx = @ecx = @edx = 0
		@edi = @esi = @ebp = @esp = 0
		@edx = 0x00000633 #Pentium II Model 3 Stepping 3

		@ecx = 0xf800 # Command line parameter
		@ebx = SYS_RAM_SIZE

		@interruptFlags = 0
		@currentPrivilegeLevel = 0

		@alignmentChecking = false

		@setEIP(0x10000) # Controle nodig, zie wiki
#		@setEIP(-917504)

		# @CR0_PROTECTION_ENABLE is to set directly into protected mode.
		@cr0 = 0
		@cr0 = @CR0_CACHE_DISABLE | @CR0_NOT_WRITETHROUGH |  0x10 | @CR0_PROTECTION_ENABLE
		@cr2 = @cr3 = @cr4 = 0x0

		@dr0 = @dr1 = @dr2 = @dr3 = 0x0
		@dr6 = 0xfff0ff0
		@dr7 = 0x0000700

		@eflagsCarry = @eflagsParity = @eflagsAuxiliaryCarry = @eflagsZero = @eflagsSign = @eflagsTrap = @eflagsInterruptEnable = false
		@carryCalculated = @parityCalculated = @auxiliaryCarryCalculated = @zeroCalculated = @signCalculated = true
		@eflagsDirection = @eflagsOverflow = @eflagsNestedTask = @eflagsResume = @eflagsVirtual8086Mode = false
		@overflowCalculated = true

		@eflagsAlignmentCheck = @eflagsVirtualInterrupt = @eflagsVirtualInterruptPending = @eflagsID = false

		@eflagsIOPrivilegeLevel = 0
		@eflagsInterruptEnableSoon = false

		@cs = sgm.createRealModeSegment(0xf000)
		@cs = sgm.createRealModeSegment(0)
		@ds = sgm.createRealModeSegment(0)
		@ss = sgm.createRealModeSegment(0)
		@es = sgm.createRealModeSegment(0)
		@fs = sgm.createRealModeSegment(0)
		@gs = sgm.createRealModeSegment(0)

		@idtr = sgm.createDescriptorTableSegment(0, 0xffff)
		@ldtr = sgm.NULL_SEGMENT
		@gdtr = sgm.createDescriptorTableSegment(0, 0xffff)
		@tss = sgm.NULL_SEGMENT

	#	@modelSpecificRegisters.clear()

	initialised: ->
		result = @ioports != undefined && @ioports != null && @interruptController != undefined && @interruptController != null

		log "Init result: " + result

		if (result && !@started)
			log "Started"
			@reset()
			@started = true


		return result
	acceptComponent: (component) ->
		log "Got a " + component + " for proc"

		if (component instanceof IOPortHandler && !@ioports)
			@ioports = component

		if (component instanceof InterruptController && component.initialised() && !@interruptController)
			@interruptController = component

	processVirtual8086ModeInterrupts: (instructions) ->
		throw "Virtual8086 Mode is not supported"

	processProtectedModeInterrupts: (instructions) ->
		Clock.updateAndProcess(instructions)

		if (@eflagsInterruptEnable)
			if ((@interruptFlags & @IFLAGS_RESET_REQUEST) != 0)
				@reset()
				return

			if ((@interruptFlags & @IFLAGS_HARDWARE_INTERRUPT) != 0)
				interruptFlags &= ~@IFLAGS_HARDWARE_INTERRUPT
				@handleHardProtectedModeInterrupt(@interruptController.cpuGetInterrupt())
		@eflagsInterruptEnable = @eflagsInterruptEnableSoon

	handleProtectedModeException: (pe) ->
		savedESP = @esp
		savedEIP = @getEIP()
		savedCS = @cs
		savedSS = @ss

		try
			@followProtectedModeException(pe, false, false)
		catch e
			if (e instanceof ProcessorException)
				log "Double fault" + e

				@esp = savedESP
				@setEIP savedEIP
				@cs = savedCS
				@ss = savedSS

				if (pe.getType() == Type.DOUBLE_FAULT)
					log "Triple-Fault: Unhandleable, machine will halt!"
					pc.stop()
					return
				else if (e.combinesToDoubleFault(pe))
					@handleProtectedModeException(DOUBLE_FAULT_0)
					return
				else
					@handleProtectedModeException(e)
			else
				log "Different error: " + e

	followProtectedModeException: (error, hardware, software) ->
		log "followProtectedModeException"

		if (error.type == Type.PAGE_FAULT)
			@setCR2(les.getLastWalkedAddress())

			if (les.getLastWalkedAddress() == 0xbff9a3c0)
				log "Found it?"
				pc.stop()


		selector = vector << 3
		EXT = hardware ? 1:0

		gate = null
		isSup = les.isSupervisor()

		try
			les.setSupervisor(true)
			descriptor = @idtr.getQuadWord(selector)
			#gate = SegmentFactory.createProtectedModeSegment(linearMemory, selector, descriptor)
			#TODO FIX
		catch e
			log "failed to create gate"
			les.setSupervisor(isSup)
			throw new ProcessorException(Type.GENERAL_PROTECTION, selector+2+EXT, true)
		les.setSupervisor(isSup)

		switch gate.getType()
			when 0x05
				throw new IllegalStateException("Unimplemented Interrupt Handler: Task Gate")
			else
				log "Invalid gate type for throwing interrupt 0x#{gate.getType()}"
				throw new ProcessorException(Type.GENERAL_PROTECTION, selector + 2 + EXT, true)
	createDescriptorTableSegment: (base, limit) ->
		return sgm.createDescriptorTableSegment(base, limit)


#	getSegment: (segmentSelector) ->

#		segmentDescriptor = 0

#		if ((segmentSelector & 0x4) != 0)
#			segmentDescriptor = @ldtr.getQuadWord(segmentSelector & 0xfff8)

#		else
#		if (segmentSelector < 0x4) # removed comments.
#			return sgm.NULL_SEGMENT
#			segmentDescriptor = @gdtr.getQuadWord(segmentSelector & 0xfff8)

#		result = sgm.createProtectedModeSegment(segmentSelector, segmentDescriptor)

#		if (@alignmentChecking)
#			if ((result.getType() & 0x18) == 0x10)
#				result.setAddressSpace(alignmentCheckedMemory)
#		return result

	setParityFlagBool: (value) ->
		@parityCalculcated = true
		@eflagsParity = value

	setParityFlagInt: (data) ->
		@parityCalculated = false
		@parityOne = data

	# CarryLong doesnt seem to be supported now?
	setCarryFlag: (data..., value) ->
		if (data.length == 0)
			@carryCalculated = true
			@eflagsCarry = value
		else
			@carryCalculated = false
			@carryOne = data[0]
			@carryMethod = value
			if (data[1])
				@carryTwo = data[1]

	setAuxiliaryCarryFlag: (data..., value) ->
		if (data.length == 0)
			@AuxiliaryCarryCalculated = true
			@eflagsAuxiliaryCarry = value
		else
			@AuxiliaryCarryCalculated = false
			@AuxiliaryCarryOne = data[0]
			@AuxiliaryCarryMethod = value
			if (data[1])
				@AuxiliaryCarryTwo = data[1]

			if (data[2])
				@AuxiliaryCarryThree = data[2]

	setOverflowFlag: (data..., value) ->
		if (data.length == 0)
			@overflowCalculated = true
			@eflagsOverflow = value
		else
			@overflowwCalculated = false
			@overflowOne = data[0]
			@overflowMethod = value
			if (data[1])
				@overflowTwo = data[1]

			if (data[2])
				@overflowThree = data[2]

	setZeroFlag: (value) ->
		if (typeof value == "number")
			@ZeroCalculated = false
			@ZeroOne = value
		else
			@ZeroCalculated = true
			@eflagsZero = value

	setParityFlag: (value) ->
		if (typeof value == "number")
			@ParityCalculated = false
			@ParityOne = value
		else
			@ParityCalculated = true
			@eflagsParity = value

	setSignFlag: (value) ->
		if (typeof value == "number")
			@signCalculated = false
			@signOne = value
		else
			@signCalculated = true
			@eflagsSign = value

	getCarryFlag: ->
		if (@carryCalculated)
			return @eflagsCarrry
		else
			@carryCalculated = true

			if (@carryMethod == @CY_TWIDDLE_FFFF)
				@eflagsCarry = ((@carryOne & (~0xffff)) != 0)
			else if (@carryMethod == @CY_TWIDDLE_FF)
				@eflagsCarry = ((@carryOne & (~0xff)) != 0)
			else if (@carryMethod == @CY_SHR_OUTBIT)
				@eflagsCarry = (((@carryOne >>> (@carryTwo - 1)) & 0x1) != 0)
			else if (@carryMethod == @CY_TWIDDLE_FFFFFFFF)
##				@eflagsCarry = ((@carryLong & (~0xffffffff)) != 0)
				log "Unsuported action"
			else if (@carryMethod == @CY_SHL_OUTBIT_SHORT)
				@eflagsCarry = (((@carryOne << (@carryTwo - 1)) & 0x8000) != 0)

			else
				switch (@carryMethod)
					when @CY_NZ
						@eflagsCarry = @carryOne != 0
					when @CY_NOT_BYTE
						@eflagsCarry = -1
					when @CY_NOT_SHORT
						@eflagsCarry = -1
					when @CY_NOT_INT
						@eflagsCarry = -1
					when @CY_NOT_BYTE
						@eflagsCarry = (@carryOne != byte(@carryOne))
					when @CY_NOT_SHORT
						@eflagsCarry = (@carryOne != short(@carryOne))
					when @CY_NOT_INT
						@eflagsCarry = (@carryLong != int(@carryLong))
					when @CY_LOW_WORD_NZ
						@eflagsCarry = ((@carryOne & 0xffff) != 0)
					when @CY_HIGH_BYTE_NZ
						@eflagsCarry = ((@carryOne & 0xff00) != 0)
					when @CY_NTH_BIT_SIT
						@eflagsCarry = ((@carryOne & (1 << @carryTwo)) != 0)
					when @CY_GREATER_FF
						@eflagsCarry = (@carryOne > 0xff)
					when @CY_SHL_OUTBIT_BYTE
						@eflagsCarry = (((@carryOne << (@carryTwo - 1)) & 0x80) != 0)
					when @CY_SHL_OUTBIT_INT
						@eflagsCarry = (((@carryOne << (@carryTwo - 1)) & 0x80000000) != 0)
					when @CY_LOWBIT
						@eflagsCarry = ((@carryOne & 0x1) != 0)
					when @CY_HIGHBIT_BYTE
						@eflagsCarry = ((@carryOne & 0x80) != 0)
					when @CY_HIGHBIT_SHORT
						@eflagsCarry = ((@carryOne & 0x8000) != 0)
					when @CY_HIGHBIT_INT
						@eflagsCarry = ((@carryOne & 0x80000000) != 0)
					when @CY_OFFENDBIT_BYTE
						@eflagsCarry = ((@carryOne & 0x100) != 0)
					when @CY_OFFENDBIT_SHORT
						@eflagsCarry = ((@carryOne & 0x10000) != 0)

					when @CY_OFFENDBIT_INT
						@eflagsCarry = ((@carryLong & 0x100000000) != 0)
					else
						throw new IllegalStateException("Missing carry flag calcuation method")
			return @eflagsCarry
	getZeroFlag:  ->
		if (@zeroCalculated)
			return @eflagsZero
		else
			@zeroCalculated = true
			@eflagsZero = (@zeroOne == 0)
			return @eflagsZero
	getSignFlag: ->
		if (@signCalculated)
			return @flagsSign
		else
			@signCalculated = true
			@eflagsSign = (@ignOne < 0)
			return @eflagsSign
	getAuxiliaryCarryFlag: ->
		if (@auxiliaryCarryCalculated)
			return @eflagsAuxiliaryCarry
		else
			@auxiliaryCarryCalculated = true

			switch @auxiliaryCarryMethod
				when @AC_XOR
					@eflagsAuxiliaryCarry = ((((@auxiliaryCarryOne ^ @auxiliaryCarryTwo) ^ @auxiliaryCarryThree) & 0x10) != 0)
				when @AC_LNIBBLE_MAX
					@eflagsAuxiliaryCarry = ((@auxiliaryCarryOne & 0xf) == 0xf)
				when @AC_LNIBBLE_ZERO
					@eflagsAuxiliaryCarry = ((@auxiliaryCarryOne & 0xf) == 0x0)
				when @AC_BIT4_NEQ
					@eflagsAuxiliaryCarry = ((@auxiliaryCarryOne & 0x08) != (@auxiliaryCarryTwo & 0x08))
				when @AC_LNIBBLE_NZERO
					@eflagsAuxiliaryCarry = ((@auxiliaryCarryOne & 0xf) != 0x0)
				else
					throw new IllegalStateException("Missing auxiliary carry flag. Value: #{@auxiliaryCarryMethod}")
			return @eflagsAuxiliaryCarry
	getParityFlag: ->
		if (@parityCalculated)
			return @flagsParity
		else
			@parityCalculated = true

		@eflagsParity = @parityMap[@parityOne & 0xff]
		return @eflagsParity

	getOverflowFlag: ->
		if (@overflowCalculated)
			return @eflagsoverflow
		else
			@overflowCalculated = true
		if (@overflowMethod == @OF_ADD_BYTE)
			return (((@overflowTwo & 0x80) == (@overflowThree & 0x80)) && ((@overflowTwo & 0x80) != (@overflowOne & 0x80)))
		else if (@overflowMethod == @OF_ADD_SHORT)
			return (((@overflowTwo & 0x8000) == (@overflowThree & 0x8000)) && ((@overflowTwo & 0x8000) != (@overflowOne & 0x8000)))
		else if (@overflowMethod == @OF_ADD_INT)
			return (((@overflowTwo & 0x80000000) == (@overflowThree & 0x80000000)) && ((@overflowTwo & 0x80000000) != (@overflowOne & 0x80000000)))
		else if (@overflowMethod == @OF_SUB_BYTE)
			return (((@overflowTwo & 0x80) != (@overflowThree & 0x80)) && ((@overflowTwo & 0x80) != (@overflowOne & 0x80)))
		else if (@overflowMethod == @OF_SUB_SHORT)
			return (((@overflowTwo & 0x8000) != (@overflowThree & 0x8000)) && ((@overflowTwo & 0x8000) != (@overflowOne & 0x8000)))
		else if (@overflowMethod == @OF_SUB_INT)
			return (((@overflowTwo & 0x80000000) != (@overflowThree & 0x80000000)) && ((@overflowTwo & 0x80000000) != (@overflowOne & 0x80000000)))
		else if (@overflowMethod == @OF_MAX_BYTE)
			return (@eflagsoverflow = (@overflowOne == 0x7f))
		else if (@overflowMethod == @OF_MAX_SHORT)
			return (@eflagsoverflow = (@overflowOne == 0x7fff))
		else if (@overflowMethod == @OF_MIN_SHORT)
			return (@eflagsoverflow = (@overflowOne == short(0x8000)))#short
		else if (@overflowMethod == @OF_BIT15_XOR_CARRY)
			return (@eflagsoverflow = (((@overflowOne & 0x8000) != 0) ^ getCarryFlag()))
		else
			switch (@overflowMethod)
				when @OF_NZ
					return (@eflagsoverflow = (@overflowOne != 0))
				when @OF_NOT_BYTE
					return (@eflagsoverflow = (@overflowOne != byte(@overflowOne))) #byte
				when @OF_NOT_SHORT
					return (@eflagsoverflow = (@overflowOne != short(@overflowOne))) #short
				when @OF_NOT_INT
					return (@eflagsoverflow = (@overflowLong != int(@overflowLong))) #int

				when @OF_LOW_WORD_NZ
					return (@eflagsoverflow = ((@overflowOne & 0xffff) != 0))
				when @OF_HIGH_BYTE_NZ
					return (@eflagsoverflow = ((@overflowOne & 0xff00) != 0))

				when @OF_BIT6_XOR_CARRY
					return (@eflagsoverflow = (((@overflowOne & 0x40) != 0) ^ getCarryFlag()))
				when @OF_BIT7_XOR_CARRY
					return (@eflagsoverflow = (((@overflowOne & 0x80) != 0) ^ getCarryFlag()))
				when @OF_BIT14_XOR_CARRY
					return (@eflagsoverflow = (((@overflowOne & 0x4000) != 0) ^ getCarryFlag()))
				when @OF_BIT30_XOR_CARRY
					return (@eflagsoverflow = (((@overflowOne & 0x40000000) != 0) ^ getCarryFlag()))
				when @OF_BIT31_XOR_CARRY
					return (@eflagsoverflow = (((@overflowOne & 0x80000000) != 0) ^ getCarryFlag()))

				when @OF_BIT7_DIFFERENT
					return (@eflagsoverflow = ((@overflowOne & 0x80) != (@overflowTwo & 0x80)))
				when @OF_BIT15_DIFFERENT
					return (@eflagsoverflow = ((@overflowOne & 0x8000) != (@overflowTwo & 0x8000)))
				when @OF_BIT31_DIFFERENT
					return (@eflagsoverflow = ((@overflowOne & 0x80000000) != (@overflowTwo & 0x80000000)))

				when @OF_MAX_INT
					return (@eflagsoverflow = (@overflowOne == 0x7fffffff))

				when @OF_MIN_BYTE
					return (@eflagsoverflow = (@overflowOne == byte(0x80))) #byte
				when @OF_MIN_INT
					return (@eflagsoverflow = (@overflowOne == 0x80000000))

	setCR0: (value) ->
		value |= 0x10

		changedBits = value ^ @cr0

		if changedBits == 0
			return

		@cr0 = value

		pagingChanged = (changedBits & @CR0_PAGING) != 0
		cachingChanged = (changedBits & @CR0_CACHE_DISABLE) != 0
		modeSwitch = (changedBits & @CR0_PROTECTION_ENABLE) != 0
		wpUserPagesChanged = (changedBits & @CR0_WRITE_PROTECT) != 0
		alignmentChanged = (changedBits & @CR0_ALIGNMENT_MASK) != 0

		if (changedBits & @CR0_NOT_WRITETHROUGH) != 0
			log "Unimplemented CR0 flags changed."

		if (pagingChanged)
			if (((value & @CR0_PROTECTION_ENABLE) == 0) && ((value & @CR0_PAGING) != 0))
				throw new ProcessorException(Type.GENERAL_PROTECTION, 0, true)


		if (alignmentChanged)
			@checkAlignmentChecking()

		if (pagingChanged || cachingChanged)
			log "Unsupported cr0 flag changed."
			les.setPagingEnabled ((value & @CR0_PAGING) != 0)
			les.setPageCacheEnabled((value & @CR0_CACHE_DISABLE) == 0)

		if (wpUserPagesChanged)
			log "Unsuported cr0 flag changed."
			les.setWriteProtectUserPages((value & CR0_WRITE_PROTECT) != 0)

		if (modeSwitch)
			if (value & @CR0_PROTECTION_ENABLE) != 0
				@convertSegmentsToProtectedMode()
				throw ModeSwitchException.PROTECTED_MODE_EXCEPTION
			else
				@setCPL(0)
				@convertSegmentsToRealMode()
				throw ModeSwitchException.REAL_MODE_EXCEPTION

	getCR0: ->
		return @cr0

	setCR3: (value) ->
		@cr3 = value
		log "No les"
#linearMemory.setPageWriteThroughEnabled((value & CR3_PAGE_WRITES_TRANSPARENT) != 0);
#linearMemory.setPageCacheEnabled((value & CR3_PAGE_CACHE_DISABLE) == 0);
#linearMemory.setPageDirectoryBaseAddress(value);

	getCR3: ->
		return @cr3

	getCR2: ->
		return @cr2

	setCR2: (value) ->
		@cr2 = value

	setCR4: (value) ->
		if (@cr4 == value)
			return

		@cr4 = (@cr4 & ~0x5f) | (value & 0xf5)

		if ((@cr4 & @CR4_VIRTUAL8086_MODE_EXTENSIONS) != 0)
			log "Virtual-8086 mode extensions enabled in the processor"
		if ((@cr4 & @CR4_PROTECTED_MODE_VIRTUAL_INTERRUPTS) != 0)
			log "Protected mode virtual interrupts enabled in the processor"
		if ((@cr4 & @CR4_OS_SUPPORT_UNMASKED_SIMD_EXCEPTIONS) != 0)
			log "SIMD instruction support modified in the processor"
		if ((@cr4 & @CR4_OS_SUPPORT_FXSAVE_FXSTORE) != 0)
			log "FXSave and FXRStore enabled in the processor"
		if ((@cr4 & @CR4_DEBUGGING_EXTENSIONS) != 0)
			log "Debugging extensions enabled"
		if ((@cr4 & @CR4_TIME_STAMP_DISABLE) != 0)
			log "Timestamp restricted to CPL0"
		if ((@cr4 & @CR4_PHYSICAL_ADDRESS_EXTENSION) != 0)
			log "36-bit addressing enabled"
			throw new IllegalStateException("36-bit addressing enabled")

#		linearMemory.setGlobalPagesEnabled((value & CR4_PAGE_GLOBAL_ENABLE) != 0)
#		linearMemory.setPageSizeExtensionsEnabled((cr4 & CR4_PAGE_SIZE_EXTENSIONS) != 0)

	getCR4: ->
		return @cr4

	setDR0: (@dr0) ->

	setDR1: (@dr1) ->

	setDR2: (@dr2) ->

	setDR3: (@dr3) ->

	setDR4: (@dr4) ->

	setDR5: (@dr5) ->

	setDR6: (@dr6) ->

	setDR7: (@dr7) ->

	getDR0: ->
		return @dr0

	getDR1: ->
		return @dr1

	getDR2: ->
		return @dr2

	getDR3: ->
		return @dr3

	getDR4: ->
		return @dr4

	getDR5: ->
		return @dr5

	getDR6: ->
		return @dr6

	getDR7: ->
		return @dr7

	getIOPrivilegeLevel: ->
		return @eflagsIOPrivilegeLevel

	getCPL: ->
		return @currentPrivilegeLevel

	getEIP: ->
		return @ip

	incEIP: (i) ->
		log "Increate EIP with #{i}"
		i = @getEIP() + i
		@setEIP(i)

	setEIP: (i) ->
		log "EIP update: Old: #{@getEIP()} new #{i}"
		log "Address value: "
		log window.pc.getMemoryOffset(8, i)

		if (i == 995326)
			log "995326 recevied."
			a.a()
#			throw "dead"
#			return

		@ip = i
