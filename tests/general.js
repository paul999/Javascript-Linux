function setup()
{
	proc = null
	window.pc = null
	window.pc = new PC
}


QUnit.module("PC object test");
QUnit.test("PC object exists", function()
{
	console.log("PC Object exists here...");
	expect(5);

	notEqual(PC, undefined, 'Expect PC to be defined')

	notEqual(window.pc, undefined, 'Expect window.pc to be defined.')
	notEqual(window.pc.start, undefined, 'Required start method in window.pc')
	notEqual(window.pc.create, undefined, 'Required create method in window.pc')
	notEqual(jDataView, undefined, 'Check for required BinaryReader.')
});

QUnit.test("PC object creation" , function()
{
	expect(1)

	equal(window.pc.create(), true, 'PC creation without expections')
});

QUnit.test("PC real mode exceptions", function()
{
	raises(function(){window.pc.executeReal()}, "Test if real mode throws a exception")
});


QUnit.module("Bitwise operations")
QUnit.test("And", function()
{
	raises(function(){bitand(a, 1);}, "Test if bitand throws a exception when bita is undefined")
	raises(function(){bitand(null, 1);}, "Test if bitand throws a exception when bita is null")
	raises(function(){bitand(false, 1);}, "Test if bitand throws a exception when bita is false")


	raises(function(){bitand(1, a);}, "Test if bitand throws a exception when bitb is undefined")
	raises(function(){bitand(1, null);}, "Test if bitand throws a exception when bitb is null")
	raises(function(){bitand(1, false);}, "Test if bitand throws a exception when bitb is false")

	equal(bitand(1, 1), 1, "test if 1 & 1 == 1");
	equal(bitand(85, 0x7), 5);
});
