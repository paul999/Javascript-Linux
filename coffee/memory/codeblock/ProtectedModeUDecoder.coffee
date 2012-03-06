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

class ProtectedModeUDecoder extends MicrocodeSet
	constructor: ->
		super
		@modrmArray = [
			true, true, true, true, false, false, false, false, true, true, true, true, false, false, false, false,
			true, true, true, true, false, false, false, false, true, true, true, true, false, false, false, false,
			true, true, true, true, false, false, false, false, true, true, true, true, false, false, false, false,
			true, true, true, true, false, false, false, false, true, true, true, true, false, false, false, false,

			false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false,
			false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false,
			false, false, true, true, false, false, false, false, false, true, false, true, false, false, false, false,
			false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false,

			true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true,
			false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false,
			false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false,
			false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false,

			true, true, false, false, true, true, true, true, false, false, false, false, false, false, false, false,
			true, true, true, true, false, false, false, false, false, false, false, false, false, false, false, false,
			false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false,
			false, false, false, false, false, false, true, true, false, false, false, false, false, false, true, true
		]

		@sibArray = [
			false, false, false, false, true, false, false, false, false, false, false, false, true, false, false, false,
			false, false, false, false, true, false, false, false, false, false, false, false, true, false, false, false,
			false, false, false, false, true, false, false, false, false, false, false, false, true, false, false, false,
			false, false, false, false, true, false, false, false, false, false, false, false, true, false, false, false,

			false, false, false, false, true, false, false, false, false, false, false, false, true, false, false, false,
			false, false, false, false, true, false, false, false, false, false, false, false, true, false, false, false,
			false, false, false, false, true, false, false, false, false, false, false, false, true, false, false, false,
			false, false, false, false, true, false, false, false, false, false, false, false, true, false, false, false,

			false, false, false, false, true, false, false, false, false, false, false, false, true, false, false, false,
			false, false, false, false, true, false, false, false, false, false, false, false, true, false, false, false,
			false, false, false, false, true, false, false, false, false, false, false, false, true, false, false, false,
			false, false, false, false, true, false, false, false, false, false, false, false, true, false, false, false,

			false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false,
			false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false,
			false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false,
			false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false
		]

		@twoByte_0f_modrmArray = [
			true, true, true, true, false, false, false, false, false, false, false, true,  false, false, false, false,
			true, true, true, true, true, true, true, true, true, false, false, false, false, false, false, true,
			true, true, true, true, true, false, true, false, true, true, true, true, true, true, true, true,
			false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false,

			true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true,
			true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true,
			true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true,
			true, true, true, true, true, true, true, false, false, false, false, false, true, true, true, true,

			false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false,
			true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true,
			false, false, false, true, true, true, false, false, false, false, false, true, true, true, true, true,
			true, true, true, true, true, true, true, true, false, true, true, true, true, true, true, true,

			true, true, true, true, true, true, true, true, false, false, false, false, false, false, false, false,
			true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true,
			true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true,
			true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true
		]

		@twoByte_0f_sibArray = [
			false, false, false, false, true, false, false, false, false, false, false, false, true, false, false, false,
			false, false, false, false, true, false, false, false, false, false, false, false, true, false, false, false,
			false, false, false, false, true, false, false, false, false, false, false, false, true, false, false, false,
			false, false, false, false, true, false, false, false, false, false, false, false, true, false, false, false,

			false, false, false, false, true, false, false, false, false, false, false, false, true, false, false, false,
			false, false, false, false, true, false, false, false, false, false, false, false, true, false, false, false,
			false, false, false, false, true, false, false, false, false, false, false, false, true, false, false, false,
			false, false, false, false, true, false, false, false, false, false, false, false, true, false, false, false,

			false, false, false, false, true, false, false, false, false, false, false, false, true, false, false, false,
			false, false, false, false, true, false, false, false, false, false, false, false, true, false, false, false,
			false, false, false, false, true, false, false, false, false, false, false, false, true, false, false, false,
			false, false, false, false, true, false, false, false, false, false, false, false, true, false, false, false,

			false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false,
			false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false,
			false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false,
			false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false
		]
		@PREFICES_SG = 0x7
		@PREFICES_ES = 0x1
		@PREFICES_CS = 0x2
		@PREFICES_SS = 0x3
		@PREFICES_DS = 0x4
		@PREFICES_FS = 0x5
		@PREFICES_GS = 0x6

		@PREFICES_OPERAND = 0x8
		@PREFICES_ADDRESS = 0x10

		@PREFICES_REPNE = 0x20
		@PREFICES_REPE = 0x40

		@PREFICES_REP = @PREFICES_REPNE | @PREFICES_REPE

		@PREFICES_LOCK = 0x80

		@source = null
		@current = null
		@waiting = null
		@working = null

		@blockComplete = null
		@addressModeDecoded = null

		@decodeLimit = null

		@current = new Operation()
		@waiting = new Operation()
		@working = new Operation()

	decodeProtected: (source, operandSize, limit) ->
		log "decodedProtected source: " + source
		@reset()
		@operandSizeIs32Bit = operandSize
		@source = source
		@decodeLimit = limit

		return this

	reset: ->
		@working.reset()
		@waiting.reset()
		@current.reset()
		@blockComplete = false

	getMicrocode: ->
		return @current.getMicrocode()

	rotate: ->
		temp = @current
		@current = @waiting
		@waiting = @working
		@working = temp

	getNext: ->
		@decode() #New block to compile
		@rotate()

		if (@current.decoded)
			return true
		else if (@current.terminal)
			@reset()
			return false
		else
			return @getNext()
	getLength: ->
		return @current.getLength()

	getX86Length: ->
		return @current.getX86Length()

	blockFinished: ->
		@blockComplete = true

	decodeComplete: (position) ->
		if (@addressModeDecoded)
			@working.write(@MEM_RESET)
			@addressModeDecoded = false
		@working.finish(position)

	decode: ->
		@working.reset()

		if (@blockComplete)
			@working.makeTerminal()
			return

		length = 0

		try
			length = @decodeOpcode(@operandSizeIs32Bit)
			@decodeLimit--
		catch e
			if (!@waiting.decoded)
				throw e
			@waiting.write(@EIP_UPDATE)
			@working.makeTerminal()
			@blockFinished()
			return

		if (length < 0)
			@decodeComplete(-length)
			@blockFinished()
		else if (@decodeLimit <= 0)
			@decodeComplete(length)
			@working.write(@EIP_UPDATE)
			@blockFinished()
		else
			@decodeComplete(length)

	decodeOpcode: (operandSizeIs32Bit) ->
		opcode = 0
		opcodePrefix = 0
		tmp = (@PREFICES_OPERAND | @PREFICES_ADDRESS)
		prefices = operandSizeIs32Bit ? tmp : 0x00
		bytesRead = 0
		modrm = -1
		sib = -1
		lock = false

		while true
			read = @source.getByte()

			if (!read && read != 0 )
				throw new LengthIncorrectError("Read has been undefined, source: #{@source}")

			opcode = 0xff & read

			bytesRead += 1

			switch (opcode)
				when 0x0f
					opcodePrefix = (opcodePrefix << 8) | opcode
					opcode = 0xff & @source.getByte()
					bytesRead += 1
					modrm = opcode
				when 0xd8, 0xd9, 0xda, 0xdb, 0xdc, 0xdd, 0xde, 0xdf
					opcodePrefix = (opcodePrefix << 8) | opcode
					opcode = 0
					modrm = 0xff & @source.getByte()
					bytesRead += 1
				when 0x2e
					prefices &= ~@PREFICES_SG
					prefices |= @PREFICES_CS
					continue
				when 0x3e
					prefices &= ~@PREFICES_SG
					prefices |= @PREFICES_DS
					continue
				when 0x26
					prefices &= ~@PREFICES_SG
					prefices |= @PREFICES_ES
					continue
				when 0x36
					prefices &= ~@PREFICES_SG
					prefices |= @PREFICES_SS
					continue
				when 0x64
					prefices &= ~@PREFICES_SG
					prefices |= @PREFICES_FS
					continue
				when 0x65
					prefices &= ~@PREFICES_SG
					prefices |= @PREFICS_GS
					continue
				when 0x66
					if @operandSizeIs32Bit
						prefices = prefices & ~@PREFICES_OPERAND
					else
						prefices = prefices | @PREFICES_OPERAND
					continue
				when 0x67
					if @operandSizeIs32Bit
						prefices = prefices & ~@PREFICES_ADDRESS
					else
						prefices = prefices | @PREFICES_ADDRESS
					continue
				when 0xf2
					prefices |= @PREFICES_REPNE
					continue
				when 0xf3
					prefices |= @PREFICES_REPE
					continue
				when 0xf0
					lock = true
					prefices |= @PREFICES_LOCK
					continue
			break



		opcode = (opcodePrefix << 8) | opcode;

		log "Executing opcode: #{opcode}"

		switch opcodePrefix
			when 0x00
				if (@modrmArray[opcode])
					modrm = 0xff & @source.getByte()
					bytesRead += 1
				else
					modrm = -1

				if (modrm == -1) || ((prefices & @PREFICES_ADDRESS) == 0)
					sib = -1
				else
					if (@sibArray[modrm])
						sib = 0xff & @source.getByte()
						bytesRead += 1
					else
						sib = -1
			when 0x0f
				if (@twoByte_0f_modrmArray[0xff & opcode])
					modrm = 0xff & @source.getByte()
					bytesRead += 1
				else
					modrm = -1

				if modrm == -1 || ((prefices & @PREFICES_ADDRESS) == 0)
					sib = -1
				else
					if (@twoByte_0f_sibArray[modrm])
						sib = 0xff & @source.getByte()
						byteRead += 1
					else
						sib = -1
			when 0xd8, 0xd9, 0xda, 0xdb, 0xdc, 0xd, 0xde, 0xdf
				if (@sibArray[modrm])
					sib = 0xff & @source.getByte()
					bytesRead += 1
				else
					sib = -1
			else
				modrm = -1
				sib = -1
		if (@isJump(opcode, modrm))
			@working.write(@EIP_UPDATE)


		displacement = 0

		switch (@operationHasDisplacement(prefices, opcode, modrm, sib))
			when 0
				break
			when 1
				displacement = @source.getByte()
				bytesRead += 1
			when 2
				displacement = (@source.getByte() & 0xff) | ((@source.getByte() << 8) & 0xff00)
				bytesRead += 2
			when 4
				displacement = (@source.getByte() & 0xff) | ((@source.getByte() << 8) & 0xff00) | ((@source.getByte() << 16) & 0xff0000) | ((@source.getByte() << 24) & 0xff000000)
				bytesRead += 4
			else
				log "Invalid byte result for displacement"

		immediate = 0

		switch (@operationHasImmediate(prefices, opcode, modrm))
			when 0
				break
			when 1
				immediate = @source.getByte()
				bytesRead += 1
			when 2
				immediate = (@source.getByte() & 0xff) | ((@source.getByte() << 8) & 0xff00)
				bytesRead += 2

			when 3
				immediate = ((@source.getByte() << 16) & 0xff0000) | ((@source.getByte() << 24) & 0xff000000) | (@source.getByte() & 0xff)
				bytesRead += 3
			when 4
				immediate = (@source.getByte() & 0xff) | ((@source.getByte() << 8) & 0xff00) | ((@source.getByte() << 16) & 0xff0000) | ((@source.getByte() << 24) & 0xff000000)
				bytesRead += 4

			when 6
				immediate = 0xffffffff & ((@source.getByte() & 0xff) | ((@source.getByte() << 8) & 0xff00) | ((@source.getByte() << 16) & 0xff0000) | ((@source.getByte() << 24) & 0xff000000))
				immediate |= ((@source.getByte() & 0xff) | ((@source.getByte() << 8) & 0xff00)) << 32
			else
				log "Immediate byte invalid"

		log "displacement: #{displacement} immediate: #{immediate}"

		@writeInputOperands(prefices, opcode, modrm, sib, displacement, immediate)

		@writeOperation(prefices, opcode, modrm)

		@writeOutputOperands(prefices, opcode, modrm, sib, displacement)

		if (@isJump(opcode, modrm))
			return -bytesRead
		else
			return bytesRead
	# operationHasDisplacement switch values:
	# 0x00: //ADD  Eb, Gb
	# 0x01: //ADD Ev, Gv
	# 0x02: //ADD Gb, Eb
	# 0x03: //ADD Gv, Ev
	# 0x08: //OR   Eb, Gb
	# 0x09: //OR  Ev, Gv
	# 0x0a: //OR  Gb, Eb
	# 0x0b: //OR  Gv, Ev
	# 0x10: //ADC  Eb, Gb
	# 0x11: //ADC Ev, Gv
	# 0x12: //ADC Gb, Eb
	# 0x13: //ADC Gv, Ev
	# 0x18: //SBB  Eb, Gb
	# 0x19: //SBB Ev, Gv
	# 0x1a: //SBB Gb, Eb
	# 0x1b: //SBB Gv, Ev
	# 0x20: //AND  Eb, Gb
	# 0x21: //AND Ev, Gv
	# 0x22: //AND Gb, Eb
	# 0x23: //AND Gv, Ev
	# 0x28: //SUB  Eb, Gb
	# 0x29: //SUB Ev, Gv
	# 0x2a: //SUB Gb, Eb
	# 0x2b: //SUB Gv, Ev
	# 0x30: //XOR  Eb, Gb
	# 0x31: //XOR Ev, Gv
	# 0x32: //XOR Gb, Eb
	# 0x33: //XOR Gv, Ev
	# 0x38: //CMP  Eb, Gb
	# 0x39: //CMP  Ev, Gv
	# 0x3a: //CMP Gb, Eb
	# 0x3b: //CMP Gv, Ev
	# 0x62: //BOUND Gv, Ma
	# 0x69: //IMUL Gv, Ev, Iv
	# 0x6b: //IMUL Gv, Ev, Ib
	# 0x80: //IMM G1 Eb, Ib
	# 0x81: //IMM G1 Ev, Iv
	# 0x82: //IMM G1 Eb, Ib
	# 0x83: //IMM G1 Ev, Ib
	# 0x84: //TEST Eb, Gb
	# 0x85: //TEST Ev, Gv
	# 0x86: //XCHG Eb, Gb
	# 0x87: //XCHG Ev, Gv
	# 0x88: //MOV  Eb, Gb
	# 0x89: //MOV  Ev, Gv
	# 0x8a: //MOV Gb, Eb
	# 0x8b: //MOV Gv, Ev
	# 0x8c: //MOV Ew, Sw
	# 0x8d: //LEA Gv, M
	# 0x8e: //MOV Sw, Ew
	# 0x8f: //POP Ev
	# 0xc0: //SFT G2 Eb, Ib
	# 0xc1: //SFT G2 Ev, Ib
	# 0xc4: //LES Gv, Mp
	# 0xc5: //LDS Gv, Mp
	# 0xc6: //MOV G11 Eb, Ib
	# 0xc7: //MOV G11 Ev, Iv
	# 0xd0: //SFT G2 Eb, 1
	# 0xd1: //SFT G2 Ev, 1
	# 0xd2: //SFT G2 Eb, CL
	# 0xd3: //SFT G2 Ev, CL
	# 0xf6: //UNA G3 Eb, ?
	# 0xf7: //UNA G3 Ev, ?
	# 0xfe: //INC/DEC G4 Eb
	# 0xff: //INC/DEC G5

	# 0xf00: //Grp 6
	# 0xf01: //Grp 7

	# 0xf20: //MOV Rd, Cd
	# 0xf22: //MOV Cd, Rd

	# 0xf40: //CMOVO
	# 0xf41: //CMOVNO
	# 0xf42: //CMOVC
	# 0xf43: //CMOVNC
	# 0xf44: //CMOVZ
	# 0xf45: //CMOVNZ
	# 0xf46: //CMOVBE
	# 0xf47: //CMOVNBE
	# 0xf48: //CMOVS
	# 0xf49: //CMOVNS
	# 0xf4a: //CMOVP
	# 0xf4b: //CMOVNP
	# 0xf4c: //CMOVL
	# 0xf4d: //CMOVNL
	# 0xf4e: //CMOVLE
	# 0xf4f: //CMOVNLE

	# 0xf90: //SETO
	# 0xf91: //SETNO
	# 0xf92: //SETC
	# 0xf93: //SETNC
	# 0xf94: //SETZ
	# 0xf95: //SETNZ
	# 0xf96: //SETBE
	# 0xf97: //SETNBE
	# 0xf98: //SETS
	# 0xf99: //SETNS
	# 0xf9a: //SETP
	# 0xf9b: //SETNP
	# 0xf9c: //SETL
	# 0xf9d: //SETNL
	# 0xf9e: //SETLE
	# 0xf9f: //SETNLE

	# 0xfa3: //BT Ev, Gv
	# 0xfa4: //SHLD Ev, Gv, Ib
	# 0xfa5: //SHLD Ev, Gv, CL
	# 0xfab: //BTS Ev, Gv
	# 0xfac: //SHRD Ev, Gv, Ib
	# 0xfad: //SHRD Ev, Gv, CL

	# 0xfaf: //IMUL Gv, Ev

	# 0xfb0: //CMPXCHG Eb, Gb
	# 0xfb1: //CMPXCHG Ev, Gv
	# 0xfb2: //LSS Mp
	# 0xfb3: //BTR Ev, Gv
	# 0xfb4: //LFS Mp
	# 0xfb5: //LGS Mp
	# 0xfb6: //MOVZX Gv, Eb
	# 0xfb7: //MOVZX Gv, Ew

	# 0xfba: //Grp 8 Ev, Ib
	# 0xfbb: //BTC Ev, Gv
	# 0xfbc: //BSF Gv, Ev
	# 0xfbd: //BSR Gv, Ev
	# 0xfbe: //MOVSX Gv, Eb
	# 0xfbf: //MOVSX Gv, Ew
	# 0xfc0: //XADD Eb, Gb
	# 0xfc1: //XADD Ev, Gv

	# 0xfc7: //CMPXCHG8B

	# 0xa0: //MOV AL, Ob
	# 0xa2: //MOV Ob, AL
	# 0xa1: //MOV eAX, Ov
	# 0xa3: //MOV Ov, eAX
	operationHasDisplacement: (prefices, opcode, modrm,sib) ->
		switch opcode
			when 0x00, 0x01, 0x02, 0x03, 0x08, 0x09, 0x0a, 0x0b, 0x10, 0x11, 0x12, 0x13, 0x18, 0x19, 0x1a, 0x1b, 0x20, 0x21, 0x22, 0x23, 0x28, 0x29, 0x2a, 0x2b, 0x30, 0x31, 0x32, 0x33, 0x38, 0x39, 0x3a, 0x3b, 0x62, 0x69, 0x6b, 0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87, 0x88, 0x89, 0x8a, 0x8b, 0x8c, 0x8d, 0x8e, 0x8f, 0xc0, 0xc1, 0xc4, 0xc5, 0xc6, 0xc7, 0xd0, 0xd1, 0xd2, 0xd3, 0xf6, 0xf7, 0xfe, 0xff, 0xf00, 0xf01, 0xf20, 0xf22, 0xf40, 0xf41, 0xf42, 0xf43, 0xf44, 0xf45, 0xf46, 0xf47, 0xf48, 0xf49, 0xf4a, 0xf4b, 0xf4c, 0xf4d, 0xf4e, 0xf4f, 0xf90, 0xf91, 0xf92, 0xf93, 0xf94, 0xf95, 0xf96, 0xf97, 0xf98, 0xf99, 0xf9a, 0xf9b, 0xf9c, 0xf9d, 0xf9e, 0xf9f, 0xfa3, 0xfa4, 0xfa5, 0xfab, 0xfac, 0xfad, 0xfaf, 0xfb0, 0xfb1, 0xfb2, 0xfb3, 0xfb4, 0xfb5, 0xfb6, 0xfb7, 0xfba, 0xfbb, 0xfbc, 0xfbd, 0xfbe, 0xfbf, 0xfc0, 0xfc1, 0xfc7
				return @modrmHasDisplacement(prefices, modrm, sib)
			when 0xd800, 0xd900, 0xda00, 0xdb00, 0xdc00, 0xdd00, 0xde00, 0xdf00
				if ((modrm & 0xc0) != 0xc0)
					return @modrmHasDisplacement(prefices, modrm, sib)
				else
					return 0
			when 0xa0, 0xa2, 0xa1, 0xa3
				if ((prefices & @PREFICES_ADDRESS) != 0)
					return 4
				else
					return 2
			else
				return 0

	modrmHasDisplacement: (prefices, modrm, sib) ->
		if ((prefices & @PREFICES_ADDRESS) != 0)
			switch (modrm & 0xc0)
				when 0x00
					switch (modrm & 0x7)
						when 0x4
							if ((sib & 0x7) == 0x5)
								return 4
							else
								return 0
						when 0x5
							return 4
				when 0x40
					return 1
				when 0x80
					return 4
		else
			switch (modrm & 0xc0)
				when 0x00
					if ((modrm & 0x7) == 0x6)
						return 2
					else
						return 0
				when 0x40
					return 1
				when 0x80
					return 2
		return 0

	# 0x04: //ADD AL, Ib
	# 0x0c: //OR  AL, Ib
	# 0x14: //ADC AL, Ib
	# 0x1c: //SBB AL, Ib
	# 0x24: //AND AL, Ib
	# 0x2c: //SUB AL, Ib
	# 0x34: //XOR AL, Ib
	# 0x3c: //CMP AL, Ib
	# 0x6a: //PUSH Ib
	# 0x6b: //IMUL Gv, Ev, Ib
	# 0x70: //Jcc Jb
	# 0x71:
	# 0x72:
	# 0x73:
	# 0x74:
	# 0x75:
	# 0x76:
	# 0x77:
	# 0x78:
	# 0x79:
	# 0x7a:
	# 0x7b:
	# 0x7c:
	# 0x7d:
	# 0x7e:
	# 0x7f:
	# 0x80: //IMM G1 Eb, Ib
	# 0x82: //IMM G1 Eb, Ib
	# 0x83: //IMM G1 Ev, Ib
	# 0xa8: //TEST AL, Ib
	# 0xb0: //MOV AL, Ib
	# 0xb1: //MOV CL, Ib
	# 0xb2: //MOV DL, Ib
	# 0xb3: //MOV BL, Ib
	# 0xb4: //MOV AH, Ib
	# 0xb5: //MOV CH, Ib
	# 0xb6: //MOV DH, Ib
	# 0xb7: //MOV BH, Ib
	# 0xc0: //SFT G2 Eb, Ib
	# 0xc1: //SFT G2 Ev, Ib
	# 0xc6: //MOV G11 Eb, Ib
	# 0xcd: //INT Ib
	# 0xd4: //AAM Ib
	# 0xd5: //AAD Ib
	# 0xe0: //LOOPNZ Jb
	# 0xe1: //LOOPZ Jb
	# 0xe2: //LOOP Jb
	# 0xe3: //JCXZ Jb
	# 0xe4: //IN  AL, Ib
	# 0xe5: //IN eAX, Ib
	# 0xe6: //OUT Ib, AL
	# 0xe7: //OUT Ib, eAX
	# 0xeb: //JMP Jb
	# 0xfa4: //SHLD Ev, Gv, Ib
	# 0xfac: //SHRD Ev, Gv, Ib
	# 0xfba: //Grp 8 Ev, Ib

	# 0xc2: //RET Iw
	# 0xca: //RETF Iw

	# 0xc8: //ENTER Iw, Ib

	# 0x05: //ADD eAX, Iv
	# 0x0d: //OR  eAX, Iv
	# 0x15: //ADC eAX, Iv
	# 0x1d: //SBB eAX, Iv
	# 0x25: //AND eAX, Iv
	# 0x2d: //SUB eAX, Iv
	# 0x35: //XOR eAX, Iv
	# 0x3d: //CMP eAX, Iv
	# 0x68: //PUSH Iv
	# 0x69: //IMUL Gv, Ev, Iv
	# 0x81: //IMM G1 Ev, Iv
	# 0xa9: //TEST eAX, Iv
	# 0xb8: //MOV eAX, Iv
	# 0xb9: //MOV eCX, Iv
	# 0xba: //MOV eDX, Iv
	# 0xbb: //MOV eBX, Iv
	# 0xbc: //MOV eSP, Iv
	# 0xbd: //MOV eBP, Iv
	# 0xbe: //MOV eSI, Iv
	# 0xbf: //MOV eDI, Iv
	# 0xc7: //MOV G11 Ev, Iv
	# 0xe8: //CALL Jv
	# 0xe9: //JMP  Jv
	# 0xf80: //JO Jv
	# 0xf81: //JNO Jv
	# 0xf82: //JC Jv
	# 0xf83: //JNC Jv
	# 0xf84: //JZ Jv
	# 0xf85: //JNZ Jv
	# 0xf86: //JNA Jv
	# 0xf87: //JA Jv
	# 0xf88: //JS Jv
	# 0xf89: //JNS Jv
	# 0xf8a: //JP Jv
	# 0xf8b: //JNP Jv
	# 0xf8c: //JL Jv
	# 0xf8d: //JNL Jv
	# 0xf8e: //JNG Jv
	# 0xf8f: //JG Jv
	# 0x9a: //CALLF Ap
	# 0xea: //JMPF Ap
	# 0xf6: //UNA G3 Eb, ?
	# 0xf7: //UNA G3 Ev, ?
	operationHasImmediate: (prefices, opcode, modrm) ->
		switch opcode
			when 0x04, 0x0c, 0x14, 0x1c, 0x24, 0x2c, 0x34, 0x3c, 0x6a, 0x6b, 0x70, 0x71, 0x72, 0x73, 0x74, 0x75, 0x76, 0x77, 0x78, 0x79, 0x7a, 0x7b, 0x7c, 0x7d, 0x7e, 0x7f, 0x80, 0x82, 0x83, 0xa8, 0xb0, 0xb1, 0xb2, 0xb3, 0xb4, 0xb5, 0xb6, 0xb7, 0xc0, 0xc1, 0xc6, 0xcd, 0xd4, 0xd5, 0xe0, 0xe1, 0xe2, 0xe3, 0xe4, 0xe5, 0xe6, 0xe7, 0xeb, 0xfa, 0xfa, 0xfba
				return 1
			when 0xc2, 0xca
				return 2
			when 0xc8
				return 3
			when 0x05, 0x0d, 0x15, 0x1d, 0x25, 0x2d, 0x35, 0x3d, 0x68, 0x69, 0x81, 0xa9, 0xb8, 0xb9, 0xba, 0xbb, 0xbc, 0xbd, 0xbe, 0xbf, 0xc7, 0xe8, 0xe9, 0xf80, 0xf81, 0xf82, 0xf83, 0xf84, 0xf85, 0xf86, 0xf87, 0xf88, 0xf89, 0xf8a, 0xf8b, 0xf8c, 0xf8d, 0xf8e, 0xf8f
				 if ((prefices & @PREFICES_OPERAND) != 0)
				 	return 4
				 else
				 	return 2
			when 0x9a, 0xea
				if ((prefices & @PREFICES_OPERAND) != 0)
					return 6
				else
					return 4
			when 0xf6
				switch (modrm & 0x38)
					when 0x00
						return 1
					else
						return 0
			when 0xf7
				switch (modrm & 0x38)
					when 0x00
						if ((precies & @PRECICES_OPERAND) != 0)
							return 4
						else
							return 2
					else
						return 0
		return 0

	writeInputOperands: (prefices, opcode, modrm, sib, displacement, immediate) ->
		log "WriteInputOperands(#{opcode})"
		switch (opcode)
			when 0xf9
				log "no action"

			when 0x00, 0x08, 0x10, 0x18, 0x20, 0x28, 0x30, 0x38, 0x84, 0x86
				@load0_Eb(prefices, modrm, sib, displacement)
				@load1_Gb(modrm)
			when 0xb8, 0xb9, 0xba, 0xbb, 0xbc, 0xbd, 0xbe, 0xbf
				if ((prefices & @PREFICES_OPERAND))
					@working.write(@LOAD0_ID)
					@working.write(immediate)
				else
					@working.write(@LOAD0_IW)
					@working.write(immediate)
			when 0x01, 0x09, 0x11, 0x19, 0x21, 0x29, 0x31, 0x39, 0x85, 0x87
				if ((prefices & @PREFICES_OPERAND) != 0)
					@load0_Ed(prefices, modrm, sib, displacement)
					@load1_Gd(modrm)
				else
					@load0_Ew(prefices, modrm, sib, displacement)
					@load1_Gw(modrm)

			when 0x41, 0x49, 0x51
				if ((prefices & @PREFICES_OPERAND) != 0)
					@working.write(@LOAD0_ECX)
				else
					@working.write(@LOAD0_CX)
			when 0x43, 0x4b, 0x53
				if ((prefices & @PREFICES_OPERAND) != 0)
					@working.write(@LOAD0_EBX)
				else
					@working.write(@LOAD0_BX)
			when 0x40, 0x48, 0x50
				if ((prefices & @PREFICES_OPERAND) != 0)
					@working.write(@LOAD0_EAX)
				else
					@working.write(@LOAD0_AX)
			when 0xc7, 0x68, 0x6a, 0xe8, 0xe9, 0xf80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x86, 0x88, 0x89, 0x8a, 0x8b, 0x8c, 0x8d, 0x8e, 0x8f
				if ((prefices & @PREFICES_OPERAND) != 0)
					@working.write(@LOAD0_ID)
					@working.write(immediate)
				else
					@working.write(@LOAD0_IW)
					@working.write(immediate)
			when 0x80, 0x82, 0xc0
				@load0_Eb(prefices, modrm, sib, displacement)
				@working.write(@LOAD1_IB)
				@working.write(immediate)
			when 0x02, 0x0a, 0x12, 0x1a, 0x22, 0x2a, 0x32, 0x3a, 0xfc0
				@load0_Gb(modrm)
				@load1_Eb(prefices, modrm, sib, displacement)

			when 0x1e
				@working.write(@LOAD0_DS)

			when 0x16
				@working.write(@LOAD0_SS)

			when 0xf01
				switch modrm & 0x38
					when 0x10, 0x18
						@load0_Ew(prefices, modrm, sib, displacement)
						@working.write(@ADDR_ID)
						@working.write(2)
						@working.write(@LOAD0_MEM_DWORD)
					when 0x30
						@load0_Ew(prefices, modrm, sib, displacement)
					when 0x38
						@decodeM(prefices, modrm, sib, displacement)

			when 0x92
				if ((prefices & @PREFICES_OPERAND) != 0)
					@working.write(@LOAD0_EAX)
					@working.write(@LOAD1_EDX)
				else
					@working.write(@LOAD0_AX)
					@working.write(@LOAD1_DX)
			when 0xc6, 0xb0, 0xb1, 0xb2, 0xb3, 0xb4, 0xb5, 0xb6, 0xb7, 0xe4, 0x70, 0x71, 0x72, 0x73, 0x74, 0x75, 0x76, 0x77, 0x78, 0x79, 0x7a, 0x7b, 0x7c, 0x7d, 0x7e, 0x7f, 0xcd, 0xd4, 0xd5, 0xe0, 0xe1, 0xe2, 0xe3, 0xeb, 0xe5
				@working.write(@LOAD0_IB)
				@working.write(immediate)
			when 0xa4, 0xa5, 0xa6, 0xa7, 0xac, 0xad
				@decodeSegmentPrefix(prefices)
			when 0xff
				if ((prefices & @PREFICES_OPERAND) != 0)
					switch (modrm & 0x38)
						when 0x00, 0x08, 0x10, 0x20, 0x30
							@load0_Ed(prefices, modrm, sib, displacement)
						when 0x18, 0x28
							@load0_Ed(prefices, modrm, sib, displacement)
							@working.write(@ADDR_IB)
							@working.write(4)
							@working.write(@LOAD1_MEM_WORD)
				else
					switch (modrm & 0x38)
						when 0x00, 0x08, 0x10, 0x20, 0x30
							@load0_Ew(prefices, modrm, sib, displacement)
						when 0x18, 0x28
							@load0_Ew(prefices, modrm, sib, displacement)
							@working.write(@ADDR_IB)
							@working.write(2)
							@working.write(@LOAD1_MEM_WORD)

			when -1
				log "-1"
			else
				throw "ProtectedModeUdecoded, writeInputOperands, Non supported opcode, Got opcode #{opcode}"


	# 0x00: ADD Eb, Gb
	# 0x01: ADD Ev, Gv
	# 0x02: ADD Gb, Eb
	# 0x03: ADD Gv, Ev
	# 0x04: ADD AL, Ib
	# 0x05: ADD eAX, Iv
	# 0xfc0: XADD Eb, Gb
	# 0xfc1: XADD Ev, Gv

	# 0x86: //XCHG Eb, Gb
	# 0x87: //XCHG Ev, Gv
	# 0x88: //MOV Eb, Gb
	# 0x89: //MOV Ev, Gv
	# 0x8a: //MOV Gb, Eb
	# 0x8b: //MOV Gv, Ev
	# 0x8c: //MOV Ew, Sw
	# 0x8d: //LEA Gv, M
	# 0x8e: //MOV Sw, Ew

	# 0x91: //XCHG eAX, eCX
	# 0x92: //XCHG eAX, eCX
	# 0x93: //XCHG eAX, eCX
	# 0x94: //XCHG eAX, eCX
	# 0x95: //XCHG eAX, eCX
	# 0x96: //XCHG eAX, eCX
	# 0x97: //XCHG eAX, eCX

	# 0xa0: //MOV AL, Ob
	# 0xa1: //MOV eAX, Ov
	# 0xa2: //MOV Ob, AL
	# 0xa3: //MOV Ov, eAX

	# 0xb0: //MOV AL, Ib
	# 0xb1: //MOV CL, Ib
	# 0xb2: //MOV DL, Ib
	# 0xb3: //MOV BL, Ib
	# 0xb4: //MOV AH, Ib
	# 0xb5: //MOV CH, Ib
	# 0xb6: //MOV DH, Ib
	# 0xb7: //MOV BH, Ib

	# 0xb8: //MOV eAX, Iv
	# 0xb9: //MOV eCX, Iv
	# 0xba: //MOV eDX, Iv
	# 0xbb: //MOV eBX, Iv
	# 0xbc: //MOV eSP, Iv
	# 0xbd: //MOV eBP, Iv
	# 0xbe: //MOV eSI, Iv
	# 0xbf: //MOV eDI, Iv

	# 0xc4: //LES
	# 0xc5: //LDS
	# 0xc6: //MOV GP11 Eb, Gb
	# 0xc7: //MOV GP11 Ev, Gv

	# 0xd7: //XLAT
	writeOperation: (prefices, opcode, modrm) ->
