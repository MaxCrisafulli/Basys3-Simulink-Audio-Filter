function bf_generate_hdl (mymodel, hdltop, lang, dir, tb)
%-------------------------------------------------------------------------------
% function bf_generate_hdl
% wrapper function for generation of HDL code
% arguments:
% mymodel  : name of the Simulink (top-level) model
% hdltop   : name of system to be generated
% lang     : HDL language ('VHDL' or 'Verilog')
% dir      : directory where generated code is stored
% tb       : 0 (DUT only, no TB generated), 1 (TB with DUT sources) or
%          : 2 (TB only)
% 
% This wrapper function will call your custom function bf_generate_<hdltop>
% configure that function for generation command and / or generation parameters
%
%-------------------------------------------------------------------------------
% Revision history :
% 2022-03-03  PAEI  Will not return error anymore when the system for which code
%                   is generated is the top-level itself
%
%-------------------------------------------------------------------------------
myfunctionname = 'bf_generate_hdl';
errorfound = 0;
try
  open_system(mymodel)
  modelisopen = 1;
catch ME
  if (strcmp(ME.identifier,'MATLAB:open:fileNotFound') || strcmp(ME.identifier,'Simulink:Commands:OpenSystemUnknownSystem'))
    msg = ['ERROR: ' myfunctionname ' - cannot find model ' mymodel];
    disp(msg);
    disp('Please check Matlab path or create the model.');
  end
  msg = ['ERROR: Error opening model ' mymodel];
  disp(msg);
  modelisopen = 0;
  errorfound = 1;
end

if (modelisopen)
  try
    gen_options = {};
    %
    % A file on filesystem should not contain spaces - replace spaces with _:
    hdltop_no_space = strrep (hdltop, ' ', '_');
    % check if HDL options file exists

    hdl_options_file = 'hdl_gen_options_common'
    if (exist(hdl_options_file, 'file') == 2)
      msg = ['NOTE: opening ''' hdl_options_file ''' for HDL generation parameters.'];
      disp(msg);
      run(hdl_options_file);
      msg = ['NOTE: reading ''' hdl_options_file ''' done.'];
      disp(msg);
    else
      msg = ['NOTE: No options file ''' hdl_options_file ''' found, using model default HDL generation parameters.'];
      disp(msg);
    end

    hdl_options_file = ['hdl_gen_options_' hdltop_no_space];
    if (exist(hdl_options_file, 'file') == 2)
      msg = ['NOTE: opening ''' hdl_options_file ''' for HDL generation parameters.'];
      disp(msg);
      run(hdl_options_file);
      msg = ['NOTE: reading ''' hdl_options_file ''' done.'];
      disp(msg);
    else
      msg = ['NOTE: No options file ''' hdl_options_file ''' found, using model default HDL generation parameters.'];
      disp(msg);
    end

    gen_options = {...
            gen_options{:},...
            'TargetLanguage',       lang,...
            'TargetDirectory',      dir};

    %% support generation of design without a top-level simulink testbench
    %% (name of simulink model is then the same as the DUT (hdltop)
    if (strcmp(mymodel,hdltop))
        obj = [mymodel];
    else
        obj = [mymodel '/' hdltop];
    end
    disp ('--------------------------------------------------------------------------------');
    msg = ['The following HDL parameters are set on model ' obj ':'];
    disp (msg);
    hdldispmdlparams(obj,'all');
    disp ('--------------------------------------------------------------------------------');
    disp ('The following HDL parameters will be overwritten when generating HDL:');
    for indx = 0:(length(gen_options)/2 - 1)
      [key, value] = gen_options{2*indx+1:2*indx+2};
      msg = sprintf('%-50s : ''%s''', ['''' key ''''], value);
      disp (msg);
    end
    disp ('--------------------------------------------------------------------------------');
    disp ('Starting HDL Code Generation');
    disp ('--------------------------------------------------------------------------------');
    % call generation command:
    if (tb < 2)
      % create DUT HDL
      makehdl (obj, gen_options{:});
    end
    if (tb > 0)
      % create test bench HDL
      makehdltb (obj, gen_options{:});
    end
  catch ME
    msg = ['ERROR: Error detected when generating HDL or HDL testbench.'];
    disp(msg);
    errorfound = 1;
  end
end
% exit if in batch mode:
if (~usejava('desktop'))
  % not interactive
  bdclose all;
  exit(errorfound);
else
  msg = ['NOTE: ' myfunctionname ' - No auto-exit because desktop is enabled.'];
  disp(msg);
  msg = ['Use Matlab command line option -nodesktop to exit after code generation.'];
  disp(msg);
  msg = ['When using buildfiles, check variable MATLAB_GENERATE_ARGS.'];
  disp(msg);
end

