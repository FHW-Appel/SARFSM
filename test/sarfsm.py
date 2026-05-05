import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer

@cocotb.test()
async def test_basic(dut):
    dut._log.info("DUT successfully instantiatd!")
    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())
    dut._log.info("Clock started")
    await initialisation(dut)
    await RisingEdge(dut.clk)
    dut._log.info("Simulation done")
    assert dut.sar_int.value == 0b0100, "Unexpected Error"


async def initialisation(dut):
    dut.rst_n.value = 0
    dut.compare.value = 0
    await Timer(25, unit="ns")
    await RisingEdge(dut.clk)
    dut.rst_n.value = 1
    await RisingEdge(dut.clk)
    dut._log.info("Initialization done")
