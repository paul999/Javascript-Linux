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



Type = {
	DIVIDE_ERROR: 0x00, DEBUG: 0x01, BREAKPOINT: 0x03, OVERFLOW: 0x04,
	BOUND_RANGE: 0x05, UNDEFINED: 0x06, NO_FPU: 0x07, DOUBLE_FAULT: 0x08,
	FPU_SEGMENT_OVERRUN: 0x09, TASK_SWITCH: 0x0a, NOT_PRESENT: 0x0b,
	STACK_SEGMENT: 0x0c, GENERAL_PROTECTION: 0x0d, PAGE_FAULT: 0x0e,
	FLOATING_POINT: 0x10, ALIGNMENT_CHECK: 0x11, MACHINE_CHECK: 0x12,
	SIMD_FLOATING_POINT: 0x13
}


class ProcessorException
	constructor: (@type, mid..., @pointtoself) ->

		@hasErrorCode = (mid[0]) ? true : false
		@errorCode = mid[0]? 0

	combinesToDoubleFault: (exception) ->
		switch (@getType())
			when Type.DEVIDE_ERROR, Type.TASK_SWITCH, Type.NOT_PRESENT, Type.STACK_SEGMENT, Type.GENERAL_PROTECTION
				switch (exception.getType())
					when Type.DEVIDE_ERROR, Type.TASK_SWITCH, Type.NOT_PRESENT, Type.STACK_SEGMENT, Type.GENERAL_PROTECTION, Type.PAGE_FAULT
						return true
					else
						return false
			when @PAGE_FAULT
				return (exception.getType() == Type.PAGE_FAULT)
			else return false

	toString: ->
		if (hasErrorCode())
			return "CPU Exception type " + @type + " with error 0x" + @errorCode
		else
			return "CPU Exception type " + @type



DIVIDE_ERROR = new ProcessorException(Type.DIVIDE_ERROR, true);
BOUND_RANGE = new ProcessorException(Type.BOUND_RANGE, true);
UNDEFINED = new ProcessorException(Type.UNDEFINED, true);
DOUBLE_FAULT_0 = new ProcessorException(Type.DOUBLE_FAULT, 0, true);
STACK_SEGMENT_0 = new ProcessorException(Type.STACK_SEGMENT, 0, true);
GENERAL_PROTECTION_0 = new ProcessorException(Type.GENERAL_PROTECTION, 0, true);
FLOATING_POINT = new ProcessorException(Type.FLOATING_POINT, true);
ALIGNMENT_CHECK_0 = new ProcessorException(Type.ALIGNMENT_CHECK, 0, true);