#		log "WriteOperation(#{opcode})"
		switch opcode
			when 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0xfc0, 0xfc1
				@working.write(@ADD)

			when 0x86, 0x87, 0x88, 0x89, 0x8a, 0x8b, 0x8c, 0x8d, 0x8e, 0x91, 0x92, 0x93, 0x94, 0x95, 0x96, 0x97, 0xa0, 0xa1, 0xa2, 0xa3, 0xb0, 0xb1, 0xb2, 0xb3, 0xb4, 0xb5, 0xb6, 0xb7, 0xb8, 0xb9, 0xba, 0xbb, 0xbc, 0xbd, 0xbe, 0xbf, 0xc4, 0xc5, 0xc6, 0xc7, 0xd7
				break

			when 0x06, 0x0e, 0x16, 0x1e, 0x50, 0x51, 0x52, 0x53, 0x54, 0x55, 0x56, 0x57, 0x68, 0x6a, 0xfa0, 0xfa8

				switch (prefices & (@PREFICES_OPERAND | @PREFICES_ADDRESS))
					when 0
						@working.write(@PUSH_O16_A16)
					when @PREFICES_OPERAND
						@working.write(@PUSH_O32_A16)
					when @PREFICES_ADDRESS
						@working.write(@PUSH_O16_A31)
					when @PREFICES_ADDRESS | @PREFICES_OPERAND
						@working.write(@PUSH_O32_A32)
			when 0xe8
				switch (prefices & (@PREFICES_OPERAND | @PREFICES_ADDRESS))
					when 0
						@working.write(@CALL_O16_A16)
					when @PREFICES_OPERAND
						@working.write(@CALL_O32_A16)
					when @PREFICES_ADDRESS
						@working.write(@CALL_O16_A31)
					when @PREFICES_ADDRESS | @PREFICES_OPERAND
						@working.write(@CALL_O32_A32)
			when 0x80, 0x81, 0x82, 0x83
				switch modrm & 0x38
					when 0x00
						@working.write(@ADD)
					when 0x08
						@working.write(@OR)
					when 0x10
						@working.write(@ADC)
					when 0x18
						@working.write(@SBB)
					when 0x20
						@working.write(@AND)
					when 0x28, 0x38
						@working.write(@SUB)
					when 0x30
						@working.write(@XOR)
			when 0xf01
				switch modrm & 0x38
					when 0x00
						if ((prefices & @PREFICES_OPERAND) != 0)
							@working.write(@SGDT_O32)
						else
							@working.write(@SGDT_O16)
					when 0x08
						if ((prefices & @PREFICES_OPERAND) != 0)
							@working.write(@SGDT_O32)
						else
							@working.write(@SGDT_O16)
					when 0x10
						if ((prefices & @PREFICES_OPERAND) != 0)
							@working.write(@LGDT_O32)
						else
							@working.write(@LGDT_O16)
					when 0x18
						if ((prefices & @PREFICES_OPERAND) != 0)
							@working.write(@LIDT_O32)
						else
							@working.write(@LIDT_O16)
					when 0x20
						@working.write(@SMSW)
					when 0x30
						@working.write(@LMSW)
					when 0x38
						@working.write(@INVLPG)
					else
						throw new IllegalStateException("Invalid Gp 7 Instruction?")

			when 0xe2
				if ((prefices & @PREFICES_ADDRESS) != 0)
					@working.write(@LOOP_ECX)
				else
					@working.write(@LOOP_CX)
			when 0x48, 0x49, 0x4a, 0x4b, 0x4c, 0x4d, 0x4e, 0x4f
				@working.write(@DEC)
			when 0xac
				if (prefices & @PREFICES_REP) != 0
					if (prefices & PREFICES_ADDRESS) != 0
						@working.write(@REP_LODSB_A32)
					else
						@working.write(@REP_LODSB_A16)
				else
					if (prefices & @PREFICES_ADDRESS) != 0
						@working.write(@LODSB_A32)
					else
						@working.write(@LODSB_A16)
			when 0xf9
				@working.write(@STC)

			when 0xff
				tmp = modrm & 0x38
				log tmp
				switch (modrm & 0x38)
					when 0x00
						@working.write(@INC)
					when 0x08
						@working.write(@DEC)
					when 0x10
						switch (prefices & (@PREFICES_OPERAND | @PREFICES_ADDRESS))
							when 0
								@working.write(@CALL_ABS_O16_A16)
							when @PREFICES_OPERAND
								@working.write(@CALL_ABS_O32_A16)
							when @PREFICES_
								@working.write(@CALL_ABS_O16_A32)
							when @PREFICES_ADDRESS | @PREFICES_OPERAND
								@working.write(@CALL_ABS_O32_A32)
					when 0x18
						switch (prefices & (@PREFICES_OPERAND | @PREFICES_ADDRESS))
							when 0
								@working.write(@CALL_FAR_O16_A16)
							when @PREFICES_OPERAND
								@working.write(@CALL_FAR_O32_A16)
							when @PREFICES_
								@working.write(@CALL_FAR_O16_A32)
							when @PREFICES_ADDRESS | @PREFICES_OPERAND
								@working.write(@CALL_FAR_O32_A32)
					when 0x20
						if ((prefices & @PREFICES_OPERAND) != 0)
							@working.write(@JUMP_ABS_O32)
						else
							@working.write(@JUMP_ABS_O16)
					when 0x28
						if ((prefices & @PREFICES_OPERAND) != 0)
							@working.write(@JUMP_FAR_O32)
						else
							@working.write(@JUMP_FAR_O16)
					when 0x30
						switch (prefices & (@PREFICES_OPERAND | @PREFICES_ADDRESS))
							when 0
								@working.write(@PUSH_O16_A16)
							when @PREFICES_OPERAND
								@working.write(@PUSH_O32_A16)
							when @PREFICES_
								@working.write(@PUSH_O16_A32)
							when @PREFICES_ADDRESS | @PREFICES_OPERAND
								@working.write(@PUSH_O32_A32)
					else
						log IllegalStateException("Invalid Gp 5 Instruction? FF modrm=" + modrm )
			else throw "ProtectedModeUdecoded, Got non supported opcode @writeOperation #{opcode}"

	writeOutputOperands: (prefices, opcode, modrm, sib, displacement) ->
		switch opcode
			# One byte operation
			when 0x00, 0x08, 0x10, 0x18, 0x20, 0x28, 0x30, 0x88, 0xc0, 0xc6, 0xfe, 0xf90, 0xf91, 0xf92, 0xf93, 0xf94, 0xf95, 0xf96, 0xf97, 0xf98, 0xf99, 0xf9a, 0xf9b, 0xf9c, 0xf9d, 0xf9e, 0x9f
				@store0_Eb(prefices, modrm, sib, displacement)
			when 0x44, 0x4c, 0x5c, 0xbc
				if ((prefices & @PREFICES_OPERAND) != 0)
					@working.write(@STORE_ESP)
				else
					@working.write(@STORE0_SP)
			when 0x01, 0x09, 0x11, 0x19, 0x21, 0x29, 0x31, 0x89, 0xc7, 0xc1, 0x8f, 0xd1, 0xd3
				if ((prefices & @PREFICES_OPERAND) != 0)
					@store0_Ed(prefices, modrm, sib, displacement)
				else
					@store0_Ew(prefices, modrm, sib, displacement)
			when 0x03, 0x0b, 0x13, 0x1b, 0x23, 0x2b, 0x33, 0x69, 0x6b, 0x8b, 0x8d, 0xf02, 0xf03, 0xf40, 0xf41, 0xf42, 0xf43, 0xf44, 0xf45, 0xf46, 0xf47, 0xf48, 0xf49, 0xf4a, 0xf4b, 0xf4c, 0xf4d, 0xf4e, 0xf4f, 0xfaf, 0xfb6, 0xfb7, 0xfbc, 0xfbd, 0xfbe, 0xfbf
				if ((prefices & @PREFICES_OPERAND) != 0)
					@store0_Gd(modrm)
				else
					@store0_Gw(modrm)
			when 0x80, 0x82
				if (modrm & 0x38) == 0x38
					break
				@store0_Eb(prefices, modrm, sib, displacement)
			when 0x86
				@store0_Gb(modrm)
				@store1_Eb(prefices, modrm, sib, displacement)

			when 0x02, 0x0a, 0x12, 0x1a, 0x22, 0x2a, 0x32, 0x8a
				@store0_Gb(modrm)
			when 0xf01
				switch (modrm & 0x38)
					when 0x00, 0x08
						@store0_Ew(prefices, modrm, sib, displacement)
						@working.write(@ADDR_ID)
						@working.write(2)
						@working.write(@STORE1_MEM_DWORD)
					when 0x20
						@store0_Ew(prefices, modrm, sib, displacement)
			when 0x92

				if ((prefices & @PREFICES_OPERAND) != 0)
					@working.write(@STORE0_DEX)
					@working.write(@STORE1_EAX)
				else
					@working.write(@STORE0_DX)
					@working.write(@STORE1_AX)
			when 0x8e
				@store0_Sw(modrm)

			when 0x43, 0x4b, 0x5b, 0xbb
				if ((prefices & @PREFICES_OPERAND) != 0)
					@working.write(@STORE0_EBX)
				else
					@working.write(@STORE0_BX)


			when 0x51, 0x53, 0x50, 0xe8, 0x16, 0xe2, 0xac, 0xf9
				log "No action?"

			when 0xff
				rm = modrm & 0x38
				if ((prefices & @PREFICES_OPERAND) != 0)
					if (rm == 0x00 || rm == 0x08)
						@store0_Ed(prefices, modrm, sib, displacement)
				else
					if (rm == 0x00 || rm == 0x08)
						@store0_Ew(prefices, modrm, sib, displacement)

			when -1

			else
				throw "ProtectedModeUdecoded, Got not supported opcode @writeOutputOperands #{opcode}"



	load0_Eb: (prefices, modrm, sib, displacement) ->
		switch (modrm & 0xc7)
			when 0xc0
				@working.write(@LOAD0_AL)
			when 0xc1
				@working.write(@LOAD0_CL)
			when 0xc2
				@working.write(@LOAD0_DL)
			when 0xc3
				@working.write(@LOAD0_BL)
			when 0xc4
				@working.write(@LOAD0_AH)
			when 0xc5
				@working.write(@LOAD0_CH)
			when 0xc6
				@working.write(@LOAD0_DH)
			when 0xc7
				@working.write(@LOAD0_BH)
			else
				@decodeM(prefices, modrm, sib, displacement)
				@working.write(@LOAD0_MEM_BYTE)
	load1_Gb: (modrm) ->
		val = modrm & 0x38

		switch (val)
			when 0x00
				@working.write(@LOAD1_AL)
			when 0x08
				@working.write(@LOAD1_CL)
			when 0x10
				@working.write(@LOAD1_DL)
			when 0x18
				@working.write(@LOAD1_BL)
			when 0x20
				@working.write(@LOAD1_AH)
			when 0x28
				@working.write(@LOAD1_CH)
			when 0x30
				@working.write(@LOAD1_DH)
			when 0x38
				@working.write(@LOAD1_BH)
			else
				throw "Unknown Byte Register Operand #{val}"
	load0_Ew: (prefices, modrm, sib, displacement) ->
		switch (modrm & 0xc7)
			when 0xc0
				@working.write(@LOAD0_AX)
			when 0xc1
				@working.write(@LOAD0_CX)
			when 0xc2
				@working.write(@LOAD0_DX)
			when 0xc3
				@working.write(@LOAD0_BX)
			when 0xc4
				@working.write(@LOAD0_SP)
			when 0xc5
				@working.write(@LOAD0_BP)
			when 0xc6
				@working.write(@LOAD0_SI)
			when 0xc7
				@working.write(@LOAD0_DI)
			else
				@decodeM(prefices, modrm, sib, displacement)
				@working.write(@LOAD0_MEM_WORD)

	store0_Eb: (prefices, modrm, sib, displacement)	->
		switch (modrm & 0xc7)
			when 0xc0
				@working.write(@STORE0_AL)
			when 0xc1
				@working.write(@STORE0_CL)
			when 0xc2
				@working.write(@STORE0_DL)
			when 0xc3
				@working.write(@STORE0_BL)
			when 0xc4
				@working.write(@STORE0_AH)
			when 0xc5
				@working.write(@STORE0_CH)
			when 0xc6
				@working.write(@STORE0_DH)
			when 0xc7
				@working.write(@STORE0_BH)
			else
				@decodeM(prefices, modrm, sib, displacement)
				@working.write(@STORE0_MEM_BYTE)
	load1_Gw: (modrm) ->
		switch (modrm & 0x38)
			when 0x00
				@working.write(@LOAD1_AX)
			when 0x08
				@working.write(@LOAD1_CX)
			when 0x10
				@working.write(@LOAD1_DX)
			when 0x18
				@working.write(@LOAD1_BX)
			when 0x20
				@working.write(@LOAD1_SP)
			when 0x28
				@working.write(@LOAD1_BP)
			when 0x30
				@working.write(@LOAD1_SI)
			when 0x38
				@working.write(@LOAD1_DI)
			else
				throw new IllegalStateException("Unknown Word Register Operand")
	store0_Ew: (prefices, modrm, sib, displacement) ->
		switch (modrm & 0xc7)
			when 0xc0
				@working.write(@STORE0_AX)
			when 0xc1
				@working.write(@STORE0_CX)
			when 0xc2
				@working.write(@STORE0_DX)
			when 0xc3
				@working.write(@STORE0_BX)
			when 0xc4
				@working.write(@STORE0_SP)
			when 0xc5
				@working.write(@STORE0_BP)
			when 0xc6
				@working.write(@STORE0_SI)
			when 0xc7
				@working.write(@STORE0_DI)
			else
				@decodeM(prefices, modrm, sib, displacement)
				@working.write(@STORE0_MEM_WORD)
	store0_Gw: (modrm) ->
		switch modrm & 0x38
			when 0x00
				@working.write(@STORE0_AX)
			when 0x08
				@working.write(@STORE0_CX)
			when 0x10
				@working.write(@STORE0_DX)
			when 0x18
				@working.write(@STORE0_BX)
			when 0x20
				@working.write(@STORE0_SP)
			when 0x28
				@working.write(@STORE0_BP)
			when 0x30
				@working.write(@STORE0_SI)
			when 0x38
				@working.write(@STORE0_DI)
			else
				throw new IllegalStateException("Unknown Word Register Operand")
	store0_Gb: (modrm) ->
		switch modrm & 0x38
			when 0x00
				@working.write(@STORE0_AL)
			when 0x08
				@working.write(@STORE0_CL)
			when 0x10
				@working.write(@STORE0_DL)
			when 0x18
				@working.write(@STORE0_BL)
			when 0x20
				@working.write(@STORE0_AH)
			when 0x28
				@working.write(@STORE0_CH)
			when 0x30
				@working.write(@STORE0_DH)
			when 0x38
				@working.write(@STORE0_BH)
			else
				throw new IllegalStateException("Unknown Byte Register Operand")

	load0_Gb: (modrm) ->
		switch (modrm & 0x38)
			when 0x00
				@working.write(@LOAD1_AL)
			when 0x08
				@working.write(@LOAD1_CL)
			when 0x10
				@working.write(@LOAD1_DL)
			when 0x18
				@working.write(@LOAD1_BL)
			when 0x20
				@working.write(@LOAD1_AH)
			when 0x28
				@working.write(@LOAD1_CH)
			when 0x30
				@working.write(@LOAD1_DH)
			when 0x38
				@working.write(@LOAD1_BH)
			else
				throw new IllegalStateException("Unknown Byte Register Operand")

	store0_Sw: (modrm) ->
		switch (modrm & 0x38)
			when 0x00
				@working.write(@STORE0_ES)
			when 0x08
				@working.write(@STORE0_CS)
			when 0x10
				@working.write(@STORE0_SS)
			when 0x18
				@working.write(@STORE0_DS)
			when 0x20
				@working.write(@STORE0_FS)
			when 0x28
				@working.write(@STORE0_GS)
			else
				throw new IllegalStateException("Unknown Segment Register Operand")

	store1_Eb: (prefices, modrm, sib, displacement) ->
		switch (modrm & 0xc7)
			when 0xc0
				@working.write(@STORE1_AL)
			when 0xc1
				@working.write(@STORE1_CL)
			when 0xc2
				@working.write(@STORE1_DL)
			when 0xc3
				@working.write(@STORE1_BL)
			when 0xc4
				@working.write(@STORE1_AH)
			when 0xc5
				@working.write(@STORE1_CH)
			when 0xc6
				@working.write(@STORE1_DH)
			when 0xc7
				@working.write(@STORE1_BH)
			else
				@decodeM(prefices, modrm, sib, displacement)
				@working.write(@STORE1_MEM_BYTE)

	load1_Eb: (prefices, modrm, sib, displacement) ->
		switch (modrm & 0xc7)
			when 0xc0
				@working.write(@LOAD1_AL)
			when 0xc1
				@working.write(@LOAD1_CL)
			when 0xc2
				@working.write(@LOAD1_DL)
			when 0xc3
				@working.write(@LOAD1_BL)
			when 0xc4
				@working.write(@LOAD1_AH)
			when 0xc5
				@working.write(@LOAD1_CH)
			when 0xc6
				@working.write(@LOAD1_DH)
			when 0xc7
				@working.write(@LOAD1_BH)
			else
				@decodeM(prefices, modrm, sib, displacement)
				@working.write(@LOAD1_MEM_BYTE)


	isJump: (opcode, modrm) ->
		return @isNearJump(opcode, modrm) || @isFarJump(opcode, modrm) || @isModeSwitch(opcode, modrm) || @isBlockTerminating(opcode, modrm);

	isNearJump: (opcode, modrm)->
		switch (opcode)
			when 0x70, 0x71, 0x72, 0x73, 0x74, 0x74, 0x76, 0x77, 0x78, 0x79,0x7a, 0x7b, 0x7c, 0x7d, 0x7e, 0x7f, 0xc2, 0xc3, 0xe0, 0xe1, 0xe2, 0xe3, 0xe8, 0xe9, 0xeb
				return true
			when 0xff
				switch (modrm & 0x38)
					when 0x10, 0x20
						return true
					else
						return false
			when 0x0f80, 0x0f81, 0x0f82, 0x0f83, 0x0f84, 0x0f85, 0x0f86, 0x0f87, 0x0f88, 0x0f89, 0x0f8, 0x0f8a, 0x0f8b, 0x0f8c, 0x0f8d, 0x0f8e, 0x0f8f
				return true
			else
				return false

	isFarJump: (opcode, modrm) ->
		switch (opcode)
			when 0x9a, 0xca, 0xcb, 0xcc, 0xcd, 0xce, 0xcf, 0xea, 0xf1, 0xf34, 0xf35
				return true
			when 0xff
				switch (modrm & 0x38)
					when 0x18, 0x28
						return true
					else
						return false
			else
				return false
	isModeSwitch: (opcode, modrm) ->
		#Should we give a exception as we only support 1 mode?
		switch (opcode)
			when 0x0f22
				return true
			when 0x0f01
				return ((modrm & 0x38) == 0x30)
			else
				return false
	isBlockTerminating: (opcode, modrm) ->
		switch (opcode)
			when 0xf4
				return true
			else
				return false

	decodeM: (prefices, modrm, sib, displacement) ->
		if (!@decodingAddressMode())
			return

		if ((prefices & @PREFICES_ADDRESS) != 0)
			# 32 bit address

			switch (prefices & PREFICES_SG)
				when @PREFICES_CS
					@working.write(@LOAD_SEG_CS)
				when @PREFICES_DS
					@working.write(@LOAD_SEG_DS)
				when @PREFICES_SS
					@working.write(@LOAD_SEG_SS)
				when @PREFICES_ES
					@working.write(@LOAD_SEG_ES)
				when @PREFICES_FS
					@working.write(@LOAD_SEG_FS)
				when @PREFICES_GS
					@working.write(@LOAD_SEG_GS)
				else
					switch (modrm & 0xc7)
						when 0x04, 0x44, 0x84
							break
						when 0x45, 0x85
							@working.write(@LOAD_SEG_SS)
						else
							@working.write(@LOAD_SEG_DS)
			switch (modrm & 0x7)
				when 0x0
					@working.write(@ADDR_EAX)
				when 0x1
					@working.write(@ADDR_ECX)
				when 0x2
					@working.write(@ADDR_EDX)
				when 0x3
					@working.write(@ADDR_EBX)
				when 0x4
					@decodeSIB(prefices, modrm, displacement)
				when 0x5
					if ((modrm & 0xc0) == 0x00)
						@working.write(@ADDR_ID)
						@working.write(displacement)
					else
						@working.write(@ADDR_EBP)
				when 0x6
					@working.write(@ADDR_ESI)
				when 0x7
					@working.write(@ADDR_EDI)
			switch (modrm & 0xc0)
				when 0x40
					@working.write(@ADDR_IB)
					@working.write(displacement)

				when 0x80
					@working.write(@ADDR_ID)
					@working.write(displacement)

		else
			switch (prefices & @PREFICES_SG)
				when @PREFICES_CS
					@working.write(@LOAD_SEG_CS)
				when @PREFICES_DS
					@working.write(@LOAD_SEG_DS)
				when @PREFICES_SS
					@working.write(@LOAD_SEG_SS)
				when @PREFICES_ES
					@working.write(@LOAD_SEG_ES)
				when @PREFICES_FS
					@working.write(@LOAD_SEG_FS)
				when @PREFICES_GS
					@working.write(@LOAD_SEG_GS)
				else
					switch (modrm & 0xc7)
						when 0x02, 0x03, 0x42, 0x43, 0x46, 0x82, 0x83, 0x86
							@working.write(@LOAD_SEG_SS)
						else
							@working.write(@LOAD_SEG_DS)
			switch (modrm & 0x7)
				when 0x0
					@working.write(@ADDR_BX)
					@working.write(@ADDR_SI)
				when 0x1
					@working.write(@ADDR_BX)
					@working.write(@ADDR_DI)
				when 0x2
					@working.write(@ADDR_BP)
					@working.write(@ADDR_SI)
				when 0x3
					@working.write(@ADDR_BP)
					@working.write(@ADDR_DI)
				when 0x4
					@working.write(@ADDR_SI)
				when 0x5
					@working.write(@ADDR_DI)
				when 0x6
					if ((modrm & 0xc0) == 0x00)
						@working.write(@ADDR_IW)
						@working.write(displacement)
					else
						@working.write(@ADDR_BP)
				when 0x7
					@working.write(@ADDR_BX)
			switch (modrm & 0xc0)
				when 0x40
					@working.write(@ADDR_IB)
					@working.write(displacement)
				when 0x80
					@working.write(@ADDR_IW)
					@working.write(displacement)
			@working.write(@ADDR_MASK16)

	decodeSegmentPrefix: (prefices) ->
		switch (prefices & @PREFICES_SG)
			when @PREFICES_DS
				@working.write(@LOAD_SEG_DS)
			when @PREFICES_ES
				@working.write(@LOAD_SEG_ES)
			when @PREFICES_SS
				@working.write(@LOAD_SEG_SS)
			when @PREFICES_CS
				@working.write(@LOAD_SEG_CS)
			when @PREFICES_FS
				@working.write(@LOAD_SEG_FS)
			when @PREFICES_GS
				@working.write(@LOAD_SEG_GS)
			else
				@working.write(@LOAD_SEG_DS)


	decodingAddressMode: ->
