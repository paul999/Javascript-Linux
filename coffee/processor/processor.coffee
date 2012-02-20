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


class processor
	constructor: ->
		console.log "Processor created"

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

	type: ->
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
			@vmClock.updateNowAndProcess()

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
		console.log "Protected: " + (@cr0 & @CR0_PROTECTION_ENABLE)
		return (@cr0 & @CR0_PROTECTION_ENABLE) == 1

	isVirtual8086Mode: ->
		console.log "isVirtual8086: " + @eflagsVirtual8086Mode
		return @eflagsVirtual8086Mode

	getInstructionPointer: ->
		#TODO: CS is null
		#return @cs.translateAddressRead(@eip)
		return

	reset: ->
		console.log "Resetting CPU"
		@resetTime = 0 #TODO: Get reset time in JS
		@eax = @ebx = @ecx = @edx = 0
		@edi = @esi = @ebp = @esp = 0
		@edx = 0x00000633 #Pentium II Model 3 Stepping 3

		@interruptFlags = 0
		@currentPrivilegeLevel = 0

		@linearMemory.reset()
		@alignmentChecking = false

		@eip = 0x000fff0

		# @CR0_PROTECTION_ENABLE is to set directly into protected mode.
		@cr0 = 0
		@cr0 |= @CR0_CACHE_DISABLE
		@cr0 |= @CR0_NOT_WRITETHROUGH
		@cr0 |= 0x10
		@cr0 |= @CR0_PROTECTION_ENABLE
		console.log "@CR0_CACHE_DISABLE" + @CR0_CACHE_DISABLE
		console.log "cr0: " + @cr0
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
#TODO: FIXME :(
#		@cs = @SegmentFactory.createRealModeSegment(@physicalMemory, 0xf000)
#		@ds = @SegmentFactory.createRealModeSegment(@physicalMemory, 0)
#		@ss = @SegmentFactory.createRealModeSegment(@physicalMemory, 0)
#		@es = @SegmentFactory.createRealModeSegment(@physicalMemory, 0)
#		@fs = @SegmentFactory.createRealModeSegment(@physicalMemory, 0)
#		@gs = @SegmentFactory.createRealModeSegment(@physicalMemory, 0)

#		@idtr = @SegmentFactory.createDescriptorTableSegment(@physicalMemory, 0, 0xFFFF)
#		@ldtr = @SegmentFactory.NULL_SEGMENT
#		@gdtr = @SegmentFactory.createDescriptorTableSegment(@physicalMemory, 0, 0xFFFF)
#		@tss = @SegmentFactory.NULL_SEGMENT

	#	@modelSpecificRegisters.clear()

	initialised: ->
		result = @physicalMemory != undefined && @physicalMemory != null && @linearMemory != undefined && @linearMemory != null && @ioports != undefined && @ioports != null && @interruptController != undefined && @interruptController != null

		console.log @physicalMemory != undefined && @physicalMemory != null
		console.log @linearMemory != undefined && @linearMemory != null
		console.log @ioports != undefined && @ioports != null
		console.log @interruptController != undefined && @interruptController != null


		if (result && !@started)
			console.log "Started"
			@reset()
			@started = true


		return result
	acceptComponent: (component, type="error") ->
		if (!type || type == null || type == undefined || type =="error")
			throw "BC break, type missing"

		console.log "Got a " + type + " for proc"

		if (type == "LinearAddresSpace" && !@linearMemory)
			@linearMemory = component

#			@alignmentCheckedMemory = new AlignmentCheckedAddressSpace(linearMemory)

		if (type == "PhysicalAddressSpace" && !@physicalMemory)
			@physicalMemory = component

		if (type == "IOPortHandler" && !@ioports)
			@ioports = component

		if (type == "InteruptController" && component.initialised() && !@interruptController)
			@interruptController = component

	processVirtual8086ModeInterrupts: (instructions) ->
		throw "Virtual8086 Mode is not supported"
