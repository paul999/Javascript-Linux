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
		@addressModeDecoded = false

		@decodeLimit = null

		@current = new Operation()
		@waiting = new Operation()
		@working = new Operation()

	decodeProtected: (source, operandSize, limit) ->
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

	setOperand: (size) ->

		if size and proc.isProtectedMode()
			@prefices = (@PREFICES_OPERAND | @PREFICES_ADDRESS)

	decodeOpcode: (operandSizeIs32Bit) ->
		opcode = 0
		opcodePrefix = 0

		@prefices = 0x00 # If in real mode it always is 0x00

		bytesRead = 0
		@modrm = -1
		@sib = -1
		lock = false

		while true
			read = bitand 0xff, @source.getByte()

			if (!read && read != 0 )
				throw new LengthIncorrectError("Read has been undefined, source: #{@source}, value: #{read}")

			opcode = read

			bytesRead += 1

			switch (opcode)
				when 0x0f
					log "Old opcode: #{opcode}"
					opcodePrefix = (opcodePrefix << 8) | opcode
					opcode = bitand 0xff, @source.getByte()
					log "new opcode #{opcode}"
					bytesRead += 1
					@modrm = opcode
#					throw "t"

				when 0xd8, 0xd9, 0xda, 0xdb, 0xdc, 0xdd, 0xde, 0xdf
					opcodePrefix = (opcodePrefix << 8) | opcode
					opcode = 0
					log "Opcode 0"
					@modrm =  bitand 0xff, @source.getByte()
					bytesRead += 1
				when 0x2e
					@prefices &= ~@PREFICES_SG
					@prefices |= @PREFICES_CS
					continue
				when 0x3e
					@prefices &= ~@PREFICES_SG
					@prefices |= @PREFICES_DS
					continue
				when 0x26
					@prefices &= ~@PREFICES_SG
					@prefices |= @PREFICES_ES
					continue
				when 0x36
					@prefices &= ~@PREFICES_SG
					@prefices |= @PREFICES_SS
					continue
				when 0x64
					@prefices &= ~@PREFICES_SG
					@prefices |= @PREFICES_FS
					continue
				when 0x65
					@prefices &= ~@PREFICES_SG
					@prefices |= @PREFICES_GS
					continue
				when 0x66
					if @operandSizeIs32Bit
						@prefices = bitand @prefices, ~@PREFICES_OPERAND
					else
						@prefices = @prefices | @PREFICES_OPERAND
					continue
				when 0x67
					if @operandSizeIs32Bit
						@prefices = bitand @prefices, ~@PREFICES_ADDRESS
					else
						@prefices = @prefices | @PREFICES_ADDRESS
					continue
				when 0xf2
					@prefices |= @PREFICES_REPNE
					continue
				when 0xf3
					@prefices |= @PREFICES_REPE
					continue
				when 0xf0
					lock = true
					@refices |= @PREFICES_LOCK
					continue
			break

		opcode = (opcodePrefix << 8) | opcode

		if opcode != 0
			log "Opcode Hex Found: 0x" + opcode.toString(16)

		switch opcodePrefix
			when 0x00
				if (@modrmArray[opcode])
					@modrm = bitand 0xff, @source.getByte()
					bytesRead += 1
				else
					@modrm = -1

				if (@modrm == -1)# || ((prefices & @PREFICES_ADDRESS) == 0)
					@sib = -1
				else
					if (@sibArray[@modrm])
						@sib = bitand 0xff, @source.getByte()
						bytesRead += 1
					else
						@sib = -1
			when 0x0f
				if (@twoByte_0f_modrmArray[bitand 0xff, opcode])
					@modrm = bitand 0xff, @source.getByte()
					bytesRead += 1
				else
					@modrm = -1

				if @modrm == -1 || ((bitand @prefices, @PREFICES_ADDRESS) == 0)
					@sib = -1
				else
					if (@twoByte_0f_sibArray[@modrm])
						@sib = bitand 0xff, @source.getByte()
						byteRead += 1
					else
						@sib = -1
			when 0xd8, 0xd9, 0xda, 0xdb, 0xdc, 0xd, 0xde, 0xdf
				if (@sibArray[@modrm])
					@sib = bitand 0xff, @source.getByte()
					bytesRead += 1
				else
					@sib = -1
			else
				@modrm = -1
				@sib = -1
		if (@isJump(opcode))
			@working.write(@EIP_UPDATE)


		displacement = 0

		switch (@operationHasDisplacement(opcode))
			when 0
				break
			when 1
				displacement = @source.getByte()
				bytesRead += 1
			when 2
				displacement = (bitand @source.getByte(), 0xff) | bitand((@source.getByte() << 8), 0xff00)
				bytesRead += 2
			when 4
				displacement = bitand(@source.getByte(), 0xff) | bitand((@source.getByte() << 8), 0xff00) | bitand((@source.getByte() << 16), 0xff0000) | bitand((@source.getByte() << 24), 0xff000000)
				bytesRead += 4
			else
				log "Invalid byte result for displacement"

		immediate = 0

		dat = @operationHasImmediate(opcode)
		switch (dat)
			when 0
				break
			when 1
				immediate = @source.getByte()
				bytesRead += 1
			when 2
				immediate = bitand(@source.getByte(), 0xff) | bitand((@source.getByte() << 8), 0xff00)
				bytesRead += 2

			when 3
				immediate = bitand((@source.getByte() << 16), 0xff0000) | bitand((@source.getByte() << 24), 0xff000000) | bitand(@source.getByte(), 0xff)
				bytesRead += 3
			when 4
				immediate = bitand(@source.getByte(), 0xff) | bitand((@source.getByte() << 8), 0xff00) | bitand((@source.getByte() << 16), 0xff0000) | bitand((@source.getByte() << 24), 0xff000000)
				bytesRead += 4

			when 6
				immediate = bitand(0xffffffff, (bitand(@source.getByte(), 0xff) | bitand((@source.getByte() << 8), 0xff00) | bitand((@source.getByte() << 16), 0xff0000) | bitand((@source.getByte() << 24), 0xff000000)))
				immediate |= (bitand(@source.getByte(), 0xff) | bitand((@source.getByte() << 8), 0xff00)) << 32
			else
				log "Immediate byte invalid"

		@writeInputOperands(opcode, displacement, immediate)

		@writeOperation(opcode)

		@writeOutputOperands(opcode, displacement)

		@writeFlags(opcode)

		if (@isJump(opcode))
			return -bytesRead
		else
			return bytesRead

	operationHasDisplacement: (opcode) ->
		switch opcode
			when 0x00, 0x01, 0x02, 0x03, 0x08, 0x09, 0x0a, 0x0b, 0x10, 0x11, 0x12, 0x13, 0x18, 0x19, 0x1a, 0x1b, 0x20, 0x21, 0x22, 0x23, 0x28, 0x29, 0x2a, 0x2b, 0x30, 0x31, 0x32, 0x33, 0x38, 0x39, 0x3a, 0x3b, 0x62, 0x69, 0x6b, 0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87, 0x88, 0x89, 0x8a, 0x8b, 0x8c, 0x8d, 0x8e, 0x8f, 0xc0, 0xc1, 0xc4, 0xc5, 0xc6, 0xc7, 0xd0, 0xd1, 0xd2, 0xd3, 0xf6, 0xf7, 0xfe, 0xff, 0xf00, 0xf01, 0xf20, 0xf22, 0xf40, 0xf41, 0xf42, 0xf43, 0xf44, 0xf45, 0xf46, 0xf47, 0xf48, 0xf49, 0xf4a, 0xf4b, 0xf4c, 0xf4d, 0xf4e, 0xf4f, 0xf90, 0xf91, 0xf92, 0xf93, 0xf94, 0xf95, 0xf96, 0xf97, 0xf98, 0xf99, 0xf9a, 0xf9b, 0xf9c, 0xf9d, 0xf9e, 0xf9f, 0xfa3, 0xfa4, 0xfa5, 0xfab, 0xfac, 0xfad, 0xfaf, 0xfb0, 0xfb1, 0xfb2, 0xfb3, 0xfb4, 0xfb5, 0xfb6, 0xfb7, 0xfba, 0xfbb, 0xfbc, 0xfbd, 0xfbe, 0xfbf, 0xfc0, 0xfc1, 0xfc7
				val = @modrmHasDisplacement()

				if opcode == 0xc7
					log "returned value: " + val
					return 2
				return val

			when 0xd800, 0xd900, 0xda00, 0xdb00, 0xdc00, 0xdd00, 0xde00, 0xdf00
				if (bitand(modrm, 0xc0) != 0xc0)
					return @modrmHasDisplacement()
				else
					return 0
			when 0xa0, 0xa2, 0xa1, 0xa3
				if (bitand(@prefices, @PREFICES_ADDRESS) != 0)
					return 4
				else
					return 2
			else
				return 0


	modrmHasDisplacement: () ->

		if (bitand(@prefices, @PREFICES_ADDRESS) != 0)
			#32 bit address size
			switch(bitand @modrm, 0xc0)
				when 0x00
					switch (bitand @modrm, 0x7)
						when 0x4
							if (bitand(@sib, 0x7) == 0x5)
								return 4
							else
								return 0
						when 0x5
							return 4
				when 0x40
					return 1 #IB
				when 0x80
					return 4 #ID
		else
			#16 bit address size
			switch(bitand @modrm, 0xc0)
				when 0x00
					if (bitand(@modrm, 0x7) == 0x6)
						return 2
					else
						return 0
				when 0x40
					return 1 #IB
				when 0x80
					return 2 #IW

		return 0


	operationHasImmediate: (opcode) ->
		switch opcode
			when 0x04, 0x0c, 0x14, 0x1c, 0x24, 0x2c, 0x34, 0x3c, 0x6a, 0x6b, 0x70, 0x71, 0x72, 0x73, 0x74, 0x75, 0x76, 0x77, 0x78, 0x79, 0x7a, 0x7b, 0x7c, 0x7d, 0x7e, 0x7f, 0x80, 0x82, 0x83, 0xa8, 0xb0, 0xb1, 0xb2, 0xb3, 0xb4, 0xb5, 0xb6, 0xb7, 0xc0, 0xc1, 0xc6, 0xcd, 0xd4, 0xd5, 0xe0, 0xe1, 0xe2, 0xe3, 0xe4, 0xe5, 0xe6, 0xe7, 0xeb, 0xfa, 0xfa, 0xfba
				return 1
			when 0xc2, 0xca
				return 2
			when 0xc8
				return 3
			when 0x05, 0x0d, 0x15, 0x1d, 0x25, 0x2d, 0x35, 0x3d, 0x68, 0x69, 0x81, 0xa9, 0xb8, 0xb9, 0xba, 0xbb, 0xbc, 0xbd, 0xbe, 0xbf, 0xc7, 0xe8, 0xe9, 0xf80, 0xf81, 0xf82, 0xf83, 0xf84, 0xf85, 0xf86, 0xf87, 0xf88, 0xf89, 0xf8a, 0xf8b, 0xf8c, 0xf8d, 0xf8e, 0xf8f
				if @preficesOperand()
					return 4
				else
					return 2
			when 0x9a, 0xea
				if @preficesOperand()
					return 6
				else
					return 4
			when 0xf6
				switch (bitand @modrm, 0x38)
					when 0x00
						return 1
					else
						return 0
			when 0xf7
				switch (bitand @modrm, 0x38)
					when 0x00
						if (bitand(@prefices, @PRECICES_OPERAND) != 0)
							return 4
						else
							return 2
					else
						return 0
		return 0

	writeInputOperands: (opcode, displacement, immediate) ->
		switch (opcode)
			when 0x00, 0x08, 0x10, 0x18, 0x20, 0x28, 0x30, 0x38, 0x84, 0x86
				@load0_Eb(displacement)
				@load1_Gb()
			when 0x88
				@load0_Gb()

			when 0x02, 0x0a, 0x12, 0x1a, 0x22, 0x2a, 0x32, 0x3a, 0xfc0
				@load0_Gb()
				@load1_Eb(displacement)

			when 0x8a, 0xfb6, 0xfbe
				@load0_Eb(displacement)

			when 0x01, 0x09, 0x11, 0x19, 0x21, 0x29, 0x31, 0x39, 0x85, 0x87
				if @preficesOperand()
					@load0_Ed(displacement)
					@load1_Gd()
				else
					@load0_Ew(displacement)
					@load1_Gw()

			when 0x89
				if @preficesOperand()
					@load0_Gd()
				else
					@load0_Gw()

			when 0x03, 0x0b, 0x13, 0x1b, 0x23, 0x2b, 0x33, 0x3b, 0xfaf, 0xfbc, 0xfbd, 0xfc1
				if @preficesOperand()
					@load0_Gd()
					@load1_Ed(displacement)
				else
					@load0_Gw()
					@load1_Ew(displacement)

			when 0x8b
				if @preficesOperand()
					@load0_Ed(displacement)
				else
					@load0_Ew(displacement)

			when 0xf02, 0xf03
				if @preficesOperand()
					@load0_Ew(displacement)
					@load1_Gd()
				else
					@load0_Ew(displacement)
					@load1_Gw()
