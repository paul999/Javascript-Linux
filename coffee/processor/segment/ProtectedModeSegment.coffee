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

class ProtectedModeSegment extends Segment
	constructor: (@selector, @descriptor) ->
		super

		@TYPE_ACCESSED = 0x1
		@TYPE_CODE = 0x8
		@TYPE_DATA_WRITABLE = 0x2
		@TYPE_DATA_EXPAND_DOWN = 0x4
		@TYPE_CODE_READABLE = 0x2
		@TYPE_CODE_CONFORMING = 0x4

		@DESCRIPTOR_TYPE_CODE_DATA = 0x10

		@granularity = (@descriptor & 0x80000000000000) != 0

		if (granularity)
			@limit = ((@descriptor << 12) & 0xffff000) | ((@descriptor >>> 20) & 0xf0000000) | 0xfff
		else
			@limit = (@descriptor & 0xffff) | ((@descriptor >>> 32) & 0xf0000)

		@base = ((0xffffff & (@descriptor >> 16)) | ((@descriptor >> 32) & 0xffffffffff000000))
		@rpl = @selector & 0x3
		@dpl =  ((@descriptor >> 45) & 0x3)

		@defaultSize = (@descriptor & (1 << 54)) != 0
		@present = (@descriptor & (1 << 47)) != 0
		@system = (@descriptor & (1 << 44)) != 0

	isPresent: ->
    		return @present

    	isSystem: ->
    		return !@sytem

    	translateAddressRead: (offset) ->
    		@checkAddress(offset)
    		return @base + offset

     	translateAddressWrite: (offset) ->
    		@checkAddress(offset)
    		return @base + offset


	checkAddress: (offset) ->

		if ((0xffffffff & offset) > limit)
			log this + "segment limit exceeded: 0x{0} > 0x{1}"
			throw new ProcessorException(Type.GENERAL_PROTECTION,0,true)

	getDefaultSizeFlag: ->
		return @defaultSize

	getLimit: ->
		return @limit

	getBase: ->
		return @base

	getSelector: ->
		return (@selector & 0xFFFC) | @rpl


	getRPL: ->
		return @rpl

	getDPL: ->
		return @dpl

	setRPL: (@rpl) ->
		return

	setSelector: ->
		throw new IllegalStateException("Cannot set a selector for a descriptor table segment")



