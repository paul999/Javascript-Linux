QUnit.module("Test opcode convertor")

QUnit.test("Simple opcode", function()
{
	ok(window.testOpCodes, "Opcodes are required to run the tests for the CPU")

	setup()
	window.pc.create()

	runCode(window.testOpCodes[0], window.resultOpCodes[0])
});

function runCode(cd, cd2)
{
	var oldram = SYS_RAM_SIZE
	for (var i = 0; i < cd.length; i++)
	{
		var bt;

//		SYS_RAM_SIZE = 1024 * 2

		window.pc.resetMemory()

		start = 0x10000;

		window.pc.saveMemory(cd[i], cd[i].length, start)

		bt = new ByteSourceWrappedMemory()
		bt.set(start)

		var rt = new Array()
		var ct = 0

		var b = cd[i].length + start;

		while ((bt.getOffset()) < b)
		{
			var p = new ProtectedModeUDecoder()

			p = p.decodeProtected(bt, true, 1)

			var t = new OptimisedCompiler()

			t.buildCodeBlockBuffers(p)
			t = t.bufferMicrocodes

			for (k = 0; k < t.length; k++)
			{
				rt[ct] = t[k];
				ct++;
			}
		}

		ok(rt.length != 0, "Testing microcode length for test + " + i)
		equal(rt.length, cd2[i].length, "Total microcode length for test + " + i)

		for (var j = 0; j < rt.length; j++)
		{
			equal(rt[j], cd2[i][j], "Testing microcode result for opcode for test + " + i + " set " + j)
		}
	}
	SYS_RAM_SIZE = oldram
}

QUnit.test("Large opcode", function()
{
	ok(window.testOpCodes, "Opcodes are required to run the tests for the CPU")

	setup()
	window.pc.create()

	runCode(window.testOpCodes[1], window.resultOpCodes[1])

});