#
			when 0xf40, 0xf41, 0xf42, 0xf43, 0xf44, 0xf45, 0xf46, 0xf47, 0xf48, 0xf49, 0xf4a, 0xf4b, 0xf4c, 0xf4d, 0xf4e, 0xf4f
				if @preficesOperand()
					@load0_Gd()
					@load1_Ed(displacement)
				else
					@load0_Gw()
					@load1_Ew(displacement)

			when 0x8d
				@load0_M(displacement)

			when 0x80, 0x82, 0xc0
				@load0_Eb(displacement)
				@working.write(@LOAD1_IB)
				@working.write(int(immediate)) #was int

			when 0xc6, 0xb0, 0xb1, 0xb2, 0xb3, 0xb4, 0xb5, 0xb6, 0xb7, 0xe4, 0x70, 0x71, 0x72, 0x73, 0x74, 0x75, 0x76, 0x77, 0x78, 0x79, 0x7a, 0x7b, 0x7c, 0x7d, 0x7e, 0x7f, 0xcd, 0xd4, 0xd5, 0xe0, 0xe1, 0xe2, 0xe3, 0xeb, 0xe5
				@working.write(@LOAD0_IB)
				@working.write(int(immediate)) # was int

			when 0x81
				if @preficesOperand()
					@load0_Ed(displacement)
					@working.write(@LOAD1_ID)
					@working.write(int(immediate)) #was int
				else
					@load0_Ew(displacement)
					@working.write(@LOAD1_IW)
					@working.write(int(immediate)) #was int

			when 0xc7, 0x68, 0x6a, 0xe8, 0xe9, 0xf80, 0xf81, 0xf82, 0xf83, 0xf84, 0xf85, 0xf86, 0xf87, 0xf88, 0xf89, 0xf8a, 0xf8b, 0xf8c, 0xf8d, 0xf8e, 0xf8f
				if @preficesOperand()
					@working.write(@LOAD0_ID)
					@working.write(int(immediate)) #int
				else
					@working.write(@LOAD0_IW)
					@working.write(int(immediate)) #int

			when 0xc1
				if @preficesOperand()
					@load0_Ed(displacement)
					@working.write(@LOAD1_IB)
					@working.write(int(immediate)) #was int
				else
					@load0_Ew(displacement)
					@working.write(@LOAD1_IB)
					@working.write(int(immediate)) #was int


			when 0x83
				if @preficesOperand()
					@load0_Ed(displacement)
					@working.write(@LOAD1_ID)
					@working.write(int(immediate)) #was int
				else
					@load0_Ew(displacement)
					@working.write(@LOAD1_IW)
					@working.write(int(immediate)) #was int

			when 0x8f, 0x58, 0x59, 0x5a, 0x5b, 0x5c, 0x5d, 0x5e, 0x5f, 0x07, 0x17, 0x1f
				break
			when 0xc2, 0xca
				@working.write(@LOAD0_IW)
				@working.write(int(immediate)) #was int

			when 0x9a, 0xea
				if @preficesOperand()
					@working.write(@LOAD0_ID)
					@working.write(int(immediate)) #was int
					@working.write(@LOAD1_IW)
					@working.write(int(immediate >>> 32)) # was int
				else
					@working.write(@LOAD0_IW)
					@working.write(bitand(0xffff, immediate)) # was int
					@working.write(@LOAD1_IW)
					@working.write(int(immediate >>> 16)) #was int

			when 0x9c
				switch (bitand @prefices, @PREFICES_OPERAND)
					when 0
						@working.write(@LOAD0_FLAGS)
					when @PREFICES_OPERAND
						@working.write(@LOAD0_EFLAGS)

			when 0xec, 0xed
				@working.write(@LOAD0_DX)

			when 0xee
				@working.write(@LOAD0_DX)
				@working.write(@LOAD1_AL)

			when 0xef
				if @preficesOperand()
					@working.write(@LOAD0_DX)
					@working.write(@LOAD1_EAX)
				else
					@working.write(@LOAD0_DX)
					@working.write(@LOAD1_AX)


			when 0x04, 0x0c, 0x14, 0x1c, 0x24, 0x2c, 0x34, 0x3c, 0xa8
				@working.write(@LOAD0_AL)
				@working.write(@LOAD1_IB)
				@working.write(int(immediate)) #was int

			when 0xc8
				@working.write(@LOAD0_IW)
				@working.write((bitand 0xffff, (immediate >>> 16))) # was int
				@working.write(@LOAD1_IB)
				@working.write(int(bitand 0xff, immediate)) #was int

			when 0x69, 0x6b
				if @preficesOperand()
					@load0_Ed(displacement)
					@working.write(@LOAD1_ID)
					@working.write(int(immediate)) #was int
				else
					@load0_Ew(displacement)
					@working.write(@LOAD1_IW)
					@working.write(int(immediate)) #was int


			when 0xe6
				@working.write(@LOAD0_IB)
				@working.write(int(immediate)) #was int
				@working.write(@LOAD1_AL)

			when 0x05, 0x0d, 0x15, 0x1d, 0x25, 0x2d, 0x35, 0x3d, 0xa9
				if @preficesOperand()
					@working.write(@LOAD0_EAX)
					@working.write(@LOAD1_ID)
					@working.write(int(immediate)) #was int
				else
					@working.write(@LOAD0_AX)
					@working.write(@LOAD1_IW)
					@working.write(int(immediate)) #was int


			when 0xb8, 0xb9, 0xba, 0xbb, 0xbc, 0xbd, 0xbe, 0xbf
				if @preficesOperand()
					@working.write(@LOAD0_ID)
					@working.write(int(immediate)) #was int
				else
					@working.write(@LOAD0_IW)
					@working.write(int(immediate)) #was int


			when 0xe7
				if @preficesOperand()
					@working.write(@LOAD0_IB)
					@working.write(int(immediate)) #was int
					@working.write(@LOAD1_EAX)
				else
					@working.write(@LOAD0_IB)
					@working.write(int(immediate)) #was int
					@working.write(@LOAD1_AX)


			when 0x40, 0x48, 0x50
				if @preficesOperand()
					@working.write(@LOAD0_EAX)
				else
					@working.write(@LOAD0_AX)

			when 0x41, 0x49, 0x51
				if @preficesOperand()
					@working.write(@LOAD0_ECX)
				else
					@working.write(@LOAD0_CX)

			when 0x42, 0x4a, 0x52
				if @preficesOperand()
					@working.write(@LOAD0_EDX)
				else
					@working.write(@LOAD0_DX)

			when 0x43, 0x4b, 0x53
				if @preficesOperand()
					@working.write(@LOAD0_EBX)
				else
					@working.write(@LOAD0_BX)


			when 0x44, 0x4c, 0x54
				if @preficesOperand()
					@working.write(@LOAD0_ESP)
				else
					@working.write(@LOAD0_SP)


			when 0x45, 0x4d, 0x55
				if @preficesOperand()
					@working.write(@LOAD0_EBP)
				else
					@working.write(@LOAD0_BP)


			when 0x46, 0x4e, 0x56
				if @preficesOperand()
					@working.write(@LOAD0_ESI)
				else
					@working.write(@LOAD0_SI)

			when 0x47, 0x4f, 0x57
				if @preficesOperand()
					@working.write(@LOAD0_EDI)
				else
					@working.write(@LOAD0_DI)

			when 0x91
				if @preficesOperand()
					@working.write(@LOAD0_EAX)
					@working.write(@LOAD1_ECX)
				else
					@working.write(@LOAD0_AX)
					@working.write(@LOAD1_CX)

			when 0x92
				if @preficesOperand()
					@working.write(@LOAD0_EAX)
					@working.write(@LOAD1_EDX)
				else
					@working.write(@LOAD0_AX)
					@working.write(@LOAD1_DX)


			when 0x93
				if @preficesOperand()
					@working.write(@LOAD0_EAX)
					@working.write(@LOAD1_EBX)
				else
					@working.write(@LOAD0_AX)
					@working.write(@LOAD1_BX)

			when 0x94
				if @preficesOperand()
					@working.write(@LOAD0_EAX)
					@working.write(@LOAD1_ESP)
				else
					@working.write(@LOAD0_AX)
					@working.write(@LOAD1_SP)

			when 0x95
				if @preficesOperand()
					@working.write(@LOAD0_EAX)
					@working.write(@LOAD1_EBP)
				else
					@working.write(@LOAD0_AX)
					@working.write(@LOAD1_BP)

			when 0x96
				if @preficesOperand()
					@working.write(@LOAD0_EAX)
					@working.write(@LOAD1_ESI)
				else
					@working.write(@LOAD0_AX)
					@working.write(@LOAD1_SI)


			when 0x97
				if @preficesOperand()
					@working.write(@LOAD0_EAX)
					@working.write(@LOAD1_EDI)
				else
					@working.write(@LOAD0_AX)
					@working.write(@LOAD1_DI)

			when 0xd0
				@load0_Eb(displacement)
				@working.write(@LOAD1_IB)
				@working.write(1)

			when 0xd2
				@load0_Eb(displacement)
				@working.write(@LOAD1_CL)

			when 0xd1
				if @preficesOperand()
					@load0_Ed(displacement)
					@working.write(@LOAD1_IB)
					@working.write(1)
				else
					@load0_Ew(displacement)
					@working.write(@LOAD1_IB)
					@working.write(1)


			when 0xd3
				if @preficesOperand()
					@load0_Ed(displacement)
					@working.write(@LOAD1_CL)
				else
					@load0_Ew(displacement)
					@working.write(@LOAD1_CL)

			when 0xf6
				switch (bitand @modrm, 0x38)
					when 0x00
						@load0_Eb(displacement)
						@working.write(@LOAD1_IB)
						@working.write(int(immediate)) #was int
					when 0x10, 0x18
						@load0_Eb(displacement)
					when 0x20, 0x28
						@load0_Eb(displacement)
					when 0x30, 0x38
						@load0_Eb(displacement)

			when 0xf7
				if @preficesOperand()
					switch (bitand @modrm, 0x38)
						when 0x00
							load0_Ed(displacement)
							@working.write(@LOAD1_ID)
							@working.write(int(immediate)) #was int
						when 0x10, 0x18
							load0_Ed(displacement)
						when 0x20, 0x28
							load0_Ed(displacement)
						when 0x30, 0x38
							load0_Ed(displacement)

				else
					switch (bitand @modrm, 0x38)
						when 0x00
							@load0_Ew(displacement)
							@working.write(@LOAD1_IW)
							@working.write(int(immediate)) #was int
						when 0x10, 0x18
							@load0_Ew(displacement)
						when 0x20, 0x28
							@load0_Ew(displacement)
						when 0x30, 0x38
							@load0_Ew(displacement)

			when 0xfe
				@load0_Eb(displacement)

			when 0x06
				@working.write(@LOAD0_ES)

			when 0x0e
				@working.write(@LOAD0_CS)

			when 0x16
				@working.write(@LOAD0_SS)

			when 0x1e
				@working.write(@LOAD0_DS)

			when 0x62
				if @preficesOperand()
					@load0_Eq(displacement)
					@load1_Gd()
				else
					@load0_Ed(displacement)
					@load1_Gw()

			when 0x8c
				@load0_Sw()


			when 0x8e, 0xfb7, 0xfbf
				@load0_Ew(displacement)

			when 0xa0
				@load0_Ob(displacement)

			when 0xa2
				@working.write(@LOAD0_AL)

			when 0xa1
				if @preficesOperand()
					@load0_Od(displacement)
				else
					@load0_Ow(displacement)

			when 0xa3
				if @preficesOperand()
					@working.write(@LOAD0_EAX)
				else
					@working.write(@LOAD0_AX)

			when 0x6c, 0x6d
				@working.write(@LOAD0_DX)

			when 0x6e, 0x6f
				@working.write(@LOAD0_DX)
				@decodeSegmentPrefix()

			when 0xa4, 0xa5, 0xa6, 0xa7, 0xac, 0xad
				@decodeSegmentPrefix()

			when 0xaa
				@working.write(@LOAD0_AL)

			when 0xab
				if @preficesOperand()
					@working.write(@LOAD0_EAX)
				else
					@working.write(@LOAD0_AX)

			when 0xae
				@working.write(@LOAD0_AL)

			when 0xaf
				if @preficesOperand()
					@working.write(@LOAD0_EAX)
				else
					@working.write(@LOAD0_AX)

			when 0xff
				if @preficesOperand()
					switch (bitand @modrm, 0x38)
						when 0x00, 0x08, 0x10, 0x20, 0x30
							@load0_Ed(displacement)
						when 0x18, 0x28
							@load0_Ed(displacement)
							@working.write(@ADDR_IB)
							@working.write(4)
							@working.write(@LOAD1_MEM_WORD)

				else
					switch (bitand @modrm, 0x38)
						when 0x00, 0x08, 0x10, 0x20, 0x30
							@load0_Ew(displacement)

						when 0x18, 0x28
							@load0_Ew(displacement)
							@working.write(@ADDR_IB)
							@working.write(2)
							@working.write(@LOAD1_MEM_WORD)


			when 0xc4, 0xc5, 0xfb2, 0xfb4, 0xfb5
				if @preficesOperand()
					@load0_Ed(displacement)
					@working.write(@ADDR_IB)
					@working.write(4)
					@working.write(@LOAD1_MEM_WORD)
				else
					@load0_Ew(displacement)
					@working.write(@ADDR_IB)
					@working.write(2)
					@working.write(@LOAD1_MEM_WORD)


			when 0xd7
				switch (bitand @prefices, @PREFICES_SG)
					when @PREFICES_ES
						@working.write(@LOAD_SEG_ES)
					when @PREFICES_CS
						@working.write(@LOAD_SEG_CS)
					when @PREFICES_SS
						@working.write(@LOAD_SEG_SS)

					when @PREFICES_DS
						@working.write(@LOAD_SEG_DS)
					when @PREFICES_FS
						@working.write(@LOAD_SEG_FS)
					when @PREFICES_GS
						@working.write(@LOAD_SEG_GS)
					else
						@working.write(@LOAD_SEG_DS)

				if ((bitand @prefices, @PREFICES_ADDRESS) != 0)
					if (@decodingAddressMode())
						@working.write(@ADDR_EBX)
						@working.write(@ADDR_uAL)
				else
					if (@decodingAddressMode())
						@working.write(@ADDR_BX)
						@working.write(@ADDR_uAL)
						@working.write(@ADDR_MASK16)

				@working.write(@LOAD0_MEM_BYTE)


			when 0xf00
				switch (bitand @modrm, 0x38)
					when 0x10, 0x18, 0x20, 0x28
						@load0_Ew(displacement)

			when 0xf01
				switch (bitand @modrm, 0x38)
					when 0x10, 0x18
						@load0_Ew(displacement)
						@working.write(@ADDR_ID)
						@working.write(2)
						@working.write(@LOAD1_MEM_DWORD)
					when 0x30
						@load0_Ew(displacement)
					when 0x38
						@decodeM(displacement)

			when 0xfa0
				@working.write(@LOAD0_FS)
			when 0xfa8
				@working.write(@LOAD0_GS)

			when 0xf20
				@load0_Cd()

			when 0xf21
				@load0_Dd()

			when 0xf22, 0xf23
				@load0_Rd()

			when 0xf30
				@working.write(@LOAD0_ECX)
				@working.write(@LOAD1_EDX)
				@working.write(@LOAD2_EAX)

			when 0xf32
				@working.write(@LOAD0_ECX)

			when 0xf35
				@working.write(@LOAD0_ECX)
				@working.write(@LOAD1_EDX)

			when 0xfa4, 0xfac
				if @preficesOperand()
					@load0_Ed(displacement)
					@load1_Gd()
					@working.write(@LOAD2_IB)
					@working.write(int(immediate)) #was int
				else
					@load0_Ew(displacement)
					@load1_Gw()
					@working.write(@LOAD2_IB)
					@working.write(int(immediate)) #was int

			when 0xfa5, 0xfad
				if @preficesOperand()
					@load0_Ed(displacement)
					@load1_Gd()
					@working.write(@LOAD2_CL)
				else
					@load0_Ew(displacement)
					@load1_Gw()
					@working.write(@LOAD2_CL)

			when 0xfb0
				@load0_Eb(displacement)
				@load1_Gb()
				@working.write(@LOAD2_AL)

			when 0xfb1
				if @preficesOperand()
					@load0_Ed(displacement)
					@load1_Gd()
					@working.write(@LOAD2_EAX)
				else
					@load0_Ew(displacement)
					@load1_Gw()
					@working.write(@LOAD2_AX)
			when 0xfa3, 0xfab, 0xfb3, 0xfbb
				if @preficesOperand()
					switch (bitand @modrm, 0xc7)
						when 0xc0
							@working.write(@LOAD0_EAX)
						when 0xc1
							@working.write(@LOAD0_ECX)
						when 0xc2
							@working.write(@LOAD0_EDX)
						when 0xc3
							@working.write(@LOAD0_EBX)
						when 0xc4
							@working.write(@LOAD0_ESP)
						when 0xc5
							@working.write(@LOAD0_EBP)
						when 0xc6
							@working.write(@LOAD0_ESI)
						when 0xc7
							@working.write(@LOAD0_EDI)
						else
							@decodeM(displacement)
					@load1_Gd()
				else
					switch (bitand @modrm, 0xc7)
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
							@decodeM(displacement)
					@load1_Gw()

			when 0xfba
				if @preficesOperand()
					switch (bitand @modrm, 0xc7)
						when 0xc0
							@working.write(@LOAD0_EAX)
						when 0xc1
							@working.write(@LOAD0_ECX)
						when 0xc2
							@working.write(@LOAD0_EDX)
						when 0xc3
							@working.write(@LOAD0_EBX)
						when 0xc4
							@working.write(@LOAD0_ESP)
						when 0xc5
							@working.write(@LOAD0_EBP)
						when 0xc6
							@working.write(@LOAD0_ESI)
						when 0xc7
							@working.write(@LOAD0_EDI)
						else
							@decodeM(displacement)

				else
					switch (bitand @modrm, 0xc7)
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
							@decodeM(displacement)
				@working.write(@LOAD1_IB)
				@working.write(int(bitand immediate, 0x1f)) #int
				#check of voor of na if moet.

			when 0xfc7
				switch (bitand @modrm, 0x38)
					when 0x08
						@decodeM(displacement)
						@working.write(@LOAD0_MEM_QWORD)
					else
						throw new IllegalStateException("4 6 Instruction?")
			when 0xfc8
				@working.write(@LOAD0_EAX)
			when 0xfc9
				@working.write(@LOAD0_ECX)
			when 0xfca
				@working.write(@LOAD0_EDX)
			when 0xfcb
				@working.write(@LOAD0_EBX)
			when 0xfcc
				@working.write(@LOAD0_ESP)
			when 0xfcd
				@working.write(@LOAD0_EBP)
			when 0xfce
				@working.write(@LOAD0_ESI)
			when 0xfcf
				@working.write(@LOAD0_EDI)

			when 0xd800
				@working.write(@FWAIT)
				if ((bitand @modrm, 0xc0) != 0xc0)
					switch (bitand @modrm, 0x38)
						when 0x28, 0x38
							@decodeM(displacement)
							@working.write(@FLOAD0_MEM_SINGLE)
							@working.write(@FLOAD1_ST0)
						else
							@working.write(@FLOAD0_ST0)
							@decodeM(displacement)
							@working.write(@FLOAD1_MEM_SINGLE)
				else
					switch (bitand @modrm, 0xf8)
						when 0xe8, 0xf8
							@working.write(@FLOAD0_STN)
							@working.write(bitand @modrm, 0x07)
							@working.write(@FLOAD1_ST0)
						else
							@working.write(@FLOAD0_ST0)
							@working.write(@FLOAD1_STN)
							@working.write(bitand @modrm, 0x07)
			when 0xd900
				if ((bitand @modrm, 0xc0) != 0xc0)
					switch (bitand @modrm, 0x38)
						when 0x00
							@working.write(@FWAIT)
							@decodeM(displacement)
							@working.write(@FLOAD0_MEM_SINGLE)
						when 0x10, 0x18
							@working.write(@FWAIT)
							@working.write(@FLOAD0_ST0)
						when 0x20
							@working.write(@FWAIT)
							@decodeM(displacement)
						when 0x28
							@working.write(@FWAIT)
							@decodeM(displacement)
							@working.write(@LOAD0_MEM_WORD)
						when 0x30
							@decodeM(displacement)
						when 0x38
							@working.write(@LOAD0_FPUCW)
				else
					@working.write(@FWAIT)
					switch (bitand @modrm, 0xf8)
						when 0xc0
							@working.write(@FLOAD0_STN)
							@working.write(bitand @modrm, 0x07)
						when 0xc8
							@working.write(@FLOAD0_ST0)
							@working.write(@FLOAD1_STN)
							@working.write(bitand @modrm, 0x07)
					switch (@modrm)

						when 0xd0, 0xf6, 0xf7
							break
						when 0xe0, 0xe1, 0xe5, 0xf0, 0xf2, 0xf4, 0xfa, 0xfb, 0xfc, 0xfe, 0xff
							@working.write(@FLOAD0_ST0)
						when 0xf1, 0xf3, 0xf5, 0xf8, 0xf9, 0xfd
							@working.write(@FLOAD0_ST0)
							@working.write(@FLOAD1_STN)
							@working.write(1)
						when 0xe4
							@working.write(@FLOAD0_ST0)
							@working.write(@FLOAD1_POS0)
						when 0xe8
							@working.write(@FLOAD0_1)
						when 0xe9
							@working.write(@FLOAD0_L2TEN)
						when 0xea
							@working.write(@FLOAD0_L2E)
						when 0xeb
							@working.write(@FLOAD0_PI)
						when 0xec
							@working.write(@FLOAD0_LOG2)
						when 0xed
							@working.write(@FLOAD0_LN2)
						when 0xee
							@working.write(@FLOAD0_POS0)
			when 0xda00
				@working.write(@FWAIT)
				if ((bitand @modrm, 0xc0) != 0xc0)
					switch (bitand @modrm, 0x38)
						when 0x28, 0x38
							@decodeM(displacement)
							@working.write(@LOAD0_MEM_DWORD)
							@working.write(@FLOAD0_REG0)
							@working.write(@FLOAD1_ST0)
						else
							@working.write(@FLOAD0_ST0)
							@decodeM(displacement)
							@working.write(@LOAD0_MEM_DWORD)
							@working.write(@FLOAD1_REG0)
				else

					switch (bitand @modrm, 0xf8)
						when 0xc0, 0xc8, 0xd0, 0xd8
							@working.write(@FLOAD0_STN)
							@working.write(bitand @modrm, 0x07)
					switch (@modrm)
						when 0xe9
							@working.write(@FLOAD0_ST0)
							@working.write(@FLOAD1_STN)
							@working.write(1)

			when 0xdb00
				if ((bitand @modrm, 0xc0) != 0xc0)
					@working.write(@FWAIT)
					switch (bitand @modrm, 0x38)
						when 0x00
							@decodeM(displacement)
							@working.write(@LOAD0_MEM_DWORD)
							@working.write(@FLOAD0_REG0)
						when 0x08, 0x10, 0x18, 0x38
							@working.write(@FLOAD0_ST0)
						when 0x28
							@decodeM(displacement)
							@working.write(@FLOAD0_MEM_EXTENDED)
				else
					switch (@modrm)
						when 0xe2, 0xe3
							break
						else
							@working.write(@FWAIT)
					switch (bitand @modrm, 0xf8)
						when 0xc0, 0xc8, 0xd0, 0xd8
							@working.write(@FLOAD0_STN)
							@working.write(bitand @modrm, 0x07)
						when 0xe8, 0xf0
							@working.write(@FLOAD0_ST0)
							@working.write(@FLOAD1_STN)
							@working.write(bitand @modrm, 0x07)

			when 0xdc00
				@working.write(@FWAIT)
				if ((bitand @modrm, 0xc0) != 0xc0)
					switch (bitand @modrm, 0x38)
						when 0x28, 0x38
							@decodeM(displacement)
							@working.write(@FLOAD0_MEM_DOUBLE)
							@working.write(@FLOAD1_ST0)
						else
							@working.write(@FLOAD0_ST0)
							@decodeM(displacement)
							@working.write(@FLOAD1_MEM_DOUBLE)
				else
					switch (bitand @modrm, 0xf8)
						when 0xe8, 0xf8
							@working.write(@FLOAD0_STN)
							@working.write(bitand @modrm, 0x07)
							@working.write(@FLOAD1_ST0)
						else
							@working.write(@FLOAD0_ST0)
							@working.write(@FLOAD1_STN)
							@working.write(bitand @modrm, 0x07)


			when 0xdd00
				if ((bitand @modrm, 0xc0) != 0xc0)
					switch (bitand @modrm, 0x38)
						when 0x00
							@working.write(@FWAIT)
							@decodeM(displacement)
							@working.write(@FLOAD0_MEM_DOUBLE)
						when 0x08, 0x10, 0x18
							@working.write(@FWAIT)
							@working.write(@FLOAD0_ST0)
						when 0x20
							@working.write(@FWAIT)
							@decodeM(displacement)
						when 0x30
							@decodeM(displacement)
						when 0x38
							@working.write(@LOAD0_FPUSW)
				else
					@working.write(@FWAIT)
					switch (bitand @modrm, 0xf8)
						when 0xc0
							@working.write(@LOAD0_ID)
							@working.write(bitand @modrm, 0x07)
						when 0xd0, 0xd8
							@working.write(@FLOAD0_ST0)
						when 0xe0, 0xe8
							@working.write(@FLOAD0_ST0)
							@working.write(@FLOAD1_STN)
							@working.write(bitand @modrm, 0x07)


			when 0xde00
				@working.write(@FWAIT)
				if ((bitand @modrm, 0xc0) != 0xc0)
					switch (bitand @modrm, 0x38)
						when 0x28, 0x38
							decodeM(displacement)
							@working.write(@LOAD0_MEM_WORD)
							@working.write(@FLOAD0_REG0)
							@working.write(@FLOAD1_ST0)
						when 0x30
							@working.write(@FLOAD0_ST0)
							decodeM(displacement)
							@working.write(@LOAD0_MEM_QWORD)
							@working.write(@FLOAD1_REG0L)
						else
							@working.write(@FLOAD0_ST0)
							decodeM(displacement)
							@working.write(@LOAD0_MEM_WORD)
							@working.write(@FLOAD1_REG0)
				else
					switch (bitand @modrm, 0xf8)
						when 0xc0, 0xc8, 0xe0, 0xf0
							@working.write(@FLOAD0_ST0)
							@working.write(@FLOAD1_STN)
							@working.write(bitand @modrm, 0x07)
						when 0xe8, 0xf8
							@working.write(@FLOAD1_ST0)
							@working.write(@FLOAD0_STN)
							@working.write(bitand @modrm, 0x07)

					switch (@modrm)
						when 0xd9
							@working.write(@FLOAD0_ST0)
							@working.write(@FLOAD1_STN)
							@working.write(1)

			when 0xdf00
				if ((bitand @modrm, 0xc0) != 0xc0)
					@working.write(@FWAIT)
					switch (bitand @modrm, 0x38)
						when 0x00
							@decodeM(displacement)
							@working.write(@LOAD0_MEM_WORD)
							@working.write(@FLOAD0_REG0)
						when 0x28
							@decodeM(displacement)
							@working.write(@LOAD0_MEM_QWORD)
							@working.write(@FLOAD0_REG0L)
						when 0x08, 0x10, 0x18, 0x38
							@working.write(@FLOAD0_ST0)
						when 0x30
							@working.write(@FLOAD0_ST0)
							@decodeM(displacement)
						when 0x20
							@decodeM(displacement)
				else
					switch (@modrm)
						when 0xe0
							@working.write(@LOAD0_FPUSW)
						else
							@working.write(@FWAIT)
					switch (bitand @modrm, 0xf8)
						when 0xe8, 0xf0
							@working.write(@FLOAD0_ST0)
							@working.write(@FLOAD1_STN)
							@working.write(bitand @modrm, 0x07)

	writeOperation: (opcode) ->
