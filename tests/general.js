function setup()
{
	console.log("RESET")
	proc = null
	window.pc = null
	window.pc = new PC
}


module("PC object test");
test("PC object exists", function()
{
	expect(5);

	notEqual(PC, undefined, 'Expect PC to be defined')

	notEqual(window.pc, undefined, 'Expect window.pc to be defined.')
	notEqual(window.pc.start, undefined, 'Required start method in window.pc')
	notEqual(window.pc.create, undefined, 'Required create method in window.pc')
	notEqual(jDataView, undefined, 'Check for required BinaryReader.')
});

test("PC object creation" , function()
{
	expect(1)

	equal(window.pc.create(), true, 'PC creation without expections')
});

test("PC real mode exceptions", function()
{
	raises(function(){window.pc.executeReal()}, "Test if real mode throws a exception")
});


module("Casting")
test("Casting byte methodes", function()
{

	equal(byte(0), 0, "Test byte if 0 becomes 0.")
	equal(byte(128), 127, "Test byte if 128 becomes 127")
	equal(byte(0xff), 127, "Test byte if 0xff becomes 127")
	equal(byte(30000), 127, "Test byte if 30000 becomes 127")
	equal(byte(32767), 127, "Test byte if 32767 becomes 127")
	equal(byte(32768), 127, "Test byte if 32768 becomes 127")
	equal(byte(Infinity), 127, "Test byte if Infinity becomes 127") // Deze moet 0 zijn?

	for (i = 129; i < 5000; i++)
	{
		equal(byte(i), 127, "Test byte if " + i + " becomes 127")
	}


	equal(byte(-128), -127, "Test byte if -128 becomes -127")
	equal(byte(-0xff), -127, "Test byte if -0xff becomes -127")
	equal(byte(-30000), -127, "Test byte if -30000 becomes -127")
	equal(byte(-32767), -127, "Test byte if -32767 becomes -127")
	equal(byte(-32768), -127, "Test byte if -32768 becomes -127")
	equal(byte(-Infinity), -127, "Test byte if Infinity becomes -127") // Deze moet 0 zijn?

	for (i = -129; i > -5000; i--)
	{
		equal(byte(i), -127, "Test byte if " + i + " becomes -127")
	}

});

test("Casting short methodes", function()
{
	equal(short(0), 0, "Test Short if 0 becomes 0.")
	equal(short(128), 128, "Test Short if 128 becomes 128")
	equal(short(0xff), 0xff, "Test Short if 0xff becomes 0xff")
	equal(short(30000), 30000, "Test Short if 30000 becomes 30000")
	equal(short(32767), 32767, "Test Short if 32767 becomes 32767")
	equal(short(32768), 32767, "Test Short if 32768 becomes 32767")
	equal(short(Infinity), 32767, "Test byte if Infinity becomes 32767") // Deze moet 0 zijn?

	for (i = 32768 * 2 - 5; i < 32768 * 2 - 5 + 5000; i++)
	{
		equal(short(i), 32767, "Test short if " + i + " becomes 32767")
	}


	equal(short(-128), -128, "Test Short if -128 becomes -128")
	equal(short(-0xff), -0xff, "Test Short if -0xff becomes -0xff")
	equal(short(-30000), -30000, "Test Short if -30000 becomes -30000")
	equal(short(-32767), -32767, "Test Short if -32767 becomes -32767")
	equal(short(-32768), -32767, "Test Short if -32768 becomes -32767")
	equal(short(-Infinity), -32767, "Test byte if Infinity becomes -32767") // Deze moet 0 zijn?

	for (i = (32768 * 2 - 5) * -1; i > (32768 * 2 - 5 + 5000) * -1; i--)
	{
		equal(short(i), -32767, "Test byte if " + i + " becomes -32767")
	}
});

test("Casting int methodes", function()
{
	equal(int(0), 0, "Test int if 0 becomes 0.")
	equal(int(128), 128, "Test int if 128 becomes 128")
	equal(int(0xff), 0xff, "Test int if 0xff becomes 0xff")
	equal(int(30000), 30000, "Test int if 30000 becomes 30000")
	equal(int(32767), 32767, "Test int if 32767 becomes 32767")
	equal(int(32768), 32768, "Test int if 32768 becomes 32767")
	equal(int(Infinity), Infinity, "Test int if Infinity becomes Infinity") // Deze moet 0 zijn?


	equal(int(-128), -128, "Test int if -128 becomes -128")
	equal(int(-0xff), -0xff, "Test int if -0xff becomes -0xff")
	equal(int(-30000), -30000, "Test int if -30000 becomes -30000")
	equal(int(-32767), -32767, "Test int if -32767 becomes -32767")
	equal(int(-32768), -32768, "Test int if -32768 becomes -32767")
	equal(int(-Infinity), -Infinity, "Test int if -Infinity becomes -Infinity") // Deze moet 0 zijn?
});
