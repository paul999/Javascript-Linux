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

log = (message) =>
	if window.tests or not debug
		return

	console.log(message)

	return

input = () ->
	@newLine
	inp = @lineBuffer

	@prompt()

	console.log "Got input: #{inp}"

	# Nice hack, so we can start :)
	if (inp == "start")
		log("Starting PC...")
		window.pc.start()
		return

	serial.receive(inp)

# Copy of the java method Systemarraycopy
arraycopy = (buf, offset, buffer, address, len) ->
	log "Buf:  offset: #{offset} buffer: #{buffer} address: #{address} len #{len} old length: #{buffer.length}"

	log "Buf check: " + parseInt(buf.charCodeAt(offset))

	if (typeof buf == "string")
		for i in [0...len]
			rw = i + offset
			rs = parseInt(buf.charCodeAt(rw))

			if (isNaN(rs))
				rs = null

#			log "Going to write to buffer[#{address}] #{rs}"


			buffer[address] = rs
			address++
	else
		log "Non type String found in Arraycopy."
#		j = 0
#		for i in [0...len]
#			buffer[address + j] = buf[i + offset]
#			j++
		throw "Array"
	log "New length: " + buffer.length

	return buffer

# Java byte: signed
# Functie heeft geen support voor negatief, gaat van 0-128.
# Results > 128 geven 128 terug.
byte = (x) =>
	if (x == 'undefined')
		throw new IllegalStateException('Undefined cant be casted')
	convert = new jDataView(jDataView.createBuffer(x), undefined, undefined)

	result =  convert.getInt8()

	return result

short = (x) =>
	if (x == 'undefined')
		throw new IllegalStateException('Undefined cant be casted')
	convert = new jDataView(jDataView.createBuffer(x), undefined, undefined)

	result =  convert.getInt16()

	return result

int = (x) =>
	if (x == 'undefined')
		throw new IllegalStateException('Undefined cant be casted')

	return parseInt x
	convert = new jDataView(jDataView.createBuffer(x), undefined, undefined)

	result =  convert.getInt32()

	return result

numberOfSetBits = (i) ->
	i = i - bitand((i >> 1), 0x55555555)
	i = bitand(i, 0x33333333) + bitand((i >> 2), 0x33333333)
	return (bitand((i + (i >> 4)), 0x0F0F0F0F) * 0x01010101) >> 24

scale64 = (input,multiply,devide) ->
	rl = bitand(0xffffffff, input) * multiply
	rh = (input >>> 32) * multiply

	rh += (rl >> 32)

	resultHigh = bitand 0xffffffff, (rh / divide)
	resultLow = bitand 0xffffffff, ((((rh % divide) << 32) + bitand(rl, 0xffffffff)) / divide)

	(resultHigh << 32) | resultLow

bits = 0
bitand = (bita, bitb) =>
	bits++
	if bita == 'undefined' || bita == null
		a.a()
		throw new IllegalStateException('Bita is undefined')
	if bitb == 'undefined' || bitb == null
		a.a()
		throw new IllegalStateException('Bitb is undefined')
	return bita & bitb

class TimerResponsive
	constructor: ->
		return

`
Error.createCustromConstructor = (function() {

    function define(obj, prop, value) {
        Object.defineProperty(obj, prop, {
            value: value,
            configurable: true,
            enumerable: false,
            writable: true
        });
    }

    return function(name, init, proto) {
        var CustomError;
        proto = proto || {};
        function build(message) {
            var self = this instanceof CustomError
                ? this
                : Object.create(CustomError.prototype);
            Error.apply(self, arguments);

            if (Error.stacktrace && !Error.stack)
	            Error.captureStackTrace(self, CustomError);
            if (message != undefined) {
                define(self, 'message', String(message));
            }
            define(self, 'arguments', undefined);
            define(self, 'type', undefined);
            if (typeof init == 'function') {
                init.apply(self, arguments);
            }
            return self;
        }
        eval('CustomError = function ' + name + '() {' +
            'return build.apply(this, arguments); }');
        CustomError.prototype = Object.create(Error.prototype);
        define(CustomError.prototype, 'constructor', CustomError);
        for (var key in proto) {
            define(CustomError.prototype, key, proto[key]);
        }
        Object.defineProperty(CustomError.prototype, 'name', { value: name });
        return CustomError;
    }

})();

NotImplementedError = Error.createCustromConstructor('NotImplementedError')
LengthIncorrectError = Error.createCustromConstructor('LengthIncorrectError')
MemoryOutOfBound = Error.createCustromConstructor('MemoryOutOfBound')
IllegalStateException = Error.createCustromConstructor('IllegalStateException')
`