#		log "WriteOperation(#{opcode})"
		switch (opcode)
			when 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0xfc0, 0xfc1
				@working.write(@ADD)
			when 0x08, 0x09, 0x0a,0x0b, 0x0c, 0x0d
				@working.write(@OR )

			when 0x10, 0x11, 0x12, 0x13, 0x14, 0x15
				@working.write(@ADC)

			when 0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d
				@working.write(@SBB)

			when 0x20, 0x21, 0x22, 0x23, 0x24, 0x25, 0x84, 0x85, 0xa8, 0xa9
				@working.write(@AND)

			when 0x27
				@working.write(@DAA)

			when 0x28, 0x29, 0x2a, 0x2b, 0x2c, 0x2d, 0x38, 0x39, 0x3a, 0x3b, 0x3c, 0x3d
				@working.write(@SUB)

			when 0x2f
				@working.write(@DAS)

			when 0x30, 0x31, 0x32, 0x33, 0x34, 0x35
				@working.write(@XOR)

			when 0x37
				@working.write(@AAA)
			when 0x3f
				@working.write(@AAS)

			when 0x40, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46, 0x47
				@working.write(@INC)

			when 0x48, 0x49, 0x4a, 0x4b, 0x4c, 0x4d, 0x4e, 0x4f
				@working.write(@DEC)

			when 0x06, 0x0e, 0x16, 0x1e, 0x50, 0x51, 0x52, 0x53, 0x54, 0x55, 0x56, 0x57, 0x68, 0x6a, 0xfa0, 0xfa8
				switch (bitand @prefices, (@PREFICES_OPERAND | @PREFICES_ADDRESS))
					when 0
						@working.write(@PUSH_O16_A16)
					when @PREFICES_OPERAND
						@working.write(@PUSH_O32_A16)
					when @PREFICES_ADDRESS
						@working.write(@PUSH_O16_A32)
					when @PREFICES_ADDRESS | @PREFICES_OPERAND
						@working.write(@PUSH_O32_A32)
			when 0x9c
				switch (bitand @prefices, (@PREFICES_OPERAND | @PREFICES_ADDRESS))
					when 0
						@working.write(@PUSHF_O16_A16)
					when @PREFICES_OPERAND
						@working.write(@PUSHF_O32_A16)
					when @PREFICES_ADDRESS
						@working.write(@PUSHF_O16_A32)
					when @PREFICES_ADDRESS | @PREFICES_OPERAND
						@working.write(@PUSHF_O32_A32)

			when 0x07, 0x17, 0x1f, 0x58, 0x59, 0x5a, 0x5b, 0x5c, 0x5d, 0x5e, 0x5f, 0x8f, 0xfa1, 0xfa9
				switch (bitand @prefices, (@PREFICES_OPERAND | @PREFICES_ADDRESS))
					when 0
						@working.write(@POP_O16_A16)
					when @PREFICES_OPERAND
						@working.write(@POP_O32_A16)
					when @PREFICES_ADDRESS
						@working.write(@POP_O16_A32)
					when @PREFICES_ADDRESS | @PREFICES_OPERAND
						@working.write(@POP_O32_A32)

			when 0x9d
				switch (bitand @prefices, (@PREFICES_OPERAND | @PREFICES_ADDRESS))
					when 0
						@working.write(@POPF_O16_A16)
					when @PREFICES_OPERAND
						@working.write(@POPF_O32_A16)
					when @PREFICES_ADDRESS
						@working.write(@POPF_O16_A32)
					when @PREFICES_ADDRESS | @PREFICES_OPERAND
						@working.write(@POPF_O32_A32)

			when 0x60
				switch (bitand @prefices, @PREFICES_OPERAND)
					when 0
						@working.write(@PUSHAD_A16)
					when @PREFICES_OPERAND
						@working.write(@PUSHAD_A32)


			when 0x61
				switch (bitand @prefices, (@PREFICES_OPERAND | @PREFICES_ADDRESS))
					when 0
						@working.write(@POPA_A16)
					when @PREFICES_OPERAND
						@working.write(@POPAD_A16)
					when @PREFICES_ADDRESS
						@working.write(@POPA_A32)
					when @PREFICES_ADDRESS | @PREFICES_OPERAND
						@working.write(@POPAD_A32)

			when 0x62
				if @preficesOperand()
					@working.write(@BOUND_O32)
				else
					@working.write(@BOUND_O16)


			when 0x69, 0x6b, 0xfaf
				if @preficesOperand()
					@working.write(@IMUL_O32)
				else
					@working.write(@IMUL_O16)


			when 0x6c
				if ((bitand @prefices, @PREFICES_REP) != 0)
					if ((bitand @prefices, @PREFICES_ADDRESS) != 0)
						@working.write(@REP_INSB_A32)
					else
						@working.write(@REP_INSB_A16)
				else
					if ((bitand @prefices, @PREFICES_ADDRESS) != 0)
						@working.write(@INSB_A32)
					else
						@working.write(@INSB_A16)
			when 0x6d
				if @preficesOperand()
					if ((bitand @prefices, @PREFICES_REP) != 0)
						if ((bitand @prefices, @PREFICES_ADDRESS) != 0)
							@working.write(@REP_INSD_A32)
						else
							@working.write(@REP_INSD_A16)
					else
						if ((bitand @prefices, @PREFICES_ADDRESS) != 0)
							@working.write(@INSD_A32)
						else
							@working.write(@INSD_A16)
				else
					if ((bitand @prefices, @PREFICES_REP) != 0)
						if ((bitand @prefices, @PREFICES_ADDRESS) != 0)
							@working.write(@REP_INSW_A32)
						else
							@working.write(@REP_INSW_A16)
					else
						if ((bitand @prefices, @PREFICES_ADDRESS) != 0)
							@working.write(@INSW_A32)
						else
							@working.write(@INSW_A16)

			when 0x6e
				if ((bitand @prefices, @PREFICES_REP) != 0)
					if ((bitand @prefices, @PREFICES_ADDRESS) != 0)
						@working.write(@REP_OUTSB_A32)
					else
						@working.write(@REP_OUTSB_A16)
				else
					if ((bitand @prefices, @PREFICES_ADDRESS) != 0)
						@working.write(@OUTSB_A32)
					else
						@working.write(@OUTSB_A16)

			when 0x6f
				if @preficesOperand()
					if ((bitand @prefices, @PREFICES_REP) != 0)
						if ((bitand @prefices, @PREFICES_ADDRESS) != 0)
							@working.write(@REP_OUTSD_A32)
						else
							@working.write(@REP_OUTSD_A16)
					else
						if ((bitand @prefices, @PREFICES_ADDRESS) != 0)
							@working.write(@OUTSD_A32)
						else
							@working.write(@OUTSD_A16)
				else
					if ((bitand @prefices, @PREFICES_REP) != 0)
						if ((bitand @prefices, @PREFICES_ADDRESS) != 0)
							@working.write(@REP_OUTSW_A32)
						else
							@working.write(@REP_OUTSW_A16)
					else
						if ((bitand @prefices, @PREFICES_ADDRESS) != 0)
							@working.write(@OUTSW_A32)
						else
							@working.write(@OUTSW_A16)

			when 0x70
				@working.write(@JO_O8)
			when 0x71
				@working.write(@JNO_O8)
			when 0x72
				@working.write(@JC_O8)
			when 0x73
				@working.write(@JNC_O8)
			when 0x74
				@working.write(@JZ_O8)
			when 0x75
				@working.write(@JNZ_O8)
			when 0x76
				@working.write(@JNA_O8)
			when 0x77
				@working.write(@JA_O8)
			when 0x78
				@working.write(@JS_O8)
			when 0x79
				@working.write(@JNS_O8)
			when 0x7a
				@working.write(@JP_O8)
			when 0x7b
				@working.write(@JNP_O8)
			when 0x7c
				@working.write(@JL_O8)
			when 0x7d
				@working.write(@JNL_O8)
			when 0x7e
				@working.write(@JNG_O8)
			when 0x7f
				@working.write(@JG_O8)

			when 0x80, 0x81, 0x8, 0x83
				switch (bitand @modrm, 0x38)
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

			when 0x98
				if @preficesOperand()
					@working.write(@LOAD0_AX)
					@working.write(@SIGN_EXTEND_16_32)
					@working.write(@STORE0_EAX)
				else
					@working.write(@LOAD0_AL)
					@working.write(@SIGN_EXTEND_8_16)
					@working.write(@STORE0_AX)


			when 0x99
				if @preficesOperand()
					@working.write(@CDQ)
				else
					@working.write(@CWD)

			when 0x9a
				switch (bitand @prefices, (@PREFICES_OPERAND | @PREFICES_ADDRESS))
					when 0
						@working.write(@CALL_FAR_O16_A16)
					when @PREFICES_OPERAND
						@working.write(@CALL_FAR_O32_A16)
					when @PREFICES_ADDRESS
						@working.write(@CALL_FAR_O16_A32)
					when @PREFICES_ADDRESS | @PREFICES_OPERAND
						@working.write(@CALL_FAR_O32_A32)

			when 0x9b
				@working.write(@FWAIT)
			when 0x9e
				@working.write(@SAHF)
			when 0x9f
				@working.write(@LAHF)

			when 0xa4
				if ((bitand @prefices, @PREFICES_REP) != 0)
					if ((bitand @prefices, @PREFICES_ADDRESS) != 0)
						@working.write(@REP_MOVSB_A32)
					else
						@working.write(@REP_MOVSB_A16)
				else
					if ((bitand @prefices, @PREFICES_ADDRESS) != 0)
						@working.write(@MOVSB_A32)
					else
						@working.write(@MOVSB_A16)

			when 0xa5
				if @preficesOperand()
					if ((bitand @prefices, @PREFICES_REP) != 0)
						if ((bitand @prefices, @PREFICES_ADDRESS) != 0)
							@working.write(@REP_MOVSD_A32)
						else
							@working.write(@REP_MOVSD_A16)
					else
						if ((bitand @prefices, @PREFICES_ADDRESS) != 0)
							@working.write(@MOVSD_A32)
						else
							@working.write(@MOVSD_A16)

				else
					if ((bitand @prefices, @PREFICES_REP) != 0)
						if ((bitand @prefices, @PREFICES_ADDRESS) != 0)
							@working.write(@REP_MOVSW_A32)
						else
							@working.write(@REP_MOVSW_A16)
					else
						if ((bitand @prefices, @PREFICES_ADDRESS) != 0)
							@working.write(@MOVSW_A32)
						else
							@working.write(@MOVSW_A16)
			when 0xa6
				if ((bitand @prefices, @PREFICES_REPE) != 0)
					if ((bitand @prefices, @PREFICES_ADDRESS) != 0)
						@working.write(@REPE_CMPSB_A32)
					else
						@working.write(@REPE_CMPSB_A16)
				else if ((bitand @prefices, @PREFICES_REPNE) != 0)
					if ((bitand @prefices, @PREFICES_ADDRESS) != 0)
						@working.write(@REPNE_CMPSB_A32)
					else
						@working.write(@REPNE_CMPSB_A16)
				else
					if ((bitand @prefices, @PREFICES_ADDRESS) != 0)
						@working.write(@CMPSB_A32)
					else
						@working.write(@CMPSB_A16)

			when 0xa7
				if @preficesOperand()
					if ((bitand @prefices, @PREFICES_REPE) != 0)
						if ((bitand @prefices, @PREFICES_ADDRESS) != 0)
							@working.write(@REPE_CMPSD_A32)
						else
							@working.write(@REPE_CMPSD_A16)
					else if ((bitand @prefices, @PREFICES_REPNE) != 0)
						if ((bitand @prefices, @PREFICES_ADDRESS) != 0)
							@working.write(@REPNE_CMPSD_A32)
						else
							@working.write(@REPNE_CMPSD_A16)
					else
						if ((bitand @prefices, @PREFICES_ADDRESS) != 0)
							@working.write(@CMPSD_A32)
						else
							@working.write(@CMPSD_A16)
				else
					if ((bitand @prefices, @PREFICES_REPE) != 0)
						if ((bitand @prefices, @PREFICES_ADDRESS) != 0)
							@working.write(@REPE_CMPSW_A32)
						else
							@working.write(@REPE_CMPSW_A16)
					else if ((bitand @prefices, @PREFICES_REPNE) != 0)
						if ((bitand @prefices, @PREFICES_ADDRESS) != 0)
							@working.write(@REPNE_CMPSW_A32)
						else
							@working.write(@REPNE_CMPSW_A16)
					else
						if ((bitand @prefices, @PREFICES_ADDRESS) != 0)
							@working.write(@CMPSW_A32)
						else
							@working.write(@CMPSW_A16)

			when 0xaa
				if ((bitand @prefices, @PREFICES_REP) != 0)
					if ((bitand @prefices, @PREFICES_ADDRESS) != 0)
						@working.write(@REP_STOSB_A32)
					else
						@working.write(@REP_STOSB_A16)
				else
					if ((bitand @prefices, @PREFICES_ADDRESS) != 0)
						@working.write(@STOSB_A32)
					else
						@working.write(@STOSB_A16)

			when 0xab
				if @preficesOperand()
					if ((bitand @prefices, @PREFICES_REP) != 0)
						if ((bitand @prefices, @PREFICES_ADDRESS) != 0)
							@working.write(@REP_STOSD_A32)
						else
							@working.write(@REP_STOSD_A16)
					else
						if ((bitand @prefices, @PREFICES_ADDRESS) != 0)
							@working.write(@STOSD_A32)
						else
							@working.write(@STOSD_A16)
				else
					if ((bitand @prefices, @PREFICES_REP) != 0)
						if ((bitand @prefices, @PREFICES_ADDRESS) != 0)
							@working.write(@REP_STOSW_A32)
						else
							@working.write(@REP_STOSW_A16)
					else
						if ((bitand @prefices, @PREFICES_ADDRESS) != 0)
							@working.write(@STOSW_A32)
						else
							@working.write(@STOSW_A16)

			when 0xac
				if ((bitand @prefices, @PREFICES_REP) != 0)
					if ((bitand @prefices, @PREFICES_ADDRESS) != 0)
						@working.write(@REP_LODSB_A32)
					else
						@working.write(@REP_LODSB_A16)
				else
					if ((bitand @prefices, @PREFICES_ADDRESS) != 0)
						@working.write(@LODSB_A32)
					else
						@working.write(@LODSB_A16)

			when 0xad
				if @preficesOperand()
					if ((bitand @prefices, @PREFICES_REP) != 0)
						if ((bitand @prefices, @PREFICES_ADDRESS) != 0)
							@working.write(@REP_LODSD_A32)
						else
							@working.write(@REP_LODSD_A16)
					else
						if ((bitand @prefices, @PREFICES_ADDRESS) != 0)
							@working.write(@LODSD_A32)
						else
							@working.write(@LODSD_A16)
				else
					if ((bitand @prefices, @PREFICES_REP) != 0)
						if ((bitand @prefices, @PREFICES_ADDRESS) != 0)
							@working.write(@REP_LODSW_A32)
						else
							@working.write(@REP_LODSW_A16)
					else
						if ((bitand @prefices, @PREFICES_ADDRESS) != 0)
							@working.write(@LODSW_A32)
						else
							@working.write(@LODSW_A16)

			when 0xae
				if ((bitand @prefices, @PREFICES_REPE) != 0)
					if ((bitand @prefices, @PREFICES_ADDRESS) != 0)
						@working.write(@REPE_SCASB_A32)
					else
						@working.write(@REPE_SCASB_A16)
				else if ((bitand @prefices, @PREFICES_REPNE) != 0)
					if ((bitand @prefices, @PREFICES_ADDRESS) != 0)
						@working.write(@REPNE_SCASB_A32)
					else
						@working.write(@REPNE_SCASB_A16)
				else
					if ((bitand @prefices, @PREFICES_ADDRESS) != 0)
						@working.write(@SCASB_A32)
					else
						@working.write(@SCASB_A16)

			when 0xaf
				if @preficesOperand()
					if ((bitand @prefices, @PREFICES_REPE) != 0)
						if ((bitand @prefices, @PREFICES_ADDRESS) != 0)
							@working.write(@REPE_SCASD_A32)
						else
							@working.write(@REPE_SCASD_A16)
					else if ((bitand @prefices, @PREFICES_REPNE) != 0)
						if ((bitand @prefices, @PREFICES_ADDRESS) != 0)
							@working.write(@REPNE_SCASD_A32)
						else
							@working.write(@REPNE_SCASD_A16)
					else
						if ((bitand @prefices, @PREFICES_ADDRESS) != 0)
							@working.write(@SCASD_A32)
						else
							@working.write(@SCASD_A16)
				else
					if ((bitand @prefices, @PREFICES_REPE) != 0)
						if ((bitand @prefices, @PREFICES_ADDRESS) != 0)
							@working.write(@REPE_SCASW_A32)
						else
							@working.write(@REPE_SCASW_A16)
					else if ((bitand @prefices, @PREFICES_REPNE) != 0)
						if ((bitand @prefices, @PREFICES_ADDRESS) != 0)
							@working.write(@REPNE_SCASW_A32)
						else
							@working.write(@REPNE_SCASW_A16)
					else
						if ((bitand @prefices, @PREFICES_ADDRESS) != 0)
							@working.write(@SCASW_A32)
						else
							@working.write(@SCASW_A16)

			when 0xc0, 0xd0, 0xd2
				switch (bitand @modrm, 0x38)
					when 0x00
						@working.write(@ROL_O8)
					when 0x08
						@working.write(@ROR_O8)
					when 0x10
						@working.write(@RCL_O8)
					when 0x18
						@working.write(@RCR_O8)
					when 0x20
						@working.write(@SHL)
					when 0x28
						@working.write(@SHR)
					when 0x30
						log "invalid SHL encoding"
						@working.write(@SHL)
					when 0x38
						@working.write(@SAR_O8)

			when 0xc1, 0xd1, 0xd3
				if @preficesOperand()
					switch (bitand @modrm, 0x38)
						when 0x00
							@working.write(@ROL_O32)
						when 0x08
							@working.write(@ROR_O32)
						when 0x10
							@working.write(@RCL_O32)
						when 0x18
							@working.write(@RCR_O32)
						when 0x20
							@working.write(@SHL)
						when 0x28
							@working.write(@SHR)
						when 0x30
							log "invalid SHL encoding"
							@working.write(@SHL)
						when 0x38
							@working.write(@SAR_O32)
				else
					switch (bitand @modrm, 0x38)
						when 0x00
							@working.write(@ROL_O16)
						when 0x08
							@working.write(@ROR_O16)
						when 0x10
							@working.write(@RCL_O16)
						when 0x18
							@working.write(@RCR_O16)
						when 0x20
							@working.write(@SHL)
						when 0x28
							@working.write(@SHR)
						when 0x30
							@working.write(@SHL)
						when 0x38
							@working.write(@SAR_O16)

			when 0xc2
				switch (bitand @prefices, (@PREFICES_OPERAND | @PREFICES_ADDRESS))
					when 0
						@working.write(@RET_IW_O16_A16)
					when @PREFICES_OPERAND
						@working.write(@RET_IW_O32_A16)
					when @PREFICES_ADDRESS
						@working.write(@RET_IW_O16_A32)
					when @PREFICES_ADDRESS | @PREFICES_OPERAND
						@working.write(@RET_IW_O32_A32)

			when 0xc3
				switch (bitand @prefices, (@PREFICES_OPERAND | @PREFICES_ADDRESS))
					when 0
						@working.write(@RET_O16_A16)
					when @PREFICES_OPERAND
						@working.write(@RET_O32_A16)
					when @PREFICES_ADDRESS
						@working.write(@RET_O16_A32)
					when @PREFICES_ADDRESS | @PREFICES_OPERAND
						@working.write(@RET_O32_A32)

			when 0xc8
				switch (bitand @prefices, (@PREFICES_OPERAND | @PREFICES_ADDRESS))
					when 0
						@working.write(@ENTER_O16_A16)
					when @PREFICES_OPERAND
						@working.write(@ENTER_O32_A16)
					when @PREFICES_ADDRESS
						@working.write(@ENTER_O16_A32)
					when @PREFICES_ADDRESS | @PREFICES_OPERAND
						@working.write(@ENTER_O32_A32)

			when 0xc9
				switch (bitand @prefices, (@PREFICES_OPERAND | @PREFICES_ADDRESS))
					when 0
						@working.write(@LEAVE_O16_A16)
					when @PREFICES_OPERAND
						@working.write(@LEAVE_O32_A16)
					when @PREFICES_ADDRESS
						@working.write(@LEAVE_O16_A32)
					when @PREFICES_ADDRESS | @PREFICES_OPERAND
						@working.write(@LEAVE_O32_A32)

			when 0xca
				switch (bitand @prefices, (@PREFICES_OPERAND | @PREFICES_ADDRESS))
					when 0
						@working.write(@RET_FAR_IW_O16_A16)
					when @PREFICES_OPERAND
						@working.write(@RET_FAR_IW_O32_A16)
					when @PREFICES_ADDRESS
						@working.write(@RET_FAR_IW_O16_A32)
					when @PREFICES_ADDRESS | @PREFICES_OPERAND
						@working.write(@RET_FAR_IW_O32_A32)

			when 0xcb
				switch (bitand @prefices, (@PREFICES_OPERAND | @PREFICES_ADDRESS))
					when 0
						@working.write(@RET_FAR_O16_A16)
					when @PREFICES_OPERAND
						@working.write(@RET_FAR_O32_A16)
					when @PREFICES_ADDRESS
						@working.write(@RET_FAR_O16_A32)
					when @PREFICES_ADDRESS | @PREFICES_OPERAND
						@working.write(@RET_FAR_O32_A32)

			when 0xcc
				switch (bitand @prefices, (@PREFICES_OPERAND | @PREFICES_ADDRESS))
					when 0
						@working.write(@INT3_O16_A16)
					when @PREFICES_OPERAND
						@working.write(@INT3_O32_A16)
					when @PREFICES_ADDRESS
						@working.write(@INT3_O16_A32)
					when @PREFICES_ADDRESS | @PREFICES_OPERAND
						@working.write(@INT3_O32_A32)

			when 0xcd
				switch (bitand @prefices, (@PREFICES_OPERAND | @PREFICES_ADDRESS))
					when 0
						@working.write(@INT_O16_A16)
					when @PREFICES_OPERAND
						@working.write(@INT_O32_A16)
					when @PREFICES_ADDRESS
						@working.write(@INT_O16_A32)
					when @PREFICES_ADDRESS | @PREFICES_OPERAND
						@working.write(@INT_O32_A32)

			when 0xce
				switch (bitand @prefices, (@PREFICES_OPERAND | @PREFICES_ADDRESS))
					when 0
						@working.write(@INTO_O16_A16)
					when @PREFICES_OPERAND
						@working.write(@INTO_O32_A16)
					when @PREFICES_ADDRESS
						@working.write(@INTO_O16_A32)
					when @PREFICES_ADDRESS | @PREFICES_OPERAND
						@working.write(@INTO_O32_A32)

			when 0xcf
				switch (bitand @prefices, (@PREFICES_OPERAND | @PREFICES_ADDRESS))
					when 0
						@working.write(@IRET_O16_A16)
					when @PREFICES_OPERAND
						@working.write(@IRET_O32_A16)
					when @PREFICES_ADDRESS
						@working.write(@IRET_O16_A32)
					when @PREFICES_ADDRESS | @PREFICES_OPERAND
						@working.write(@IRET_O32_A32)

			when 0xd4
				@working.write(@AAM)
			when 0xd5
				@working.write(@AAD)

			when 0xd6
				@working.write(@SALC)

			when 0xe0
				if ((bitand @prefices, @PREFICES_ADDRESS) != 0)
					@working.write(@LOOPNZ_ECX)
				else
					@working.write(@LOOPNZ_CX)

			when 0xe1
				if ((bitand @prefices, @PREFICES_ADDRESS) != 0)
					@working.write(@LOOPZ_ECX)
				else
					@working.write(@LOOPZ_CX)

			when 0xe2
				if ((bitand @prefices, @PREFICES_ADDRESS) != 0)
					@working.write(@LOOP_ECX)
				else
					@working.write(@LOOP_CX)


			when 0xe3
				if ((bitand @prefices, @PREFICES_ADDRESS) != 0)
					@working.write(@JECXZ)
				else
					@working.write(@JCXZ)

			when 0xe4, 0xec
				@working.write(@IN_O8)

			when 0xe5, 0xed
				if @preficesOperand()
					@working.write(@IN_O32)
				else
					@working.write(@IN_O16)

			when 0xe6, 0xee
				@working.write(@OUT_O8)

			when 0xe7, 0xef
				if @preficesOperand()
					@working.write(@OUT_O32)
				else
					@working.write(@OUT_O16)

			when 0xe8
				switch (bitand @prefices, (@PREFICES_OPERAND | @PREFICES_ADDRESS))
					when 0
						@working.write(@CALL_O16_A16)
					when @PREFICES_OPERAND
						@working.write(@CALL_O32_A16)
					when @PREFICES_ADDRESS
						@working.write(@CALL_O16_A32)
					when @PREFICES_ADDRESS | @PREFICES_OPERAND
						@working.write(@CALL_O32_A32)
					else
						log "Wrong value for 0xe8?"

			when 0xe9
				if @preficesOperand()
					@working.write(@JUMP_O32)
				else
					@working.write(@JUMP_O16)

			when 0xea
				if @preficesOperand()
					@working.write(@JUMP_FAR_O32)
				else
					@working.write(@JUMP_FAR_O16)

			when 0xeb
				@working.write(@JUMP_O8)

			when 0xf4
				@working.write(@HALT)

			when 0xf5
				@working.write(@CMC)

			when 0xf6
				switch (bitand @modrm, 0x38)
					when 0x00
						@working.write(@AND)
					when 0x10
						@working.write(@NOT)
					when 0x18
						@working.write(@NEG)
					when 0x20
						@working.write(@MUL_O8)
					when 0x28
						@working.write(@IMULA_O8)
					when 0x30
						@working.write(@DIV_O8)
					when 0x38
						@working.write(@IDIV_O8)
					else
						throw new IllegalStateException("Invalid Gp 3 Instruction?")

			when 0xf7
				if @preficesOperand()
					switch (bitand modrm, 0x38)
						when 0x00
							@working.write(@AND)
						when 0x10
							@working.write(@NOT)
						when 0x18
							@working.write(@NEG)
						when 0x20
							@working.write(@MUL_O32)
						when 0x28
							@working.write(@IMULA_O32)
						when 0x30
							@working.write(@DIV_O32)
						when 0x38
							@working.write(@IDIV_O32)
						else
							throw new IllegalStateException("Invalid Gp 3 Instruction?")
				else
					switch (bitand @modrm, 0x38)
						when 0x00
							@working.write(@AND)
						when 0x10
							@working.write(@NOT)
						when 0x18
							@working.write(@NEG)
						when 0x20
							@working.write(@MUL_O16)
						when 0x28
							@working.write(@IMULA_O16)
						when 0x30
							@working.write(@DIV_O16)
						when 0x38
							@working.write(@IDIV_O16)
						else
							throw new IllegalStateException("Invalid Gp 3 Instruction?")

			when 0xf8
				@working.write(@CLC)
			when 0xf9
				@working.write(@STC)
			when 0xfa
				@working.write(@CLI)
			when 0xfb
				@working.write(@STI)
				@decodeLimit = 2 # let one more instruction be decoded
			when 0xfc
				@working.write(@CLD)
			when 0xfd
				@working.write(@STD)

			when 0xfe
				switch (bitand @modrm, 0x38)
					when 0x00
						@working.write(@INC)
					when 0x08
						@working.write(@DEC)
					else
						bt = bitand @modrm, 0x38
						log "modrm: #{@modrm}, value: #{bt}"

						throw new IllegalStateException("Invalid Gp 4 Instruction?")

			when 0xff
				switch (bitand @modrm, 0x38)
					when 0x00
						@working.write(@INC)
					when 0x08
						@working.write(@DEC)
					when 0x10
						switch (bitand @prefices, (@PREFICES_OPERAND | @PREFICES_ADDRESS))
							when 0
								@working.write(@CALL_ABS_O16_A16)
							when @PREFICES_OPERAND
								@working.write(@CALL_ABS_O32_A16)
							when @PREFICES_ADDRESS
								@working.write(@CALL_ABS_O16_A32)
							when @PREFICES_ADDRESS | @PREFICES_OPERAND
								@working.write(@CALL_ABS_O32_A32)
					when 0x18
						switch (bitand @prefices, (@PREFICES_OPERAND | @PREFICES_ADDRESS))
							when 0
								@working.write(@CALL_FAR_O16_A16)
							when @PREFICES_OPERAND
								@working.write(@CALL_FAR_O32_A16)
							when @PREFICES_ADDRESS
								@working.write(@CALL_FAR_O16_A32)
							when @PREFICES_ADDRESS | @PREFICES_OPERAND
								@working.write(@CALL_FAR_O32_A32)
					when 0x20
						if ((bitand @prefices, @PREFICES_OPERAND) != 0)
							@working.write(@JUMP_ABS_O32)
						else
							@working.write(@JUMP_ABS_O16)

					when 0x28
						if ((bitand @prefices, @PREFICES_OPERAND) != 0)
							@working.write(@JUMP_FAR_O32)
						else
							@working.write(@JUMP_FAR_O16)

					when 0x30
						switch (bitand @prefices, (@PREFICES_OPERAND | @PREFICES_ADDRESS))
							when 0
								@working.write(@PUSH_O16_A16)
							when @PREFICES_OPERAND
								@working.write(@PUSH_O32_A16)
							when @PREFICES_ADDRESS
								@working.write(@PUSH_O16_A32)
							when @PREFICES_ADDRESS | @PREFICES_OPERAND
								@working.write(@PUSH_O32_A32)
					else
						throw new IllegalStateException("Invalid Gp 5 Instruction? FF modrm=" + modrm)

			when 0x90
				@working.write(@MEM_RESET)

			when 0x86, 0x87, 0x88, 0x89, 0x8a, 0x8b, 0x8c, 0x8d, 0x8e, 0x91, 0x92, 0x93, 0x94, 0x95, 0x96, 0x97, 0xa0, 0xa1, 0xa2, 0xa3, 0xb0, 0xb1, 0xb2, 0xb3, 0xb4, 0xb5, 0xb6, 0xb7, 0xb8, 0xb9, 0xba, 0xbb, 0xbc, 0xbd, 0xbe, 0xbf, 0xc4, 0xc5, 0xc6, 0xc7, 0xd7
				break
			when 0x0fff
				@working.write(@UNDEFINED)

			when 0xf00
				switch (bitand @modrm, 0x38)
					when 0x00
						@working.write(@SLDT)
					when 0x08
						@working.write(@STR)
					when 0x10
						@working.write(@LLDT)
					when 0x18
						@working.write(@LTR)
					when 0x20
						@working.write(@VERR)
					when 0x28
						@working.write(@VERW)
					else
						throw new IllegalStateException("Invalid Gp 6 Instruction?")


			when 0xf01
				switch (bitand @modrm, 0x38)
					when 0x00
						if @preficesOperand()
							@working.write(@SGDT_O32)
						else
							@working.write(@SGDT_O16)
					when 0x08
						if @preficesOperand()
							@working.write(@SIDT_O32)
						else
							@working.write(@SIDT_O16)
					when 0x10
						if @preficesOperand()
							@working.write(@LGDT_O32)
						else
							@working.write(@LGDT_O16)
					when 0x18
						if @preficesOperand()
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


			when 0xf02
				@working.write(@LAR)
			when 0xf03
				@working.write(@LSL)
			when 0xf06
				@working.write(@CLTS)
			when 0xf09
				@working.write(@CPL_CHECK)
			when 0xf0b
				@working.write(@UNDEFINED)
			when 0xf1f
				@working.write(@MEM_RESET)
			when 0xf30
				@working.write(@WRMSR)
			when 0xf31
				@working.write(@RDTSC)
			when 0xf32
				@working.write(@RDMSR)
			when 0xf34
				@working.write(@SYSENTER)
			when 0xf35
				@working.write(@SYSEXIT)
			when 0xf40
				@working.write(@CMOVO)
			when 0xf41
				@working.write(@CMOVNO)
			when 0xf42
				@working.write(@CMOVC)
			when 0xf43
				@working.write(@CMOVNC)
			when 0xf44
				@working.write(@CMOVZ)
			when 0xf45
				@working.write(@CMOVNZ)
			when 0xf46
				@working.write(@CMOVNA)
			when 0xf47
				@working.write(@CMOVA)
			when 0xf48
				@working.write(@CMOVS)
			when 0xf49
				@working.write(@CMOVNS)
			when 0xf4a
				@working.write(@CMOVP)
			when 0xf4b
				@working.write(@CMOVNP)
			when 0xf4c
				@working.write(@CMOVL)
			when 0xf4d
				@working.write(@CMOVNL)
			when 0xf4e
				@working.write(@CMOVNG)
			when 0xf4f
				@working.write(@CMOVG)

			when 0xf80
				if @preficesOperand()
					@working.write(@JO_O32)
				else
					@working.write(@JO_O16)

			when 0xf81
				if @preficesOperand()
					@working.write(@JNO_O32)
				else
					@working.write(@JNO_O16)

			when 0xf82
				if @preficesOperand()
					@working.write(@JC_O32)
				else
					@working.write(@JC_O16)

			when 0xf83
				if @preficesOperand()
					@working.write(@JNC_O32)
				else
					@working.write(@JNC_O16)

			when 0xf84
				if @preficesOperand()
					@working.write(@JZ_O32)
				else
					@working.write(@JZ_O16)

			when 0xf85
				if @preficesOperand()
					@working.write(@JNZ_O32)
				else
					@working.write(@JNZ_O16)

			when 0xf86
				if @preficesOperand()
					@working.write(@JNA_O32)
				else
					@working.write(@JNA_O16)

			when 0xf87
				if @preficesOperand()
					@working.write(@JA_O32)
				else
					@working.write(@JA_O16)

			when 0xf88
				if @preficesOperand()
					@working.write(@JS_O32)
				else
					@working.write(@JS_O16)

			when 0xf89
				if @preficesOperand()
					@working.write(@JNS_O32)
				else
					@working.write(@JNS_O16)

			when 0xf8a
				if @preficesOperand()
					@working.write(@JP_O32)
				else
					@working.write(@JP_O16)

			when 0xf8b
				if @preficesOperand()
					@working.write(@JNP_O32)
				else
					@working.write(@JNP_O16)

			when 0xf8c
				if @preficesOperand()
					working.write(@JL_O32)
				else
					working.write(@JL_O16)

			when 0xf8d
				if @preficesOperand()
					@working.write(@JNL_O32)
				else
					@working.write(@JNL_O16)

			when 0xf8e
				if @preficesOperand()
					@working.write(@JNG_O32)
				else
					@working.write(@JNG_O16)

			when 0xf8f
				if @preficesOperand()
					@working.write(@JG_O32)
				else
					@working.write(@JG_O16)

			when 0xf90
				@working.write(@SETO)
			when 0xf91
				@working.write(@SETNO)
			when 0xf92
				@working.write(@SETC)
			when 0xf93
				@working.write(@SETNC)
			when 0xf94
				@working.write(@SETZ)
			when 0xf95
				@working.write(@SETNZ)
			when 0xf96
				@working.write(@SETNA)
			when 0xf97
				@working.write(@SETA)
			when 0xf98
				@working.write(@SETS)
			when 0xf99
				@working.write(@SETNS)
			when 0xf9a
				@working.write(@SETP)
			when 0xf9b
				@working.write(@SETNP)
			when 0xf9c
				@working.write(@SETL)
			when 0xf9d
				@working.write(@SETNL)
			when 0xf9e
				@working.write(@SETNG)
			when 0xf9f
				@working.write(@SETG)
			when 0xfa2
				@working.write(@CPUID)

			when 0xfa4, 0xfa5
				if @preficesOperand()
					@working.write(@SHLD_O32)
				else
					@working.write(@SHLD_O16)


			when 0xfac, 0xfad
				if @preficesOperand()
					@working.write(@SHRD_O32)
				else
					@working.write(@SHRD_O16)

			when 0xfb0, 0xfb1
				@working.write(@CMPXCHG)

			when 0xfa3
				switch (bitand @modrm, 0xc7)
					when 0xc0, 0xc1, 0xc2, 0xc3, 0xc4, 0xc5, 0xc6, 0xc7
						if @preficesOperand()
							@working.write(@BT_O32)
						else
							@working.write(@BT_O16)
					else
						@working.write(BT_MEM)

			when 0xfab
				switch (bitand @modrm, 0xc7)
					when 0xc0, 0xc1, 0xc2, 0xc3, 0xc4, 0xc5, 0xc6, 0xc7
						if @preficesOperand()
							@working.write(@BTS_O32)
						else
							@working.write(@BTS_O16)
					else
						@working.write(@BTS_MEM)

			when 0xfb3
				switch (bitand @modrm, 0xc7)
					when 0xc0, 0xc1, 0xc2, 0xc3, 0xc4, 0xc5, 0xc6, 0xc7
						if @preficesOperand()
							@working.write(@BTR_O32)
						else
							@working.write(@BTR_O16)
					else
						@working.write(@BTR_MEM)

			when 0xfbb
				switch (bitand @modrm, 0xc7)
					when 0xc0, 0xc1, 0xc2, 0xc3, 0xc4, 0xc5, 0xc6, 0xc7
						if @preficesOperand()
							@working.write(@BTC_O32)
						else
							@working.write(@BTC_O16)

					else
						@working.write(@BTC_MEM)
			when 0xfba
				switch (bitand @modrm, 0x38)
					when 0x20
						switch (bitand @modrm, 0xc7)
							when 0xc0, 0xc1, 0xc2, 0xc3, 0xc4, 0xc5, 0xc6, 0xc7
								if @preficesOperand()
									@working.write(@BT_O32)
								else
									@working.write(@BT_O16)
							else
								@working.write(@BT_MEM)

					when 0x28
						switch (bitand @modrm, 0xc7)
							when 0xc0, 0xc1, 0xc2, 0xc3, 0xc4, 0xc5, 0xc6, 0xc7
								if @preficesOperand()
									@working.write(@BTS_O32)
								else
									@working.write(@BTS_O16)
							else
								@working.write(@BTS_MEM)


					when 0x30
						switch (bitand @modrm, 0xc7)
							when 0xc0, 0xc1, 0xc2, 0xc3, 0xc4, 0xc5, 0xc6, 0xc7
								if @preficesOperand()
									@working.write(@BTR_O32)
								else
									@working.write(@BTR_O16)
							else
								@working.write(@BTR_MEM)
					when 0x38
						switch (bitand @modrm, 0xc7)
							when 0xc0, 0xc1, 0xc2, 0xc3, 0xc4, 0xc5, 0xc6, 0xc7
								if @preficesOperand()
									@working.write(@BTC_O32)
								else
									@working.write(@BTC_O16)
							else
								@working.write(@BTC_MEM)
					else
						throw new IllegalStateException("Invalid Gp 8 Instruction?")

			when 0xfbc
				@working.write(@BSF)
			when 0xfbd
				@working.write(@BSR)

			when 0xfbe
				if @preficesOperand()
					@working.write(@SIGN_EXTEND_8_32)
				else
					@working.write(@SIGN_EXTEND_8_16)

			when 0xfbf
				if @preficesOperand()
					@working.write(@SIGN_EXTEND_16_32)


			when 0xfc7
				switch (bitand @modrm, 0x38)
					when 0x08
						@working.write(@CMPXCHG8B)
					else
						throw new IllegalStateException("Invalid Gp 6 Instruction?")
			when 0xfc8, 0xfc9, 0xfca, 0xfcb, 0xfcc, 0xfcd, 0xfce, 0xfcf
				@working.write(@BSWAP)

			when 0xf20, 0xf21, 0xf22, 0xf23, 0xfb2, 0xfb4, 0xfb5, 0xfb6, 0xfb7
				break # check

			when 0xd800
				switch (bitand @modrm, 0x38)
					when 0x00
						@working.write(@FADD)
					when 0x08
						@working.write(@FMUL)
					when 0x10, 0x18
						@working.write(@FCOM)
					when 0x20, 0x28
						@working.write(@FSUB)
					when 0x30, 0x38
						@working.write(@FDIV)

			when 0xd900
				if ((bitand @modrm, 0xc0) != 0xc0)
					switch (bitand @modrm, 0x38)
						when 0x00
							@working.write(@FPUSH)
						when 0x10, 0x18, 0x28, 0x38, 0x20
							if @preficesOperand()
								@working.write(@FLDENV_28)
							else
								@working.write(@FLDENV_14)

						when 0x30
							if @preficesOperand()
								@working.write(@FSTENV_28)
							else
								@working.write(@FSTENV_14)
				else
					switch (bitand @modrm, 0xf8)
						when 0xc0
							@working.write(@FPUSH)
					switch (@modrm)
						when 0xd0, 0xe0
							@working.write(@FCHS)
						when 0xe1
							@working.write(@FABS)
						when 0xe4
							@working.write(@FCOM)
						when 0xe5
							@working.write(@FXAM)
						when 0xe8, 0xe9, 0xea, 0xeb, 0xec, 0xed, 0xee
							@working.write(@FPUSH)
						when 0xf0
							@working.write(@F2XM1)
						when 0xf1
							@working.write(@FYL2X)
						when 0xf2
							@working.write(@FPTAN)
						when 0xf3
							@working.write(@FPATAN)
						when 0xf4
							@working.write(@FXTRACT)
						when 0xf5
							@working.write(@FPREM1)
						when 0xf6
							@working.write(@FDECSTP)
						when 0xf7
							@working.write(@FINCSTP)
						when 0xf8
							@working.write(@FPREM)
						when 0xf9
							@working.write(@FYL2XP1)
						when 0xfa
							@working.write(@FSQRT)
						when 0xfb
							@working.write(@FSINCOS)
						when 0xfc
							@working.write(@FRNDINT)
						when 0xfd
							@working.write(@FSCALE)
						when 0xfe
							@working.write(@FSIN)
						when 0xff
							@working.write(@FCOS)

			when 0xda00
				if ((bitand @modrm, 0xc0) != 0xc0)
					switch (bitand @modrm, 0x38)
						when 0x00
							@working.write(@FADD)
						when 0x08
							@working.write(@FMUL)
						when 0x10, 0x18
							@working.write(@FCOM)
						when 0x20, 0x28
							@working.write(@FSUB)
						when 0x30, 0x38
							@working.write(@FDIV)
				else
					switch (bitand @modrm, 0xf8)
						when 0xc0
							@working.write(@FCMOVB)
						when 0xc8
							@working.write(@FCMOVE)
						when 0xd0
							@working.write(@FCMOVBE)
						when 0xd8
							@working.write(@FCMOVU)

					switch (@modrm)
						when 0xe9
							@working.write(@FUCOM)

			when 0xdb00
				if ((bitand @modrm, 0xc0) != 0xc0)
					switch (bitand @modrm, 0x38)
						when 0x00
							@working.write(@FPUSH)
						when 0x08
							@working.write(@FCHOP)
						when 0x10, 0x18
							@working.write(@FRNDINT)
						when 0x28
							@working.write(@FPUSH)
				else
					switch (bitand @modrm, 0xf8)
						when 0xc0
							@working.write(@FCMOVNB)
						when 0xc8
							@working.write(@FCMOVNE)
						when 0xd0
							@working.write(@FCMOVNBE)
						when 0xd8
							@working.write(@FCMOVNU)
						when 0xe8
							@working.write(@FUCOMI)
						when 0xf0
							@working.write(@FCOMI)

					switch (@modrm)
						when 0xe2
							@working.write(@FCLEX)
						when 0xe3
							@working.write(@FINIT)


			when 0xdc00
				switch (bitand @modrm, 0x38)
					when 0x00
						@working.write(@FADD)
					when 0x08
						@working.write(@FMUL)
					when 0x10, 0x18
						@working.write(@FCOM)
					when 0x20, 0x28
						@working.write(@FSUB)
					when 0x30, 0x38
						@working.write(@FDIV)

			when 0xdd00
				if ((bitand @modrm, 0xc0) != 0xc0)
					switch (bitand @modrm, 0x38)
						when 0x00
							@working.write(@FPUSH)
						when 0x08
							@working.write(@FCHOP)
						when 0x10, 0x18, 0x38, 0x20
							if @preficesOperand()
								@working.write(@FRSTOR_108)
							else
								@working.write(@FRSTOR_94)

						when 0x30
							if @preficesOperand()
								@working.write(@FSAVE_108)
							else
								@working.write(@FSAVE_94)
				else
					switch (bitand @modrm, 0xf8)
						when 0xc0
							@working.write(@FFREE)
						when 0xd0, 0xd8, 0xe0, 0xe8
							@working.write(@FUCOM)

			when 0xde00
				switch (@modrm)
					when 0xd9
						@working.write(@FCOM)
					else
						switch (bitand @modrm, 0x38)
							when 0x00
								@working.write(@FADD)
							when 0x08
								@working.write(@FMUL)
							when 0x10, 0x18
								@working.write(@FCOM)
							when 0x20, 0x28
								@working.write(@FSUB)
							when 0x30, 0x38
								@working.write(@FDIV)


			when 0xdf00
				if ((bitand @modrm, 0xc0) != 0xc0)
					switch (bitand @modrm, 0x38)
						when 0x00
							@working.write(@FPUSH)
						when 0x08
							@working.write(@FCHOP)
						when 0x10, 0x18, 0x38
							@working.write(@FRNDINT)
						when 0x20
							@working.write(@FBCD2F)
						when 0x28
							@working.write(@FPUSH)
						when 0x30
							@working.write(@FF2BCD)
				else
					switch (bitand @modrm, 0xf8)
						when 0xe8
							@working.write(@FUCOMI)
						when 0xf0
							@working.write(@FCOMI)
			when 0x63
				break
			else
				throw new NotImplementedError("Opcode #{opcode} not supported.")

	writeOutputOperands: (opcode, displacement) ->
		switch opcode
			when 0x00, 0x08, 0x10, 0x18, 0x20, 0x28, 0x30, 0x88, 0xc0, 0xc6, 0xfe, 0xf90, 0xf91, 0xf92, 0xf93, 0xf94, 0xf95, 0xf96, 0xf97, 0xf98, 0xf99, 0xf9a, 0xf9b, 0xf9c, 0xf9d, 0xf9e, 0xf9f
				@store0_Eb(displacement)

			when 0xfb0
				@working.write(@STORE1_AL)
				@store0_Eb(displacement)

			when 0x80, 0x82
				if ((bitand @modrm, 0x38) == 0x38)
					break
				@store0_Eb(displacement)

			when 0x86
				@store0_Gb()
				@store1_Eb(displacement)

			when 0x02, 0x0a, 0x12, 0x1a, 0x22, 0x2a, 0x32, 0x8a
				@store0_Gb()

			when 0x01, 0x09, 0x11, 0x19, 0x21, 0x29, 0x31, 0x89, 0xc7, 0xc1, 0x8f, 0xd1, 0xd3
				if @preficesOperand()
					@store0_Ed(displacement)
				else
					@store0_Ew(displacement)

			when 0xfb1
				if @preficesOperand()
					@working.write(@STORE1_EAX)
					@store0_Ed(displacement)
				else
					@working.write(@STORE1_AX)
					@store0_Ew(displacement)

			when 0x81, 0x83
				if ((bitand @modrm, 0x38) == 0x38)
					break
				if @preficesOperand()
					@store0_Ed(displacement)
				else
					@store0_Ew(displacement)

			when 0x87
				if @preficesOperand()
					@store0_Gd()
					@store1_Ed(displacement)
				else
					@store0_Gw()
					@store1_Ew(displacement)


			when 0x03, 0x0b, 0x13, 0x1b, 0x23, 0x2b, 0x33, 0x69, 0x6b, 0x8b, 0x8d, 0xf02, 0xf03, 0xf40, 0xf41, 0xf42, 0xf43, 0xf44, 0xf45, 0xf46, 0xf47, 0xf48, 0xf49, 0xf4a, 0xf4b, 0xf4c, 0xf4d, 0xf4e, 0xf4f, 0xfaf, 0xfb6, 0xfb7, 0xfbc, 0xfbd, 0xfbe, 0xfbf
				if @preficesOperand()
					@store0_Gd()
				else
					@store0_Gw()

			when 0xec, 0x04, 0x0c, 0x14, 0x1c, 0x24, 0x2c, 0x34, 0xe4, 0xb0
				@working.write(@STORE0_AL)

			when 0xb1
				@working.write(@STORE0_CL)

			when 0xb2
				@working.write(@STORE0_DL)

			when 0xb3
				@working.write(@STORE0_BL)

			when 0xb4
				@working.write(@STORE0_AH)

			when 0xb5
				@working.write(@STORE0_CH)

			when 0xb6
				@working.write(@STORE0_DH)

			when 0xb7
				@working.write(@STORE0_BH)

			when 0x05, 0x0d, 0x15, 0x1d, 0x25, 0x2d, 0x35, 0xb8, 0xe5, 0x40, 0x48, 0x58, 0xed
				if @preficesOperand()
					@working.write(@STORE0_EAX)
				else
					@working.write(@STORE0_AX)

			when 0x41, 0x49, 0x59, 0xb9
				if @preficesOperand()
					@working.write(@STORE0_ECX)
				else
					@working.write(@STORE0_CX)

			when 0x42, 0x4a, 0x5a, 0xba
				if @preficesOperand()
					@working.write(@STORE0_EDX)
				else
					@working.write(@STORE0_DX)

			when 0x43, 0x4b, 0x5b, 0xbb
				if @preficesOperand()
					@working.write(@STORE0_EBX)
				else
					@working.write(@STORE0_BX)

			when 0x44, 0x4c, 0x5c, 0xbc
				if @preficesOperand()
					@working.write(@STORE0_ESP)
				else
					@working.write(@STORE0_SP)

			when 0x45, 0x4d, 0x5d, 0xbd
				if @preficesOperand()
					@working.write(@STORE0_EBP)
				else
					@working.write(@STORE0_BP)

			when 0x46, 0x4e, 0x5e, 0xbe
				if @preficesOperand()
					@working.write(@STORE0_ESI)
				else
					@working.write(@STORE0_SI)

			when 0x47, 0x4f, 0x5f, 0xbf
				if @preficesOperand()
					@working.write(@STORE0_EDI)
				else
					@working.write(@STORE0_DI)

			when 0x91
				if @preficesOperand()
					@working.write(@STORE0_ECX)
					@working.write(@STORE1_EAX)
				else
					@working.write(@STORE0_CX)
					@working.write(@STORE1_AX)

			when 0x92
				if @preficesOperand()
					@working.write(@STORE0_EDX)
					@working.write(@STORE1_EAX)
				else
					@working.write(@STORE0_DX)
					@working.write(@STORE1_AX)

			when 0x93
				if @preficesOperand()
					@working.write(@STORE0_EBX)
					@working.write(@STORE1_EAX)
				else
					@working.write(@STORE0_BX)
					@working.write(@STORE1_AX)

			when 0x94
				if @preficesOperand()
					@working.write(@STORE0_ESP)
					@working.write(@STORE1_EAX)
				else
					@working.write(@STORE0_SP)
					@working.write(@STORE1_AX)

			when 0x95
				if @preficesOperand()
					@working.write(@STORE0_EBP)
					@working.write(@STORE1_EAX)
				else
					@working.write(@STORE0_BP)
					@working.write(@STORE1_AX)

			when 0x96
				if @preficesOperand()
					@working.write(@STORE0_ESI)
					@working.write(@STORE1_EAX)
				else
					@working.write(@STORE0_SI)
					@working.write(@STORE1_AX)

			when 0x97
				if @preficesOperand()
					@working.write(@STORE0_EDI)
					@working.write(@STORE1_EAX)
				else
					@working.write(@STORE0_DI)
					@working.write(@STORE1_AX)

			when 0x9d
				switch (bitand @prefices, @PREFICES_OPERAND)
					when 0
						@working.write(@STORE0_FLAGS)
					when @PREFICES_OPERAND
						@working.write(@STORE0_EFLAGS)

			when 0xd0, 0xd2
				@store0_Eb(displacement)

			when 0xf6
				switch (bitand @modrm, 0x38)
					when 0x10, 0x18
						@store0_Eb(displacement)

			when 0xf7
				if @preficesOperand()
					switch (bitand @modrm, 0x38)
						when 0x10, 0x18
							@store0_Ed(displacement)
				else
					switch (bitand @modrm, 0x38)
						when 0x10, 0x18
							@store0_Ew(displacement)

			when 0x07
				@working.write(@STORE0_ES)

			when 0x17
				@working.write(@STORE0_SS)

			when 0x1f
				@working.write(@STORE0_DS)

			when 0x8c
				if @preficesOperand()
					@store0_Ed(displacement)
				else
					@store0_Ew(displacement)

			when 0x8e
				@store0_Sw()

			when 0xa0
				@working.write(@STORE0_AL)

			when 0xa2
				@store0_Ob(displacement)

			when 0xa1
				if @preficesOperand()
					@working.write(@STORE0_EAX)
				else
					@working.write(@STORE0_AX)

			when 0xa3
				if @preficesOperand()
					@store0_Od(displacement)
				else
					log "PREF" + @prefices
					@store0_Ow(displacement)

			when 0xff
				if @preficesOperand()
					switch (bitand @modrm, 0x38)
						when 0x00, 0x08
							@store0_Ed(displacement)
				else
					switch (bitand @modrm, 0x38)
						when 0x00, 0x08
							@store0_Ew(displacement)

			when 0xc4
				if @preficesOperand()
					@store0_Gd()
					@working.write(@STORE1_ES)
				else
					@store0_Gw()
					@working.write(@STORE1_ES)


			when 0xc5
				if @preficesOperand()
					@store0_Gd()
					@working.write(@STORE1_DS)
				else
					@store0_Gw()
					@working.write(@STORE1_DS)


			when 0xf00
				switch (bitand @modrm, 0x38)
					when 0x00
						@store0_Ew(displacement)
					when 0x08
						if @preficesOperand()
							switch (bitand @modrm, 0xc7)
								when 0xc0
									@working.write(@STORE0_EAX)
								when 0xc1
									@working.write(@STORE0_ECX)
								when 0xc2
									@working.write(@STORE0_EDX)
								when 0xc3
									@working.write(@STORE0_EBX)
								when 0xc4
									@working.write(@STORE0_ESP)
								when 0xc5
									@working.write(@STORE0_EBP)
								when 0xc6
									@working.write(@STORE0_ESI)
								when 0xc7
									@working.write(@STORE0_EDI)
								else
									@decodeM(displacement)
									@working.write(@STORE0_MEM_WORD)
						else
							@store0_Ew(displacement)

			when 0xf01
				switch (bitand @modrm, 0x38)
					when 0x00, 0x08
						@store0_Ew(displacement)
						@working.write(@ADDR_ID)
						@working.write(2)
						@working.write(@STORE1_MEM_DWORD)
					when 0x20
						@store0_Ew(displacement)

			when 0xf1f
				break
			when 0xfa4, 0xfa5, 0xfac, 0xfad
				if @preficesOperand()
					@store0_Ed(displacement)
				else
					@store0_Ew(displacement)

			when 0xfb2
				if @preficesOperand()
					@store0_Gd()
					@working.write(@STORE1_SS)
				else
					@store0_Gw()
					@working.write(@STORE1_SS)


			when 0xfb4
				if @preficesOperand()
					@store0_Gd()
					@working.write(@STORE1_FS)
				else
					@store0_Gw()
					@working.write(@STORE1_FS)

			when 0xfb5
				if @preficesOperand()
					@store0_Gd()
					@working.write(@STORE1_GS)
				else
					@store0_Gw()
					@working.write(@STORE1_GS)

			when 0xfc0
				@store1_Gb()
				@store0_Eb(displacement)

			when 0xfc1
				if @preficesOperand()
					@store1_Gd()
					@store0_Ed(displacement)
				else
					@store1_Gw()
					@store0_Ew(displacement)

			when 0xd6, 0xd7
				@working.write(@STORE0_AL)

			when 0xf20, 0xf21
				store0_Rd()

			when 0xf22
				@store0_Cd()
			when 0xf23
				@store0_Dd()

			when 0xf31, 0xf32
				@working.write(@STORE0_EAX)
				@working.write(@STORE1_EDX)

			when 0xfa1
				@working.write(@STORE0_FS)

			when 0xfa9
				@working.write(@STORE0_GS)

			when 0xfab, 0xfb3, 0xfbb
				if @preficesOperand()
					if ((bitand @modrm, 0xc0) == 0xc0)
						@store0_Ed(displacement)
				else
					if ((bitand @modrm, 0xc0) == 0xc0)
						@store0_Ew(displacement)

			when 0xfba
				switch (bitand @modrm, 0x38)
					when 0x28, 0x30, 0x38
						if @preficesOperand()
							if ((bitand @modrm, 0xc0) == 0xc0)
								@store0_Ed(displacement)
						else
							if ((bitand @modrm, 0xc0) == 0xc0)
								@store0_Ew(displacement)

			when 0xfc7
				switch (bitand @modrm, 0x38)
					when 0x08
						@decodeM(displacement)
						@working.write(@STORE0_MEM_QWORD)
					else
						throw new IllegalStateException("Invalid Gp 6 Instruction?")


			when 0xfc8
				@working.write(@STORE0_EAX)
			when 0xfc9
				@working.write(@STORE0_ECX)
			when 0xfca
				@working.write(@STORE0_EDX)
			when 0xfcb
				@working.write(@STORE0_EBX)
			when 0xfcc
				@working.write(@STORE0_ESP)
			when 0xfcd
				@working.write(@STORE0_EBP)
			when 0xfce
				@working.write(@STORE0_ESI)
			when 0xfcf
				@working.write(@STORE0_EDI)
			when 0xd800
				switch (bitand @modrm, 0x38)
					when 0x00, 0x08, 0x20, 0x28, 0x30, 0x38
						@working.write(@FSTORE0_ST0)
						@working.write(@FCHECK0)
					when 0x10
						break
					when 0x18
						@working.write(@FPOP)

			when 0xd900
				if ((bitand @modrm, 0xc0) != 0xc0)
					switch (bitand @modrm, 0x38)
						when 0x00, 0x20, 0x30
							break
						when 0x10
							@decodeM(displacement)
							@working.write(@FSTORE0_MEM_SINGLE)
						when 0x18
							@decodeM(displacement)
							@working.write(@FSTORE0_MEM_SINGLE)
							@working.write(@FPOP)
						when 0x28
							@working.write(@STORE0_FPUCW)
						when 0x38
							@decodeM(displacement)
							@working.write(@STORE0_MEM_WORD)

				else
					switch (bitand @modrm, 0xf8)
						when 0xc0
							break
						when 0xc8
							@working.write(@FSTORE0_STN)
							@working.write(bitand @modrm, 0x07)
							@working.write(@FSTORE1_ST0)
					switch (@modrm)
						when 0xd0, 0xe4, 0xe5, 0xe8, 0xe9, 0xea, 0xeb, 0xec, 0xed, 0xee, 0xf6, 0xf7
							break
						when 0xe0, 0xe1, 0xfe, 0xff
							@working.write(@FSTORE0_ST0)
						when 0xf0, 0xf5, 0xf8, 0xfa, 0xfc, 0xfd
							@working.write(@FSTORE0_ST0)
							@working.write(@FCHECK0)
						when 0xf2
							@working.write(@FSTORE0_ST0)
							@working.write(@FLOAD0_1)
							@working.write(@FPUSH)
						when 0xf1, 0xf3
							@working.write(@FPOP)
							@working.write(@FSTORE0_ST0)
						when 0xf9
							@working.write(@FPOP)
							@working.write(@FSTORE0_ST0)
							@working.write(@FCHECK0)
						when 0xf4
							@working.write(@FSTORE1_ST0)
							@working.write(@FPUSH)
						when 0xfb
							@working.write(@FSTORE1_ST0)
							@working.write(@FPUSH)
							@working.write(@FCHECK0)
							@working.write(@FCHECK1)

			when 0xda00
				if ((bitand @modrm, 0xc0) != 0xc0)
					switch (bitand @modrm, 0x38)
						when 0x00, 0x08, 0x20, 0x28, 0x30, 0x38
							@working.write(@FSTORE0_ST0)
							@working.write(@FCHECK0)
						when 0x10
							break
						when 0x18
							@working.write(@FPOP)
				else
					switch (@modrm)
						when 0xe9
							@working.write(@FPOP)
							@working.write(@FPOP)
			when 0xdb00
				if ((bitand @modrm, 0xc0) != 0xc0)
					switch (bitand @modrm, 0x38)
						when 0x00, 0x28
							break
						when 0x10
							@decodeM(displacement)
							@working.write(@STORE0_MEM_DWORD)
						when 0x08, 0x18
							@decodeM(displacement)
							@working.write(@STORE0_MEM_DWORD)
							@working.write(@FPOP)
						when 0x38
							@decodeM(displacement)
							@working.write(@FSTORE0_MEM_EXTENDED)
							@working.write(@FPOP)

			when 0xdc00
				if ((bitand @modrm, 0xc0) != 0xc0)
					switch (bitand @modrm, 0x38)
						when 0x00, 0x08, 0x20, 0x28, 0x30, 0x38
							@working.write(@FSTORE0_ST0)
							@working.write(@FCHECK0)

						when 0x10
							break
						when 0x18
							@working.write(@FPOP)
				else
					switch (bitand @modrm, 0xf8)
						when 0xc0, 0xc8, 0xe0, 0xe8, 0xf0, 0xf8
							@working.write(@FSTORE0_STN)
							@working.write(bitand modrm, 0x07)
							@working.write(@FCHECK0)

			when 0xdd00
				if ((bitand @modrm, 0xc0) != 0xc0)
					switch (bitand @modrm, 0x38)
						when 0x00, 0x20, 0x30
							break
						when 0x08
							@decodeM(displacement)
							@working.write(@STORE0_MEM_QWORD)
							@working.write(@FPOP)
						when 0x10
							@decodeM(displacement)
							@working.write(@FSTORE0_MEM_DOUBLE)
						when 0x18
							@decodeM(displacement)
							@working.write(@FSTORE0_MEM_DOUBLE)
							@working.write(@FPOP)
						when 0x38
							@decodeM(displacement)
							@working.write(@STORE0_MEM_WORD)
				else
					switch (bitand @modrm, 0xf8)
						when 0xc0, 0xe0
							break
						when 0xd0
							@working.write(@FSTORE0_STN)
							@working.write(bitand @modrm, 0x07)
						when 0xd8
							@working.write(@FSTORE0_STN)
							@working.write(bitand @modrm, 0x07)
							@working.write(@FPOP)
						when 0xe8
							@working.write(@FPOP)

			when 0xde00
				if ((bitand @modrm, 0xc0) != 0xc0)
					switch (bitand @modrm, 0x38)
						when 0x00, 0x08, 0x20, 0x28, 0x30, 0x38
							@working.write(@FSTORE0_ST0)
							@working.write(@FCHECK0)
						when 0x10
							break
						when 0x18
							@working.write(@FPOP)
				else
					switch (@bitand modrm, 0xf8)
						when 0xc0, 0xc8, 0xe0, 0xe8, 0xf0, 0xf8
							@working.write(@FSTORE0_STN)
							@working.write(bitand @modrm, 0x07)
							@working.write(@FPOP)
							@working.write(@FCHECK0)
						when 0xd0, 0xd8
							break
					switch (@modrm)
						when 0xd9
							@working.write(@FPOP)
							@working.write(@FPOP)

			when 0xdf00
				if ((bitand @modrm, 0xc0) != 0xc0)
					switch (bitand @modrm, 0x38)
						when 0x00, 0x20, 0x28, 0x30
							break
						when 0x08, 0x18
							@decodeM(displacement)
							@working.write(@STORE0_MEM_WORD)
							@working.write(@FPOP)
						when 0x10
							@decodeM(displacement)
							@working.write(@STORE0_MEM_WORD)
						when 0x38
							@decodeM(displacement)
							@working.write(@STORE0_MEM_QWORD)
							@working.write(@FPOP)
				else
					switch (bitand @modrm, 0xf8)
						when 0xe8, 0xf0
							@working.write(@FPOP)
					switch (@modrm)
						when 0xe0
							@working.write(@STORE0_AX)

	writeFlags: (opcode) ->
		switch (opcode)
			when 0x00, 0x02, 0x04, 0xfc0
				@working.write(@ADD_O8_FLAGS)
			when 0x10, 0x12, 0x14
				@working.write(@ADC_O8_FLAGS)
			when 0x18, 0x1a, 0x1c
				@working.write(@SBB_O8_FLAGS)
			when 0x28, 0x2a, 0x2c, 0x38, 0x3a, 0x3c
				@working.write(@SUB_O8_FLAGS)
			when 0x01, 0x03, 0x05, 0xfc1
				if @preficesOperand()
					@working.write(@ADD_O32_FLAGS)
				else
					@working.write(@ADD_O16_FLAGS)
			when 0x11, 0x13, 0x15
				if @preficesOperand()
					@working.write(@ADC_O32_FLAGS)
				else
					@working.write(@ADC_O16_FLAGS)
			when 0x19, 0x1b, 0x1d
				if @preficesOperand()
					@working.write(@SBB_O32_FLAGS)
				else
					@working.write(@SBB_O16_FLAGS)
			when 0x29, 0x2b, 0x2d, 0x39, 0x3b, 0x3d
				if @preficesOperand()
					@working.write(@SUB_O32_FLAGS)
				else
					@working.write(@SUB_O16_FLAGS)
			when 0x08, 0x0a, 0x0c, 0x20, 0x22, 0x24, 0x30, 0x32, 0x34, 0x84, 0xa8
				@working.write(@BITWISE_FLAGS_O8)

			when 0x09, 0x0b, 0x0d, 0x21, 0x23, 0x25, 0x31, 0x33, 0x35, 0x85, 0xa9
				if @preficesOperand()
					@working.write(@BITWISE_FLAGS_O32)
				else
					@working.write(@BITWISE_FLAGS_O16)
			when 0x40, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46, 0x47
				if @preficesOperand()
					@working.write(@INC_O32_FLAGS)
				else
					@working.write(@INC_O16_FLAGS)
			when 0x48, 0x49, 0x4a, 0x4b, 0x4c, 0x4d, 0x4e, 0x4f
				if @preficesOperand()
					@working.write(@DEC_O32_FLAGS)
				else
					@working.write(@DEC_O16_FLAGS)
			when 0x80, 0x82
				switch (bitand @modrm, 0x38)
					when 0x00
						@working.write(@ADD_O8_FLAGS)
					when 0x08
						@working.write(@BITWISE_FLAGS_O8)
					when 0x10
						@working.write(@ADC_O8_FLAGS)
					when 0x18
						@working.write(@SBB_O8_FLAGS)
					when 0x20
						@working.write(@BITWISE_FLAGS_O8)
					when 0x28, 0x38
						@working.write(@SUB_O8_FLAGS)
					when 0x30
						@working.write(@BITWISE_FLAGS_O8)
			when 0x81, 0x83
				if @preficesOperand()
					switch (bitand @modrm, 0x38)
						when 0x00
							@working.write(@ADD_O32_FLAGS)
						when 0x08
							@working.write(@BITWISE_FLAGS_O32)
						when 0x10
							@working.write(@ADC_O32_FLAGS)
						when 0x18
							@working.write(@SBB_O32_FLAGS)
						when 0x20
							@working.write(@BITWISE_FLAGS_O32)
						when 0x28, 0x38
							@working.write(@SUB_O32_FLAGS)
						when 0x30
							@working.write(@BITWISE_FLAGS_O32)

				else
					switch (bitand @modrm, 0x38)
						when 0x00
							@working.write(@ADD_O16_FLAGS)
						when 0x08
							@working.write(@BITWISE_FLAGS_O16)
						when 0x10
							@working.write(@ADC_O16_FLAGS)
						when 0x18
							@working.write(@SBB_O16_FLAGS)
						when 0x20
							@working.write(@BITWISE_FLAGS_O16)
						when 0x28, 0x38
							@working.write(@SUB_O16_FLAGS)
						when 0x30
							@working.write(@BITWISE_FLAGS_O16)
			when 0xc0, 0xd0, 0xd2
				switch (bitand @modrm, 0x38)
					when 0x00
						@working.write(@ROL_O8_FLAGS)
					when 0x08
						@working.write(@ROR_O8_FLAGS)
					when 0x10
						@working.write(@RCL_O8_FLAGS)
					when 0x18
						@working.write(@RCR_O8_FLAGS)
					when 0x20
						@working.write(@SHL_O8_FLAGS)
					when 0x28
						@working.write(@SHR_O8_FLAGS)
					when 0x30
						log "invalid SHL encoding"
						@working.write(@SHL_O8_FLAGS)
					when 0x38
						@working.write(@SAR_O8_FLAGS)
			when 0xc1, 0xd1, 0xd3
				if @preficesOperand()
					switch (bitand @modrm, 0x38)
						when 0x00
							@working.write(@ROL_O32_FLAGS)
						when 0x08
							@working.write(@ROR_O32_FLAGS)
						when 0x10
							@working.write(@RCL_O32_FLAGS)
						when 0x18
							@working.write(@RCR_O32_FLAGS)
						when 0x20
							@working.write(@SHL_O32_FLAGS)
						when 0x28
							@working.write(@SHR_O32_FLAGS)
						when 0x30
							@working.write(@SHL_O32_FLAGS)
						when 0x38
							@working.write(@SAR_O32_FLAGS)
				else
					switch (bitand @modrm, 0x38)
						when 0x00
							@working.write(@ROL_O16_FLAGS)
						when 0x08
							@working.write(@ROR_O16_FLAGS)
						when 0x10
							@working.write(@RCL_O16_FLAGS)
						when 0x18
							@working.write(@RCR_O16_FLAGS)
						when 0x20
							@working.write(@SHL_O16_FLAGS)
						when 0x28
							@working.write(@SHR_O16_FLAGS)
						when 0x30
							@working.write(@SHL_O16_FLAGS)
						when 0x38
							@working.write(@SAR_O16_FLAGS)
			when 0xf6
				switch (bitand @modrm, 0x38)
					when 0x00
						@working.write(@BITWISE_FLAGS_O8)
					when 0x18
						@working.write(@NEG_O8_FLAGS)
			when 0xf7
				if @preficesOperand()
					switch (bitand @modrm, 0x38)
						when 0x00
							@working.write(@BITWISE_FLAGS_O32)
						when 0x18
							@working.write(@NEG_O32_FLAGS)
				else
					switch (bitand @modrm, 0x38)
						when 0x00
							@working.write(@BITWISE_FLAGS_O16)
						when 0x18
							@working.write(@NEG_O16_FLAGS)
			when 0xfe
				switch (bitand @modrm, 0x38)
					when 0x00
						@working.write(@INC_O8_FLAGS)
					when 0x08
						@working.write(@DEC_O8_FLAGS)
			when 0xff
				switch (bitand @modrm, 0x38)
					when 0x00
						if @preficesOperand()
							@working.write(@INC_O32_FLAGS)
						else
							@working.write(@INC_O16_FLAGS)
					when 0x08
						if @preficesOperand()
							@working.write(@DEC_O32_FLAGS)
						else
							@working.write(@DEC_O16_FLAGS)
			when 0x07, 0x17, 0x1f, 0x58, 0x59, 0x5a, 0x5b, 0x5d, 0x5e, 0x5f, 0xfa1, 0xfa9
				@working.write(@STORE1_ESP)
			#0x8f //POP Ev This is really annoying and not quite correct?
			#for (int i = 0 i < @working.getLength() i++)
			#switch (@working.getMicrocodeAt(i))
			#ADDR_SP
			#ADDR_ESP
			#@working.replace(i, ADDR_REG1)
			#
			#ADDR_2ESP
			#@working.replace(i, ADDR_2REG1)
			#
			#ADDR_4ESP
			#@working.replace(i, ADDR_4REG1)
			#
			#ADDR_8ESP
			#@working.replace(i, ADDR_8REG1)
			#
			#ADDR_IB
			#ADDR_IW
			#ADDR_ID
			#i++



			#switch (@working.getMicrocodeAt(@working.getLength() - 1))
			#when STORE0_ESP
			#when STORE0_SP
			#default @working.write(STORE1_ESP)
			when 0xcf
				switch (bitand @prefices, @PREFICES_OPERAND)
					when 0
						@working.write(@STORE0_FLAGS)
					when @PREFICES_OPERAND
						@working.write(@STORE0_EFLAGS)
			when 0xf1f, 0xfa4, 0xfa5
				if @preficesOperand()
					@working.write(@SHL_O32_FLAGS)
				else
					@working.write(@SHL_O16_FLAGS)
			when 0xfac, 0xfad
				if @preficesOperand()
					@working.write(@SHR_O32_FLAGS)
				else
					@working.write(@SHR_O16_FLAGS)
			when 0xfb0
				@working.write(@CMPXCHG_O8_FLAGS)
			when 0xfb1
				if @preficesOperand()
					@working.write(@CMPXCHG_O32_FLAGS)
				else
					@working.write(@CMPXCHG_O16_FLAGS)
			when 0x06, 0x0e, 0x16, 0x1e, 0x27, 0x2f, 0x37, 0x3f, 0x50, 0x51, 0x52, 0x53, 0x54, 0x55, 0x56, 0x57, 0x5c, 0x60, 0x61, 0x62, 0x63, 0x68, 0x69, 0x6a, 0x6b, 0x6c, 0x6d, 0x6e, 0x6f, 0x70, 0x71, 0x72, 0x73, 0x74, 0x75, 0x76, 0x77, 0x78, 0x79, 0x7a, 0x7b, 0x7c, 0x7d, 0x7e, 0x7f, 0x86, 0x87, 0x88, 0x89, 0x8a, 0x8b, 0x8c, 0x8d, 0x8e, 0x90, 0x91, 0x92, 0x93, 0x94, 0x95, 0x96, 0x97, 0x98, 0x99, 0x9a, 0x9b, 0x9c, 0x9d, 0x9e, 0x9f, 0xa0, 0xa1, 0xa2, 0xa3, 0xa4, 0xa5, 0xa6, 0xa7, 0xaa, 0xab, 0xac, 0xad, 0xae, 0xaf, 0xb0, 0xb1, 0xb2, 0xb3, 0xb4, 0xb5, 0xb6, 0xb7, 0xb8, 0xb9, 0xba, 0xbb, 0xbc, 0xbd, 0xbe, 0xbf, 0xc2, 0xc3, 0xc4, 0xc5, 0xc6, 0xc7, 0xc8, 0xc9, 0xca, 0xcb, 0xcc, 0xcd, 0xce, 0xd4, 0xd5, 0xd6, 0xd7, 0xe0, 0xe1, 0xe2, 0xe3, 0xe4, 0xe5, 0xe6, 0xe7, 0xe8, 0xe9, 0xea, 0xeb, 0xec, 0xed, 0xee, 0xef, 0xf4, 0xf5, 0xf8, 0xf9, 0xfa, 0xfb, 0xfc, 0xfd, 0xf00, 0xf01, 0xf02, 0xf03, 0xf06, 0xf09, 0xf0b, 0xf20, 0xf21, 0xf22, 0xf23, 0xf30, 0xf31, 0xf32, 0xf34, 0xf35, 0xf40, 0xf41, 0xf42, 0xf43, 0xf44, 0xf45, 0xf46, 0xf47, 0xf48, 0xf49, 0xf4a, 0xf4b, 0xf4c, 0xf4d, 0xf4e, 0xf4f, 0xf80, 0xf81, 0xf82, 0xf83, 0xf84, 0xf85, 0xf86, 0xf87, 0xf88, 0xf89, 0xf8a, 0xf8b, 0xf8c, 0xf8d, 0xf8e, 0xf8f, 0xf90, 0xf91, 0xf92, 0xf93, 0xf94, 0xf95, 0xf96, 0xf97, 0xf98, 0xf99, 0xf9a, 0xf9b, 0xf9c, 0xf9d, 0xf9e, 0xf9f, 0xfa0, 0xfa2, 0xfa8, 0xfaf, 0xfa3, 0xfab, 0xfb3, 0xfbb, 0xfb2, 0xfb4, 0xfb5, 0xfb6, 0xfb7, 0xfba, 0xfbc, 0xfbd, 0xfbe, 0xfbf, 0xfc7, 0xfc8, 0xfc9, 0xfca, 0xfcb, 0xfcc, 0xfcd, 0xfce, 0xfcf, 0xd800, 0xd900, 0xda00, 0xdb00, 0xdc00, 0xdd00, 0xde00, 0xdf00, 0x0fff
				return
			else
				throw new IllegalStateException("Missing Flags 0x" + opcode)


	load0_Eb: (displacement) ->
		switch (bitand @modrm, 0xc7)
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
				@decodeM(displacement)
				@working.write(@LOAD0_MEM_BYTE)

				if (!@bla)
					@bla = 1
				else
					@bla++
