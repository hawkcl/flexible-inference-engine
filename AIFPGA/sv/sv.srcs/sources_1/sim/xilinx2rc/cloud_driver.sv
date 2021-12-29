`timescale 1ns / 1ns
import definitions_pkg::*;

class cloud_driver;
  parameter WRITE_BUS = 1;

  virtual cloud_ports ports;
  logic out_clock;
  int fin, fout, fout2;
  int fp;
  logic doReading;
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
  int outSize;
  int iter;


  function new (virtual cloud_ports ports);
  begin
    this.ports = ports;
    out_clock = 0;
    fin = $fopen("d:/aidata/cloud_sv_input.txt","r");
    fout = $fopen("d:/aidata/cloud_sv_output.txt","r");
    fout2 = $fopen("d:/aidata/cloud_sv_outputx.txt","r");
    fp = $fopen("d:/aidata/cloud_sv_sime0.txt","w");
    doReading = 1;
    hasSaved = 0;
    printEndInst = 0;
    outSize = 0;
    iter = 0;
  end
  endfunction

  task assign_inputs();
  begin
    if(!doReading)
	    ports.buf_received = 0;
    else begin
        for(int i = 0; i < DDR_LEN_SIZE + 8; i++) begin
            status = $fscanf(fin, "%d" ,data); 
            if(status != 1) begin
                ports.buf_received = 0;
                doReading = 0;
                $fwrite(fp,"End of input\n");
                return;
            end
            ports.buffer[i] = data;
        end
        $fwrite(fp,"Reading inputs (%d)\n", DDR_LEN_SIZE);
	    ports.buf_received = 1;
    end
  end
  endtask

  task cmp_outputs();
  begin

      equal = 1;  
	  //output_data.output_enable = ports.output_enable;
	  //output_data.output_addr = ports.output_addr;
	  //output_data.output_data = ports.output_data;
	  //output_data.output_len = ports.output_len;
      if(ports.output_enable) begin
          outSize += ports.output_len;
          for(int i = 0; i <  ports.output_len; i++) begin
            status = $fscanf(fout, "%d" ,data); 
            if(status != 1) begin
                $fwrite(fp,"Error : No data for addr %d (%d)\n", ports.output_addr, ports.output_len);
                return;
            end
            if(data != unsigned'(ports.output_data[i])) begin
                equal = 0;
                $fwrite(fp,"Error : Data differ addr %d (%d) i = %d, %d vs %d\n"
                , ports.output_addr, ports.output_len
            , i, data, unsigned'(ports.output_data[i]));
            end
          end
          if(equal)
                $fwrite(fp,"Data equal for addr %d (%d) , os %d\n", ports.output_addr, ports.output_len, outSize);
          if(outSize == 43095) begin
            $fclose(fin);
            fin = $fopen("d:/aidata/cloud_sv_input1.txt","r");
            doReading = 1;
          end
          else if(outSize == 43095 + 172380) begin
              iter = iter + 1;
              $fclose(fout);
              $fclose(fout2);
              $fclose(fp);
              fout = $fopen("d:/aidata/cloud_sv_output.txt","r");
              fout2 = $fopen("d:/aidata/cloud_sv_outputx.txt","r");
              if((iter & 1) == 1)
                    fp = $fopen("d:/aidata/cloud_sv_sim1.txt","w");
              else
                    fp = $fopen("d:/aidata/cloud_sv_sim0.txt","w");
              hasSaved = 0;
              printEndInst = 0;
              outSize = 0;
          end
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
                $fwrite(fp,"Error save: No data for memaddr %d (%d), %d\n"
                    , addr, len, num);
                return;
            end
            data_saved[i] = data;
      end
      status = $fscanf(fout2, "%d %d %d", num ,addr, len); 
      if(status != 3) begin
            $fwrite(fp,"Error save: No addr len data for addr %d (%d) %d\n"
               , cloud_tb.cloud.write_addr_data1, cloud_tb.cloud.write_len_data1, num_save);
            return;
      end
  end
  endtask

  task cmp_saved();
  begin
      equal = 1;
      if(addr_save != cloud_tb.cloud.write_addr_data1) begin
          $fwrite(fp,"Error cmp_saved : Addr not euqal %d vs %d , %d (%d)\n", cloud_tb.cloud.write_addr_data1, addr_save, num_save, len_save);
            equal = 0;
      end
      if(len_save  != cloud_tb.cloud.write_len_data1) begin
            $fwrite(fp,"Error cmp_saved : len not euqal for addr %d : %d vs %d, %d\n", cloud_tb.cloud.write_addr_data1
            ,cloud_tb.cloud.write_len_data1 , len_save, num_save);
            equal = 0;
      end
      for(int i = 0; i <  len_save; i++) begin
          if(data_saved[i] != unsigned'(cloud_tb.cloud.outbuf[i])) begin
                equal = 0;
                $fwrite(fp,"Error cmp_saved : MemData differ addr %d (%d) i = %d, %d vs %d , %d\n"
                , cloud_tb.cloud.write_addr_data1, cloud_tb.cloud.write_len_data1
            , i, data_saved[i], unsigned'(cloud_tb.cloud.outbuf[i]), num_save);
            end
      end
      if(equal)
            $fwrite(fp,"MemData equal for addr %d (%d), %d, %d\n", addr_save, len_save, num_save, cloud_tb.cloud.outbuf[0]);
      hasSaved = 0;
  end
  endtask

  task cmp_mem_writes();
  begin
       //         $fwrite(fp,"wen data1 %d\n", cloud_tb.cloud.wen_data1);
      equal = 1;  
      if(cloud_tb.cloud.wen_data1) begin
          if(hasSaved) begin
              cmp_saved();
              return;
          end
          status = $fscanf(fout2, "%d %d %d", num ,addr, len); 
          if(status != 3) begin
                $fwrite(fp,"Error : No addr len data for addr %d (%d) , %d\n"
                   , cloud_tb.cloud.write_addr_data1, cloud_tb.cloud.write_len_data1, num);
                return;
          end
          if(addr != cloud_tb.cloud.write_addr_data1) begin
              save_data();
              if(addr != cloud_tb.cloud.write_addr_data1) 
                  $fwrite(fp,"Error : Addr not euqal %d vs %d , %d (%d)\n", cloud_tb.cloud.write_addr_data1, addr, num, len);
          end
          if(len  != cloud_tb.cloud.write_len_data1)
                $fwrite(fp,"Error : len not euqal for addr %d : %d vs %d, %d\n", cloud_tb.cloud.write_addr_data1
                   , cloud_tb.cloud.write_len_data1, len, num);

          for(int i = 0; i <  len; i++) begin
            status = $fscanf(fout2, "%d" ,data); 
            if(status != 1) begin
                $fwrite(fp,"Error : No data for memaddr %d (%d)\n"
                    , cloud_tb.cloud.write_addr_data1, cloud_tb.cloud.write_len_data1);
                return;
            end
            if(data != unsigned'(cloud_tb.cloud.outbuf[i])) begin
                equal = 0;
                $fwrite(fp,"Error : MemData differ addr %d (%d) i = %d, %d vs %d , %d\n"
                , cloud_tb.cloud.write_addr_data1, cloud_tb.cloud.write_len_data1
            , i, data, unsigned'(cloud_tb.cloud.outbuf[i]), num);
            end
          end
          if(equal)
                $fwrite(fp,"MemData equal for addr %d (%d), %d, %d\n", addr, len, num, cloud_tb.cloud.outbuf[0]);
      end
  end
  endtask

  task write_ddr();
  begin
      $fwrite(fp,"ddrwassist saved %d %d %d %d, flash %d, process %d, save_start %d, save_pos %d, data_pos %d, \n", cloud_tb.cloud.data_write_assist.buf_used
        , cloud_tb.cloud.data_write_assist.buf_start, cloud_tb.cloud.data_write_assist.buf_end
        , cloud_tb.cloud.data_write_assist.idle_count, cloud_tb.cloud.data_write_assist.flash_saved
        , cloud_tb.cloud.data_write_assist.do_process, cloud_tb.cloud.data_write_assist.saved_start
        , cloud_tb.cloud.data_write_assist.saved_pos, cloud_tb.cloud.data_write_assist.data_pos

        );
      if(cloud_tb.cloud.write_request) begin
          $fwrite(fp,"DDRW %d %h",cloud_tb.cloud.axi_waddr, cloud_tb.cloud.axi_wstrobe);
          for(int i = 0; i < DDR_DATAWIDTH; i++)
            if(cloud_tb.cloud.axi_wstrobe[i])
                $fwrite(fp," %d", cloud_tb.cloud.axi_wdata[i]);
          $fwrite(fp,"\n");
      end
      if(cloud_tb.cloud.ctrlread.readData.input_data_fifo_wen) begin
          $fwrite(fp,"readcdata");
          for(int i = 0; i < MAX_LOAD_WIDTH; i++)
                $fwrite(fp," %d", cloud_tb.cloud.ctrlread.readData.input_data_fifo_wdata[i]);
          $fwrite(fp,"\n");
      end
      if(cloud_tb.cloud.ctrlread.readExtData.retq_fifo_wen) begin
          $fwrite(fp,"readcExtdata %d %d %d", cloud_tb.cloud.ctrlread.readExtData.retq_fifo_wdata.dtype
            , cloud_tb.cloud.ctrlread.readExtData.retq_fifo_wdata.len
            , cloud_tb.cloud.ctrlread.readExtData.retq_fifo_wdata.seq);
          for(int i = 0; i < cloud_tb.cloud.ctrlread.readExtData.retq_fifo_wdata.len; i++)
                $fwrite(fp," %d", cloud_tb.cloud.ctrlread.readExtData.retq_fifo_wdata.data[i]);
          $fwrite(fp,"\n");
      end
  end
  endtask

  task write_stats();
  begin
      if(WRITE_BUS) begin
          if(cloud_tb.cloud.data_read_assist.req_valid) begin
              $fwrite(fp,"ask data %d %d\n",cloud_tb.cloud.data_read_assist.req_addr
                , cloud_tb.cloud.data_read_assist.req_len);
          end
          if(cloud_tb.cloud.data_read_assist.ddr_vid) begin
              $fwrite(fp,"ask data return , last? %d\n",cloud_tb.cloud.data_read_assist.ddr_isLast);
          end

          if(cloud_tb.cloud.data_write_assist.req_valid) begin
              $fwrite(fp,"write data %d %d\n",cloud_tb.cloud.data_write_assist.req_addr
                , cloud_tb.cloud.data_write_assist.req_len);
          end

          $fwrite(fp,"ctrlread seq %d(%d) (%d, %d, %d%d), live %d, more %d, fifoempty %d, full %d, busvalid(%d)\n"
                ,cloud_tb.cloud.ctrlread.seqNum, cloud_tb.cloud.ctrlread.readData.newReqSeq
                , cloud_tb.cloud.ctrlread.cb_ReqFeature[0], cloud_tb.cloud.ctrlread.cb_ReqFeature[1]
                , cloud_tb.cloud.ctrlread.cb_ReqFeature[2], cloud_tb.cloud.ctrlread.cb_ReqFeature[3]
                , cloud_tb.cloud.ctrlread.readData.liveCount, cloud_tb.cloud.ctrlread.readData.readMoreData
                , cloud_tb.cloud.ctrlread.data_fifo_empty, cloud_tb.cloud.ctrlread.data_fifo_progfull
                , cloud_tb.cloud.ctrlread.pread_busValid);
      end

      if(cloud_tb.cloud.addrbuf_enable) 
          $fwrite(fp,"addrbuf_enable %d \n", cloud_tb.cloud.inst_address);

      if(printEndInst) begin
          $fwrite(fp,"EndInst %d %d\n", cloud_tb.cloud.gib.endInst.oAddr
                , cloud_tb.cloud.gib.endInst.oSize);
          printEndInst = 0;
      end
      if(cloud_tb.cloud.gib.inst_fifo_ren) begin
          $fwrite(fp,"end_deque %d %d\n", cloud_tb.cloud.gib.inst_fifo_rdata.oAddr
                , cloud_tb.cloud.gib.inst_fifo_rdata.oSize);
          printEndInst = 1;
      end
      if(cloud_tb.cloud.add_output) 
          $fwrite(fp,"add_output %d %d\n", cloud_tb.cloud.add_output_address
                , cloud_tb.cloud.add_output_size);
      
      if(cloud_tb.cloud.iftest.data_fifo_wen) begin
          {output_address, output_size} = cloud_tb.cloud.iftest.data_fifo_wdata;
          $fwrite(fp,"enque out_addr_size %d %d\n",output_address, output_size);
      end
      if(cloud_tb.cloud.iftest.data_fifo_ren) begin
          {output_address, output_size} = cloud_tb.cloud.iftest.data_fifo_rdata;
          $fwrite(fp,"deque out_addr_size %d %d\n",output_address, output_size);
      end
    
      if(WRITE_BUS) begin
          if(cloud_tb.cloud.ctrlread.reqq_fifo_ren)
                $fwrite(fp,"req_deque %d %d %d %d %d %d %d\n", cloud_tb.cloud.ctrlread.reqq_fifo_rdata.addr
                , cloud_tb.cloud.ctrlread.reqq_fifo_rdata.seq, cloud_tb.cloud.ctrlread.reqq_fifo_rdata.len
                , cloud_tb.cloud.ctrlread.reqq_fifo_rdata.token , cloud_tb.cloud.ctrlread.reqq_fifo_rdata.dtype
                , cloud_tb.cloud.ctrlread.reqq_fifo_rdata.isRamA, cloud_tb.cloud.ctrlread.reqq_fifo_rdata.isRamB);
          if(cloud_tb.cloud.ctrlread.reqq_fifo_wen)
                $fwrite(fp,"req_enque %d %d %d %d %d %d %d\n", cloud_tb.cloud.ctrlread.reqq_fifo_wdata.addr
                , cloud_tb.cloud.ctrlread.reqq_fifo_wdata.seq, cloud_tb.cloud.ctrlread.reqq_fifo_wdata.len
                , cloud_tb.cloud.ctrlread.reqq_fifo_wdata.token , cloud_tb.cloud.ctrlread.reqq_fifo_wdata.dtype
                , cloud_tb.cloud.ctrlread.reqq_fifo_wdata.isRamA, cloud_tb.cloud.ctrlread.reqq_fifo_wdata.isRamB);
          if(cloud_tb.cloud.ctrlread.retq_fifo_wen) begin
              $fwrite(fp,"ret_enque %d %d %d %d", cloud_tb.cloud.ctrlread.retq_fifo_wdata.dtype
                , cloud_tb.cloud.ctrlread.retq_fifo_wdata.seq , cloud_tb.cloud.ctrlread.retq_fifo_wdata.len
                , cloud_tb.cloud.ctrlread.retq_fifo_wdata.token);
              for(int i = 0; i < cloud_tb.cloud.ctrlread.retq_fifo_wdata.len; i++)
                  $fwrite(fp," %d", cloud_tb.cloud.ctrlread.retq_fifo_wdata.data[i]);
              $fwrite(fp,"\n");
          end
      end
      if(cloud_tb.cloud.ctrlread.retq_fifo_ren) begin
          $fwrite(fp,"ret_deque %d %d %d %d", cloud_tb.cloud.ctrlread.retq_fifo_rdata.dtype
            , cloud_tb.cloud.ctrlread.retq_fifo_rdata.seq , cloud_tb.cloud.ctrlread.retq_fifo_rdata.len
            , cloud_tb.cloud.ctrlread.retq_fifo_rdata.token);
          if(WRITE_BUS)
              for(int i = 0; i < cloud_tb.cloud.ctrlread.retq_fifo_rdata.len; i++)
                  $fwrite(fp," %d", cloud_tb.cloud.ctrlread.retq_fifo_rdata.data[i]);
          $fwrite(fp,"\n");
      end

      if(cloud_tb.cloud.hcb[0].h.weights_ren) begin
          $fwrite(fp,"weights ");
          if(WRITE_BUS)
              for(int i = 0; i < WEIGHT_BUFFER_SIZE; i++)
                  $fwrite(fp," %d", cloud_tb.cloud.hcb[0].h.weights_rdata[i]);
          $fwrite(fp,"\n");
      end

      if(cloud_tb.cloud.hcb[0].h.extWeights_ren) begin
          $fwrite(fp,"bmweights_ren ");
          if(WRITE_BUS)
              for(int i = 0; i < BM_READ_WIDTH; i++)
                  $fwrite(fp," %d", cloud_tb.cloud.hcb[0].h.extWeights_rdata[i]);
          $fwrite(fp,"\n");
      end

      if(cloud_tb.cloud.hcb[0].h.extWeights_wen) begin
          $fwrite(fp,"bmweights_wen ");
          if(WRITE_BUS)
              for(int i = 0; i < BM_READ_WIDTH; i++)
                  $fwrite(fp," %d", cloud_tb.cloud.hcb[0].h.extWeights_wdata[i]);
          $fwrite(fp,"\n");
      end

      if(cloud_tb.cloud.hcb[0].h.input_fifo_ren) begin
          $fwrite(fp,"features ");
          if(WRITE_BUS)
              for(int i = 0; i < cloud_tb.cloud.hcb[0].h.readWidth; i++)
                  $fwrite(fp," %d", cloud_tb.cloud.hcb[0].h.input_fifo_rdata[i]);
          $fwrite(fp,"\n");
      end
      if(WRITE_BUS) begin
          if(cloud_tb.cloud.hcb[0].h.pwrite_enable) begin
              $fwrite(fp,"outputs bank0 %d", cloud_tb.cloud.hcb[0].h.pwrite_addr);
              if(WRITE_BUS)
                  for(int i = 0; i < cloud_tb.cloud.hcb[0].h.outputBufW1_out; i++)
                      $fwrite(fp," %d", cloud_tb.cloud.hcb[0].h.pwrite_data[i]);
              $fwrite(fp,"\n");
          end
          if(cloud_tb.cloud.hcb[1].h.pwrite_enable) begin
              $fwrite(fp,"outputs bank1 %d", cloud_tb.cloud.hcb[1].h.pwrite_addr);
              if(WRITE_BUS)
                  for(int i = 0; i < cloud_tb.cloud.hcb[1].h.outputBufW1_out; i++)
                      $fwrite(fp," %d", cloud_tb.cloud.hcb[1].h.pwrite_data[i]);
              $fwrite(fp,"\n");
          end
          if(cloud_tb.cloud.hcb[2].h.pwrite_enable) begin
              $fwrite(fp,"outputs bank2 %d", cloud_tb.cloud.hcb[2].h.pwrite_addr);
              if(WRITE_BUS)
                  for(int i = 0; i < cloud_tb.cloud.hcb[2].h.outputBufW1_out; i++)
                      $fwrite(fp," %d", cloud_tb.cloud.hcb[2].h.pwrite_data[i]);
              $fwrite(fp,"\n");
          end
          if(cloud_tb.cloud.hcb[3].h.pwrite_enable) begin
              $fwrite(fp,"outputs bank3 %d", cloud_tb.cloud.hcb[3].h.pwrite_addr);
              if(WRITE_BUS)
                  for(int i = 0; i < cloud_tb.cloud.hcb[3].h.outputBufW1_out; i++)
                      $fwrite(fp," %d", cloud_tb.cloud.hcb[3].h.pwrite_data[i]);
              $fwrite(fp,"\n");
          end

          $fwrite(fp,"wtctrl ddr (%d %d), bv %d, empty %d\n", cloud_tb.cloud.ren_weight
            , cloud_tb.cloud.read_addr_weight, cloud_tb.cloud.pcweight_busValid
            , cloud_tb.cloud.ctrlweight.data_fifo_empty);
          $fwrite(fp,"rctrl ddr (%d %d %d), bv %d %d, idx %d, empty %d\n", cloud_tb.cloud.ren_data1
            , cloud_tb.cloud.read_addr_data1, cloud_tb.cloud.ddr_id
            , cloud_tb.cloud.pread_busValid, cloud_tb.cloud.pread_isFeature
            , cloud_tb.cloud.ctrlread.dataIdx, cloud_tb.cloud.ctrlread.data_fifo_empty);
      end
      $fwrite(fp,"wctrl writable (%d %d %d %d), idx %d, wready %d\n", cloud_tb.cloud.pwrite_isWritable[0]
        , cloud_tb.cloud.pwrite_isWritable[1], cloud_tb.cloud.pwrite_isWritable[2]
        , cloud_tb.cloud.pwrite_isWritable[3], cloud_tb.cloud.ctrlwrite.idx
        , cloud_tb.cloud.ctrlwrite.ddr_write_ready);
      if(WRITE_BUS) begin
          $fwrite(fp,"ddr fifo readfreeze %d, loadHolding %d, info_fifo_empty %d full %d,  fifo_wen %d, fifo_ren %d\n"
            ,cloud_tb.cloud.read_freeze, cloud_tb.cloud.DDR_data.loadHolding
            ,cloud_tb.cloud.DDR_data.info_fifo_empty, cloud_tb.cloud.DDR_data.info_fifo_full
            ,cloud_tb.cloud.DDR_data.info_fifo_wen, cloud_tb.cloud.DDR_data.info_fifo_ren);

          $fwrite(fp,"HCB0 hcbctrl, FDone %d, convInit %d, initWSteps %d, wtotal %d, initFSteps %d, k %d\n"
                , cloud_tb.cloud.hcb[0].h.hcbCtrl.FDone, cloud_tb.cloud.hcb[0].h.hcbCtrl.convInit
                , cloud_tb.cloud.hcb[0].h.hcbCtrl.initWSteps, cloud_tb.cloud.hcb[0].h.hcbCtrl.wtotal
                , cloud_tb.cloud.hcb[0].h.hcbCtrl.initFSteps, cloud_tb.cloud.hcb[0].h.hcbCtrl.k);
          $fwrite(fp,"HCB0 hcbctrl, input_fifo_empty %d, new_conv_inst %d\n"
                , cloud_tb.cloud.hcb[0].h.hcbCtrl.input_fifo_empty
                , cloud_tb.cloud.hcb[0].h.hcbCtrl.new_conv_inst);
          
                $fwrite(fp,"HCB0 out (%d %d), readfeature %d (%d, %d, %d,%d), pread (%d,%d) readweight %d, froze %d, state %d, wempty %d, bmempty %d, fempty (%d %d %d)\n"
                , cloud_tb.cloud.pwrite_enable[0] , cloud_tb.cloud.pwrite_addr[0]
                , cloud_tb.cloud.cb_isReadingFeatures[0], cloud_tb.cloud.hcb[0].h.readFeatures.ibSize
                , cloud_tb.cloud.hcb[0].h.readFeatures.writeWidth, cloud_tb.cloud.hcb[0].h.readFeatures.nextWritePos
                , cloud_tb.cloud.hcb[0].h.volumeSize
                , cloud_tb.cloud.hcb[0].h.readFeatures.pread_busValid, cloud_tb.cloud.hcb[0].h.readFeatures.pread_isFeature
                , cloud_tb.cloud.cb_isReadingWeights[0]
                , cloud_tb.cloud.cb_isLoadingFroze[0], cloud_tb.cloud.hcb[0].h.state
                , cloud_tb.cloud.hcb[0].h.weights_empty, cloud_tb.cloud.hcb[0].h.extWeights_empty
                , cloud_tb.cloud.hcb[0].h.input_fifo_empty, cloud_tb.cloud.hcb[0].h.assemble_buffer_empty
                , cloud_tb.cloud.hcb[0].h.inputs_buffer_empty);

          $fwrite(fp,"HCB1 out (%d %d), readfeature %d (%d,%d), readweight %d, froze %d, state %d, wempty %d, bmempty %d, fempty (%d %d %d)\n"
                , cloud_tb.cloud.pwrite_enable[1] , cloud_tb.cloud.pwrite_addr[1]
                , cloud_tb.cloud.cb_isReadingFeatures[1], cloud_tb.cloud.hcb[1].h.readFeatures.nextWritePos
                , cloud_tb.cloud.hcb[1].h.volumeSize, cloud_tb.cloud.cb_isReadingWeights[1]
                , cloud_tb.cloud.cb_isLoadingFroze[1], cloud_tb.cloud.hcb[1].h.state
                , cloud_tb.cloud.hcb[1].h.weights_empty, cloud_tb.cloud.hcb[1].h.extWeights_empty
                , cloud_tb.cloud.hcb[1].h.input_fifo_empty, cloud_tb.cloud.hcb[1].h.assemble_buffer_empty
                , cloud_tb.cloud.hcb[1].h.inputs_buffer_empty);
      end
      $fwrite(fp,"HCB2 out (%d %d), readfeature %d (%d,%d), readweight %d, froze %d, state %d, wempty %d, bmempty %d, fempty (%d %d %d)\n"
            , cloud_tb.cloud.pwrite_enable[2] , cloud_tb.cloud.pwrite_addr[2]
            , cloud_tb.cloud.cb_isReadingFeatures[2], cloud_tb.cloud.hcb[2].h.readFeatures.nextWritePos
            , cloud_tb.cloud.hcb[2].h.volumeSize, cloud_tb.cloud.cb_isReadingWeights[2]
            , cloud_tb.cloud.cb_isLoadingFroze[2], cloud_tb.cloud.hcb[2].h.state
            , cloud_tb.cloud.hcb[2].h.weights_empty, cloud_tb.cloud.hcb[2].h.extWeights_empty
            , cloud_tb.cloud.hcb[2].h.input_fifo_empty, cloud_tb.cloud.hcb[2].h.assemble_buffer_empty
            , cloud_tb.cloud.hcb[2].h.inputs_buffer_empty);
      if(WRITE_BUS) begin
          $fwrite(fp,"HCB3 out (%d %d), readfeature %d (%d,%d), readweight %d, froze %d, state %d, wempty %d, bmempty %d, fempty (%d %d %d)\n"
                , cloud_tb.cloud.pwrite_enable[3] , cloud_tb.cloud.pwrite_addr[3]
                , cloud_tb.cloud.cb_isReadingFeatures[3], cloud_tb.cloud.hcb[3].h.readFeatures.nextWritePos
                , cloud_tb.cloud.hcb[3].h.volumeSize, cloud_tb.cloud.cb_isReadingWeights[3]
                , cloud_tb.cloud.cb_isLoadingFroze[3], cloud_tb.cloud.hcb[3].h.state
                , cloud_tb.cloud.hcb[3].h.weights_empty, cloud_tb.cloud.hcb[3].h.extWeights_empty
                , cloud_tb.cloud.hcb[3].h.input_fifo_empty, cloud_tb.cloud.hcb[3].h.assemble_buffer_empty
                , cloud_tb.cloud.hcb[3].h.inputs_buffer_empty);
      end
  end
  endtask

  task check_fifos();
  begin
      assert(!(cloud_tb.cloud.hcb[0].h.extWeights_wen && cloud_tb.cloud.hcb[0].h.extWeights_full));
      assert(!(cloud_tb.cloud.hcb[0].h.weights_wen && cloud_tb.cloud.hcb[0].h.weights_full));
      assert(!(cloud_tb.cloud.hcb[0].h.resBuf_wen && cloud_tb.cloud.hcb[0].h.resBuf_full));
      assert(!(cloud_tb.cloud.hcb[0].h.inst_fifo_wen && cloud_tb.cloud.hcb[0].h.instfifo_full));
      assert(!(cloud_tb.cloud.hcb[0].h.inputs_buffer_wen && cloud_tb.cloud.hcb[0].h.inputs_buffer_full));
      assert(!(cloud_tb.cloud.hcb[0].h.assemble_buffer_wen && cloud_tb.cloud.hcb[0].h.assemble_buffer_full));
      assert(!(cloud_tb.cloud.hcb[1].h.extWeights_wen && cloud_tb.cloud.hcb[1].h.extWeights_full));
      assert(!(cloud_tb.cloud.hcb[1].h.weights_wen && cloud_tb.cloud.hcb[1].h.weights_full));
      assert(!(cloud_tb.cloud.hcb[1].h.resBuf_wen && cloud_tb.cloud.hcb[1].h.resBuf_full));
      assert(!(cloud_tb.cloud.hcb[1].h.inst_fifo_wen && cloud_tb.cloud.hcb[1].h.instfifo_full));
      assert(!(cloud_tb.cloud.hcb[1].h.inputs_buffer_wen && cloud_tb.cloud.hcb[1].h.inputs_buffer_full));
      assert(!(cloud_tb.cloud.hcb[1].h.assemble_buffer_wen && cloud_tb.cloud.hcb[1].h.assemble_buffer_full));
      assert(!(cloud_tb.cloud.hcb[2].h.extWeights_wen && cloud_tb.cloud.hcb[2].h.extWeights_full));
      assert(!(cloud_tb.cloud.hcb[2].h.weights_wen && cloud_tb.cloud.hcb[2].h.weights_full));
      assert(!(cloud_tb.cloud.hcb[2].h.resBuf_wen && cloud_tb.cloud.hcb[2].h.resBuf_full));
      assert(!(cloud_tb.cloud.hcb[2].h.inst_fifo_wen && cloud_tb.cloud.hcb[2].h.instfifo_full));
      assert(!(cloud_tb.cloud.hcb[2].h.inputs_buffer_wen && cloud_tb.cloud.hcb[2].h.inputs_buffer_full));
      assert(!(cloud_tb.cloud.hcb[2].h.assemble_buffer_wen && cloud_tb.cloud.hcb[2].h.assemble_buffer_full));
      assert(!(cloud_tb.cloud.hcb[3].h.extWeights_wen && cloud_tb.cloud.hcb[3].h.extWeights_full));
      assert(!(cloud_tb.cloud.hcb[3].h.weights_wen && cloud_tb.cloud.hcb[3].h.weights_full));
      assert(!(cloud_tb.cloud.hcb[3].h.resBuf_wen && cloud_tb.cloud.hcb[3].h.resBuf_full));
      assert(!(cloud_tb.cloud.hcb[3].h.inst_fifo_wen && cloud_tb.cloud.hcb[3].h.instfifo_full));
      assert(!(cloud_tb.cloud.hcb[3].h.inputs_buffer_wen && cloud_tb.cloud.hcb[3].h.inputs_buffer_full));
      assert(!(cloud_tb.cloud.hcb[3].h.assemble_buffer_wen && cloud_tb.cloud.hcb[3].h.assemble_buffer_full));

      assert(!(cloud_tb.cloud.addrbuf_enable && cloud_tb.cloud.addressBuffer_full));

      assert(!(cloud_tb.cloud.weight_read_assist.info_fifo_wen && cloud_tb.cloud.weight_read_assist.info_fifo_full));
      assert(!(cloud_tb.cloud.DDR_weight.info_fifo_wen && cloud_tb.cloud.DDR_weight.info_fifo_full));
      assert(!(cloud_tb.cloud.data_read_assist.info_fifo_wen && cloud_tb.cloud.data_read_assist.info_fifo_full));
      assert(!(cloud_tb.cloud.data_write_assist.info_fifo_wen && cloud_tb.cloud.data_write_assist.info_fifo_full));
      assert(!(cloud_tb.cloud.DDR_data.info_fifo_wen && cloud_tb.cloud.DDR_data.info_fifo_full));

      assert(!(cloud_tb.cloud.ctrlread.readData.input_data_fifo_wen && cloud_tb.cloud.ctrlread.readData.input_data_fifo_full));
      assert(!(cloud_tb.cloud.ctrlread.data_fifo_wen && cloud_tb.cloud.ctrlread.data_fifo_full));
      assert(!(cloud_tb.cloud.ctrlread.reqq_fifo_wen && cloud_tb.cloud.ctrlread.reqq_fifo_full));
      assert(!(cloud_tb.cloud.ctrlread.retq_fifo_wen && cloud_tb.cloud.ctrlread.retq_fifo_full));
      assert(!(cloud_tb.cloud.ctrlread.crinst_enable && cloud_tb.cloud.ctrlread.inst_fifo_full));
      assert(!(cloud_tb.cloud.ctrlwrite.cwinst_enable && cloud_tb.cloud.ctrlwrite.inst_fifo_full));
      assert(!(cloud_tb.cloud.ctrlwrite.addr_fifo_wen[0] && cloud_tb.cloud.ctrlwrite.addr_fifo_full[0]));
      assert(!(cloud_tb.cloud.ctrlwrite.data_fifo_wen[0] && cloud_tb.cloud.ctrlwrite.data_fifo_full[0]));
      assert(!(cloud_tb.cloud.ctrlwrite.addr_fifo_wen[1] && cloud_tb.cloud.ctrlwrite.addr_fifo_full[1]));
      assert(!(cloud_tb.cloud.ctrlwrite.data_fifo_wen[1] && cloud_tb.cloud.ctrlwrite.data_fifo_full[1]));
      assert(!(cloud_tb.cloud.ctrlwrite.addr_fifo_wen[2] && cloud_tb.cloud.ctrlwrite.addr_fifo_full[2]));
      assert(!(cloud_tb.cloud.ctrlwrite.data_fifo_wen[2] && cloud_tb.cloud.ctrlwrite.data_fifo_full[2]));
      assert(!(cloud_tb.cloud.ctrlwrite.addr_fifo_wen[3] && cloud_tb.cloud.ctrlwrite.addr_fifo_full[3]));
      assert(!(cloud_tb.cloud.ctrlwrite.data_fifo_wen[3] && cloud_tb.cloud.ctrlwrite.data_fifo_full[3]));


      assert(!(cloud_tb.cloud.ctrlweight.data_fifo_wen && cloud_tb.cloud.ctrlweight.data_fifo_full));
      assert(!(cloud_tb.cloud.ctrlweight.cwinst_enable && cloud_tb.cloud.ctrlweight.inst_fifo_full));
      assert(!(cloud_tb.cloud.gib.inst_fifo_wen && cloud_tb.cloud.gib.inst_fifo_full));
      assert(!(cloud_tb.cloud.iftest.data_fifo_wen && cloud_tb.cloud.iftest.data_fifo_full));
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

  task reset();
  begin
    ports.resetN= 1'b0;
    $fwrite(fp,"%dns : asserting reset\n",$time);
    for(int i = 0; i < 5; i++) begin
       @ (posedge ports.clock);
       $fwrite(fp,"%dns :waiting clk\n",$time);
    end
    #2 ports.resetN= 1'b1;
    $fwrite(fp,"%dns : Done asserting reset\n",$time);
  end
  endtask

  task gen_input();
  begin
    while (1) begin
       @ (posedge ports.clock);
       if(ports.resetN == 1'b0)
	       continue;
       assign_inputs();
       $fwrite(fp,"%dns : inputs\n", $time);
    end
  end
  endtask

  task cmp_output();
  begin
    while (1) begin
      @ (posedge out_clock);
       //@ cloud_ports.cb
       if(ports.resetN == 1'b0)
	       continue;
        cmp_outputs();
        cmp_mem_writes();
        write_ddr();
        if($time > 800) begin
            write_stats();
            check_fifos();
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
