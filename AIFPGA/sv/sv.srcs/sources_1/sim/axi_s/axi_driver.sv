`timescale 1ns / 1ns
import definitions_pkg::*;

class DDRSim #(parameter int N = 1);
  parameter DELAY_NUM = 20;
  parameter DATAWIDTH = DDR_DATAWIDTH;
  parameter TOP_IDX = DELAY_NUM - 1;
  typedef struct {
	int unsigned addr;
	int unsigned len;
    logic        valid;
  } ReadRequest;
  ReadRequest req[DELAY_NUM];
  byte unsigned mem[N];
  function new();
      begin
          for(int i = 0; i < DELAY_NUM; i++)
            req[i].valid = 0;
      end
  endfunction

  task advance();
      begin
          for(int i = TOP_IDX; i > 0; i--) begin
              if(req[i].valid == 0) begin
                  req[i] = req[i-1];
                  req[i-1].valid = 0;
              end
          end
      end
  endtask

  function int topValid;
      return req[TOP_IDX].valid == 1;
  endfunction

  function int readValid;
      return req[0].valid == 0;
  endfunction

  function byte unsigned read1(int unsigned addr);
      return mem[addr];
  endfunction

  task doRead(int unsigned a, int unsigned l);
      begin
          if(req[0].valid)
              $write("Fatal doRead %d %d\n", a, l);
          else begin
              req[0].valid = 1;
              req[0].addr  = a;
              req[0].len   = l;
          end
      end
  endtask

  task getTop(output logic [DATAWIDTH*8 - 1:0]  top_data, output logic isLst);
      begin
          if(req[TOP_IDX].valid == 0 || DATAWIDTH != 8)
              $write("Fatal getTop\n");
          else begin //TODO use generate
              int a = req[TOP_IDX].addr;
              top_data[7:0] = mem[a];
              top_data[15:8] = mem[a + 1];
              top_data[23:16] = mem[a + 2];
              top_data[31:24] = mem[a + 3];
              top_data[39:32] = mem[a + 4];
              top_data[47:40] = mem[a + 5];
              top_data[55:48] = mem[a + 6];
              top_data[63:56] = mem[a + 7];
              if(req[TOP_IDX].len == 0) begin
                  req[TOP_IDX].valid = 0;
                  isLst = 1;
              end
              else begin
                  isLst = 0;
                  req[TOP_IDX].len = req[TOP_IDX].len - 1;
                  req[TOP_IDX].addr = req[TOP_IDX].addr + DATAWIDTH;
              end
          end
      end
  endtask

  task doWrite(logic [DATAWIDTH*8 - 1:0]  wdata, logic [DATAWIDTH - 1:0] strb, int unsigned addr);
      begin
          if(strb[0])
              mem[addr + 0] = wdata[7:0];
          if(strb[1])
              mem[addr + 1] = wdata[15:8];
          if(strb[2])
              mem[addr + 2] = wdata[23:16];
          if(strb[3])
              mem[addr + 3] = wdata[31:24];
          if(strb[4])
              mem[addr + 4] = wdata[39:32];
          if(strb[5])
              mem[addr + 5] = wdata[47:40];
          if(strb[6])
              mem[addr + 6] = wdata[55:48];
          if(strb[7])
              mem[addr + 7] = wdata[63:56];
          
      end
  endtask

  task write1(byte unsigned d, int unsigned addr);
      mem[addr] = d;
  endtask

endclass

class axi_driver;
  parameter WRITE_BUS = 1;
  parameter DELAY_CYCLES = 20;
  parameter MEM_FLUSH_CNT = 105;

  virtual axi_ports ports;
  logic out_ui_clk;
  int fin, fout;
  int fp;
  int status;
  int done;
  int done_cnt;
  int data;
  int unsigned inst_addr;
  int init;
  int out_num;
  DDRSim #(3004000) f_ddr;    
  DDRSim #(9000000) w_ddr;    
  logic [DDR_DATAWIDTH*8 - 1:0]  tmp_data;
  logic [DDR_DATAWIDTH*8 - 1:0]  tmp_wrdata;
  int unsigned out_addr;
  int unsigned out_sz;
  int out_cnt;
  bit do_output;


  function new (virtual axi_ports ports);
  begin
    this.ports = ports;
    out_ui_clk = 0;
   // fin = $fopen("d:/aidata/axi_input.txt","r");
    fout = $fopen("axi_output.txt","r");
    fp = $fopen("axi_tb_output.txt","w");
    init = 1;
    done = 0;
    done_cnt = 0;
    out_num = 0;
    f_ddr = new;
    w_ddr = new;
    do_output = 0;
/*
    $fscanf(fin, "%d", inst_addr);
    for(int i = 0; i < 3; i++) begin
        $fscanf(fin, "%d %d %d", flag, addr, sz);
        for(int unsigned k = 0; k < sz; k++) begin
            $fscanf(fin, "%u", bdata);
            if(flag)
                f_ddr.write1(bdata, addr + k);
            else
                w_ddr.write1(bdata, addr + k);
        end
    end
    $fclose(fin);
    */
  end
  endfunction

  task assign_inputs();
  begin
    int unsigned flag, addr, sz;
    byte unsigned bdata;
        ports.s_axi0_awready = 1;
        ports.s_axi0_wready = 1;
        ports.s_axi0_bresp = 0;
        ports.s_axi0_bvalid = 0;
        ports.s_axi0_arready = f_ddr.readValid;
        ports.s_axi0_rresp = 0;
        ports.ps_axi_awready = 1;
        ports.ps_axi_wready = 1;
        ports.ps_axi_bresp = 0;
        ports.ps_axi_bvalid = 0;
        ports.ps_axi_arready = w_ddr.readValid;
        ports.ps_axi_rresp = 0;

       if(ports.aresetn == 1'b0) begin
        ports.addrbuf_enable = 0;
        ports.inst_address = '0;
        ports.s_axi0_rvalid  = 0;
        ports.s_axi0_rdata= '0;
        ports.s_axi0_rlast = 0;
        ports.ps_axi_rvalid  = 0;
        ports.ps_axi_rdata = '0;
        ports.ps_axi_rlast = 0;
	       return;
       end

      if(init) begin
            fin = $fopen("axi_input.txt","r");
            $fscanf(fin, "%d", inst_addr);
            for(int i = 0; i < 3; i++) begin
                $fscanf(fin, "%d %d %d", flag, addr, sz);
                $fwrite(fp, "data %d %d %d\n", flag, addr, sz);
                for(int unsigned k = 0; k < sz; k++) begin
                    $fscanf(fin, "%d", bdata);
                    if(k < 10)
                        $fwrite(fp, " %d", bdata);
                        
                    if(flag)
                        f_ddr.write1(bdata, addr + k);
                    else
                        w_ddr.write1(bdata, addr + k);
                end
                $fwrite(fp, "\n");
            end
            $fclose(fin);
        $fwrite(fp, "inst_addr %d\n", inst_addr);
        ports.addrbuf_enable = 1;
        ports.inst_address = inst_addr;
        ports.s_axi0_rvalid  = 0;
        ports.s_axi0_rdata= '0;
        ports.s_axi0_rlast = 0;
        ports.ps_axi_rvalid  = 0;
        ports.ps_axi_rdata = '0;
        ports.ps_axi_rlast = 0;
        init = 0;
        return;
      end

        ports.addrbuf_enable = 0;
        ports.inst_address = 0;


        if(f_ddr.topValid) begin
            bit isLst;
            //$fwrite(fp,"send input %d : %x\n", iaddr, tmp_idata);
            f_ddr.getTop(tmp_data, isLst);
            ports.s_axi0_rvalid  = 1;
            ports.s_axi0_rdata= tmp_data;
            ports.s_axi0_rlast = isLst;
            $fwrite(fp,"send input %d %d %d %d %d %d %d %d (%d)\n", tmp_data[7:0]
                , tmp_data[15:8], tmp_data[23:16], tmp_data[31:24]
                , tmp_data[39:32], tmp_data[47:40], tmp_data[55:48]
                , tmp_data[63:56], isLst);
        end
        else begin
            ports.s_axi0_rvalid  = 0;
            ports.s_axi0_rdata= '0;
            ports.s_axi0_rlast = 0;
        end

        if(w_ddr.topValid) begin
            bit isLst;
            //$fwrite(fp,"send input %d : %x\n", iaddr, tmp_idata);
            w_ddr.getTop(tmp_data, isLst);
            ports.ps_axi_rvalid  = 1;
            ports.ps_axi_rdata= tmp_data;
            ports.ps_axi_rlast = isLst;
            $fwrite(fp,"send weight %d %d %d %d %d %d %d %d (%d)\n", tmp_data[7:0]
                , tmp_data[15:8], tmp_data[23:16], tmp_data[31:24]
                , tmp_data[39:32], tmp_data[47:40], tmp_data[55:48]
                , tmp_data[63:56], isLst);
        end
        else begin
            ports.ps_axi_rvalid  = 0;
            ports.ps_axi_rdata= '0;
            ports.ps_axi_rlast = 0;
        end
  end
  endtask

  task cmp_outputs();
  begin
    if(ports.s_axi0_arvalid) begin
        if(f_ddr.readValid) begin
            f_ddr.doRead(ports.s_axi0_araddr, ports.s_axi0_arlen);
        end
    end
    if(ports.ps_axi_arvalid) begin
        if(w_ddr.readValid) begin
            w_ddr.doRead(ports.ps_axi_araddr, ports.ps_axi_arlen);
        end
    end
    if(ports.s_axi0_awvalid) begin
        f_ddr.doWrite( ports.s_axi0_wdata, ports.s_axi0_wstrb,  ports.s_axi0_awaddr);
    end

//output

    if(ports.add_output) begin
        out_num++;
        if(out_num == 2)
            done = 1;
        out_cnt = 0;
        do_output = 1;
        out_addr = ports.add_output_address;
        out_sz   = ports.add_output_size;
    end
    if(do_output) begin
        bit err = 0;
        out_cnt = out_cnt + 1;
        if(out_cnt > MEM_FLUSH_CNT) begin
          do_output = 0;
          $fwrite(fp, "add_output : %d %d\n", out_addr, out_sz);
          for(int i = 0; i < out_sz; i++) begin
              byte unsigned bdata, bdata1;
              bdata1 = f_ddr.read1(out_addr + i);
              $fscanf(fout, "%d", bdata);
              if(bdata != bdata1) begin
                  $fwrite(fp, "output data diff at %d : %d vs %d\n", i, bdata, bdata1);
                  err = 1;
              end
          end
          if(out_num == 2)
              $fclose(fout);
          if(err)
              $fwrite(fp, "Error :output data diff\n");
          else
              $fwrite(fp, "Equal :output data\n");
        end

    end
    $fwrite(fp, "%d %d", ports.s_axi0_arvalid, ports.s_axi0_awvalid);
    if(ports.s_axi0_arvalid) begin
        $fwrite(fp, " %d %d %d", ports.s_axi0_arid, ports.s_axi0_araddr, ports.s_axi0_arlen);
    end
    if(ports.s_axi0_awvalid) begin
        tmp_wrdata = ports.s_axi0_wdata;
        $fwrite(fp, "\nwrite_request %d %d", ports.s_axi0_awaddr, ports.s_axi0_wstrb);
        $fwrite(fp, " %d %d %d %d %d %d %d %d", tmp_wrdata[7: 0], tmp_wrdata[15: 8]
            , tmp_wrdata[23: 16], tmp_wrdata[31: 24], tmp_wrdata[39: 32]
            , tmp_wrdata[47: 40], tmp_wrdata[55: 48], tmp_wrdata[63: 56]);
    end
    $fwrite(fp, "\n");

    $fwrite(fp, " %d %d", ports.ps_axi_arvalid, ports.ps_axi_awvalid);
    if(ports.ps_axi_arvalid) begin
        $fwrite(fp, " %d %d %d", ports.ps_axi_arid, ports.ps_axi_araddr, ports.ps_axi_arlen);
    end
    $fwrite(fp, "\n");
  end
  endtask

  task write_outputs();
  begin

    $fwrite(fp, "%d %d",  ports.s_axi0_awvalid, ports.s_axi0_arvalid);
    if(ports.s_axi0_arvalid) begin
        $fwrite(fp, " %d %d %d", ports.s_axi0_arid, ports.s_axi0_araddr, ports.s_axi0_arlen);
    end
    if(ports.s_axi0_awvalid) begin
        tmp_wrdata = ports.s_axi0_wdata;
        $fwrite(fp, " %d %d", ports.s_axi0_awaddr, ports.s_axi0_wstrb);
        $fwrite(fp, " %d %d %d %d %d %d %d %d", tmp_wrdata[7: 0], tmp_wrdata[15: 8]
            , tmp_wrdata[23: 16], tmp_wrdata[31: 24], tmp_wrdata[39: 32]
            , tmp_wrdata[47: 40], tmp_wrdata[55: 48], tmp_wrdata[63: 56]);
    end
    $fwrite(fp, "\n");

    $fwrite(fp, " %d %d", ports.ps_axi_awvalid, ports.ps_axi_arvalid);
    if(ports.ps_axi_arvalid) begin
        $fwrite(fp, " %d %d %d", ports.ps_axi_arid, ports.ps_axi_araddr, ports.ps_axi_arlen);
    end
    $fwrite(fp, "\n");
  end
  endtask

  task write_ddr();
  begin
      $fwrite(fp,"ddrwassist saved %d %d %d %d, flash %d, process %d, save_start %d, save_pos %d, data_pos %d, \n", axi_tb.axi.data_write_assist.buf_used
        , axi_tb.axi.data_write_assist.buf_start, axi_tb.axi.data_write_assist.buf_end
        , axi_tb.axi.data_write_assist.idle_count, axi_tb.axi.data_write_assist.flash_saved
        , axi_tb.axi.data_write_assist.do_process, axi_tb.axi.data_write_assist.saved_start
        , axi_tb.axi.data_write_assist.saved_pos, axi_tb.axi.data_write_assist.data_pos

        );
      if(axi_tb.axi.write_request) begin
          $fwrite(fp,"DDRW %d %h",axi_tb.axi.axi_waddr, axi_tb.axi.axi_wstrobe);
          for(int i = 0; i < DDR_DATAWIDTH; i++)
            if(axi_tb.axi.axi_wstrobe[i])
                $fwrite(fp," %d", axi_tb.axi.axi_wdata[i]);
          $fwrite(fp,"\n");
      end
      if(axi_tb.axi.ctrlread.readData.input_data_fifo_wen) begin
          $fwrite(fp,"readcdata");
          for(int i = 0; i < MAX_LOAD_WIDTH; i++)
                $fwrite(fp," %d", axi_tb.axi.ctrlread.readData.input_data_fifo_wdata[i]);
          $fwrite(fp,"\n");
      end
      if(axi_tb.axi.ctrlread.readExtData.retq_fifo_wen) begin
          $fwrite(fp,"readcExtdata %d %d %d", axi_tb.axi.ctrlread.readExtData.retq_fifo_wdata.dtype
            , axi_tb.axi.ctrlread.readExtData.retq_fifo_wdata.len
            , axi_tb.axi.ctrlread.readExtData.retq_fifo_wdata.seq);
          for(int i = 0; i < axi_tb.axi.ctrlread.readExtData.retq_fifo_wdata.len; i++)
                $fwrite(fp," %d", axi_tb.axi.ctrlread.readExtData.retq_fifo_wdata.data[i]);
          $fwrite(fp,"\n");
      end
  end
  endtask

  task write_stats();
  begin

  

      if(WRITE_BUS) begin
          if(axi_tb.axi.data_read_assist.req_valid) begin
              $fwrite(fp,"ask data %d %d\n",axi_tb.axi.data_read_assist.req_addr
                , axi_tb.axi.data_read_assist.req_len);
          end
          if(axi_tb.axi.data_read_assist.ddr_vid) begin
              $fwrite(fp,"ask data return , last? %d\n",axi_tb.axi.data_read_assist.ddr_isLast);
          end

          if(axi_tb.axi.data_write_assist.req_valid) begin
              $fwrite(fp,"write data %d %d\n",axi_tb.axi.data_write_assist.req_addr
                , axi_tb.axi.data_write_assist.req_len);
          end

          $fwrite(fp,"ctrlread seq %d(%d) (%d, %d, %d%d), live %d, more %d, fifoempty %d, full %d, busvalid(%d)\n"
                ,axi_tb.axi.ctrlread.seqNum, axi_tb.axi.ctrlread.readData.newReqSeq
                , axi_tb.axi.ctrlread.cb_ReqFeature[0], axi_tb.axi.ctrlread.cb_ReqFeature[1]
                , axi_tb.axi.ctrlread.cb_ReqFeature[2], axi_tb.axi.ctrlread.cb_ReqFeature[3]
                , axi_tb.axi.ctrlread.readData.liveCount, axi_tb.axi.ctrlread.readData.readMoreData
                , axi_tb.axi.ctrlread.data_fifo_empty, axi_tb.axi.ctrlread.data_fifo_progfull
                , axi_tb.axi.ctrlread.pread_busValid);
      end

      if(axi_tb.axi.addrbuf_enable) 
          $fwrite(fp,"addrbuf_enable %d \n", axi_tb.axi.inst_address);

      if(axi_tb.axi.add_output) 
          $fwrite(fp,"add_output %d %d\n", axi_tb.axi.add_output_address
                , axi_tb.axi.add_output_size);
      

      if(axi_tb.axi.ctrlread.inst_fifo_ren)
            $fwrite(fp,"crinst pop  req %d, X %d rwidth %d oaddr %d nextread%d\n"
            , axi_tb.axi.ctrlread.inst.reqSeqNum, axi_tb.axi.ctrlread.inst.X
            , axi_tb.axi.ctrlread.processReadInstruction.readWidth_next , axi_tb.axi.ctrlread.inst.Maddr
            , axi_tb.axi.ctrlread.readData.nextReadPos_next);

      if(WRITE_BUS) begin
          if(axi_tb.axi.ctrlread.reqq_fifo_ren)
                $fwrite(fp,"req_deque %d %d %d %d %d %d %d\n", axi_tb.axi.ctrlread.reqq_fifo_rdata.addr
                , axi_tb.axi.ctrlread.reqq_fifo_rdata.seq, axi_tb.axi.ctrlread.reqq_fifo_rdata.len
                , axi_tb.axi.ctrlread.reqq_fifo_rdata.token , axi_tb.axi.ctrlread.reqq_fifo_rdata.dtype
                , axi_tb.axi.ctrlread.reqq_fifo_rdata.isRamA, axi_tb.axi.ctrlread.reqq_fifo_rdata.isRamB);
          if(axi_tb.axi.ctrlread.reqq_fifo_wen)
                $fwrite(fp,"req_enque %d %d %d %d %d %d %d\n", axi_tb.axi.ctrlread.reqq_fifo_wdata.addr
                , axi_tb.axi.ctrlread.reqq_fifo_wdata.seq, axi_tb.axi.ctrlread.reqq_fifo_wdata.len
                , axi_tb.axi.ctrlread.reqq_fifo_wdata.token , axi_tb.axi.ctrlread.reqq_fifo_wdata.dtype
                , axi_tb.axi.ctrlread.reqq_fifo_wdata.isRamA, axi_tb.axi.ctrlread.reqq_fifo_wdata.isRamB);
          if(axi_tb.axi.ctrlread.retq_fifo_wen) begin
              $fwrite(fp,"ret_enque %d %d %d %d", axi_tb.axi.ctrlread.retq_fifo_wdata.dtype
                , axi_tb.axi.ctrlread.retq_fifo_wdata.seq , axi_tb.axi.ctrlread.retq_fifo_wdata.len
                , axi_tb.axi.ctrlread.retq_fifo_wdata.token);
              for(int i = 0; i < axi_tb.axi.ctrlread.retq_fifo_wdata.len; i++)
                  $fwrite(fp," %d", axi_tb.axi.ctrlread.retq_fifo_wdata.data[i]);
              $fwrite(fp,"\n");
          end
      end
      if(axi_tb.axi.ctrlread.retq_fifo_ren) begin
          $fwrite(fp,"ret_deque %d %d %d %d", axi_tb.axi.ctrlread.retq_fifo_rdata.dtype
            , axi_tb.axi.ctrlread.retq_fifo_rdata.seq , axi_tb.axi.ctrlread.retq_fifo_rdata.len
            , axi_tb.axi.ctrlread.retq_fifo_rdata.token);
          if(WRITE_BUS)
              for(int i = 0; i < axi_tb.axi.ctrlread.retq_fifo_rdata.len; i++)
                  $fwrite(fp," %d", axi_tb.axi.ctrlread.retq_fifo_rdata.data[i]);
          $fwrite(fp,"\n");
      end

      if(axi_tb.axi.hcb[0].h.weights_ren) begin
          $fwrite(fp,"weights ");
          if(WRITE_BUS)
              for(int i = 0; i < WEIGHT_BUFFER_SIZE; i++)
                  $fwrite(fp," %d", axi_tb.axi.hcb[0].h.weights_rdata[i]);
          $fwrite(fp,"\n");
      end

      if(axi_tb.axi.hcb[0].h.input_fifo_ren) begin
          $fwrite(fp,"features ");
          if(WRITE_BUS)
              for(int i = 0; i < axi_tb.axi.hcb[0].h.readWidth; i++)
                  $fwrite(fp," %d", axi_tb.axi.hcb[0].h.input_fifo_rdata[i]);
          $fwrite(fp,"\n");
      end
      if(WRITE_BUS) begin
          if(axi_tb.axi.hcb[0].h.pwrite_enable) begin
              $fwrite(fp,"outputs bank0 %d", axi_tb.axi.hcb[0].h.pwrite_addr);
              if(WRITE_BUS)
                  for(int i = 0; i < axi_tb.axi.hcb[0].h.outputBufW1_out; i++)
                      $fwrite(fp," %d", axi_tb.axi.hcb[0].h.pwrite_data[i]);
              $fwrite(fp,"\n");
          end
          if(axi_tb.axi.hcb[1].h.pwrite_enable) begin
              $fwrite(fp,"outputs bank1 %d", axi_tb.axi.hcb[1].h.pwrite_addr);
              if(WRITE_BUS)
                  for(int i = 0; i < axi_tb.axi.hcb[1].h.outputBufW1_out; i++)
                      $fwrite(fp," %d", axi_tb.axi.hcb[1].h.pwrite_data[i]);
              $fwrite(fp,"\n");
          end
          if(axi_tb.axi.hcb[2].h.pwrite_enable) begin
              $fwrite(fp,"outputs bank2 %d", axi_tb.axi.hcb[2].h.pwrite_addr);
              if(WRITE_BUS)
                  for(int i = 0; i < axi_tb.axi.hcb[2].h.outputBufW1_out; i++)
                      $fwrite(fp," %d", axi_tb.axi.hcb[2].h.pwrite_data[i]);
              $fwrite(fp,"\n");
          end
          if(axi_tb.axi.hcb[3].h.pwrite_enable) begin
              $fwrite(fp,"outputs bank3 %d", axi_tb.axi.hcb[3].h.pwrite_addr);
              if(WRITE_BUS)
                  for(int i = 0; i < axi_tb.axi.hcb[3].h.outputBufW1_out; i++)
                      $fwrite(fp," %d", axi_tb.axi.hcb[3].h.pwrite_data[i]);
              $fwrite(fp,"\n");
          end

          $fwrite(fp,"wtctrl ddr (%d %d), bv %d, empty %d\n", axi_tb.axi.ren_weight
            , axi_tb.axi.read_addr_weight, axi_tb.axi.pcweight_busValid
            , axi_tb.axi.ctrlweight.data_fifo_empty);
          $fwrite(fp,"rctrl ddr (%d %d %d), bv %d %d, idx %d, empty %d\n", axi_tb.axi.ren_data1
            , axi_tb.axi.read_addr_data1, axi_tb.axi.ddr_id
            , axi_tb.axi.pread_busValid, axi_tb.axi.pread_isFeature
            , axi_tb.axi.ctrlread.dataIdx, axi_tb.axi.ctrlread.data_fifo_empty);
      end
      $fwrite(fp,"wctrl writable (%d %d %d %d), idx %d, wready %d\n", axi_tb.axi.pwrite_isWritable[0]
        , axi_tb.axi.pwrite_isWritable[1], axi_tb.axi.pwrite_isWritable[2]
        , axi_tb.axi.pwrite_isWritable[3], axi_tb.axi.ctrlwrite.idx
        , axi_tb.axi.ctrlwrite.ddr_write_ready);
      if(WRITE_BUS) begin

          $fwrite(fp,"HCB0 hcbctrl, FDone %d, convInit %d, initWSteps %d, wtotal %d, initFSteps %d, k %d\n"
                , axi_tb.axi.hcb[0].h.hcbCtrl.FDone, axi_tb.axi.hcb[0].h.hcbCtrl.convInit
                , axi_tb.axi.hcb[0].h.hcbCtrl.initWSteps, axi_tb.axi.hcb[0].h.hcbCtrl.wtotal
                , axi_tb.axi.hcb[0].h.hcbCtrl.initFSteps, axi_tb.axi.hcb[0].h.hcbCtrl.k);
          $fwrite(fp,"HCB0 hcbctrl, input_fifo_empty %d, new_conv_inst %d\n"
                , axi_tb.axi.hcb[0].h.hcbCtrl.input_fifo_empty
                , axi_tb.axi.hcb[0].h.hcbCtrl.new_conv_inst);
          
                $fwrite(fp,"HCB0 out (%d %d), readfeature %d (%d, %d, %d,%d), pread (%d,%d) readweight %d, froze %d, state %d, wempty %d, fempty (%d %d %d)\n"
                , axi_tb.axi.pwrite_enable[0] , axi_tb.axi.pwrite_addr[0]
                , axi_tb.axi.cb_isReadingFeatures[0], axi_tb.axi.hcb[0].h.readFeatures.ibSize
                , axi_tb.axi.hcb[0].h.readFeatures.writeWidth, axi_tb.axi.hcb[0].h.readFeatures.nextWritePos
                , axi_tb.axi.hcb[0].h.volumeSize
                , axi_tb.axi.hcb[0].h.readFeatures.pread_busValid, axi_tb.axi.hcb[0].h.readFeatures.pread_isFeature
                , axi_tb.axi.cb_isReadingWeights[0]
                , axi_tb.axi.cb_isLoadingFroze[0], axi_tb.axi.hcb[0].h.state
                , axi_tb.axi.hcb[0].h.weights_empty
                , axi_tb.axi.hcb[0].h.input_fifo_empty, axi_tb.axi.hcb[0].h.assemble_buffer_empty
                , axi_tb.axi.hcb[0].h.inputs_buffer_empty);

          $fwrite(fp,"HCB1 out (%d %d), readfeature %d (%d,%d), readweight %d, froze %d, state %d, wempty %d, fempty (%d %d %d)\n"
                , axi_tb.axi.pwrite_enable[1] , axi_tb.axi.pwrite_addr[1]
                , axi_tb.axi.cb_isReadingFeatures[1], axi_tb.axi.hcb[1].h.readFeatures.nextWritePos
                , axi_tb.axi.hcb[1].h.volumeSize, axi_tb.axi.cb_isReadingWeights[1]
                , axi_tb.axi.cb_isLoadingFroze[1], axi_tb.axi.hcb[1].h.state
                , axi_tb.axi.hcb[1].h.weights_empty
                , axi_tb.axi.hcb[1].h.input_fifo_empty, axi_tb.axi.hcb[1].h.assemble_buffer_empty
                , axi_tb.axi.hcb[1].h.inputs_buffer_empty);
      end
      $fwrite(fp,"HCB2 out (%d %d), readfeature %d (%d,%d), readweight %d, froze %d, state %d, wempty %d, fempty (%d %d %d)\n"
            , axi_tb.axi.pwrite_enable[2] , axi_tb.axi.pwrite_addr[2]
            , axi_tb.axi.cb_isReadingFeatures[2], axi_tb.axi.hcb[2].h.readFeatures.nextWritePos
            , axi_tb.axi.hcb[2].h.volumeSize, axi_tb.axi.cb_isReadingWeights[2]
            , axi_tb.axi.cb_isLoadingFroze[2], axi_tb.axi.hcb[2].h.state
            , axi_tb.axi.hcb[2].h.weights_empty
            , axi_tb.axi.hcb[2].h.input_fifo_empty, axi_tb.axi.hcb[2].h.assemble_buffer_empty
            , axi_tb.axi.hcb[2].h.inputs_buffer_empty);
      if(WRITE_BUS) begin
          $fwrite(fp,"HCB3 out (%d %d), readfeature %d (%d,%d), readweight %d, froze %d, state %d, wempty %d, fempty (%d %d %d)\n"
                , axi_tb.axi.pwrite_enable[3] , axi_tb.axi.pwrite_addr[3]
                , axi_tb.axi.cb_isReadingFeatures[3], axi_tb.axi.hcb[3].h.readFeatures.nextWritePos
                , axi_tb.axi.hcb[3].h.volumeSize, axi_tb.axi.cb_isReadingWeights[3]
                , axi_tb.axi.cb_isLoadingFroze[3], axi_tb.axi.hcb[3].h.state
                , axi_tb.axi.hcb[3].h.weights_empty
                , axi_tb.axi.hcb[3].h.input_fifo_empty, axi_tb.axi.hcb[3].h.assemble_buffer_empty
                , axi_tb.axi.hcb[3].h.inputs_buffer_empty);
      end
     
  end
  endtask

  task check_fifos();
  begin
      assert(!(axi_tb.axi.hcb[0].h.weights_wen && axi_tb.axi.hcb[0].h.weights_full));
      assert(!(axi_tb.axi.hcb[0].h.resBuf_wen && axi_tb.axi.hcb[0].h.resBuf_full));
      assert(!(axi_tb.axi.hcb[0].h.inst_fifo_wen && axi_tb.axi.hcb[0].h.instfifo_full));
      assert(!(axi_tb.axi.hcb[0].h.inputs_buffer_wen && axi_tb.axi.hcb[0].h.inputs_buffer_full));
      assert(!(axi_tb.axi.hcb[0].h.assemble_buffer_wen && axi_tb.axi.hcb[0].h.assemble_buffer_full));
      assert(!(axi_tb.axi.hcb[1].h.weights_wen && axi_tb.axi.hcb[1].h.weights_full));
      assert(!(axi_tb.axi.hcb[1].h.resBuf_wen && axi_tb.axi.hcb[1].h.resBuf_full));
      assert(!(axi_tb.axi.hcb[1].h.inst_fifo_wen && axi_tb.axi.hcb[1].h.instfifo_full));
      assert(!(axi_tb.axi.hcb[1].h.inputs_buffer_wen && axi_tb.axi.hcb[1].h.inputs_buffer_full));
      assert(!(axi_tb.axi.hcb[1].h.assemble_buffer_wen && axi_tb.axi.hcb[1].h.assemble_buffer_full));
      assert(!(axi_tb.axi.hcb[2].h.weights_wen && axi_tb.axi.hcb[2].h.weights_full));
      assert(!(axi_tb.axi.hcb[2].h.resBuf_wen && axi_tb.axi.hcb[2].h.resBuf_full));
      assert(!(axi_tb.axi.hcb[2].h.inst_fifo_wen && axi_tb.axi.hcb[2].h.instfifo_full));
      assert(!(axi_tb.axi.hcb[2].h.inputs_buffer_wen && axi_tb.axi.hcb[2].h.inputs_buffer_full));
      assert(!(axi_tb.axi.hcb[2].h.assemble_buffer_wen && axi_tb.axi.hcb[2].h.assemble_buffer_full));
      assert(!(axi_tb.axi.hcb[3].h.weights_wen && axi_tb.axi.hcb[3].h.weights_full));
      assert(!(axi_tb.axi.hcb[3].h.resBuf_wen && axi_tb.axi.hcb[3].h.resBuf_full));
      assert(!(axi_tb.axi.hcb[3].h.inst_fifo_wen && axi_tb.axi.hcb[3].h.instfifo_full));
      assert(!(axi_tb.axi.hcb[3].h.inputs_buffer_wen && axi_tb.axi.hcb[3].h.inputs_buffer_full));
      assert(!(axi_tb.axi.hcb[3].h.assemble_buffer_wen && axi_tb.axi.hcb[3].h.assemble_buffer_full));

      assert(!(axi_tb.axi.addrbuf_enable && axi_tb.axi.addressBuffer_full));

      assert(!(axi_tb.axi.weight_read_assist.info_fifo_wen && axi_tb.axi.weight_read_assist.info_fifo_full));
      assert(!(axi_tb.axi.data_read_assist.info_fifo_wen && axi_tb.axi.data_read_assist.info_fifo_full));
      assert(!(axi_tb.axi.data_write_assist.info_fifo_wen && axi_tb.axi.data_write_assist.info_fifo_full));

      assert(!(axi_tb.axi.ctrlread.readData.input_data_fifo_wen && axi_tb.axi.ctrlread.readData.input_data_fifo_full));
      assert(!(axi_tb.axi.ctrlread.data_fifo_wen && axi_tb.axi.ctrlread.data_fifo_full));
      assert(!(axi_tb.axi.ctrlread.reqq_fifo_wen && axi_tb.axi.ctrlread.reqq_fifo_full));
      assert(!(axi_tb.axi.ctrlread.retq_fifo_wen && axi_tb.axi.ctrlread.retq_fifo_full));
      assert(!(axi_tb.axi.ctrlread.crinst_enable && axi_tb.axi.ctrlread.inst_fifo_full));
      assert(!(axi_tb.axi.ctrlwrite.cwinst_enable && axi_tb.axi.ctrlwrite.inst_fifo_full));
      assert(!(axi_tb.axi.ctrlwrite.addr_fifo_wen[0] && axi_tb.axi.ctrlwrite.addr_fifo_full[0]));
      assert(!(axi_tb.axi.ctrlwrite.data_fifo_wen[0] && axi_tb.axi.ctrlwrite.data_fifo_full[0]));
      assert(!(axi_tb.axi.ctrlwrite.addr_fifo_wen[1] && axi_tb.axi.ctrlwrite.addr_fifo_full[1]));
      assert(!(axi_tb.axi.ctrlwrite.data_fifo_wen[1] && axi_tb.axi.ctrlwrite.data_fifo_full[1]));
      assert(!(axi_tb.axi.ctrlwrite.addr_fifo_wen[2] && axi_tb.axi.ctrlwrite.addr_fifo_full[2]));
      assert(!(axi_tb.axi.ctrlwrite.data_fifo_wen[2] && axi_tb.axi.ctrlwrite.data_fifo_full[2]));
      assert(!(axi_tb.axi.ctrlwrite.addr_fifo_wen[3] && axi_tb.axi.ctrlwrite.addr_fifo_full[3]));
      assert(!(axi_tb.axi.ctrlwrite.data_fifo_wen[3] && axi_tb.axi.ctrlwrite.data_fifo_full[3]));


      assert(!(axi_tb.axi.ctrlweight.data_fifo_wen && axi_tb.axi.ctrlweight.data_fifo_full));
      assert(!(axi_tb.axi.ctrlweight.cwinst_enable && axi_tb.axi.ctrlweight.inst_fifo_full));
      assert(!(axi_tb.axi.gib.inst_fifo_wen && axi_tb.axi.gib.inst_fifo_full));
  end
  endtask

  task gen_oclk();
  begin
  while(1) begin
	  @ (posedge ports.ui_clk);
	  #1 out_ui_clk = 1'b1;
	  @ (negedge ports.ui_clk);
	  #1 out_ui_clk = 1'b0;
  end
  end
  endtask

  task reset();
  begin
    ports.aresetn= 1'b0;
    $fwrite(fp,"%dns : asserting reset\n",$time);
    for(int i = 0; i < 5; i++) begin
       @ (posedge ports.ui_clk);
       $fwrite(fp,"%dns :waiting clk\n",$time);
    end
    #2 ports.aresetn= 1'b1;
    $fwrite(fp,"%dns : Done asserting reset\n",$time);
  end
  endtask

  task gen_input();
  begin
    while (1) begin
       @ (posedge ports.ui_clk);
       //if(ports.aresetn == 1'b0)
	     //  continue;
       assign_inputs();
       $fwrite(fp,"%dns : inputs\n", $time);
    end
  end
  endtask

  task cmp_output();
  begin
    while (1) begin
      @ (posedge out_ui_clk);
       //@ axi_ports.cb
       if(ports.aresetn == 1'b0)
	       continue;
       cmp_outputs();
       //    write_outputs();
       // write_ddr();
       // write_stats();
       check_fifos();
       f_ddr.advance();
       w_ddr.advance();
       if(done) begin
         done_cnt  = done_cnt + 1;
         if(done_cnt > 2 + MEM_FLUSH_CNT)
           $finish;
       end
    end
  end
  endtask
  
  task go();
  begin
    // Assert reset first
    // Start the monitors
    fork
      reset();
      gen_oclk();
      gen_input();
      cmp_output();
    join
  end
  endtask 
endclass
