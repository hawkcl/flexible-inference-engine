module test
(
input logic [20:0]a, 
input logic [20:0]b, 
input logic unsigned [4:0] x,
output logic [20:0]c
);
// c = {b, a} >> x
always_comb
	for(int i = 0; i < 20; i++)
		if(i + x < 20)
			c[i] = a[i + x];
		else
			c[i] = b[i + x - 20];	
endmodule