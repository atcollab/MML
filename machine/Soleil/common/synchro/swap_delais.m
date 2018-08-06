% swap delai address

function swap_delais(cas)

temp=tango_read_attribute2('ANS/SY/CENTRAL', 'TSoftStepDelay');clk_soft=temp.value(1);
temp=tango_read_attribute2('ANS/SY/CENTRAL', 'TInjStepDelay');clk_inj=temp.value(1);
temp=tango_read_attribute2('ANS/SY/CENTRAL', 'ExtractionOffsetClkStepValue');clk_ext=temp.value(1);

if (cas==1) % Soft 2  3Hz
    clk1_inj =clk_soft;
    clk1_ext =clk_soft/52+2;
    clk1_soft=clk_soft-10*52;
    tango_write_attribute2('ANS/SY/CENTRAL', 'TSoftStepDelay',clk1_soft);
    tango_write_attribute2('ANS/SY/CENTRAL', 'TInjStepDelay',clk1_inj);
    tango_write_attribute2('ANS/SY/CENTRAL', 'ExtractionOffsetClkStepValue',clk1_ext);
elseif(cas==2) % 3Hz 2 Soft
end