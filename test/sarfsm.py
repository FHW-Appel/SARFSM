import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer, FallingEdge, ValueChange

@cocotb.test()
async def test_basic(dut):
    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())
    await initialisation(dut)

    assert dut.sar_int.value == 0b1000, "Initialiszation Failed"
    await RisingEdge(dut.clk)
    dut._log.info("Simulation test_basic done")


@cocotb.test()
async def test_basic2(dut):
    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())
    await initialisation(dut)

    assert dut.sar_int.value == 0b0100, "Expacted Failed"
    await RisingEdge(dut.clk)
    dut._log.info("Simulation test_basic2 done")


@cocotb.test()
async def test_analog_emulation(dut):
    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())
    await initialisation(dut)
    
    compare_value = 5
    cocotb.start_soon(analog_emulation(dut,compare_value))
    await RisingEdge(dut.EOC)
    await FallingEdge(dut.clk)
    assert dut.sar_out.value == compare_value, "Conversion Value not correct"    
    dut._log.info("Simulation test_analog_emulation done")


async def initialisation(dut):
    dut.rst_n.value = 0
    dut.compare.value = 0
    await Timer(25, unit="ns")
    await RisingEdge(dut.clk)
    dut.rst_n.value = 1
    await RisingEdge(dut.clk)
    dut._log.info("Initialization done")


async def analog_emulation(dut, compare_value):
    while True:
        if int(dut.sar_int.value) <= compare_value:       
            dut.compare.value = 1
        else:
            dut.compare.value = 0
        await ValueChange(dut.sar_int)

