`timescale 1ns / 1ns
import definitions_pkg::*;

class axi_driver;
  parameter WRITE_BUS = 1;
  parameter DELAY_CYCLES = 20;

  virtual axi_ports ports;
  logic out_ui_clk;
  int ffi, fwi, fii, ffro, ffwo, fwro, fio;
  int fp;
  int status;
  int data;
  int fdone, wdone, idone;
  logic   [DDR_DATA_WIDTH-1:0] data8;
  int equal;
  int addr, len, num;
  int addr_save, len_save, num_save;
  logic   [DDR_DATA_WIDTH-1:0]    data_saved[DDR_LEN_SIZE];
  logic [DDR_ADDR_WIDTH-1:0]   output_address;
  logic [DDR_ADDR_WIDTH-1:0]   output_size;
  logic [7:0]  byte_data;
  logic [DDR_DATAWIDTH*8 - 1:0]    tmp_rdata;
  logic [DDR_DATAWIDTH*8 - 1:0]    tmp_idata;
  logic [DDR_DATAWIDTH*8 - 1:0]    tmp_wdata;
  logic [DDR_DATAWIDTH*8 - 1:0]    tmp_wrdata;
  int fiter, witer, iter;
  int vrd, vwt;
  int rid, raddr, rlen;
  int iiter, iaddr, ilast;
  int wraddr, strob;
  int fcycles[int];
  int icycles[int];
  int wcycles[int];
  int init;
  int wlast, flast;
  int waddr, faddr;
  int i;
  int unsigned inst_addr;


  function new (virtual axi_ports ports);
  begin
    this.ports = ports;
    out_ui_clk = 0;
    ffi = $fopen("d:/aidata/axi_feature_input.txt","r");
    fwi = $fopen("d:/aidata/axi_weight_input.txt","r");
    fii = $fopen("d:/aidata/axi_inst_input.txt","r");
    ffro = $fopen("d:/aidata/axi_feature_read_output.txt","r");
    ffwo = $fopen("d:/aidata/axi_feature_write_output.txt","r");
    fwro = $fopen("d:/aidata/axi_weight_read_output.txt","r");
    fio = $fopen("d:/aidata/axi_inst_read_output.txt","r");
    fp = $fopen("d:/aidata/axi_tb_output.txt","w");
    fiter = 0;
    witer = 0;
    fdone = 0;
    wdone = 0;
    idone = 0;
    init = 1;
  end
  endfunction

  task read_next_feature();
  begin
    status = $fscanf(ffi, "%d %d %d", fiter ,faddr, flast); 
    if(status != 3) begin
        $fwrite(fp,"End of input\n");
        fdone = 1;
        return;
    end
    status = $fscanf(ffi, "%d" ,byte_data); 
    if(status != 1) begin
        fdone = 1;
    end
    tmp_rdata[7 : 0] = byte_data;

    status = $fscanf(ffi, "%d" ,byte_data); 
    if(status != 1) begin
        fdone = 1;
    end
    tmp_rdata[15 : 8] = byte_data;

    status = $fscanf(ffi, "%d" ,byte_data); 
    if(status != 1) begin
        fdone = 1;
    end
    tmp_rdata[23 : 16] = byte_data;

    status = $fscanf(ffi, "%d" ,byte_data); 
    if(status != 1) begin
        fdone = 1;
    end
    tmp_rdata[31 : 24] = byte_data;

    status = $fscanf(ffi, "%d" ,byte_data); 
    if(status != 1) begin
        fdone = 1;
    end
    tmp_rdata[39 : 32] = byte_data;

    status = $fscanf(ffi, "%d" ,byte_data); 
    if(status != 1) begin
        fdone = 1;
    end
    tmp_rdata[47 : 40] = byte_data;

    status = $fscanf(ffi, "%d" ,byte_data); 
    if(status != 1) begin
        fdone = 1;
    end
    tmp_rdata[55 : 48] = byte_data;

    status = $fscanf(ffi, "%d" ,byte_data); 
    if(status != 1) begin
        fdone = 1;
    end
    tmp_rdata[63 : 56] = byte_data;
  end
  endtask

  task read_next_instruction();
  begin
    status = $fscanf(fii, "%d %d %d", iiter ,iaddr, ilast); 
    if(status != 3) begin
        $fwrite(fp,"End of input\n");
        idone = 1;
        return;
    end
    status = $fscanf(fii, "%d" ,byte_data); 
    if(status != 1) begin
        idone = 1;
    end
    tmp_idata[7 : 0] = byte_data;

    status = $fscanf(fii, "%d" ,byte_data); 
    if(status != 1) begin
        idone = 1;
    end
    tmp_idata[15 : 8] = byte_data;

    status = $fscanf(fii, "%d" ,byte_data); 
    if(status != 1) begin
        idone = 1;
    end
    tmp_idata[23 : 16] = byte_data;

    status = $fscanf(fii, "%d" ,byte_data); 
    if(status != 1) begin
        idone = 1;
    end
    tmp_idata[31 : 24] = byte_data;

    status = $fscanf(fii, "%d" ,byte_data); 
    if(status != 1) begin
        idone = 1;
    end
    tmp_idata[39 : 32] = byte_data;

    status = $fscanf(fii, "%d" ,byte_data); 
    if(status != 1) begin
        idone = 1;
    end
    tmp_idata[47 : 40] = byte_data;

    status = $fscanf(fii, "%d" ,byte_data); 
    if(status != 1) begin
        idone = 1;
    end
    tmp_idata[55 : 48] = byte_data;

    status = $fscanf(fii, "%d" ,byte_data); 
    if(status != 1) begin
        idone = 1;
    end
    tmp_idata[63 : 56] = byte_data;
  end
  endtask

  task read_next_weight();
  begin
    status = $fscanf(fwi, "%d %d %d", witer ,waddr, wlast); 
    if(status != 3) begin
        $fwrite(fp,"End of winput\n");
        wdone = 1;
        return;
    end
    status = $fscanf(fwi, "%d" ,byte_data); 
    if(status != 1) begin
        wdone = 1;
    end
    tmp_wdata[7 : 0] = byte_data;

    status = $fscanf(fwi, "%d" ,byte_data); 
    if(status != 1) begin
        wdone = 1;
    end
    tmp_wdata[15 : 8] = byte_data;

    status = $fscanf(fwi, "%d" ,byte_data); 
    if(status != 1) begin
        wdone = 1;
    end
    tmp_wdata[23 : 16] = byte_data;

    status = $fscanf(fwi, "%d" ,byte_data); 
    if(status != 1) begin
        wdone = 1;
    end
    tmp_wdata[31 : 24] = byte_data;

    status = $fscanf(fwi, "%d" ,byte_data); 
    if(status != 1) begin
        wdone = 1;
    end
    tmp_wdata[39 : 32] = byte_data;

    status = $fscanf(fwi, "%d" ,byte_data); 
    if(status != 1) begin
        wdone = 1;
    end
    tmp_wdata[47 : 40] = byte_data;

    status = $fscanf(fwi, "%d" ,byte_data); 
    if(status != 1) begin
        wdone = 1;
    end
    tmp_wdata[55 : 48] = byte_data;

    status = $fscanf(fwi, "%d" ,byte_data); 
    if(status != 1) begin
        wdone = 1;
    end
    tmp_wdata[63 : 56] = byte_data;
  end
  endtask

  task assign_inputs();
  begin
        ports.s_axi0_awready = 1;
        ports.s_axi0_wready = 1;
        ports.s_axi0_bresp = 0;
        ports.s_axi0_bvalid = 0;
        ports.s_axi0_arready = 1;
        ports.s_axi0_rresp = 0;
        ports.ps_axi_awready = 1;
        ports.ps_axi_wready = 1;
        ports.ps_axi_bresp = 0;
        ports.ps_axi_bvalid = 0;
        ports.ps_axi_arready = 1;
        ports.ps_axi_rresp = 0;

          if(init) begin
            status = $fscanf(ffi, "%d" ,inst_addr); 
            if(status != 1) begin
                $fwrite(fp,"End of input\n");
                return;
            end
            ports.addrbuf_enable = 1;
            ports.inst_address = inst_addr;
            ports.s_axi0_rvalid  = 0;
            ports.s_axi0_rdata= '0;
            ports.s_axi0_rlast = 0;
            ports.ps_axi_rvalid  = 0;
            ports.ps_axi_rdata = '0;
            ports.ps_axi_rlast = 0;
            init = 0;
            read_next_feature();
            read_next_weight();
            read_next_instruction();
            return;
          end

        ports.addrbuf_enable = 0;
        ports.inst_address = 0;


        // instruction and feature send order matters, they share the same buffer in read assist
        if((~idone) && icycles.exists(iaddr) && (icycles[iaddr] >= DELAY_CYCLES)) begin
            $fwrite(fp,"send input %d : %x\n", iaddr, tmp_idata);
            ports.s_axi0_rvalid  = 1;
            ports.s_axi0_rdata= tmp_idata;
            ports.s_axi0_rlast = ilast;
            if(ilast)
                icycles.delete(iaddr);
            read_next_instruction();
        end
        else if((~fdone) && fcycles.exists(faddr) && (fcycles[faddr] >= DELAY_CYCLES)) begin
            $fwrite(fp,"send feature %d : %x\n", faddr, tmp_rdata);
            ports.s_axi0_rvalid  = 1;
            ports.s_axi0_rdata= tmp_rdata;
            ports.s_axi0_rlast = flast;
            if(flast)
                fcycles.delete(faddr);
            read_next_feature();
        end
        else begin
            ports.s_axi0_rvalid  = 0;
            ports.s_axi0_rdata= '0;
            ports.s_axi0_rlast = 0;
        end

        if((~wdone) && wcycles.exists(waddr) && (wcycles[waddr] >= DELAY_CYCLES)) begin
            $fwrite(fp,"send weight %d : %x\n", waddr, tmp_wdata);
            ports.ps_axi_rvalid  = 1;
            ports.ps_axi_rdata= tmp_wdata;
            ports.ps_axi_rlast = wlast;
            if(wlast)
                wcycles.delete(waddr);
            read_next_weight();
        end
        else begin
            ports.ps_axi_rvalid  = 0;
            ports.ps_axi_rdata = '0;
            ports.ps_axi_rlast = 0;
        end
        foreach(icycles[i])
            icycles[i] = icycles[i] + 1;
        foreach(fcycles[i])
            fcycles[i] = fcycles[i] + 1;
        foreach(wcycles[i])
            wcycles[i] = wcycles[i] + 1;

/*
        status = $fscanf(fin, "%d %d %d" ,wrdy, rrdy, dv); 
        if(status != 3) begin
            $fwrite(fp,"Error : No rdy data for daxi iter %d (status %d)\n", iter, status);
            return;
        end
        ports.s_axi0_rvalid  = dv;
        if(dv) begin
                status = $fscanf(fin, "%d" ,byte_data); 
                if(status != 1) begin
                    $fwrite(fp,"Error : No data for daxi iter %d (status %d, i 0)\n", iter, status);
                    return;
                end
                tmp_rdata[7 : 0] = byte_data;

                status = $fscanf(fin, "%d" ,byte_data); 
                if(status != 1) begin
                    $fwrite(fp,"Error : No data for daxi iter %d (status %d, i 1)\n", iter, status);
                    return;
                end
                tmp_rdata[15 : 8] = byte_data;

                status = $fscanf(fin, "%d" ,byte_data); 
                if(status != 1) begin
                    $fwrite(fp,"Error : No data for daxi iter %d (status %d, i 2)\n", iter, status);
                    return;
                end
                tmp_rdata[23 : 16] = byte_data;

                status = $fscanf(fin, "%d" ,byte_data); 
                if(status != 1) begin
                    $fwrite(fp,"Error : No data for daxi iter %d (status %d, i 3)\n", iter, status);
                    return;
                end
                tmp_rdata[31 : 24] = byte_data;

                status = $fscanf(fin, "%d" ,byte_data); 
                if(status != 1) begin
                    $fwrite(fp,"Error : No data for daxi iter %d (status %d, i 4)\n", iter, status);
                    return;
                end
                tmp_rdata[39 : 32] = byte_data;

                status = $fscanf(fin, "%d" ,byte_data); 
                if(status != 1) begin
                    $fwrite(fp,"Error : No data for daxi iter %d (status %d, i 5)\n", iter, status);
                    return;
                end
                tmp_rdata[47 : 40] = byte_data;

                status = $fscanf(fin, "%d" ,byte_data); 
                if(status != 1) begin
                    $fwrite(fp,"Error : No data for daxi iter %d (status %d, i 6)\n", iter, status);
                    return;
                end
                tmp_rdata[55 : 48] = byte_data;

                status = $fscanf(fin, "%d" ,byte_data); 
                if(status != 1) begin
                    $fwrite(fp,"Error : No data for daxi iter %d (status %d, i 7)\n", iter, status);
                    return;
                end
                tmp_rdata[63 : 56] = byte_data;

            ports.s_axi0_rdata= tmp_rdata;
            status = $fscanf(fin, "%d" ,data); 
            if(status != 1) begin
                $fwrite(fp,"Error : No last data for daxi iter %d (status %d)\n", iter, status);
                return;
            end
            ports.s_axi0_rlast = data;
        end
        else begin
            //for(int i = 0; i < DDR_DATAWIDTH; i++) begin
            //    ports.s_axi0_rdata[i*8 + 7 : 8*i] = 0;
            //end
            ports.s_axi0_rdata= '0;
            ports.s_axi0_rlast = 0;
        end

        status = $fscanf(fin, "%d %d %d" ,wrdy, rrdy, dv); 
        if(status != 3) begin
            $fwrite(fp,"Error : No rdy data for waxi iter %d (status %d)\n", iter, status);
            return;
        end
        ports.ps_axi_awready = wrdy;
        ports.ps_axi_wready = wrdy;
        ports.ps_axi_bresp = 0;
        ports.ps_axi_bvalid = 0;
        ports.ps_axi_arready = rrdy;
        ports.ps_axi_rvalid  = dv;
        ports.ps_axi_rresp = 0;
        if(dv) begin
                status = $fscanf(fin, "%d" ,byte_data); 
                if(status != 1) begin
                    $fwrite(fp,"Error : No data for waxi iter %d (status %d, i 0)\n", iter, status);
                    return;
                end
                tmp_rdata[7 : 0] = byte_data;

                status = $fscanf(fin, "%d" ,byte_data); 
                if(status != 1) begin
                    $fwrite(fp,"Error : No data for waxi iter %d (status %d, i 1)\n", iter, status);
                    return;
                end
                tmp_rdata[15 : 8] = byte_data;

                status = $fscanf(fin, "%d" ,byte_data); 
                if(status != 1) begin
                    $fwrite(fp,"Error : No data for waxi iter %d (status %d, i 2)\n", iter, status);
                    return;
                end
                tmp_rdata[23 : 16] = byte_data;

                status = $fscanf(fin, "%d" ,byte_data); 
                if(status != 1) begin
                    $fwrite(fp,"Error : No data for waxi iter %d (status %d, i 3)\n", iter, status);
                    return;
                end
                tmp_rdata[31 : 24] = byte_data;

                status = $fscanf(fin, "%d" ,byte_data); 
                if(status != 1) begin
                    $fwrite(fp,"Error : No data for waxi iter %d (status %d, i 4)\n", iter, status);
                    return;
                end
                tmp_rdata[39 : 32] = byte_data;

                status = $fscanf(fin, "%d" ,byte_data); 
                if(status != 1) begin
                    $fwrite(fp,"Error : No data for waxi iter %d (status %d, i 5)\n", iter, status);
                    return;
                end
                tmp_rdata[47 : 40] = byte_data;

                status = $fscanf(fin, "%d" ,byte_data); 
                if(status != 1) begin
                    $fwrite(fp,"Error : No data for waxi iter %d (status %d, i 6)\n", iter, status);
                    return;
                end
                tmp_rdata[55 : 48] = byte_data;

                status = $fscanf(fin, "%d" ,byte_data); 
                if(status != 1) begin
                    $fwrite(fp,"Error : No data for waxi iter %d (status %d, i 7)\n", iter, status);
                    return;
                end
                tmp_rdata[63 : 56] = byte_data;

            ports.ps_axi_rdata = tmp_rdata;
            status = $fscanf(fin, "%d" ,data); 
            if(status != 1) begin
                $fwrite(fp,"Error : No last data for waxi iter %d (status %d)\n", iter, status);
                return;
            end
            ports.ps_axi_rlast = data;
        end
        else begin
            //for(int i = 0; i < DDR_DATAWIDTH; i++) begin
            //    ports.ps_axi_rdata[i*8 + 7 : 8*i] = 0;
            //end
            ports.ps_axi_rdata = '0;
            ports.ps_axi_rlast = 0;
        end
*/
  end
  endtask

  task cmp_outputs();
  begin
    if(ports.s_axi0_arvalid) begin
        if(ports.s_axi0_araddr >= inst_addr) begin
            status = $fscanf(fio, "%d %d %d %d", iter, rid, raddr, rlen);
            if(status != 4) begin
                $fwrite(fp,"Error fio: No inst for fio\n");
            end
        end
        else begin
            status = $fscanf(ffro, "%d %d %d %d", iter, rid, raddr, rlen);
            if(status != 4) begin
                $fwrite(fp,"Error ffro: No data for ffro\n");
            end
        end
        if(rid != ports.s_axi0_arid)
            $fwrite(fp,"Error %d: drid rid %d, ar_rid %d\n", iter, rid, ports.s_axi0_arid);
        if(raddr != ports.s_axi0_araddr)
            $fwrite(fp,"Error %d: draddr addr %d, ar_raddr %d\n", iter, raddr, ports.s_axi0_araddr);
        if(rlen != ports.s_axi0_arlen)
            $fwrite(fp,"Error %d : dlen rilen %d, ar_len %d\n", iter, rlen, ports.s_axi0_arlen);
        if(ports.s_axi0_araddr >= inst_addr) begin
            if(icycles.exists(ports.s_axi0_araddr)) begin
                $fwrite(fp,"Error inst read addr %d existed. iter %d\n", ports.s_axi0_araddr, iter);
            end
            else
                icycles[ports.s_axi0_araddr] = 1;
            $fwrite(fp,"ask inst read addr %d. iter %d\n", ports.s_axi0_araddr, iter);
        end
        else begin
            if(fcycles.exists(ports.s_axi0_araddr)) begin
                $fwrite(fp,"Error data read addr %d existed. iter %d\n", ports.s_axi0_araddr, iter);
            end
            else
                fcycles[ports.s_axi0_araddr] = 1;
            $fwrite(fp,"ask data read addr %d. iter %d\n", ports.s_axi0_araddr, iter);
        end
    end
    if(ports.ps_axi_arvalid) begin
        status = $fscanf(fwro, "%d %d %d %d", iter, rid, raddr, rlen);
        if(status != 4) begin
            $fwrite(fp,"Error fwro: No data for fwro\n");
        end
        //if(rid != ports.ps_axi_arid)
        //    $fwrite(fp,"Error %d: wrid rid %d, ar_rid %d\n", iter, rid, ports.ps_axi_arid);
        if(raddr != ports.ps_axi_araddr)
            $fwrite(fp,"Error %d: wraddr addr %d, ar_raddr %d\n", iter, raddr, ports.ps_axi_araddr);
        if(rlen != ports.ps_axi_arlen)
            $fwrite(fp,"Error %d : wlen rilen %d, ar_len %d\n", iter, rlen, ports.ps_axi_arlen);
        if(wcycles.exists(ports.ps_axi_araddr)) begin
            $fwrite(fp,"Error weight read addr %d existed. iter %d\n", ports.ps_axi_araddr, iter);
        end
        else
            wcycles[ports.ps_axi_araddr] = 1;
        $fwrite(fp,"ask weight read addr %d. iter %d\n", ports.ps_axi_araddr, iter);
    end
    if(ports.s_axi0_awvalid) begin
        status = $fscanf(ffwo, "%d %d %d", iter, wraddr, strob);
        if(status != 3) begin
            $fwrite(fp,"Error ffwo: No data for ffwo\n");
        end
        status = $fscanf(ffwo, "%d", byte_data);
        tmp_wrdata[7 : 0] = byte_data;
        status = $fscanf(ffwo, "%d", byte_data);
        tmp_wrdata[15 : 8] = byte_data;
        status = $fscanf(ffwo, "%d", byte_data);
        tmp_wrdata[23 : 16] = byte_data;
        status = $fscanf(ffwo, "%d", byte_data);
        tmp_wrdata[31 : 24] = byte_data;
        status = $fscanf(ffwo, "%d", byte_data);
        tmp_wrdata[39 : 32] = byte_data;
        status = $fscanf(ffwo, "%d", byte_data);
        tmp_wrdata[47 : 40] = byte_data;
        status = $fscanf(ffwo, "%d", byte_data);
        tmp_wrdata[55 : 48] = byte_data;
        status = $fscanf(ffwo, "%d", byte_data);
        tmp_wrdata[63 : 56] = byte_data;
        if(wraddr != ports.s_axi0_awaddr)
            $fwrite(fp," %d: dwaddr addr %d, aw_waddr %d\n", iter, wraddr, ports.s_axi0_awaddr);
        if(strob != ports.s_axi0_wstrb)
            $fwrite(fp," %d: strobe strob %d, aw_strob %d\n", iter, strob, ports.s_axi0_wstrb);
        if(tmp_wrdata != ports.s_axi0_wdata)
            $fwrite(fp," %d: dwrite data %x, w_data %x\n", iter, tmp_wrdata, ports.s_axi0_wdata);
    end

//output

    if(ports.add_output)
        $fwrite(fp, "add_output : %d %d\n", ports.add_output_address, ports.add_output_size);
    $fwrite(fp, "%d : %d %d", iter, ports.s_axi0_arvalid, ports.s_axi0_awvalid);
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

    $fwrite(fp, "%d : %d %d", iter, ports.s_axi0_awvalid, ports.s_axi0_arvalid);
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
      if(fdone && wdone && idone)
           break;
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
       if(ports.aresetn == 1'b0)
	       continue;
       assign_inputs();
       if(fdone && wdone && idone)
           break;
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
        write_ddr();
        write_stats();
       check_fifos();
       if(fdone && wdone && idone)
           break;
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
