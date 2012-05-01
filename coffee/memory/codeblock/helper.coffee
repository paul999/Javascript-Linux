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

bitwise_flags = (result) =>
	proc.setOverflowFlag(false)
	proc.setCarryFlag(false)
	proc.setZeroFlag(result)
	proc.setParityFlag(result)
	proc.setSignFlag(result)

###
bitwise_flags: (result, type = "") ->
	if (type == "")
		throw new IllegalStateException("Type is required.")



void bitwise_flags(byte result)
{
proc.setOverflowFlag(false);
proc.setCarryFlag(false);
proc.setZeroFlag(result);
proc.setParityFlag(result);
proc.setSignFlag(result);
}

void bitwise_flags(short result)
{
proc.setOverflowFlag(false);
proc.setCarryFlag(false);
proc.setZeroFlag(result);
proc.setParityFlag(result);
proc.setSignFlag(result);
}

void bitwise_flags(int result)
{
proc.setOverflowFlag(false);
proc.setCarryFlag(false);
proc.setZeroFlag(result);
proc.setParityFlag(result);
proc.setSignFlag(result);
}
###

arithmetic_flags_o8 = (result, operand1, operand2) =>
	proc.setZeroFlag(byte(result))
	proc.setParityFlag(result)
	proc.setSignFlag(byte(result))

	proc.setCarryFlag(result, proc.CY_TWIDDLE_FF)
	proc.setAuxiliaryCarryFlag(operand1, operand2, result, proc.AC_XOR)

arithmetic_flags_o16 = (result, operand1, operand2) =>
	proc.setZeroFlag(short(result))
	proc.setParityFlag(result)
	proc.setSignFlag(short(result))

	proc.setCarryFlag(result, proc.CY_TWIDDLE_FFFF)
	proc.setAuxiliaryCarryFlag(operand1, operand2, result, proc.AC_XOR)

arithmetic_flags_o32 = (result, operand1, operand2) =>
	proc.setZeroFlag(int(result))
	proc.setParityFlag(int(result))
	proc.setSignFlag(int(result))

	proc.setCarryFlag(result, proc.CY_TWIDDLE_FFFFFFFF)
	proc.setAuxiliaryCarryFlag(operand1, operand2, int(result), proc.AC_XOR)

add_o32_flags = (result, operand1, operand2) =>
	result = (0xffffffff & operand1) + (0xffffffff & operand2)

	arithmetic_flags_o32(result, operand1, operand2)
	proc.setOverflowFlag(int(result), operand1, operand2, proc.OF_ADD_INT)

add_o16_flags = (result, operand1, operand2) =>
	arithmetic_flags_o16(result, operand1, operand2)
	proc.setOverflowFlag(result, operand1, operand2, proc.OF_ADD_SHORT)

add_o8_flags = (result, operand1, operand2) =>
	arithmetic_flags_o8(result, operand1, operand2)
	proc.setOverflowFlag(result, operand1, operand2, proc.OF_ADD_BYTE)

sub_o32_flags = (result, operand1, operand2) =>
	result = (0xffffffff & operand1) - (0xffffffff & operand2)

	arithmetic_flags_o32(result, operand1, operand2)
	proc.setOverflowFlag(int(result), operand1, operand2, proc.OF_SUB_INT)

sub_o16_flags = (result, operand1, operand2) =>
	arithmetic_flags_o16(result, operand1, operand2)
	proc.setOverflowFlag(result, operand1, operand2, proc.OF_SUB_SHORT)

sub_o8_flags = (result, operand1, operand2) =>
	arithmetic_flags_o8(result, operand1, operand2)
	proc.setOverflowFlag(result, operand1, operand2, proc.OF_SUB_BYTE)

sbb_o32_flags = (result, operand1, operand2) =>
	carry = (proc.getCarryFlag() ? 1 : 0)
	result = (0xffffffff & operand1) - ((0xffffffff & operand2) + carry)

	proc.setOverflowFlag(int(result), operand1, operand2, proc.OF_SUB_INT)
	arithmetic_flags_o32(result, operand1, operand2)

sbb_o16_flags = (result, operand1, operand2) =>
	proc.setOverflowFlag(result, operand1, operand2, proc.OF_SUB_SHORT)
	arithmetic_flags_o16(result, operand1, operand2)

sbb_o8_flags = (result, operand1, operand2) =>
	proc.setOverflowFlag(result, operand1, operand2, proc.OF_SUB_BYTE)
	arithmetic_flags_o8(result, operand1, operand2)

shr_flags = (result, initial, count, type = "") =>
	if (count > 0)
		if (type == "")
			throw new IllegalStateException("Execute Failed")
		else if (type == "byte")
			initial = byte(initial)
			result = byte(result)
			proc.setCarryFlag(initial, count, proc.CY_SHR_OUTBIT_BYTE)
		else if (type == "short")
			initial = short(initial)
			result = short(result)
			proc.setCarryFlag(initial, count, proc.CY_SHR_OUTBIT_SHORT)
		else if (type == "int")
			proc.setCarryFlag(initial, count, proc.CY_SHR_OUTBIT_INT)

		if (count == 1)
			proc.setOverflowFlag(result, proc.OF_BIT7_DIFFERENT)

		proc.setZeroFlag(result)
		proc.setParityFlag(result)
		proc.setSignFlag(result)

rep_movsw_a16 = (outSegment) =>
	count = proc.ecx & 0xffff
	inAddr = proc.edi & 0xffff
	outAddr = proc.esi & 0xffff
	@executeCount += count

	try
		if (proc.eflagsDirection)
			while (count != 0)
				#check hardware interrupts
				proc.es.setWord(inAddr & 0xffff, outSegment.getWord(outAddr & 0xffff))
				count--
				outAddr -= 2
				inAddr -= 2
		else
			while (count != 0)
				#check hardware interrupts
				proc.es.setWord(inAddr & 0xffff, outSegment.getWord(outAddr & 0xffff))
				count--
				outAddr += 2
				inAddr += 2
	finally
		proc.ecx = (proc.ecx & ~0xffff) | (count & 0xffff)
		proc.edi = (proc.edi & ~0xffff) | (inAddr & 0xffff)
		proc.esi = (proc.esi & ~0xffff) | (outAddr & 0xffff)
