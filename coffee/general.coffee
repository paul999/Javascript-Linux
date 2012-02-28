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
c = document.getElementById("log");
log = (message) ->
#	c.appendChild(document.createTextNode(message));
#	c.appendChild(document.createElement("br"));
	console.log(message);
#	c.scrollTop += 20;
	return

# Copy of the java method Systemarraycopy
arraycopy = (buf, offset, buffer, address, len) ->
#	log "Buf: #{buf} offset: #{offset} buffer: #{buffer} address: #{address} len #{len} old length: #{buffer.length}"

	if (typeof buf == "string")
		j = 0
		for i in [offset...len]
			buffer[address + j] = buf.charCodeAt(i)
			j++
	else
		j = 0
		for i in [offset...len]
			buffer[address + j] = buf[i]
			j++
#	log "New length: " + buffer.length

	return buffer



class general
	scale64: (input,multiply,devide) ->
		rl = (0xffffffff & input) * multiply
		rh = (input >>> 32) * multiply

		rh += (rl >> 32)

		resultHigh = 0xffffffff & (rh / divide)
		resultLow = 0xffffffff & ((((rh % divide) << 32) + (rl & 0xffffffff)) / divide)

		(resultHigh << 32) | resultLow


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

var NotImplementedError = Error.createCustromConstructor('NotImplementedError')
var LengthIncorrectError = Error.createCustromConstructor('LengthIncorrectError')
`