#		return true
		#todo, check why
		if (@addressModeDecoded == true)
			return false
		else
			@addressModeDecoded = true
			return @addresModeDecoded
	toString: ->
		return "ProtectedModeUDecoder"

class Operation
	constructor: ->
		@microcodes = new Array()
		@microcodesLength = 0
		@x86Length = null
		@readOffset = null
		@decoded = null
		@terminal = null

	write: (microcode) ->
		if ((!microcode && microcode != 0) || microcode == null)
			throw new NotImplementedError("Cant set a undefined/null microcode: " + microcode)

		try
			log "Adding microcode #{microcode} to @microcodes[#{@microcodesLength}]"
			@microcodes[@microcodesLength] = microcode
			@microcodesLength++
		catch e
			throw e
#		int[] temp = new int[2*microcodes.length];
#		System.arraycopy(microcodes, 0, temp, 0, microcodes.length);
#		microcodes = temp;
#		microcodes[microcodesLength++] = microcode;

	replace: (offset, microcode) ->
		@microcodes[offset] = microcode

	finish: (x86Length) ->
		@x86Length = x86Length
		@decoded = true

	makeTerminal: ->
		@reset()
		@terminal = true

	reset: ->
		@microcodesLength = 0;
		@x86Length = 0;
		@readOffset = 0;
		@decoded = false;
		@terminal = false;

	getMicrocodeAt: (offset) ->
		return @microcodes[offset]

	getMicrocode: ->
		if (@readOffset < @microcodesLength)
			return @microcodes[@readOffset++]
		else
			throw "Illigal state (#{@readOffset}, #{@microcodesLength})"
	getLength: ->
		return @microcodesLength

	getX86Length: ->
		return @x86Length
