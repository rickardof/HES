onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /aes_stream_cipher_tb/clk
add wave -noupdate -radix hexadecimal /aes_stream_cipher_tb/reset_n
add wave -noupdate -radix hexadecimal /aes_stream_cipher_tb/valid_in
add wave -noupdate -radix hexadecimal /aes_stream_cipher_tb/new_message
add wave -noupdate -radix hexadecimal /aes_stream_cipher_tb/key
add wave -noupdate -radix hexadecimal /aes_stream_cipher_tb/data_in
add wave -noupdate -radix hexadecimal /aes_stream_cipher_tb/valid_out
add wave -noupdate -radix hexadecimal /aes_stream_cipher_tb/data_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {5 ps} {270 ps}
