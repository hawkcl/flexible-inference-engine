`timescale 1ns / 1ns
import definitions_pkg::*;

class cloud_driver;
    parameter WRITE_BUS = 1;
    virtual cloud_ports ports;
    int fnetin, fnetout;
    int rec_stop;
    integer I;
    reg [31:0] fcs;
  int fout, fout2;
  logic out_clock;
  int status;
  int data;
  int equal;
  int addr, len, num;
  logic hasSaved;
  int addr_save, len_save, num_save;
  logic   [DDR_DATA_WIDTH-1:0]    data_saved[DDR_LEN_SIZE];
  logic printEndInst;
  logic [DDR_ADDR_WIDTH-1:0]   output_address;
  logic [DDR_ADDR_WIDTH-1:0]   output_size;


    function new (virtual cloud_ports ports);
        begin
            this.ports = ports;
            fnetin = $fopen("d:/aidata/cloud_udp.txt","r");
            fnetout = $fopen("d:/aidata/cloud_output.txt","w");
            rec_stop = 0;
    fout = $fopen("d:/aidata/cloud_sv_output.txt","r");
    fout2 = $fopen("d:/aidata/cloud_sv_outputx.txt","r");
    hasSaved = 0;
    printEndInst = 0;
            end
        endfunction

     


    //--------------------------------------------------------------------
// CRC engine
//--------------------------------------------------------------------
task calc_crc;
    input  [7:0]  data;
    inout  [31:0] fcs;

    reg [31:0] crc;
    reg        crc_feedback;
    integer    I;
    begin

        crc = ~ fcs;

        for (I = 0; I < 8; I = I + 1)
        begin
            crc_feedback = crc[0] ^ data[I];

            crc[0]       = crc[1];
            crc[1]       = crc[2];
            crc[2]       = crc[3];
            crc[3]       = crc[4];
            crc[4]       = crc[5];
            crc[5]       = crc[6]  ^ crc_feedback;
            crc[6]       = crc[7];
            crc[7]       = crc[8];
            crc[8]       = crc[9]  ^ crc_feedback;
            crc[9]       = crc[10] ^ crc_feedback;
            crc[10]      = crc[11];
            crc[11]      = crc[12];
            crc[12]      = crc[13];
            crc[13]      = crc[14];
            crc[14]      = crc[15];
            crc[15]      = crc[16] ^ crc_feedback;
            crc[16]      = crc[17];
            crc[17]      = crc[18];
            crc[18]      = crc[19];
            crc[19]      = crc[20] ^ crc_feedback;
            crc[20]      = crc[21] ^ crc_feedback;
            crc[21]      = crc[22] ^ crc_feedback;
            crc[22]      = crc[23];
            crc[23]      = crc[24] ^ crc_feedback;
            crc[24]      = crc[25] ^ crc_feedback;
            crc[25]      = crc[26];
            crc[26]      = crc[27] ^ crc_feedback;
            crc[27]      = crc[28] ^ crc_feedback;
            crc[28]      = crc[29];
            crc[29]      = crc[30] ^ crc_feedback;
            crc[30]      = crc[31] ^ crc_feedback;
            crc[31]      =           crc_feedback;
        end

        // return the CRC result
        fcs = ~ crc;

    end
endtask // calc_crc


    task gen_input();
        reg[7:0]    byte_data;
        int status, num;
        int rows;
        begin
            ports.rgmii_rxctl = 0;
            ports.rgmii_rxd = 0;
            rows = 0;
            wait(ports.arp_request == 1);
            while(!rec_stop) begin
                status = $fscanf(fnetin, "%d", num);
                if(status != 1) begin
                    $write("Error, read lenght\n");
                    return;
                end
                if(num == 0) begin
                    $write("end of inputs\n");
                    rec_stop = 1;
                    return;
                end
                @(posedge ports.rgmii_rxc);
                $write("%dns : input row %d\n", $time, rows);
                rows = rows + 1;
                fcs = 32'b0;

                for (I = 0; I <= 13; I = I + 1)
                begin
                    ports.rgmii_rxd   <= 4'h5;
                    ports.rgmii_rxctl <= 1'b1;
                    @(ports.rgmii_rxc);
                end

                // Adding the Start of Frame Delimiter (SFD)
                ports.rgmii_rxd   <= 4'h5;
                ports.rgmii_rxctl <= 1'b1;
                @(ports.rgmii_rxc)
                ports.rgmii_rxd   <= 4'hD;
                ports.rgmii_rxctl <= 1'b1;
                @(ports.rgmii_rxc)
                // loop over columns in frame.
                while (num > 0)
                begin
                    status = $fscanf(fnetin, "%x", byte_data);
                    num = num - 1;
                    if(status != 1) begin
                        $write("Error, read byte data %d\n", num);
                        return;
                    end
                    
                    // send one column of data
                    ports.rgmii_rxd    <= byte_data[3:0];
                    ports.rgmii_rxctl <= 1;
                    @(ports.rgmii_rxc)
                    ports.rgmii_rxd    <= byte_data[7:4];
                    ports.rgmii_rxctl <= 1;
                    calc_crc(byte_data, fcs);

                    @(ports.rgmii_rxc);  // wait for next clock tick

                end

                // Send the CRC.
                for (I = 0; I < 4; I = I + 1)
                begin
                    case(I)
                        0 : ports.rgmii_rxd    <= fcs[3:0];
                        1 : ports.rgmii_rxd    <= fcs[11:8];
                        2 : ports.rgmii_rxd    <= fcs[19:16];
                        3 : ports.rgmii_rxd    <= fcs[27:24];
                    endcase
                    ports.rgmii_rxctl <= 1'b1;
                    @(ports.rgmii_rxc)
                    case(I)
                        0 : ports.rgmii_rxd    <= fcs[7:4];
                        1 : ports.rgmii_rxd    <= fcs[15:12];
                        2 : ports.rgmii_rxd    <= fcs[23:20];
                        3 : ports.rgmii_rxd    <= fcs[31:28];
                    endcase
                    ports.rgmii_rxctl <= 1'b1;

                    @(ports.rgmii_rxc);  // wait for next clock tick
                end

                // Clear the data lines.
                ports.rgmii_rxd       <= 4'h0;
                ports.rgmii_rxctl    <= 1'b0;

                // Adding the minimum Interframe gap for a receiver (8 idles)
                for (I = 0; I < 160; I = I + 1)
                    @(ports.rgmii_rxc);
            end
        end
endtask

task save_output();
    begin
        while (1) begin
            while (ports.rgmii_txctl !== 1'b1)
                @(ports.rgmii_txc);
            if(ports.resetN == 1'b0 || ports.init_calib_complete == 1'b0)
                continue;
            while (ports.rgmii_txctl) begin
                $fwrite(fnetout, "%x", ports.rgmii_txd[3:0]); 
                @(ports.rgmii_txc);
            end
            $fwrite(fnetout, "\n");
            $fflush(fnetout);
        end
    end
endtask

  task cmp_outputs();
  begin
      if(sim_tb_top.u_ip_top.add_output) begin
        $write("Add Output %d (%d)\n", sim_tb_top.u_ip_top.add_output_address, sim_tb_top.u_ip_top.add_output_size);
      end
  end
  endtask
  task save_data();
  begin
      hasSaved = 1;
      addr_save = addr;
      len_save  = len;
      num_save  = num;
      for(int i = 0; i <  len; i++) begin
            status = $fscanf(fout2, "%d" ,data); 
            if(status != 1) begin
                $write("Error save: No data for memaddr %d (%d), %d\n"
                    , addr, len, num);
                return;
            end
            data_saved[i] = data;
      end
      status = $fscanf(fout2, "%d %d %d", num ,addr, len); 
      if(status != 3) begin
            $write("Error save: No addr len data for addr %d (%d) %d\n"
               , sim_tb_top.u_ip_top.write_addr_data1, sim_tb_top.u_ip_top.write_len_data1, num_save);
            return;
      end
  end
  endtask

  task cmp_saved();
  begin
      equal = 1;
      if(addr_save != sim_tb_top.u_ip_top.write_addr_data1) begin
          $write("Error cmp_saved : Addr not euqal %d vs %d , %d (%d)\n", sim_tb_top.u_ip_top.write_addr_data1, addr_save, num_save, len_save);
            equal = 0;
      end
      if(len_save  != sim_tb_top.u_ip_top.write_len_data1) begin
            $write("Error cmp_saved : len not euqal for addr %d : %d vs %d, %d\n", sim_tb_top.u_ip_top.write_addr_data1
            ,sim_tb_top.u_ip_top.write_len_data1 , len_save, num_save);
            equal = 0;
      end
      for(int i = 0; i <  len_save; i++) begin
            if(data_saved[i] != sim_tb_top.u_ip_top.write_data_data1[i]) begin
                equal = 0;
                $write("Error cmp_saved : MemData differ addr %d (%d) i = %d, %d vs %d , %d\n"
                , sim_tb_top.u_ip_top.write_addr_data1, sim_tb_top.u_ip_top.write_len_data1
                , i, data_saved[i], sim_tb_top.u_ip_top.write_data_data1[i], num_save);
            end
      end
      if(equal)
            $write("MemData equal for addr %d (%d), %d, %d\n", addr_save, len_save, num_save, sim_tb_top.u_ip_top.write_data_data1[0]);
      hasSaved = 0;
  end
  endtask

  task cmp_mem_writes();
  begin
       //         $write("wen data1 %d\n", sim_tb_top.u_ip_top.wen_data1);
      equal = 1;  
      if(sim_tb_top.u_ip_top.wen_data1) begin
          if(hasSaved) begin
              cmp_saved();
              return;
          end
          status = $fscanf(fout2, "%d %d %d", num ,addr, len); 
          if(status != 3) begin
                $write("Error : No addr len data for addr %d (%d) , %d\n"
                   , sim_tb_top.u_ip_top.write_addr_data1, sim_tb_top.u_ip_top.write_len_data1, num);
                return;
          end
          if(addr != sim_tb_top.u_ip_top.write_addr_data1) begin
              save_data();
              if(addr != sim_tb_top.u_ip_top.write_addr_data1) 
                  $write("Error : Addr not euqal %d vs %d , %d (%d)\n", sim_tb_top.u_ip_top.write_addr_data1, addr, num, len);
          end
          if(len  != sim_tb_top.u_ip_top.write_len_data1)
                $write("Error : len not euqal for addr %d : %d vs %d, %d\n", sim_tb_top.u_ip_top.write_addr_data1
                   , sim_tb_top.u_ip_top.write_len_data1, len, num);

          for(int i = 0; i <  len; i++) begin
            status = $fscanf(fout2, "%d" ,data); 
            if(status != 1) begin
                $write("Error : No data for memaddr %d (%d)\n"
                    , sim_tb_top.u_ip_top.write_addr_data1, sim_tb_top.u_ip_top.write_len_data1);
                return;
            end
            if(data != sim_tb_top.u_ip_top.write_data_data1[i]) begin
                equal = 0;
                $write("Error : MemData differ addr %d (%d) i = %d, %d vs %d , %d\n"
                , sim_tb_top.u_ip_top.write_addr_data1, sim_tb_top.u_ip_top.write_len_data1
                , i, data, sim_tb_top.u_ip_top.write_data_data1[i], num);
            end
          end
          if(equal)
                $write("MemData equal for addr %d (%d), %d, %d\n", addr, len, num, sim_tb_top.u_ip_top.write_data_data1[0]);
      end
  end
  endtask

  task write_ddr();
  begin
      $write("ddrwassist saved %d %d %d %d, flash %d, process %d, save_start %d, save_pos %d, data_pos %d, \n", sim_tb_top.u_ip_top.data_write_assist.buf_used
        , sim_tb_top.u_ip_top.data_write_assist.buf_start, sim_tb_top.u_ip_top.data_write_assist.buf_end
        , sim_tb_top.u_ip_top.data_write_assist.idle_count, sim_tb_top.u_ip_top.data_write_assist.flash_saved
        , sim_tb_top.u_ip_top.data_write_assist.do_process, sim_tb_top.u_ip_top.data_write_assist.saved_start
        , sim_tb_top.u_ip_top.data_write_assist.saved_pos, sim_tb_top.u_ip_top.data_write_assist.data_pos

        );
      if(sim_tb_top.u_ip_top.write_request) begin
          $write("DDRW %d %h",sim_tb_top.u_ip_top.axi_waddr, sim_tb_top.u_ip_top.axi_wstrobe);
          for(int i = 0; i < DDR_DATAWIDTH; i++)
            if(sim_tb_top.u_ip_top.axi_wstrobe[i])
                $write(" %d", sim_tb_top.u_ip_top.axi_wdata[i]);
          $write("\n");
      end
      if(sim_tb_top.u_ip_top.ctrlread.readData.input_data_fifo_wen) begin
          $write("readcdata");
          for(int i = 0; i < MAX_LOAD_WIDTH; i++)
                $write(" %d", sim_tb_top.u_ip_top.ctrlread.readData.input_data_fifo_wdata[i]);
          $write("\n");
      end
      if(sim_tb_top.u_ip_top.ctrlread.readExtData.retq_fifo_wen) begin
          $write("readcExtdata %d %d %d", sim_tb_top.u_ip_top.ctrlread.readExtData.retq_fifo_wdata.dtype
            , sim_tb_top.u_ip_top.ctrlread.readExtData.retq_fifo_wdata.len
            , sim_tb_top.u_ip_top.ctrlread.readExtData.retq_fifo_wdata.seq);
          for(int i = 0; i < sim_tb_top.u_ip_top.ctrlread.readExtData.retq_fifo_wdata.len; i++)
                $write(" %d", sim_tb_top.u_ip_top.ctrlread.readExtData.retq_fifo_wdata.data[i]);
          $write("\n");
      end
  end
  endtask

  task write_stats();
  begin
      if(WRITE_BUS) begin
          if(sim_tb_top.u_ip_top.write_request2) begin
              $write("read feature data at %d (%d,%d)\n",sim_tb_top.u_ip_top.axi2_waddr
                , sim_tb_top.u_ip_top.axi2_wdata[0], sim_tb_top.u_ip_top.axi2_wdata[1]);
          end
          if(sim_tb_top.u_ip_top.ps_write_request) begin
              $write("read weight data at %d (%d,%d)\n",sim_tb_top.u_ip_top.ps_axi_waddr
                , sim_tb_top.u_ip_top.ps_axi_wdata[0], sim_tb_top.u_ip_top.ps_axi_wdata[1]);
          end
          if(sim_tb_top.u_ip_top.data_read_assist.req_valid) begin
              $write("ask data %d %d\n",sim_tb_top.u_ip_top.data_read_assist.req_addr
                , sim_tb_top.u_ip_top.data_read_assist.req_len);
          end
          if(sim_tb_top.u_ip_top.data_read_assist.ddr_vid) begin
              $write("ask data return , last? %d\n",sim_tb_top.u_ip_top.data_read_assist.ddr_isLast);
          end

          if(sim_tb_top.u_ip_top.data_write_assist.req_valid) begin
              $write("write data %d %d\n",sim_tb_top.u_ip_top.data_write_assist.req_addr
                , sim_tb_top.u_ip_top.data_write_assist.req_len);
          end

          $write("ctrlread seq %d(%d) (%d, %d, %d%d), live %d, more %d, fifoempty %d, full %d, busvalid(%d)\n"
                ,sim_tb_top.u_ip_top.ctrlread.seqNum, sim_tb_top.u_ip_top.ctrlread.readData.newReqSeq
                , sim_tb_top.u_ip_top.ctrlread.cb_ReqFeature[0], sim_tb_top.u_ip_top.ctrlread.cb_ReqFeature[1]
                , sim_tb_top.u_ip_top.ctrlread.cb_ReqFeature[2], sim_tb_top.u_ip_top.ctrlread.cb_ReqFeature[3]
                , sim_tb_top.u_ip_top.ctrlread.readData.liveCount, sim_tb_top.u_ip_top.ctrlread.readData.readMoreData
                , sim_tb_top.u_ip_top.ctrlread.data_fifo_empty, sim_tb_top.u_ip_top.ctrlread.data_fifo_progfull
                , sim_tb_top.u_ip_top.ctrlread.pread_busValid);
      end

      if(sim_tb_top.u_ip_top.addrbuf_enable) 
          $write("addrbuf_enable %d \n", sim_tb_top.u_ip_top.inst_address);

      if(printEndInst) begin
          $write("EndInst %d %d\n", sim_tb_top.u_ip_top.gib.endInst.oAddr
                , sim_tb_top.u_ip_top.gib.endInst.oSize);
          printEndInst = 0;
      end
      if(sim_tb_top.u_ip_top.gib.inst_fifo_ren) begin
          $write("end_deque %d %d\n", sim_tb_top.u_ip_top.gib.inst_fifo_rdata.oAddr
                , sim_tb_top.u_ip_top.gib.inst_fifo_rdata.oSize);
          printEndInst = 1;
      end
      if(sim_tb_top.u_ip_top.add_output) 
          $write("add_output %d %d\n", sim_tb_top.u_ip_top.add_output_address
                , sim_tb_top.u_ip_top.add_output_size);
      
    
      if(WRITE_BUS) begin
          if(sim_tb_top.u_ip_top.ctrlread.reqq_fifo_ren)
                $write("req_deque %d %d %d %d %d %d %d\n", sim_tb_top.u_ip_top.ctrlread.reqq_fifo_rdata.addr
                , sim_tb_top.u_ip_top.ctrlread.reqq_fifo_rdata.seq, sim_tb_top.u_ip_top.ctrlread.reqq_fifo_rdata.len
                , sim_tb_top.u_ip_top.ctrlread.reqq_fifo_rdata.token , sim_tb_top.u_ip_top.ctrlread.reqq_fifo_rdata.dtype
                , sim_tb_top.u_ip_top.ctrlread.reqq_fifo_rdata.isRamA, sim_tb_top.u_ip_top.ctrlread.reqq_fifo_rdata.isRamB);
          if(sim_tb_top.u_ip_top.ctrlread.reqq_fifo_wen)
                $write("req_enque %d %d %d %d %d %d %d\n", sim_tb_top.u_ip_top.ctrlread.reqq_fifo_wdata.addr
                , sim_tb_top.u_ip_top.ctrlread.reqq_fifo_wdata.seq, sim_tb_top.u_ip_top.ctrlread.reqq_fifo_wdata.len
                , sim_tb_top.u_ip_top.ctrlread.reqq_fifo_wdata.token , sim_tb_top.u_ip_top.ctrlread.reqq_fifo_wdata.dtype
                , sim_tb_top.u_ip_top.ctrlread.reqq_fifo_wdata.isRamA, sim_tb_top.u_ip_top.ctrlread.reqq_fifo_wdata.isRamB);
          if(sim_tb_top.u_ip_top.ctrlread.retq_fifo_wen) begin
              $write("ret_enque %d %d %d %d", sim_tb_top.u_ip_top.ctrlread.retq_fifo_wdata.dtype
                , sim_tb_top.u_ip_top.ctrlread.retq_fifo_wdata.seq , sim_tb_top.u_ip_top.ctrlread.retq_fifo_wdata.len
                , sim_tb_top.u_ip_top.ctrlread.retq_fifo_wdata.token);
              for(int i = 0; i < sim_tb_top.u_ip_top.ctrlread.retq_fifo_wdata.len; i++)
                  $write(" %d", sim_tb_top.u_ip_top.ctrlread.retq_fifo_wdata.data[i]);
              $write("\n");
          end
      end
      if(sim_tb_top.u_ip_top.ctrlread.retq_fifo_ren) begin
          $write("ret_deque %d %d %d %d", sim_tb_top.u_ip_top.ctrlread.retq_fifo_rdata.dtype
            , sim_tb_top.u_ip_top.ctrlread.retq_fifo_rdata.seq , sim_tb_top.u_ip_top.ctrlread.retq_fifo_rdata.len
            , sim_tb_top.u_ip_top.ctrlread.retq_fifo_rdata.token);
          if(WRITE_BUS)
              for(int i = 0; i < sim_tb_top.u_ip_top.ctrlread.retq_fifo_rdata.len; i++)
                  $write(" %d", sim_tb_top.u_ip_top.ctrlread.retq_fifo_rdata.data[i]);
          $write("\n");
      end

      if(sim_tb_top.u_ip_top.hcb[0].h.weights_ren) begin
          $write("weights ");
          if(WRITE_BUS)
              for(int i = 0; i < WEIGHT_BUFFER_SIZE; i++)
                  $write(" %d", sim_tb_top.u_ip_top.hcb[0].h.weights_rdata[i]);
          $write("\n");
      end

      if(sim_tb_top.u_ip_top.hcb[0].h.extWeights_ren) begin
          $write("bmweights_ren ");
          if(WRITE_BUS)
              for(int i = 0; i < BM_READ_WIDTH; i++)
                  $write(" %d", sim_tb_top.u_ip_top.hcb[0].h.extWeights_rdata[i]);
          $write("\n");
      end

      if(sim_tb_top.u_ip_top.hcb[0].h.extWeights_wen) begin
          $write("bmweights_wen ");
          if(WRITE_BUS)
              for(int i = 0; i < BM_READ_WIDTH; i++)
                  $write(" %d", sim_tb_top.u_ip_top.hcb[0].h.extWeights_wdata[i]);
          $write("\n");
      end

      if(sim_tb_top.u_ip_top.hcb[0].h.input_fifo_ren) begin
          $write("features ");
          if(WRITE_BUS)
              for(int i = 0; i < sim_tb_top.u_ip_top.hcb[0].h.readWidth; i++)
                  $write(" %d", sim_tb_top.u_ip_top.hcb[0].h.input_fifo_rdata[i]);
          $write("\n");
      end
      if(WRITE_BUS) begin
          if(sim_tb_top.u_ip_top.hcb[0].h.pwrite_enable) begin
              $write("outputs bank0 %d", sim_tb_top.u_ip_top.hcb[0].h.pwrite_addr);
              if(WRITE_BUS)
                  for(int i = 0; i < sim_tb_top.u_ip_top.hcb[0].h.outputBufW1_out; i++)
                      $write(" %d", sim_tb_top.u_ip_top.hcb[0].h.pwrite_data[i]);
              $write("\n");
          end
          if(sim_tb_top.u_ip_top.hcb[1].h.pwrite_enable) begin
              $write("outputs bank1 %d", sim_tb_top.u_ip_top.hcb[1].h.pwrite_addr);
              if(WRITE_BUS)
                  for(int i = 0; i < sim_tb_top.u_ip_top.hcb[1].h.outputBufW1_out; i++)
                      $write(" %d", sim_tb_top.u_ip_top.hcb[1].h.pwrite_data[i]);
              $write("\n");
          end
          if(sim_tb_top.u_ip_top.hcb[2].h.pwrite_enable) begin
              $write("outputs bank2 %d", sim_tb_top.u_ip_top.hcb[2].h.pwrite_addr);
              if(WRITE_BUS)
                  for(int i = 0; i < sim_tb_top.u_ip_top.hcb[2].h.outputBufW1_out; i++)
                      $write(" %d", sim_tb_top.u_ip_top.hcb[2].h.pwrite_data[i]);
              $write("\n");
          end
          if(sim_tb_top.u_ip_top.hcb[3].h.pwrite_enable) begin
              $write("outputs bank3 %d", sim_tb_top.u_ip_top.hcb[3].h.pwrite_addr);
              if(WRITE_BUS)
                  for(int i = 0; i < sim_tb_top.u_ip_top.hcb[3].h.outputBufW1_out; i++)
                      $write(" %d", sim_tb_top.u_ip_top.hcb[3].h.pwrite_data[i]);
              $write("\n");
          end

          $write("wtctrl ddr (%d %d), bv %d, empty %d\n", sim_tb_top.u_ip_top.ren_weight
            , sim_tb_top.u_ip_top.read_addr_weight, sim_tb_top.u_ip_top.pcweight_busValid
            , sim_tb_top.u_ip_top.ctrlweight.data_fifo_empty);
          $write("rctrl ddr (%d %d %d), bv %d %d, idx %d, empty %d\n", sim_tb_top.u_ip_top.ren_data1
            , sim_tb_top.u_ip_top.read_addr_data1, sim_tb_top.u_ip_top.ddr_id
            , sim_tb_top.u_ip_top.pread_busValid, sim_tb_top.u_ip_top.pread_isFeature
            , sim_tb_top.u_ip_top.ctrlread.dataIdx, sim_tb_top.u_ip_top.ctrlread.data_fifo_empty);
      end
      $write("wctrl writable (%d %d %d %d), idx %d, wready %d\n", sim_tb_top.u_ip_top.pwrite_isWritable[0]
        , sim_tb_top.u_ip_top.pwrite_isWritable[1], sim_tb_top.u_ip_top.pwrite_isWritable[2]
        , sim_tb_top.u_ip_top.pwrite_isWritable[3], sim_tb_top.u_ip_top.ctrlwrite.idx
        , sim_tb_top.u_ip_top.ctrlwrite.ddr_write_ready);
      if(WRITE_BUS) begin

          $write("HCB0 hcbctrl, FDone %d, convInit %d, initWSteps %d, wtotal %d, initFSteps %d, k %d\n"
                , sim_tb_top.u_ip_top.hcb[0].h.hcbCtrl.FDone, sim_tb_top.u_ip_top.hcb[0].h.hcbCtrl.convInit
                , sim_tb_top.u_ip_top.hcb[0].h.hcbCtrl.initWSteps, sim_tb_top.u_ip_top.hcb[0].h.hcbCtrl.wtotal
                , sim_tb_top.u_ip_top.hcb[0].h.hcbCtrl.initFSteps, sim_tb_top.u_ip_top.hcb[0].h.hcbCtrl.k);
          $write("HCB0 hcbctrl, wait_k1 %d, input_fifo_empty %d, new_conv_inst %d\n"
                , sim_tb_top.u_ip_top.hcb[0].h.hcbCtrl.wait_k1_feature, sim_tb_top.u_ip_top.hcb[0].h.hcbCtrl.input_fifo_empty
                , sim_tb_top.u_ip_top.hcb[0].h.hcbCtrl.new_conv_inst);
          
                $write("HCB0 out (%d %d), readfeature %d (%d, %d, %d,%d), pread (%d,%d) readweight %d, froze %d, state %d, wempty %d, bmempty %d, fempty (%d %d %d)\n"
                , sim_tb_top.u_ip_top.pwrite_enable[0] , sim_tb_top.u_ip_top.pwrite_addr[0]
                , sim_tb_top.u_ip_top.cb_isReadingFeatures[0], sim_tb_top.u_ip_top.hcb[0].h.readFeatures.ibSize
                , sim_tb_top.u_ip_top.hcb[0].h.readFeatures.writeWidth, sim_tb_top.u_ip_top.hcb[0].h.readFeatures.nextWritePos
                , sim_tb_top.u_ip_top.hcb[0].h.volumeSize
                , sim_tb_top.u_ip_top.hcb[0].h.readFeatures.pread_busValid, sim_tb_top.u_ip_top.hcb[0].h.readFeatures.pread_isFeature
                , sim_tb_top.u_ip_top.cb_isReadingWeights[0]
                , sim_tb_top.u_ip_top.cb_isLoadingFroze[0], sim_tb_top.u_ip_top.hcb[0].h.state
                , sim_tb_top.u_ip_top.hcb[0].h.weights_empty, sim_tb_top.u_ip_top.hcb[0].h.extWeights_empty
                , sim_tb_top.u_ip_top.hcb[0].h.input_fifo_empty, sim_tb_top.u_ip_top.hcb[0].h.assemble_buffer_empty
                , sim_tb_top.u_ip_top.hcb[0].h.inputs_buffer_empty);

          $write("HCB1 out (%d %d), readfeature %d (%d,%d), readweight %d, froze %d, state %d, wempty %d, bmempty %d, fempty (%d %d %d)\n"
                , sim_tb_top.u_ip_top.pwrite_enable[1] , sim_tb_top.u_ip_top.pwrite_addr[1]
                , sim_tb_top.u_ip_top.cb_isReadingFeatures[1], sim_tb_top.u_ip_top.hcb[1].h.readFeatures.nextWritePos
                , sim_tb_top.u_ip_top.hcb[1].h.volumeSize, sim_tb_top.u_ip_top.cb_isReadingWeights[1]
                , sim_tb_top.u_ip_top.cb_isLoadingFroze[1], sim_tb_top.u_ip_top.hcb[1].h.state
                , sim_tb_top.u_ip_top.hcb[1].h.weights_empty, sim_tb_top.u_ip_top.hcb[1].h.extWeights_empty
                , sim_tb_top.u_ip_top.hcb[1].h.input_fifo_empty, sim_tb_top.u_ip_top.hcb[1].h.assemble_buffer_empty
                , sim_tb_top.u_ip_top.hcb[1].h.inputs_buffer_empty);
      end
      $write("HCB2 out (%d %d), readfeature %d (%d,%d), readweight %d, froze %d, state %d, wempty %d, bmempty %d, fempty (%d %d %d)\n"
            , sim_tb_top.u_ip_top.pwrite_enable[2] , sim_tb_top.u_ip_top.pwrite_addr[2]
            , sim_tb_top.u_ip_top.cb_isReadingFeatures[2], sim_tb_top.u_ip_top.hcb[2].h.readFeatures.nextWritePos
            , sim_tb_top.u_ip_top.hcb[2].h.volumeSize, sim_tb_top.u_ip_top.cb_isReadingWeights[2]
            , sim_tb_top.u_ip_top.cb_isLoadingFroze[2], sim_tb_top.u_ip_top.hcb[2].h.state
            , sim_tb_top.u_ip_top.hcb[2].h.weights_empty, sim_tb_top.u_ip_top.hcb[2].h.extWeights_empty
            , sim_tb_top.u_ip_top.hcb[2].h.input_fifo_empty, sim_tb_top.u_ip_top.hcb[2].h.assemble_buffer_empty
            , sim_tb_top.u_ip_top.hcb[2].h.inputs_buffer_empty);
      if(WRITE_BUS) begin
          $write("HCB3 out (%d %d), readfeature %d (%d,%d), readweight %d, froze %d, state %d, wempty %d, bmempty %d, fempty (%d %d %d)\n"
                , sim_tb_top.u_ip_top.pwrite_enable[3] , sim_tb_top.u_ip_top.pwrite_addr[3]
                , sim_tb_top.u_ip_top.cb_isReadingFeatures[3], sim_tb_top.u_ip_top.hcb[3].h.readFeatures.nextWritePos
                , sim_tb_top.u_ip_top.hcb[3].h.volumeSize, sim_tb_top.u_ip_top.cb_isReadingWeights[3]
                , sim_tb_top.u_ip_top.cb_isLoadingFroze[3], sim_tb_top.u_ip_top.hcb[3].h.state
                , sim_tb_top.u_ip_top.hcb[3].h.weights_empty, sim_tb_top.u_ip_top.hcb[3].h.extWeights_empty
                , sim_tb_top.u_ip_top.hcb[3].h.input_fifo_empty, sim_tb_top.u_ip_top.hcb[3].h.assemble_buffer_empty
                , sim_tb_top.u_ip_top.hcb[3].h.inputs_buffer_empty);
      end
  end
  endtask

  task check_fifos();
  begin
      assert(!(sim_tb_top.u_ip_top.hcb[0].h.extWeights_wen && sim_tb_top.u_ip_top.hcb[0].h.extWeights_full));
      assert(!(sim_tb_top.u_ip_top.hcb[0].h.weights_wen && sim_tb_top.u_ip_top.hcb[0].h.weights_full));
      assert(!(sim_tb_top.u_ip_top.hcb[0].h.resBuf_wen && sim_tb_top.u_ip_top.hcb[0].h.resBuf_full));
      assert(!(sim_tb_top.u_ip_top.hcb[0].h.inst_fifo_wen && sim_tb_top.u_ip_top.hcb[0].h.instfifo_full));
      assert(!(sim_tb_top.u_ip_top.hcb[0].h.inputs_buffer_wen && sim_tb_top.u_ip_top.hcb[0].h.inputs_buffer_full));
      assert(!(sim_tb_top.u_ip_top.hcb[0].h.assemble_buffer_wen && sim_tb_top.u_ip_top.hcb[0].h.assemble_buffer_full));
      assert(!(sim_tb_top.u_ip_top.hcb[1].h.extWeights_wen && sim_tb_top.u_ip_top.hcb[1].h.extWeights_full));
      assert(!(sim_tb_top.u_ip_top.hcb[1].h.weights_wen && sim_tb_top.u_ip_top.hcb[1].h.weights_full));
      assert(!(sim_tb_top.u_ip_top.hcb[1].h.resBuf_wen && sim_tb_top.u_ip_top.hcb[1].h.resBuf_full));
      assert(!(sim_tb_top.u_ip_top.hcb[1].h.inst_fifo_wen && sim_tb_top.u_ip_top.hcb[1].h.instfifo_full));
      assert(!(sim_tb_top.u_ip_top.hcb[1].h.inputs_buffer_wen && sim_tb_top.u_ip_top.hcb[1].h.inputs_buffer_full));
      assert(!(sim_tb_top.u_ip_top.hcb[1].h.assemble_buffer_wen && sim_tb_top.u_ip_top.hcb[1].h.assemble_buffer_full));
      assert(!(sim_tb_top.u_ip_top.hcb[2].h.extWeights_wen && sim_tb_top.u_ip_top.hcb[2].h.extWeights_full));
      assert(!(sim_tb_top.u_ip_top.hcb[2].h.weights_wen && sim_tb_top.u_ip_top.hcb[2].h.weights_full));
      assert(!(sim_tb_top.u_ip_top.hcb[2].h.resBuf_wen && sim_tb_top.u_ip_top.hcb[2].h.resBuf_full));
      assert(!(sim_tb_top.u_ip_top.hcb[2].h.inst_fifo_wen && sim_tb_top.u_ip_top.hcb[2].h.instfifo_full));
      assert(!(sim_tb_top.u_ip_top.hcb[2].h.inputs_buffer_wen && sim_tb_top.u_ip_top.hcb[2].h.inputs_buffer_full));
      assert(!(sim_tb_top.u_ip_top.hcb[2].h.assemble_buffer_wen && sim_tb_top.u_ip_top.hcb[2].h.assemble_buffer_full));
      assert(!(sim_tb_top.u_ip_top.hcb[3].h.extWeights_wen && sim_tb_top.u_ip_top.hcb[3].h.extWeights_full));
      assert(!(sim_tb_top.u_ip_top.hcb[3].h.weights_wen && sim_tb_top.u_ip_top.hcb[3].h.weights_full));
      assert(!(sim_tb_top.u_ip_top.hcb[3].h.resBuf_wen && sim_tb_top.u_ip_top.hcb[3].h.resBuf_full));
      assert(!(sim_tb_top.u_ip_top.hcb[3].h.inst_fifo_wen && sim_tb_top.u_ip_top.hcb[3].h.instfifo_full));
      assert(!(sim_tb_top.u_ip_top.hcb[3].h.inputs_buffer_wen && sim_tb_top.u_ip_top.hcb[3].h.inputs_buffer_full));
      assert(!(sim_tb_top.u_ip_top.hcb[3].h.assemble_buffer_wen && sim_tb_top.u_ip_top.hcb[3].h.assemble_buffer_full));

      assert(!(sim_tb_top.u_ip_top.addrbuf_enable && sim_tb_top.u_ip_top.addressBuffer_full));

      assert(!(sim_tb_top.u_ip_top.weight_read_assist.info_fifo_wen && sim_tb_top.u_ip_top.weight_read_assist.info_fifo_full));
      assert(!(sim_tb_top.u_ip_top.data_read_assist.info_fifo_wen && sim_tb_top.u_ip_top.data_read_assist.info_fifo_full));
      assert(!(sim_tb_top.u_ip_top.data_write_assist.info_fifo_wen && sim_tb_top.u_ip_top.data_write_assist.info_fifo_full));

      assert(!(sim_tb_top.u_ip_top.ctrlread.readData.input_data_fifo_wen && sim_tb_top.u_ip_top.ctrlread.readData.input_data_fifo_full));
      assert(!(sim_tb_top.u_ip_top.ctrlread.data_fifo_wen && sim_tb_top.u_ip_top.ctrlread.data_fifo_full));
      assert(!(sim_tb_top.u_ip_top.ctrlread.reqq_fifo_wen && sim_tb_top.u_ip_top.ctrlread.reqq_fifo_full));
      assert(!(sim_tb_top.u_ip_top.ctrlread.retq_fifo_wen && sim_tb_top.u_ip_top.ctrlread.retq_fifo_full));
      assert(!(sim_tb_top.u_ip_top.ctrlread.crinst_enable && sim_tb_top.u_ip_top.ctrlread.inst_fifo_full));
      assert(!(sim_tb_top.u_ip_top.ctrlwrite.cwinst_enable && sim_tb_top.u_ip_top.ctrlwrite.inst_fifo_full));
      assert(!(sim_tb_top.u_ip_top.ctrlwrite.addr_fifo_wen[0] && sim_tb_top.u_ip_top.ctrlwrite.addr_fifo_full[0]));
      assert(!(sim_tb_top.u_ip_top.ctrlwrite.data_fifo_wen[0] && sim_tb_top.u_ip_top.ctrlwrite.data_fifo_full[0]));
      assert(!(sim_tb_top.u_ip_top.ctrlwrite.addr_fifo_wen[1] && sim_tb_top.u_ip_top.ctrlwrite.addr_fifo_full[1]));
      assert(!(sim_tb_top.u_ip_top.ctrlwrite.data_fifo_wen[1] && sim_tb_top.u_ip_top.ctrlwrite.data_fifo_full[1]));
      assert(!(sim_tb_top.u_ip_top.ctrlwrite.addr_fifo_wen[2] && sim_tb_top.u_ip_top.ctrlwrite.addr_fifo_full[2]));
      assert(!(sim_tb_top.u_ip_top.ctrlwrite.data_fifo_wen[2] && sim_tb_top.u_ip_top.ctrlwrite.data_fifo_full[2]));
      assert(!(sim_tb_top.u_ip_top.ctrlwrite.addr_fifo_wen[3] && sim_tb_top.u_ip_top.ctrlwrite.addr_fifo_full[3]));
      assert(!(sim_tb_top.u_ip_top.ctrlwrite.data_fifo_wen[3] && sim_tb_top.u_ip_top.ctrlwrite.data_fifo_full[3]));


      assert(!(sim_tb_top.u_ip_top.ctrlweight.data_fifo_wen && sim_tb_top.u_ip_top.ctrlweight.data_fifo_full));
      assert(!(sim_tb_top.u_ip_top.ctrlweight.cwinst_enable && sim_tb_top.u_ip_top.ctrlweight.inst_fifo_full));
      assert(!(sim_tb_top.u_ip_top.gib.inst_fifo_wen && sim_tb_top.u_ip_top.gib.inst_fifo_full));
  end
  endtask
  task cmp_output();
  begin
    while (1) begin
      @ (posedge out_clock);
       //@ cloud_ports.cb
       if(ports.resetN == 1'b0 || ports.init_calib_complete == 1'b0)
	       continue;
        cmp_outputs();
        cmp_mem_writes();
        //write_ddr();
        if($time > 800) begin
            write_stats();
            check_fifos();
        end
    end
  end
  endtask

  task gen_oclk();
  begin
  while(1) begin
	  @ (posedge ports.clock);
	  #1 out_clock = 1'b1;
	  @ (negedge ports.clock);
	  #1 out_clock = 1'b0;
  end
  end
  endtask

task go();
    begin
        // Assert reset first
        // Start the monitors
        fork
            gen_input();
            save_output();
      gen_oclk();
      cmp_output();
        join
    end
endtask 
endclass
