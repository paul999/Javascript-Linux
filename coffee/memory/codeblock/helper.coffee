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
