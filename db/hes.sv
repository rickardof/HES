
module AES_Stream_Cipher (
    input wire clk,
    input wire rst_n,
    input wire [7:0] key,
    input wire input_valid,
    input wire new_message,
    input wire [7:0] input_data, // Array to hold plaintext byte/ ciphertext byte
    output reg output_valid,
    output reg [7:0] output_byte, // reg hold output (either plaintext or ciphertext)
	output reg [7:0] counter_block // reg to hold counter block, just for testing, originally it's a internal signal
);



// Internal signals
// reg [7:0] counter_block; // reg to hold counter block
reg [7:0] msb;
reg [7:0] lsb;
reg [7:0] i=8'h00; //this is to indicate the i-th byte to process and serves to initialize the counter block value


//S box function implementation

function automatic reg[7:0] S_Box_Function (input reg [7:0] msb,input reg[7:0] lsb);
   //separate msb and lsb outside the function
	reg [7:0] s_box_function;


	// S-box table
	// Defined as a constant array since it won't change during simulation
	const reg [7:0] s_box_table [0:15][0:15] = '{
		// S-box table contents
// Row 0
    {8'h52, 8'h09, 8'h6a, 8'hd5, 8'h30, 8'h36, 8'ha5, 8'h38, 8'hbf, 8'h40, 8'ha3, 8'h9e, 8'h81, 8'hf3, 8'hd7, 8'hfb},
    // Row 1
    {8'h7c, 8'he3, 8'h39, 8'h82, 8'h9b, 8'h2f, 8'hff, 8'h87, 8'h34, 8'h8e, 8'h43, 8'h44, 8'hc4, 8'hde, 8'he9, 8'hcb},
    // Row 2
    {8'h54, 8'h7b, 8'h94, 8'h32, 8'ha6, 8'hc2, 8'h23, 8'h3d, 8'hee, 8'h4c, 8'h95, 8'h0b, 8'h42, 8'hfa, 8'hc3, 8'h4e},
    // Row 3
    {8'h08, 8'h2e, 8'ha1, 8'h66, 8'h28, 8'hd9, 8'h24, 8'hb2, 8'h76, 8'h5b, 8'ha2, 8'h49, 8'h6d, 8'h8b, 8'hd1, 8'h25},
    // Row 4
    {8'h72, 8'hf8, 8'hf6, 8'h64, 8'h86, 8'h68, 8'h98, 8'h16, 8'hd4, 8'ha4, 8'h5c, 8'hcc, 8'h5d, 8'h65, 8'hb6, 8'h92},
    // Row 5
    {8'h6c, 8'h70, 8'h48, 8'h50, 8'hfd, 8'hed, 8'hb9, 8'hda, 8'h5e, 8'h15, 8'h46, 8'h57, 8'ha7, 8'h8d, 8'h9d, 8'h84},
    // Row 6
    {8'h90, 8'hd8, 8'hab, 8'h00, 8'h8c, 8'hbc, 8'hd3, 8'h0a, 8'hf7, 8'he4, 8'h58, 8'h05, 8'hb8, 8'hb3, 8'hd3, 8'h45},
    // Row 7
    {8'hd0, 8'h2c, 8'h1e, 8'h8f, 8'hca, 8'h3f, 8'h0f, 8'h02, 8'hc1, 8'haf, 8'hbd, 8'h03, 8'h01, 8'h13, 8'h8a, 8'h6b},
    // Row 8
    {8'h3a, 8'h91, 8'h11, 8'h41, 8'h4f, 8'h67, 8'hdc, 8'hea, 8'h97, 8'hf2, 8'hcf, 8'hce, 8'hf0, 8'hb4, 8'he6, 8'h73},
    // Row 9
    {8'h96, 8'hac, 8'h74, 8'h22, 8'he7, 8'had, 8'h35, 8'h85, 8'he2, 8'hf9, 8'h37, 8'he8, 8'h1c, 8'h75, 8'hdf, 8'h6e},
    // Row 10
    {8'h47, 8'hf1, 8'h1a, 8'h71, 8'h1d, 8'h29, 8'hc5, 8'h89, 8'h6f, 8'hb7, 8'h62, 8'h0e, 8'h0a, 8'h18, 8'hbe, 8'h1b},
    // Row 11
    {8'hfc, 8'h56, 8'h3e, 8'h4b, 8'hc6, 8'hd2, 8'h79, 8'h20, 8'h9a, 8'hdb, 8'hc0, 8'hfe, 8'h78, 8'hcd, 8'hc0, 8'hf4},
    // Row 12
    {8'h1f, 8'hdd, 8'ha8, 8'h33, 8'h88, 8'h07, 8'hc7, 8'h31, 8'hb1, 8'h12, 8'h10, 8'h59, 8'h27, 8'h80, 8'hec, 8'h5f},
    // Row 13
    {8'h60, 8'h51, 8'h7f, 8'ha9, 8'h19, 8'hb5, 8'h4a, 8'h0d, 8'h2d, 8'he5, 8'h7a, 8'h9f, 8'h93, 8'hc9, 8'h9c, 8'hef},
    // Row 14
    {8'ha0, 8'he0, 8'h3b, 8'h4d, 8'hae, 8'h2a, 8'hf5, 8'hb0, 8'hc8, 8'heb, 8'hbb, 8'h3c, 8'h83, 8'h53, 8'h99, 8'h61},
    // Row 15
    {8'h17, 8'h2b, 8'h04, 8'h7e, 8'hba, 8'h77, 8'hd6, 8'h26, 8'he1, 8'h69, 8'h14, 8'h63, 8'h55, 8'h21, 8'h0c, 8'h7d}
	};

	// Assign the S-box output based on the row and column coordinates
	s_box_function = s_box_table[msb][lsb];
	return s_box_function;
endfunction



// Always block to handle counter block logic

//problem is now that if new_message is asserted counterblock is not updated
//seems like at the first iteration counterblock skips and assumes the value when new_message is at 0, in fact at first byte when new_message is at 1, output valid is still at 0 (but it should be at 1)
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Initialization
        counter_block <= 8'h0; // Initialize counter block to zero
        output_valid <= 1'b0; // Reset output_valid when in reset state
        output_byte <= 8'h0; // Initialize output byte in reset condition
        i <= 8'h0; // Initialize i to zero
    end else if (input_valid) begin
        // Counter Block and Index Update
        if (new_message) begin
            counter_block <= key; // Set counter block to key if new message
            i <= 8'h0; // Reset i if new message
        end else begin
			i <= i + 1; // Increment i
            counter_block <= (key + i) % 256; // Update counter block
            
        end
        // Extract MSB and LSB
        msb <= counter_block[7:4];
        lsb <= counter_block[3:0];
        
        // Perform XOR operation with S-Box function
        output_byte <= input_data ^ S_Box_Function(msb, lsb);
        
        // Set output_valid when input_valid is asserted
        output_valid <= 1'b1;
    end else begin
        output_valid <= 1'b0; // Reset output_valid if input_valid is not asserted
    end
end




endmodule


