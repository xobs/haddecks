# Tests for Wishbone-over-SPI
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Edge, NullTrigger, Timer
from cocotb.result import TestFailure, TestSuccess, ReturnValue

from wishbone import WishboneMaster, WBOp

import logging
import csv
import inspect
import os

# Disable pylint's E1101, which breaks on our wishbone addresses
#pylint:disable=E1101

class HaddecksTest:
    def __init__(self, dut, test_name):
        self.dut = dut
        self.test_name = test_name
        self.csrs = dict()
        self.dut.reset = 1
        with open("../build/csr.csv", newline='') as csr_csv_file:
            csr_csv = csv.reader(csr_csv_file)
            # csr_register format: csr_register, name, address, size, rw/ro
            for row in csr_csv:
                if row[0] == 'csr_register':
                    exec("self.{} = {}".format(row[1].upper(), int(row[2], base=0)))
        cocotb.fork(Clock(dut.clk48, 20800//4, 'ps').start())
        self.wb = WishboneMaster(dut, "wishbone", dut.clk48, timeout=20)

        # Set the signal "test_name" to match this test, so that we can
        # tell from gtkwave which test we're in.
        tn = cocotb.binary.BinaryValue(value=None, n_bits=4096)
        tn.buff = test_name
        self.dut.test_name = tn

    @cocotb.coroutine
    def write(self, addr, val):
        yield self.wb.write(addr, val)

    @cocotb.coroutine
    def read(self, addr):
        value = yield self.wb.read(addr)
        raise ReturnValue(value)

    @cocotb.coroutine
    def reset(self):
        self.dut.reset = 1
        yield RisingEdge(self.dut.clk48)
        yield RisingEdge(self.dut.clk48)
        yield RisingEdge(self.dut.clk48)
        yield RisingEdge(self.dut.clk48)
        self.dut.reset = 0
        yield RisingEdge(self.dut.clk48)
        yield RisingEdge(self.dut.clk48)
        yield RisingEdge(self.dut.clk48)
        yield RisingEdge(self.dut.clk48)

# @cocotb.test()
# def test_wishbone_write(dut):
#     harness = SpiboneTest(dut, inspect.currentframe().f_code.co_name)
#     yield harness.reset()
#     yield harness.write(0x40000000, 0x12345678)
#     val = yield harness.read(0x40000000)
#     if val != 0x12345678:
#         raise TestFailure("memory check failed -- expected 0x12345678, got 0x{:08x}".format(val))

#     yield harness.write(harness.CTRL_SCRATCH, 0x54)
#     val = yield harness.read(harness.CTRL_SCRATCH)
#     if val != 0x54:
#         raise TestFailure("wishbone check failed -- expected 0x54, got 0x{:02x}".format(val))

@cocotb.test()
def test_spiram_read(dut):
    harness = HaddecksTest(dut, inspect.currentframe().f_code.co_name)
    dut._log.info("Resetting board...")
    yield harness.reset()
    dut._log.info("Beginning read...")
    yield harness.read(0x04000000)
    yield harness.read(0x04000000)

@cocotb.test()
def test_spiram_write(dut):
    harness = HaddecksTest(dut, inspect.currentframe().f_code.co_name)
    yield harness.reset()
    yield harness.write(0x04000000, 0xffffffff)
    yield harness.write(0x0400000f, 0x00000000)
    yield harness.write(0x0400000f, 0x00000001)

@cocotb.test()
def test_spiram_read_write(dut):
    harness = HaddecksTest(dut, inspect.currentframe().f_code.co_name)
    yield harness.reset()
    yield harness.read(0x04000000)
    yield harness.write(0x04000000, 0x98765432)
