`ifndef CLOUD_PORTS_SV
`define CLOUD_PORTS_SV

`timescale 1ns / 1ns
interface cloud_ports 
import definitions_pkg::*;
(
input logic clock, 
input logic resetN,
input logic init_calib_complete,
input logic [3:0]   rgmii_txd,
input logic         rgmii_txctl,
input logic         rgmii_txc,
input  logic        rgmii_rxc,
input logic         arp_request,
output logic[3:0]   rgmii_rxd,
output logic        rgmii_rxctl
);
endinterface



`endif
