%% Set Model 'FIR_filter_shell' HDL parameters
hdlset_param('FIR_filter_shell', 'ClockInputPort', 'MCLK');
hdlset_param('FIR_filter_shell', 'ClockRatePipelineOutputPorts', 'on');
hdlset_param('FIR_filter_shell', 'HDLSubsystem', 'FIR_filter_shell/FIR_filter');
hdlset_param('FIR_filter_shell', 'Oversampling', 512);
hdlset_param('FIR_filter_shell', 'ResetAssertedLevel', 'Active-low');
hdlset_param('FIR_filter_shell', 'ResetInputPort', 'nRst');
hdlset_param('FIR_filter_shell', 'SynthesisTool', 'Xilinx Vivado');
hdlset_param('FIR_filter_shell', 'SynthesisToolChipFamily', 'Artix7');
hdlset_param('FIR_filter_shell', 'SynthesisToolDeviceName', 'xc7a35t');
hdlset_param('FIR_filter_shell', 'SynthesisToolPackageName', 'cpg236');
hdlset_param('FIR_filter_shell', 'SynthesisToolSpeedValue', '-1');
hdlset_param('FIR_filter_shell', 'TargetDirectory', 'hdl_prj/hdlsrc');
hdlset_param('FIR_filter_shell', 'UseSingleLibrary', 'on');
hdlset_param('FIR_filter_shell', 'VHDLArchitectureName', 'RTL');
hdlset_param('FIR_filter_shell', 'VHDLLibraryName', 'lib_FIR_filter');

