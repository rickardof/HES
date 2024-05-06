module AES_cipher (
    input wire clk,
    input wire reset_n,
    input wire valid_in,
    input wire new_message,
    input wire [7:0] key,
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    output reg valid_out, 
	output reg [7:0] counter_block //just for testing purposes
);
//internal signals
    //reg [7:0] counter_block;
    reg [7:0] s_box_out;
    reg [7:0] s_box_input;

    // AES Inverse S-box Lookup Table
    reg [7:0] aes_inv_sbox [0:255];
	
	 initial begin
	  // Row 0
    aes_inv_sbox[0]  = 8'h52; aes_inv_sbox[1]  = 8'h09; aes_inv_sbox[2]  = 8'h6a; aes_inv_sbox[3]  = 8'hd5;
    aes_inv_sbox[4]  = 8'h30; aes_inv_sbox[5]  = 8'h36; aes_inv_sbox[6]  = 8'ha5; aes_inv_sbox[7]  = 8'h38;
    aes_inv_sbox[8]  = 8'hbf; aes_inv_sbox[9]  = 8'h40; aes_inv_sbox[10] = 8'ha3; aes_inv_sbox[11] = 8'h9e;
    aes_inv_sbox[12] = 8'h81; aes_inv_sbox[13] = 8'hf3; aes_inv_sbox[14] = 8'hd7; aes_inv_sbox[15] = 8'hfb;
    aes_inv_sbox[16] = 8'h7c; aes_inv_sbox[17] = 8'he3; aes_inv_sbox[18] = 8'h39; aes_inv_sbox[19] = 8'h82;
    aes_inv_sbox[20] = 8'h9b; aes_inv_sbox[21] = 8'h2f; aes_inv_sbox[22] = 8'hff; aes_inv_sbox[23] = 8'h87;
    aes_inv_sbox[24] = 8'h34; aes_inv_sbox[25] = 8'h8e; aes_inv_sbox[26] = 8'h43; aes_inv_sbox[27] = 8'h44;
    aes_inv_sbox[28] = 8'hc4; aes_inv_sbox[29] = 8'hde; aes_inv_sbox[30] = 8'he9; aes_inv_sbox[31] = 8'hcb;
    aes_inv_sbox[32] = 8'h54; aes_inv_sbox[33] = 8'h7b; aes_inv_sbox[34] = 8'h94; aes_inv_sbox[35] = 8'h32;
    aes_inv_sbox[36] = 8'ha6; aes_inv_sbox[37] = 8'hc2; aes_inv_sbox[38] = 8'h23; aes_inv_sbox[39] = 8'h3d;
    aes_inv_sbox[40] = 8'hee; aes_inv_sbox[41] = 8'h4c; aes_inv_sbox[42] = 8'h95; aes_inv_sbox[43] = 8'h0b;
    aes_inv_sbox[44] = 8'h42; aes_inv_sbox[45] = 8'hfa; aes_inv_sbox[46] = 8'hc3; aes_inv_sbox[47] = 8'h4e;
    aes_inv_sbox[48] = 8'h08; aes_inv_sbox[49] = 8'h2e; aes_inv_sbox[50] = 8'ha1; aes_inv_sbox[51] = 8'h66;
    aes_inv_sbox[52] = 8'h28; aes_inv_sbox[53] = 8'hd9; aes_inv_sbox[54] = 8'h24; aes_inv_sbox[55] = 8'hb2;
    aes_inv_sbox[56] = 8'h76; aes_inv_sbox[57] = 8'h5b; aes_inv_sbox[58] = 8'ha2; aes_inv_sbox[59] = 8'h49;
    aes_inv_sbox[60] = 8'h6d; aes_inv_sbox[61] = 8'h8b; aes_inv_sbox[62] = 8'hd1; aes_inv_sbox[63] = 8'h25;
    aes_inv_sbox[64]  = 8'h72; aes_inv_sbox[65]  = 8'hf8; aes_inv_sbox[66]  = 8'hf6; aes_inv_sbox[67]  = 8'h64;
    aes_inv_sbox[68]  = 8'h86; aes_inv_sbox[69]  = 8'h68; aes_inv_sbox[70]  = 8'h98; aes_inv_sbox[71]  = 8'h16;
    aes_inv_sbox[72]  = 8'hd4; aes_inv_sbox[73]  = 8'ha4; aes_inv_sbox[74]  = 8'h5c; aes_inv_sbox[75]  = 8'hcc;
    aes_inv_sbox[76]  = 8'h5d; aes_inv_sbox[77]  = 8'h65; aes_inv_sbox[78]  = 8'hb6; aes_inv_sbox[79]  = 8'h92;
    aes_inv_sbox[80]  = 8'h6c; aes_inv_sbox[81]  = 8'h70; aes_inv_sbox[82]  = 8'h48; aes_inv_sbox[83]  = 8'h50;
    aes_inv_sbox[84]  = 8'hfd; aes_inv_sbox[85]  = 8'hed; aes_inv_sbox[86]  = 8'hb9; aes_inv_sbox[87]  = 8'hda;
    aes_inv_sbox[88]  = 8'h5e; aes_inv_sbox[89]  = 8'h15; aes_inv_sbox[90]  = 8'h46; aes_inv_sbox[91]  = 8'h57;
    aes_inv_sbox[92]  = 8'ha7; aes_inv_sbox[93]  = 8'h8d; aes_inv_sbox[94]  = 8'h9d; aes_inv_sbox[95]  = 8'h84;
    aes_inv_sbox[96]  = 8'h90; aes_inv_sbox[97]  = 8'hd8; aes_inv_sbox[98]  = 8'hab; aes_inv_sbox[99]  = 8'h00;
    aes_inv_sbox[100] = 8'h8c; aes_inv_sbox[101] = 8'hbc; aes_inv_sbox[102] = 8'hd3; aes_inv_sbox[103] = 8'h0a;
    aes_inv_sbox[104] = 8'hf7; aes_inv_sbox[105] = 8'he4; aes_inv_sbox[106] = 8'h58; aes_inv_sbox[107] = 8'h05;
    aes_inv_sbox[108] = 8'hb8; aes_inv_sbox[109] = 8'hb3; aes_inv_sbox[110] = 8'h45; aes_inv_sbox[111] = 8'hd3;
    aes_inv_sbox[112] = 8'hd0; aes_inv_sbox[113] = 8'h2c; aes_inv_sbox[114] = 8'h1e; aes_inv_sbox[115] = 8'h8f;
    aes_inv_sbox[116] = 8'hca; aes_inv_sbox[117] = 8'h3f; aes_inv_sbox[118] = 8'h0f; aes_inv_sbox[119] = 8'h02;
    aes_inv_sbox[120] = 8'hc1; aes_inv_sbox[121] = 8'haf; aes_inv_sbox[122] = 8'hbd; aes_inv_sbox[123] = 8'h03;
    aes_inv_sbox[124] = 8'h01; aes_inv_sbox[125] = 8'h13; aes_inv_sbox[126] = 8'h8a; aes_inv_sbox[127] = 8'h6b;
    aes_inv_sbox[128] = 8'h3a; aes_inv_sbox[129] = 8'h91; aes_inv_sbox[130] = 8'h11; aes_inv_sbox[131] = 8'h41;
    aes_inv_sbox[132] = 8'h4f; aes_inv_sbox[133] = 8'h67; aes_inv_sbox[134] = 8'hdc; aes_inv_sbox[135] = 8'hea;
    aes_inv_sbox[136] = 8'h97; aes_inv_sbox[137] = 8'hf2; aes_inv_sbox[138] = 8'hcf; aes_inv_sbox[139] = 8'hce;
    aes_inv_sbox[140] = 8'hf0; aes_inv_sbox[141] = 8'hb4; aes_inv_sbox[142] = 8'he6; aes_inv_sbox[143] = 8'h73;
    aes_inv_sbox[144] = 8'h96; aes_inv_sbox[145] = 8'hac; aes_inv_sbox[146] = 8'h74; aes_inv_sbox[147] = 8'h22;
    aes_inv_sbox[148] = 8'he7; aes_inv_sbox[149] = 8'had; aes_inv_sbox[150] = 8'h35; aes_inv_sbox[151] = 8'h85;
    aes_inv_sbox[152] = 8'he2; aes_inv_sbox[153] = 8'hf9; aes_inv_sbox[154] = 8'h37; aes_inv_sbox[155] = 8'he8;
    aes_inv_sbox[156] = 8'h1c; aes_inv_sbox[157] = 8'h75; aes_inv_sbox[158] = 8'hdf; aes_inv_sbox[159] = 8'h6e;
    aes_inv_sbox[160] = 8'h47; aes_inv_sbox[161] = 8'hf1; aes_inv_sbox[162] = 8'h1a; aes_inv_sbox[163] = 8'h71;
    aes_inv_sbox[164] = 8'h1d; aes_inv_sbox[165] = 8'h29; aes_inv_sbox[166] = 8'hc5; aes_inv_sbox[167] = 8'h89;
    aes_inv_sbox[168] = 8'h6f; aes_inv_sbox[169] = 8'hb7; aes_inv_sbox[170] = 8'h62; aes_inv_sbox[171] = 8'h0e;
    aes_inv_sbox[172] = 8'h0a; aes_inv_sbox[173] = 8'h18; aes_inv_sbox[174] = 8'hbe; aes_inv_sbox[175] = 8'h1b;
    aes_inv_sbox[176] = 8'hfc; aes_inv_sbox[177] = 8'h56; aes_inv_sbox[178] = 8'h3e; aes_inv_sbox[179] = 8'h4b;
    aes_inv_sbox[180] = 8'hc6; aes_inv_sbox[181] = 8'hd2; aes_inv_sbox[182] = 8'h79; aes_inv_sbox[183] = 8'h20;
    aes_inv_sbox[184] = 8'h9a; aes_inv_sbox[185] = 8'hdb; aes_inv_sbox[186] = 8'hc0; aes_inv_sbox[187] = 8'hfe;
    aes_inv_sbox[188] = 8'h78; aes_inv_sbox[189] = 8'hcd; aes_inv_sbox[190] = 8'hc0; aes_inv_sbox[191] = 8'hf4;
    aes_inv_sbox[192] = 8'h1f; aes_inv_sbox[193] = 8'hdd; aes_inv_sbox[194] = 8'ha8; aes_inv_sbox[195] = 8'h33;
    aes_inv_sbox[196] = 8'h88; aes_inv_sbox[197] = 8'h07; aes_inv_sbox[198] = 8'hc7; aes_inv_sbox[199] = 8'h31;
    aes_inv_sbox[200] = 8'hb1; aes_inv_sbox[201] = 8'h12; aes_inv_sbox[202] = 8'h10; aes_inv_sbox[203] = 8'h59;
    aes_inv_sbox[204] = 8'h27; aes_inv_sbox[205] = 8'h80; aes_inv_sbox[206] = 8'hec; aes_inv_sbox[207] = 8'h5f;
    aes_inv_sbox[208] = 8'h60; aes_inv_sbox[209] = 8'h51; aes_inv_sbox[210] = 8'h7f; aes_inv_sbox[211] = 8'ha9;
    aes_inv_sbox[212] = 8'h19; aes_inv_sbox[213] = 8'hb5; aes_inv_sbox[214] = 8'h4a; aes_inv_sbox[215] = 8'h0d;
    aes_inv_sbox[216] = 8'h2d; aes_inv_sbox[217] = 8'he5; aes_inv_sbox[218] = 8'h7a; aes_inv_sbox[219] = 8'h9f;
    aes_inv_sbox[220] = 8'h93; aes_inv_sbox[221] = 8'hc9; aes_inv_sbox[222] = 8'h9c; aes_inv_sbox[223] = 8'hef;
    aes_inv_sbox[224] = 8'ha0; aes_inv_sbox[225] = 8'he0; aes_inv_sbox[226] = 8'h3b; aes_inv_sbox[227] = 8'h4d;
    aes_inv_sbox[228] = 8'hae; aes_inv_sbox[229] = 8'h2a; aes_inv_sbox[230] = 8'hf5; aes_inv_sbox[231] = 8'hb0;
    aes_inv_sbox[232] = 8'hc8; aes_inv_sbox[233] = 8'heb; aes_inv_sbox[234] = 8'hbb; aes_inv_sbox[235] = 8'h3c;
    aes_inv_sbox[236] = 8'h83; aes_inv_sbox[237] = 8'h53; aes_inv_sbox[238] = 8'h99; aes_inv_sbox[239] = 8'h61;
    aes_inv_sbox[240] = 8'h17; aes_inv_sbox[241] = 8'h2b; aes_inv_sbox[242] = 8'h04; aes_inv_sbox[243] = 8'h7e;
    aes_inv_sbox[244] = 8'hba; aes_inv_sbox[245] = 8'h77; aes_inv_sbox[246] = 8'hd6; aes_inv_sbox[247] = 8'h26;
    aes_inv_sbox[248] = 8'he1; aes_inv_sbox[249] = 8'h69; aes_inv_sbox[250] = 8'h14; aes_inv_sbox[251] = 8'h63;
    aes_inv_sbox[252] = 8'h55; aes_inv_sbox[253] = 8'h21; aes_inv_sbox[254] = 8'h0c; aes_inv_sbox[255] = 8'h7d;


	 end

   

   // Sequential block for updating counter and s_box_input
	always_comb begin
		if (!reset_n) begin
			counter_block = 0;
			data_out = 0;
			valid_out=0;
		end else if (valid_in) begin
			if (new_message) begin
				counter_block = key; // Initialize counter_block with key
			end else if (!new_message) begin
				counter_block = counter_block + 1; // Increment counter_block
			end
			s_box_input = (counter_block[7:4] * 16) + counter_block[3:0]; //these before were..
			s_box_out = aes_inv_sbox[s_box_input]; // Perform S-box lookup  //these before were in the first always_ff block after counter	
			data_out <= data_in ^ s_box_out; // XOR data input with S-box output
			valid_out = 1'b1;
		end else if (!valid_in) 
			valid_out=1'b0;
	end
	
endmodule
	
	
	