#				if @bla > 12
#					a.a();
	load1_Gb: () ->
		val = bitand @modrm, 0x38

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

	load0_Ew: (displacement) ->
		switch (bitand @modrm, 0xc7)
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
				@decodeM(displacement)
				@working.write(@LOAD0_MEM_WORD)



	store0_Eb: (displacement)	->
		switch (bitand @modrm, 0xc7)
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
				@decodeM(displacement)
				@working.write(@STORE0_MEM_BYTE)

	load1_Gw: () ->
		switch (bitand @modrm, 0x38)
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

	store0_Ew: (displacement) ->
		switch (bitand @modrm, 0xc7)
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
				@decodeM(displacement)
				@working.write(@STORE0_MEM_WORD)

	store0_Gw: () ->
		switch bitand @modrm, 0x38
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

	store0_Gb: () ->
		switch bitand @modrm, 0x38
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

	load0_Gb: () ->
		switch bitand @modrm, 0x38
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

	store0_Sw: () ->
		switch bitand @modrm, 0x38
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

	store1_Eb: (displacement) ->
		switch bitand @modrm, 0xc7
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
				@decodeM(displacement)
				@working.write(@STORE1_MEM_BYTE)

	load1_Eb: (displacement) ->
		switch bitand @modrm, 0xc7
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
				@decodeM(displacement)
				@working.write(@LOAD1_MEM_BYTE)

	load0_Ed: (displacement) ->
		switch bitand @modrm, 0xc7
			when 0xc0
				@working.write(@LOAD0_EAX)
			when 0xc1
				@working.write(@LOAD0_ECX)
			when 0xc2
				@working.write(@LOAD0_EDX)
			when 0xc3
				@working.write(@LOAD0_EBX)
			when 0xc4
				@working.write(@LOAD0_ESP)
			when 0xc5
				@working.write(@LOAD0_EBP)
			when 0xc6
				@working.write(@LOAD0_ESI)
			when 0xc7
				@working.write(@LOAD0_EDI)
			else
				@decodeM(displacement)
				@working.write(@LOAD0_MEM_DWORD)
	load0_Gw: () ->
		switch bitand @modrm, 0x38
			when 0x00
				@working.write(@LOAD0_AX)
			when 0x08
				@working.write(@LOAD0_CX)
			when 0x10
				@working.write(@LOAD0_DX)
			when 0x18
				@working.write(@LOAD0_BX)
			when 0x20
				@working.write(@LOAD0_SP)
			when 0x28
				@working.write(@LOAD0_BP)
			when 0x30
				@working.write(@LOAD0_SI)
			when 0x38
				@working.write(@LOAD0_DI)
			else
				throw new IllegalStateException("Unknown Word Register Operand")

	load1_Ew: (displacement) ->
		switch bitand @modrm, 0xc7
			when 0xc0
				@working.write(@LOAD1_AX)
			when 0xc1
				@working.write(@LOAD1_CX)
			when 0xc2
				@working.write(@LOAD1_DX)
			when 0xc3
				@working.write(@LOAD1_BX)
			when 0xc4
				@working.write(@LOAD1_SP)
			when 0xc5
				@working.write(@LOAD1_BP)
			when 0xc6
				@working.write(@LOAD1_SI)
			when 0xc7
				@working.write(@LOAD1_DI)

	store0_Ed: (displacement) ->
		switch bitand @modrm, 0xc7
			when 0xc0
				@working.write(@STORE0_EAX)
			when 0xc2
				@working.write(@STORE0_ECX)
			when 0xc2
				@working.write(@STORE0_EDX)
			when 0xc3
				@working.write(@STORE0_EBX)
			when 0xc4
				@working.write(@STORE0_ESP)
			when 0xc5
				@working.write(@STORE0_EBP)
			when 0xc6
				@working.write(@STORE0_ESI)
			when 0xc7
				@working.write(@STORE0_EDI)
			else
				@decodeM(displacement)
				@working.write(@STORE0_MEM_DWORD)

	isJump: (opcode) ->
		return @isNearJump(opcode) || @isFarJump(opcode) || @isModeSwitch(opcode) || @isBlockTerminating(opcode);

	isNearJump: (opcode)->
		switch (opcode)
			when 0x70, 0x71, 0x72, 0x73, 0x74, 0x74, 0x76, 0x77, 0x78, 0x79,0x7a, 0x7b, 0x7c, 0x7d, 0x7e, 0x7f, 0xc2, 0xc3, 0xe0, 0xe1, 0xe2, 0xe3, 0xe8, 0xe9, 0xeb
				return true
			when 0xff
				switch bitand @modrm, 0x38
					when 0x10, 0x20
						return true
					else
						return false
			when 0x0f80, 0x0f81, 0x0f82, 0x0f83, 0x0f84, 0x0f85, 0x0f86, 0x0f87, 0x0f88, 0x0f89, 0x0f8, 0x0f8a, 0x0f8b, 0x0f8c, 0x0f8d, 0x0f8e, 0x0f8f
				return true
			else
				return false

	isFarJump: (opcode) ->
		switch (opcode)
			when 0x9a, 0xca, 0xcb, 0xcc, 0xcd, 0xce, 0xcf, 0xea, 0xf1, 0xf34, 0xf35
				return true
			when 0xff
				switch bitand @modrm, 0x38
					when 0x18, 0x28
						return true
					else
						return false
			else
				return false

	isModeSwitch: (opcode) ->
		#Should we give a exception as we only support 1 mode?
		switch (opcode)
			when 0x0f22
				return true
			when 0x0f01
				return (bitand(@modrm, 0x38) == 0x30)
			else
				return false

	isBlockTerminating: (opcode) ->
		switch (opcode)
			when 0xf4
				return true
			else
				return false

	decodeM: (displacement) ->
		if (!@decodingAddressMode())
			log "already decoded"
			a.a()
			return

		if ((bitand @prefices, @PREFICES_ADDRESS) != 0)
			#32 bit address size

			#Segment load
			switch bitand @prefices, @PREFICES_SG
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
					switch bitand @modrm, 0xc7
						when 0x04, 0x44, 0x84
							break #segment working.write will occur in decodeSIB
						when 0x45, 0x85
							@working.write(@LOAD_SEG_SS)
						else
							@working.write(@LOAD_SEG_DS)

			# Address Load
			switch bitand @modrm, 0x7
				when 0x0
					@working.write(@ADDR_EAX)
				when 0x1
					@working.write(@ADDR_ECX)
				when 0x2
					@working.write(@ADDR_EDX)
				when 0x3
					@working.write(@ADDR_EBX)
				when 0x4
					@decodeSIB(displacement)
				when 0x5
					if((bitand @modrm, 0xc0) == 0x00)
						@working.write(@ADDR_ID)
						@working.write(displacement)
					else
						@working.write(@ADDR_EBP)
				when 0x6
					@working.write(@ADDR_ESI)
				when 0x7
					@working.write(@ADDR_EDI)

			switch bitand @modrm, 0xc0
				when 0x40
					@working.write(@ADDR_IB)
					@working.write(displacement)
				when 0x80
					@working.write(@ADDR_ID)
					@working.write(displacement)

		else
			#16 bit address size
			#Segment load

			switch bitand @prefices, @PREFICES_SG
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
					switch bitand @modrm, 0xc7
						when 0x02, 0x03, 0x42, 0x43, 0x46, 0x82, 0x83,0x86
							@working.write(@LOAD_SEG_SS)
						else
							@working.write(@LOAD_SEG_DS)

			switch bitand @modrm, 0x7
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
					if ((bitand @modrm, 0xc0) == 0x00)
						@working.write(@ADDR_IW)
						@working.write(displacement)
					else
						@working.write(@ADDR_BP)
				when 0x7
					@working.write(@ADDR_BX)


			switch bitand @modrm, 0xc0
				when 0x40
					@working.write(@ADDR_IB)
					@working.write(displacement)
				when 0x80
					@working.write(@ADDR_IW)
					@working.write(displacement)
			@working.write(@ADDR_MASK16)

	decodeSegmentPrefix: () ->
		switch bitand @prefices, @PREFICES_SG
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

	load0_Ob: (displacement) ->
		@decodeO(displacement)
		@working.write(@LOAD0_MEM_BYTE)

	decodeO: (displacement) ->
		log @prefices
		log @prefices & @PREFICES_SG
		a.a()
		switch bitand @prefices, @PREFICES_SG
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
				log "Invalid option?"
				log @prefices
				log bitand @prefices, @PREFICES_SG

				#a.a()
				@working.write(@LOAD_SEG_SS)

		if ((bitand @prefices, @PREFICES_ADDRESS) != 0)
			if (@decodingAddressMode())
				@working.write(@ADDR_ID)
				@working.write(@displacement)
		else
			if (@decodingAddressMode())
				@working.write(@ADDR_IW)
				@working.write(@displacement)
				@working.write(@ADDR_MASK16)

	load0_M: (displacement) ->
		@decodeM(displacement)
		@working.write(@LOAD0_ADDR)

	load0_Ow: (displacement) ->
		@decodeO(displacement)
		@working.write(@LOAD0_MEM_WORD)

	store0_Ow: (displacement) ->
		@decodeO(displacement)
		@working.write(@STORE0_MEM_WORD)

	decodingAddressMode: ->
		if (!@addressModeDecoded)
			@addressModeDecoded = true
		return @addressModeDecoded

	toString: ->
		return "ProtectedModeUDecoder"

	preficesOperand:  ->
		if bitand(@prefices, @PREFICES_OPERAND) != 0
			return true
		else
			return false



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

#		if (microcode == @LOAD0_MEM_BYTE)
#			a.a();

		try
#			log "Adding microcode #{microcode} to @microcodes[#{@microcodesLength}]"
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
		@microcodes = new Array()

	getMicrocodeAt: (offset) ->
		return @microcodes[offset]

	getMicrocode: ->
		if (@readOffset < @getLength())
			return @microcodes[@readOffset++]
		else
			throw new IlligalState("Offset #{@readOffset},length #{@getLength()}")
	getLength: ->
		return @microcodesLength

	getX86Length: ->
		return @x86Length
