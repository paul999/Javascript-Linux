function setup()
{
	console.log("RESET")
	proc = null
	console.log(proc)
	window.pc = null
	window.pc = new PC
}


module("PC object test");
test("PC object exists", function()
{
	expect(4);

	notEqual(PC, undefined, 'Expect PC to be defined')

	notEqual(window.pc, undefined, 'Expect window.pc to be defined.')
	notEqual(window.pc.start, undefined, 'Required start method in window.pc')
	notEqual(window.pc.create, undefined, 'Required create method in window.pc')
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
