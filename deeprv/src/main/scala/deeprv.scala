//see LICENSE for license
//authors: Lei Cheng
package accelrv 

import Chisel._
//import chisel3.experimental._
import chisel3.util.HasBlackBoxResource
import freechips.rocketchip.tile._
import freechips.rocketchip.tilelink._
import freechips.rocketchip.config._
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.subsystem.{BaseSubsystem, RocketTilesKey}
import freechips.rocketchip.rocket.{TLBConfig, HellaCacheReq}
import freechips.rocketchip.amba.axi4._
//import boom.common.{BoomTilesKey}

case object DeepRVPrintfEnable extends Field[Boolean](false)


class DeepRV(opcodes: OpcodeSet)(implicit p: Parameters) extends LazyRoCC(
    opcodes = opcodes) {
  override lazy val module = new DeepRVImp(this)
  val weightAXI4Node = AXI4MasterNode(
    Seq
    ( 
       AXI4MasterPortParameters
       (
        masters = Seq(AXI4MasterParameters(
        name = "axi_weight",
        id = IdRange(0,1),
        maxFlight = Some(4),
        aligned = true))
       )
    )
  )
  val featureAXI4Node = AXI4MasterNode(
    Seq
    ( 
       AXI4MasterPortParameters
       (
        masters = Seq(AXI4MasterParameters(
        name = "axi_feature",
        id = IdRange(0,1),
        maxFlight = Some(4),
        aligned = true))
       )
    )
  )
  tlNode := TLFIFOFixer() := AXI4ToTL() := AXI4UserYanker(Some(4)) := AXI4Fragmenter() := AXI4IdIndexer(1) := featureAXI4Node   
  tlNode :=* TLFIFOFixer() := AXI4ToTL() := AXI4UserYanker(Some(4)) := AXI4Fragmenter() := AXI4IdIndexer(1) := weightAXI4Node   
}

