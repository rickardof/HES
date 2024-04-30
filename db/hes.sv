module AES_Stream_Cipher (
    input wire clk,
    input wire rst_n,
    input wire [7:0] key,
    input wire input_valid,
    input wire new_message,
    input wire is_ciphertext, // Input flag set in the testbench to indicate whether input is ciphertext or plaintext
    input wire [7:0] plaintext_array[0:255], // Array to hold plaintext
    input wire [7:0] ciphertext_array[0:255], // Array to hold ciphertext
    output reg output_valid,
    output reg [7:0] output_array[0:255] // Array to hold output (either plaintext or ciphertext)
);


// Internal signals
reg [7:0] counter_block[0:255]; // Array to hold counter block
reg [7:0] msb;
reg [7:0] lsb;


// Function prototype for S-box function
function automatic byte s_box_function(byte msb, byte lsb);
 byte s_box_output;
    // Call the S_Box_Function module to compute the S-box output
    s_box_output = S_Box_Function(msb,lsb);
    return s_box_output;
endfunction



// Counter initialization
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (int i = 0; i < 256; i = i + 1) begin
            counter_block[i] <= 8'h0; // Initialize counter block to all zeros
        end							
    end else begin
        if (new_message) begin
            for (int i = 0; i < 256; i = i + 1) begin
                counter_block[i] <= key + i % 256;
            end
        end 
    end
end

// XOR plaintext or ciphertext with S-box transformed counter block to generate output
always_comb begin
    if (input_valid) begin
        for (int i = 0; i < 256; i = i + 1) begin
		msb = counter_block[i][7:4]; // Extract MSB
		lsb = counter_block[i][3:0]; // Extract LSB
            if (is_ciphertext) begin
                output_array[i] = ciphertext_array[i] ^ s_box_function(msb,lsb);
            end else begin
                output_array[i] = plaintext_array[i] ^ s_box_function(msb,lsb);
            end
        end
        output_valid <= 1'b1;
    end else begin
        output_valid <= 1'b0;
    end
end

endmodule