###

    static abstract class ReadOnlyProtectedModeSegment extends ProtectedModeSegment
    {
        public ReadOnlyProtectedModeSegment(AddressSpace memory, int selector, long descriptor)
        {
            super(memory, selector, descriptor);
        }

        void writeAttempted()
        {
            throw new IllegalStateException();
        }

        public final void setByte(int offset, byte data)
        {
            writeAttempted();
        }

        public final void setWord(int offset, short data)
        {
            writeAttempted();
        }

        public final void setDoubleWord(int offset, int data)
        {
            writeAttempted();
        }

        public final void setQuadWord(int offset, long data)
        {
            writeAttempted();
        }
    }

    static final class ReadOnlyDataSegment extends ReadOnlyProtectedModeSegment
    {
        public ReadOnlyDataSegment(AddressSpace memory, int selector, long descriptor)
        {
            super(memory, selector, descriptor);
        }

        public int getType()
        {
            return DESCRIPTOR_TYPE_CODE_DATA;
        }

        void writeAttempted()
        {
            throw ProcessorException.GENERAL_PROTECTION_0;
        }
    }

    static final class ReadOnlyAccessedDataSegment extends ReadOnlyProtectedModeSegment
    {
        public ReadOnlyAccessedDataSegment(AddressSpace memory, int selector, long descriptor)
        {
            super(memory, selector, descriptor);
        }

        public int getType()
        {
            return DESCRIPTOR_TYPE_CODE_DATA | TYPE_ACCESSED;
        }

        void writeAttempted()
        {
            throw ProcessorException.GENERAL_PROTECTION_0;
        }
    }

    static final class ReadWriteDataSegment extends ProtectedModeSegment
    {
        public ReadWriteDataSegment(AddressSpace memory, int selector, long descriptor)
        {
            super(memory, selector, descriptor);
        }

        public int getType()
        {
            return DESCRIPTOR_TYPE_CODE_DATA | TYPE_DATA_WRITABLE;
        }
    }

    static final class DownReadWriteDataSegment extends ProtectedModeSegment
    {
        public DownReadWriteDataSegment(AddressSpace memory, int selector, long descriptor)
        {
            super(memory, selector, descriptor);
        }

        public int getType()
        {
            return DESCRIPTOR_TYPE_CODE_DATA | TYPE_DATA_WRITABLE;
        }

        public final int translateAddressRead(int offset)
        {
            checkAddress(offset);
            return super.base + offset;
        }

        public final int translateAddressWrite(int offset)
        {
            checkAddress(offset);
            return super.base + offset;
        }

        public final void checkAddress(int offset)
        {
            if ((0xffffffffL & offset) > super.limit)
            {
                throw new ProcessorException(ProcessorException.Type.GENERAL_PROTECTION, 0, true);//ProcessorException.GENERAL_PROTECTION_0;
            }
        }
    }

    static final class ReadWriteAccessedDataSegment extends ProtectedModeSegment
    {
        public ReadWriteAccessedDataSegment(AddressSpace memory, int selector, long descriptor)
        {
            super(memory, selector, descriptor);
        }

        public int getType()
        {
            return DESCRIPTOR_TYPE_CODE_DATA | TYPE_DATA_WRITABLE | TYPE_ACCESSED;
        }
    }

    static final class ExecuteOnlyCodeSegment extends ReadOnlyProtectedModeSegment
    {
        public ExecuteOnlyCodeSegment(AddressSpace memory, int selector, long descriptor)
        {
            super(memory, selector, descriptor);
        }

        public int getType()
        {
            return DESCRIPTOR_TYPE_CODE_DATA | TYPE_CODE;
        }
    }

    static final class ExecuteReadAccessedCodeSegment extends ProtectedModeSegment
    {
        public ExecuteReadAccessedCodeSegment(AddressSpace memory, int selector, long descriptor)
        {
            super(memory, selector, descriptor);
        }

        public int getType()
        {
            return DESCRIPTOR_TYPE_CODE_DATA | TYPE_CODE | TYPE_CODE_READABLE | TYPE_ACCESSED;
        }
    }

    static final class ExecuteReadCodeSegment extends ProtectedModeSegment
    {
        public ExecuteReadCodeSegment(AddressSpace memory, int selector, long descriptor)
        {
            super(memory, selector, descriptor);
        }

        public int getType()
        {
            return DESCRIPTOR_TYPE_CODE_DATA | TYPE_CODE | TYPE_CODE_READABLE;
        }
    }

    static final class ExecuteOnlyConformingAccessedCodeSegment extends ReadOnlyProtectedModeSegment
    {
        public ExecuteOnlyConformingAccessedCodeSegment(AddressSpace memory, int selector, long descriptor)
        {
            super(memory, selector, descriptor);
        }

        public int getType()
        {
            return DESCRIPTOR_TYPE_CODE_DATA | TYPE_CODE | TYPE_CODE_CONFORMING | TYPE_ACCESSED;
        }
    }

    static final class ExecuteReadConformingAccessedCodeSegment extends ProtectedModeSegment
    {
        public ExecuteReadConformingAccessedCodeSegment(AddressSpace memory, int selector, long descriptor)
        {
            super(memory, selector, descriptor);
        }

        public int getType()
        {
            return DESCRIPTOR_TYPE_CODE_DATA | TYPE_CODE | TYPE_CODE_CONFORMING | TYPE_CODE_READABLE | TYPE_ACCESSED;
        }
    }

    static final class ExecuteReadConformingCodeSegment extends ProtectedModeSegment
    {
        public ExecuteReadConformingCodeSegment(AddressSpace memory, int selector, long descriptor)
        {
            super(memory, selector, descriptor);
        }

        public int getType()
        {
            return DESCRIPTOR_TYPE_CODE_DATA | TYPE_CODE | TYPE_CODE_CONFORMING | TYPE_CODE_READABLE;
        }
    }

    static public abstract class AbstractTSS extends ReadOnlyProtectedModeSegment
    {
        public AbstractTSS(AddressSpace memory, int selector, long descriptor)
        {
            super(memory, selector, descriptor);
        }

        public void saveCPUState(Processor cpu)
        {
            int initialAddress = translateAddressWrite(0);
            memory.setDoubleWord(initialAddress + 32, cpu.eip);
            memory.setDoubleWord(initialAddress + 36, cpu.getEFlags());
            memory.setDoubleWord(initialAddress + 40, cpu.eax);
            memory.setDoubleWord(initialAddress + 44, cpu.ecx);
            memory.setDoubleWord(initialAddress + 48, cpu.edx);
            memory.setDoubleWord(initialAddress + 52, cpu.ebx);
            memory.setDoubleWord(initialAddress + 56, cpu.esp);
            memory.setDoubleWord(initialAddress + 60, cpu.ebp);
            memory.setDoubleWord(initialAddress + 64, cpu.esi);
            memory.setDoubleWord(initialAddress + 68, cpu.edi);
            memory.setDoubleWord(initialAddress + 72, cpu.es.getSelector());
            memory.setDoubleWord(initialAddress + 76, cpu.cs.getSelector());
            memory.setDoubleWord(initialAddress + 80, cpu.ss.getSelector());
            memory.setDoubleWord(initialAddress + 84, cpu.ds.getSelector());
            memory.setDoubleWord(initialAddress + 88, cpu.fs.getSelector());
            memory.setDoubleWord(initialAddress + 92, cpu.gs.getSelector());
        }

        public void restoreCPUState(Processor cpu)
        {
            int initialAddress = translateAddressRead(0);
            cpu.eip = memory.getDoubleWord(initialAddress + 32);
            cpu.setEFlags(memory.getDoubleWord(initialAddress + 36));
            cpu.eax = memory.getDoubleWord(initialAddress + 40);
            cpu.ecx = memory.getDoubleWord(initialAddress + 44);
            cpu.edx = memory.getDoubleWord(initialAddress + 48);
            cpu.ebx = memory.getDoubleWord(initialAddress + 52);
            cpu.esp = memory.getDoubleWord(initialAddress + 56);
            cpu.ebp = memory.getDoubleWord(initialAddress + 60);
            cpu.esi = memory.getDoubleWord(initialAddress + 64);
            cpu.edi = memory.getDoubleWord(initialAddress + 68);
            cpu.es = cpu.getSegment(0xFFFF & memory.getDoubleWord(initialAddress + 72));
            cpu.cs = cpu.getSegment(0xFFFF & memory.getDoubleWord(initialAddress + 76));
            cpu.ss = cpu.getSegment(0xFFFF & memory.getDoubleWord(initialAddress + 80));
            cpu.ds = cpu.getSegment(0xFFFF & memory.getDoubleWord(initialAddress + 84));
            cpu.fs = cpu.getSegment(0xFFFF & memory.getDoubleWord(initialAddress + 88));
            cpu.gs = cpu.getSegment(0xFFFF & memory.getDoubleWord(initialAddress + 92));
            // non dynamic fields
            cpu.ldtr = cpu.getSegment(0xFFFF & memory.getDoubleWord(initialAddress + 96));
            cpu.setCR3(memory.getDoubleWord(initialAddress + 28));
        }

        public byte getByte(int offset)
        {
            boolean isSup = ((LinearAddressSpace) memory).isSupervisor();
            try {
                ((LinearAddressSpace) memory).setSupervisor(true);
                return super.getByte(offset);
            } finally {
                ((LinearAddressSpace) memory).setSupervisor(isSup);
            }
        }

        public short getWord(int offset)
        {
            boolean isSup = ((LinearAddressSpace) memory).isSupervisor();
            try {
                ((LinearAddressSpace) memory).setSupervisor(true);
                return super.getWord(offset);
            } finally {
                ((LinearAddressSpace) memory).setSupervisor(isSup);
            }
        }

        public int getDoubleWord(int offset)
        {
            boolean isSup = ((LinearAddressSpace) memory).isSupervisor();
            try {
                ((LinearAddressSpace) memory).setSupervisor(true);
                return super.getDoubleWord(offset);
            } finally {
                ((LinearAddressSpace) memory).setSupervisor(isSup);
            }
        }

        public long getQuadWord(int offset)
        {
            boolean isSup = ((LinearAddressSpace) memory).isSupervisor();
            try {
                ((LinearAddressSpace) memory).setSupervisor(true);
                return super.getQuadWord(offset);
            } finally {
                ((LinearAddressSpace) memory).setSupervisor(isSup);
            }
        }
    }

    static final class Available32BitTSS extends AbstractTSS
    {
        public Available32BitTSS(AddressSpace memory, int selector, long descriptor)
        {
            super(memory, selector, descriptor);
        }

        public int getType()
        {
            return 0x09;
        }
    }

    static final class Busy32BitTSS extends AbstractTSS
    {
        public Busy32BitTSS(AddressSpace memory, int selector, long descriptor)
        {
            super(memory, selector, descriptor);
        }

        public int getType()
        {
            return 0x0b;
        }
    }

    static final class LDT extends ReadOnlyProtectedModeSegment
    {
        public LDT(AddressSpace memory, int selector, long descriptor)
        {
            super(memory, selector, descriptor);
        }

        public int getType()
        {
            return 0x02;
        }
    }

    public static abstract class GateSegment extends ReadOnlyProtectedModeSegment
    {
        private int targetSegment,  targetOffset;

        public GateSegment(AddressSpace memory, int selector, long descriptor)
        {
            super(memory, selector, descriptor);

            targetSegment = (int) ((descriptor >> 16) & 0xffff);
            targetOffset = (int) ((descriptor & 0xffff) | ((descriptor >>> 32) & 0xffff0000));
        }

        public int getTargetSegment()
        {
            return targetSegment;
        }

        public int getTargetOffset()
        {
            return targetOffset;
        }
    }

    static final class TaskGate extends GateSegment
    {
        public TaskGate(AddressSpace memory, int selector, long descriptor)
        {
            super(memory, selector, descriptor);
        }

        public final int getTargetOffset()
        {
            throw new IllegalStateException();
        }

        public int getType()
        {
            return 0x05;
        }
    }

    static final class InterruptGate32Bit extends GateSegment
    {
        public InterruptGate32Bit(AddressSpace memory, int selector, long descriptor)
        {
            super(memory, selector, descriptor);
        }

        public int getType()
        {
            return 0x0e;
        }
    }

    static final class InterruptGate16Bit extends GateSegment
    {
        public InterruptGate16Bit(AddressSpace memory, int selector, long descriptor)
        {
            super(memory, selector, descriptor);
        }

        public int getType()
        {
            return 0x06;
        }
    }

    static final class TrapGate32Bit extends GateSegment
    {
        public TrapGate32Bit(AddressSpace memory, int selector, long descriptor)
        {
            super(memory, selector, descriptor);
        }

        public int getType()
        {
            return 0x0f;
        }
    }

    static final class TrapGate16Bit extends GateSegment
    {
        public TrapGate16Bit(AddressSpace memory, int selector, long descriptor)
        {
            super(memory, selector, descriptor);
        }

        public int getType()
        {
            return 0x07;
        }
    }

    public static final class CallGate32Bit extends GateSegment
    {
        private final int parameterCount;

        public CallGate32Bit(AddressSpace memory, int selector, long descriptor)
        {
            super(memory, selector, descriptor);
            parameterCount = (int) ((descriptor >> 32) & 0xF);
        }

        public int getType()
        {
            return 0x0c;
        }

        public final int getParameterCount()
        {
            return parameterCount;
        }
    }

    public static final class CallGate16Bit extends GateSegment
    {
        private final int parameterCount;

        public CallGate16Bit(AddressSpace memory, int selector, long descriptor)
        {
            super(memory, selector, descriptor);
            parameterCount = (int) ((descriptor >> 32) & 0xF);
        }

        public int getType()
        {
            return 0x04;
        }

        public final int getParameterCount()
        {
            return parameterCount;
        }
    }

    static final class Available16BitTSS extends ProtectedModeSegment
    {
        public Available16BitTSS(AddressSpace memory, int selector, long descriptor)
        {
            super(memory, selector, descriptor);
        }

        public int getType()
        {
            return 0x01;
        }
    }

    static final class Busy16BitTSS extends ProtectedModeSegment
    {
        public Busy16BitTSS(AddressSpace memory, int selector, long descriptor)
        {
            super(memory, selector, descriptor);
        }

        public int getType()
        {
            return 0x03;
        }
    }

    public void printState()
    {
        System.out.println("PM Mode segment");
        System.out.println("selector: " + Integer.toHexString(selector));
        System.out.println("base: " + Integer.toHexString(base));
        System.out.println("dpl: " + Integer.toHexString(dpl));
        System.out.println("rpl: " + Integer.toHexString(rpl));
        System.out.println("limit: " + Long.toHexString(limit));
        System.out.println("descriptor: " + Long.toHexString(descriptor));
    }
}

###