class rv_top_wrapper extends BlackBox with HasBlackBoxResource {
    val axiParams = AXI4BundleParameters(addrBits = 32, dataBits = 64, idBits = 4)
    val io = IO( new Bundle {
                  val clock = Input(Clock())
                  val reset = Input(Bool())
                  val addrbuf_enable = Input(Bool())
                  //val inst_address = Input(UInt(p(XLen).W))
                  val inst_address = Input(UInt(64.W))
                  val set_base_addr_enable = Input(Bool())
                  val new_base_feature_address = Input(UInt(64.W))
                  val new_base_weight_address = Input(UInt(64.W))
                  val interrupt = Output(Bool())
                  val interrupt_address = Output(UInt(32.W))
                  val weight_axi = (AXI4Bundle(axiParams))
                  val feature_axi = (AXI4Bundle(axiParams))
                  //foutput.cloneType
                })
    addResource(s"/vsrc/pkg.sv")
    addResource(s"/vsrc/BMWeightFifo.sv")
    addResource(s"/vsrc/GIB.sv")
    addResource(s"/vsrc/HCB.sv")
    addResource(s"/vsrc/HCBCtrl.sv")
    addResource(s"/vsrc/SCG.sv")
    addResource(s"/vsrc/Token.sv")
    addResource(s"/vsrc/UCL.sv")
    addResource(s"/vsrc/UCU.sv")
    addResource(s"/vsrc/assembleInput.sv")
    addResource(s"/vsrc/assembleInputBuffer.sv")
    addResource(s"/vsrc/buildInputFifo.sv")
    addResource(s"/vsrc/ctrlread.sv")
    addResource(s"/vsrc/ctrlweight.sv")
    addResource(s"/vsrc/ctrlwrite.sv")
    addResource(s"/vsrc/ddrreadassist.sv")
    addResource(s"/vsrc/ddrreadassist_axi.sv")
    addResource(s"/vsrc/ddrwriteassist.sv")
    addResource(s"/vsrc/ddrwriteassist_axi.sv")
    addResource(s"/vsrc/processConvOut.sv")
    addResource(s"/vsrc/processInstruction.sv")
    addResource(s"/vsrc/processNextFeatureLoading.sv")
    addResource(s"/vsrc/processNextWeightLoading.sv")
    addResource(s"/vsrc/pushHCBInst.sv")
    addResource(s"/vsrc/readExtra.sv")
    addResource(s"/vsrc/readFeatures.sv")
    addResource(s"/vsrc/resFifo.sv")
    addResource(s"/vsrc/rv_axi4.sv")
    addResource(s"/vsrc/rv_top.sv")
    addResource(s"/vsrc/sendBackUpInput.sv")
    addResource(s"/vsrc/setupShiftInputs.sv")
    addResource(s"/vsrc/startConvOut.sv")
    addResource(s"/vsrc/top_wrapper.sv")
    addResource(s"/vsrc/weightFifo.sv")
    addResource(s"/vsrc/ips/ctrlweight_mem.sv")
    addResource(s"/vsrc/ips/dmem_32_16.sv")
    addResource(s"/vsrc/ips/fifo_DDRReadInfo.sv")
    addResource(s"/vsrc/ips/fifo_DDRWriteInfo.sv")
    addResource(s"/vsrc/ips/fifo_InstructionEnd.sv")
    addResource(s"/vsrc/ips/fifo_InstructionHCB.sv")
    addResource(s"/vsrc/ips/fifo_InstructionHCBWt.sv")
    addResource(s"/vsrc/ips/fifo_InstructionRead.sv")
    addResource(s"/vsrc/ips/fifo_InstructionWeight.sv")
    addResource(s"/vsrc/ips/fifo_InstructionWrite.sv")
    addResource(s"/vsrc/ips/fifo_assemble_buffer.sv")
    addResource(s"/vsrc/ips/fifo_bmweights.sv")
    addResource(s"/vsrc/ips/fifo_ctrlread_data.sv")
    addResource(s"/vsrc/ips/fifo_ctrlread_info.sv")
    addResource(s"/vsrc/ips/fifo_ctrlread_req.sv")
    addResource(s"/vsrc/ips/fifo_ctrlread_ret.sv")
    addResource(s"/vsrc/ips/fifo_ctrlweight_data.sv")
    addResource(s"/vsrc/ips/fifo_ctrlwrite_addr.sv")
    addResource(s"/vsrc/ips/fifo_ctrlwrite_data.sv")
    addResource(s"/vsrc/ips/fifo_out_addrs_sizes.sv")
    addResource(s"/vsrc/ips/fifo_addressBuffer.sv")
    addResource(s"/vsrc/ips/fifo_resdata.sv")
    addResource(s"/vsrc/ips/fifo_weights.sv")
    addResource(s"/vsrc/ips/inputs_mem.sv")
    addResource(s"/vsrc/ips/ram_fifo.sv")

}
//@chiselName
class DeepRVImp(outer: DeepRV)(implicit p: Parameters) extends LazyRoCCModuleImp(outer)  with HasCoreParameters  {
  //parameters
  val (woutput,wedge) = outer.weightAXI4Node.out(0)
  val (foutput,fedge) = outer.featureAXI4Node.out.head
  //val f_axi = Flipped(AXI4Bundle(axiParams))
  val blackbox = Module (new rv_top_wrapper)
  val funct = io.cmd.bits.inst.funct
  val doReset = funct === UInt(0)
  val doCompute = funct === UInt(1)
  val doSetBaseAddr = funct === UInt(2)
  val doResetInterrupt = funct === UInt(3)
  val rst_idle :: rst_reset :: rst_done :: Nil = Enum(Bits(), 3)
  val rstate = Reg(init = rst_idle)
  val reset_cycles = 50.U;
  val reset_count = RegInit(0.U(10.W))
  val interrupt_count = RegInit(0.U(2.W))

  when (io.cmd.fire() && doReset ){
    printf("cmd reset\n")
    rstate := rst_reset;
  }
  when(rstate === rst_reset) {
    printf("cmd reset count %d\n", reset_count)
    reset_count := reset_count + 1.U
    when(reset_count === reset_cycles){
      printf("cmd reset done\n")
      rstate := rst_done;
    }
  }

  when(rstate === rst_reset){
    interrupt_count := 0.U;
  } .elsewhen(io.cmd.fire() && doResetInterrupt){
    when((!blackbox.io.interrupt) && (interrupt_count =/= 0.U)){
      interrupt_count := interrupt_count - 1.U
    }
  } .elsewhen(blackbox.io.interrupt && (interrupt_count =/= 3.U)){
      interrupt_count := interrupt_count + 1.U
  }

  blackbox.io.clock := clock
  blackbox.io.reset := (rstate === rst_reset)
  woutput <> blackbox.io.weight_axi
  foutput <> blackbox.io.feature_axi
 
  io.cmd.ready := ((rstate === rst_idle) || (rstate === rst_done))
  blackbox.io.addrbuf_enable := (io.cmd.fire() && doCompute)
  blackbox.io.inst_address := io.cmd.bits.rs1
  blackbox.io.set_base_addr_enable := (io.cmd.fire() && doSetBaseAddr)
  blackbox.io.new_base_feature_address := io.cmd.bits.rs1
  blackbox.io.new_base_weight_address := io.cmd.bits.rs2

  io.interrupt := (interrupt_count > 0.U)
  io.resp.valid := Bool(false)
  io.busy := Bool(false)
  io.mem.req.valid := Bool(false)

