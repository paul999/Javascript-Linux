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

class AbstractMemory
	constructor: ->


	clear: ->
		for i in [0...@getSize()]
			@setByte(i, 0)

	clear: (start, length) ->
		limit = start + length
		if (limit > @getSize())
			throw "Attempt to clear outside of memory bounds"

		for i in [start...limit]
			@setByte(i, 0)

	copyContentsIntoArray: (address, buffer, offset, len)->

		log "HIER!"

		tmp = offset + len
		for i in [offset...tmp]
			buffer[i] = @getByte(address)
			address++
		return buffer

	copyArrayIntoContents: (address, buffer, offset, len) ->
		tmp = offset+len
		log "HIER :)offset:  #{offset} len: #{tmp}"

		for i in [offset...tmp]
			@setByte(address, buffer[i])
			address++
		return buffer

	# Get little-endian word at <code>offset</code> by repeated calls to
	# <code>getByte</code>.
	# @param offset index of first byte of word.
	# @return word at <code>offset</code> as a short.
	getWordInBytes: (offset) ->
		result = 0xFF & @getByte(offset + 1)
		result <<= 8
		result |= (0xFF & @getByte(offset))
		return result

	# Get little-endian doubleword at <code>offset</code> by repeated calls to
	# <code>getByte</code>.
	# @param offset index of first byte of doubleword.
	# @return doubleword at <code>offset</code> as an int.
	getDoubleWordInBytes: (offset) ->
		result=  0xFFFF & @getWordInBytes(offset+2)
		result <<= 16
		result |= (0xFFFF & @getWordInBytes(offset))
		return result

	# Get little-endian quadword at <code>offset</code> by repeated calls to
	# <code>getByte</code>.
	# @param offset index of first byte of quadword.
	# @return quadword at <code>offset</code> as a long.
	getQuadWordInBytes: (offset) ->
		result = 0xFFFFFFFF & @getDoubleWordInBytes(offset+4)
		result <<= 32
		result |= 0xFFFFFFFF & @getDoubleWordInBytes(offset)
		return result


	getWord: (offset) ->
		return @getWordInBytes(offset)

	getDoubleWord: (offset) ->
		return @getDoubleWordInBytes(offset)

	getQuadWordInBytes: (offset) ->
		return @getQuadWordInBytes(offset)

	getLowerDoubleQuadWord: (offset) ->
		return @getQuadWordInBytes(offset)

	getUpperDoubleQuadWord: (offset) ->
		return @getQuadWordInBytes(offset+8)

	# Set little-endian word at <code>offset</code> by repeated calls to
	# <code>setByte</code>.
	# @param offset index of first byte of word.
	# @param data new value as a short.
	setWordInBytes: (offset, data) ->
		@setByte(offset, data) #TODO: data is geen byte, maar setByte verwacht wel byte
		offset++
		@setByte(offset, (data >> 8))



	# Set little-endian doubleword at <code>offset</code> by repeated calls to
	# <code>setByte</code>.
	# @param offset index of first byte of doubleword.
	# @param data new value as an int.
	setDoubleWordInBytes: (offset, data) ->
		@setByte(offset, data)
		offset++
		data >>= 8
		@setByte(offset, data)
		offset++
		data >>= 8
		@setByte(offset, data)
		offset++
		data >>= 8
		@setByte(offset, data)

	# Set little-endian quadword at <code>offset</code> by repeated calls to
	# <code>setByte</code>.
	# @param offset index of first byte of quadword.
	# @param data new value as a long.
	setQuadWordInBytes: (offset, data) ->
		@setDoubleWordInBytes(offset, data)
		@setDoubleWordInBytes(offset+4, (data >> 32))

	setWord: (offset, data) ->
		@setWordInBytes(offset, data)

	setDoubleWord: (offset, data) ->
		@setDoubleWordInBytes(offset, data)

	setQuadWord: (offset, data) ->
		@setQuadWordInBytes(offset, data)

	setLowerDoubleQuadWord: (offset, data) ->
		@setQuadWordInBytes(offset, data)

	setUpperDoubleQuadWord: (offset, data) ->
		@setQuadWordInBytes(offset+8, data)

	clearArray: (target, value) ->
		if (target == undefined || target == null)
			return

		for i in [i...target.length]
			target[i] = value
		return target
