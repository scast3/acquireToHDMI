restart

add_wave  -color green /scopeToHdmi_tb/uut/sysClk
add_wave  -color green /scopeToHdmi_tb/uut/vc/clk_out1
add_wave  -color green /scopeToHdmi_tb/uut/vc/locked
add_wave  -color green /scopeToHdmi_tb/uut/resetn

add_wave   -color yellow -radix unsigned /scopeToHdmi_tb/uut/vsg/h_cnt
add_wave   -color yellow -radix unsigned /scopeToHdmi_tb/uut/vsg/pixelHorz
add_wave   -color yellow 		/scopeToHdmi_tb/uut/vsg/h_activeArea
add_wave   -color yellow 		/scopeToHdmi_tb/uut/vsg/hs

add_wave   -color orange -radix unsigned /scopeToHdmi_tb/uut/vsg/v_cnt
add_wave   -color yellow -radix unsigned /scopeToHdmi_tb/uut/vsg/pixelVert
add_wave   -color orange 		/scopeToHdmi_tb/uut/vsg/v_activeArea
add_wave   -color orange		/scopeToHdmi_tb/uut/vsg/vs

add_wave   -color aqua	 		/scopeToHdmi_tb/uut/vsg/de

add_wave   -color red -radix unsigned	/scopeToHdmi_tb/uut/sf/red
add_wave   -color green -radix unsigned	/scopeToHdmi_tb/uut/sf/green
add_wave   -color blue -radix unsigned	/scopeToHdmi_tb/uut/sf/blue

add_wave   -color orange		/scopeToHdmi_tb/uut/hdmi_inst/TMDS_DATA_P
add_wave   -color orange		/scopeToHdmi_tb/uut/hdmi_inst/TMDS_DATA_N
add_wave   -color orange		/scopeToHdmi_tb/uut/hdmi_inst/TMDS_CLK_P
add_wave   -color orange		/scopeToHdmi_tb/uut/hdmi_inst/TMDS_CLK_N
add_wave   -color orange		/scopeToHdmi_tb/uut/hdmiOen