  when (io.cmd.fire() && (!doSetBaseAddr) && (!doCompute) && (!doReset) && (!doResetInterrupt)){
    printf("invalid cmd %x\n", funct);
  }
  when (io.cmd.fire() && doSetBaseAddr ){
    printf("cmd base addr %x, %x\n", io.cmd.bits.rs1, io.cmd.bits.rs2);
  }
  when (io.cmd.fire() && doCompute){
    printf("cmd received adr %x\n" , io.cmd.bits.rs1);
  }
  when (io.interrupt ){
    printf("interrupt %x\n" , blackbox.io.interrupt_address);
  }
  when (foutput.w.fire()){
    printf("axi writedata %x %x (%x)\n" , foutput.w.bits.data(31,0) , foutput.w.bits.data(63,32), foutput.w.bits.strb);
  }
  when (foutput.aw.fire()){
    printf("axi writeaddr %x (%x)\n" , foutput.aw.bits.addr , foutput.aw.bits.len);
  }
  /*when (foutput.ar.valid ){
    printf("axi read request %x (%d)\n" , foutput.ar.bits.addr, foutput.ar.bits.len);
  }
  when (foutput.r.fire()){
    printf("axi read return %x %x\n" , foutput.r.bits.data(31,0) , foutput.r.bits.data(63,32));
  }*/
}

class WithDeepRV extends Config ((site, here, up) => {
  case BuildRoCC => Seq(
    (p: Parameters) => {
      val dprv = LazyModule.apply(new DeepRV(OpcodeSet.custom2)(p))
      /*p(FBUS).fromPort(Some("accelrv_axi_feature")) {
            (
            AXI4ToTL() :=  
            AXI4UserYanker(Some(4)) :=
            AXI4Fragmenter() :=
            AXI4IdIndexer(1) :=  
            dprv.featureAXI4Node)    
        }
      p(FBUS).fromPort(Some("accelrv_axi_weight")) {
            (
            AXI4ToTL() :=  
            AXI4UserYanker(Some(4)) :=
            AXI4Fragmenter() :=
            AXI4IdIndexer(1) :=  
            dprv.weightAXI4Node)    
        }*/
      dprv
    }
  )
  //case XLen => 32
})
// ------------------
// Multi-RoCC Support
// ------------------

/**
 * Map from a hartId to a particular RoCC accelerator
 */
case object MultiRoCCKey extends Field[Map[Int, Seq[Parameters => LazyRoCC]]](Map.empty[Int, Seq[Parameters => LazyRoCC]])

/**
 * Config fragment to enable different RoCCs based on the hartId
 */
class WithMultiRoCC extends Config((site, here, up) => {
  case BuildRoCC => site(MultiRoCCKey).getOrElse(site(TileKey).hartId, Nil)
})

class WithMultiRoCCDeepRV(harts: Int*) extends Config((site, here, up) => {
  case MultiRoCCKey => {
//    require(harts.max <= ((up(RocketTilesKey, site).length + up(BoomTilesKey, site).length) - 1))
    up(MultiRoCCKey, site) ++ harts.distinct.map{ i =>
      (i -> Seq((p: Parameters) => {
        //LazyModule(new DeepRV(OpcodeSet.custom2)(p)).suggestName("deeprv")
        val dprv = LazyModule.apply(new DeepRV(OpcodeSet.custom2)(p))
        dprv
      }))
    }
  }
})

class DeepRVConfig extends Config(new WithDeepRV ++
                                    new freechips.rocketchip.system.DefaultConfig)
/*
trait HasDeepRVRoCC { this: BaseSubsystem =>
  implicit val p: Parameters
  val roccs = p(BuildRoCC).map(_(p))
  roccs.map(_.asInstanceOf[DeepRV].featureAXI4Node).foreach {axi_node =>  
    fbus.fromPort(Some("accelrv_axi_feature")) {
            (
            TLWidthWidget(fbus.beatBytes) :=
            AXI4ToTL() :=  
            AXI4UserYanker(Some(4)) :=
            AXI4Fragmenter() :=
            AXI4IdIndexer(1)) 
    }  := axi_node    
  }
  roccs.map(_.asInstanceOf[DeepRV].weightAXI4Node).foreach {axi_node =>  
    fbus.fromPort(Some("accelrv_axi_weight")) {
            (
            AXI4ToTL() :=  
            AXI4UserYanker(Some(4)) :=
            AXI4Fragmenter() :=
            AXI4IdIndexer(1) :=  
            axi_node)    
        }}
}*/
class WithDeepRVPrintf extends Config((site, here, up) => {
  case DeepRVPrintfEnable => true
})
