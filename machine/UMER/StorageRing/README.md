# BPM Measurements

The functions in this folder are used to take bpm measurements. For any questions ask Kiersten, Levon, or Brian for help.

### Files
1. Wall Current Monitor
 * read_scope_wcm - Reads the Wall current monitor scope
 * analyze_wcm_data - analyzes wall current monitor data
2. BPM Monitor
 * initialize_scope - creates a scope object. There should be no need to directly call this function
 * get_scope - measures and returns a trace of the data on the scope screen.
 * get_bpm - Measures and grabs information for a bpm
 * get_bpms - Measures and grabs information for all bpms
3. Utility functions
 * plot_scope - plots the scope trace from bpmObject.scope_data
4. helper functions - should not need to be used directly
 * cytec_mux_controller - Used to control the multiplexor that switches between bpms
 * get_bpmcalibration - returns each bpms calibration settings
5. Old BPM Files - not used anymore
 * close_scope - closes a scope connection
 * initialize_scope - does the same thing as get_scope
 * read_BPM_n - replaced by get_bpm
 * read_bpm_point - replaced by read_bpm_point
 * read_scope replaced by get_scope

### Example calls

```matlab
## Grabbing 3 turns of data from RC2

>> bpm_index = 2; turns = 3;
>> bpmObject = get_bpm(turns,bpm_index)

bpmObject = 

          name: 'RC2'
             X: [3x1 double]
             Y: [3x1 double]
            Xe: [3x1 double]
            Ye: [3x1 double]
           top: [3x1 double]
        bottom: [3x1 double]
          left: [3x1 double]
         right: [3x1 double]
           sum: [3x1 double]
    scope_data: [1000x6 double]

>> bpmObject.X

ans =

   -1.2917
   -0.9204
   15.8950
```
```matlab
## Grabbing 1 turn of data from all bpms

>> bpms = get_bpms(1)

bpms = 

    [1x1 struct]
    [1x1 struct]
    [1x1 struct]
    [1x1 struct]
    [1x1 struct]
    [1x1 struct]
    [1x1 struct]
    [1x1 struct]
    [1x1 struct]
    [1x1 struct]
    [1x1 struct]
    [1x1 struct]
    [1x1 struct]
    [1x1 struct]

>> bpms{1}

ans = 

          name: 'RC1'
             X: -1.2656
             Y: -2.0947
            Xe: 0.0059
            Ye: 0.0064
           top: -0.1371
        bottom: -0.0978
          left: -0.1321
         right: -0.1062
           sum: -0.4732
    scope_data: [1000x6 double]
```
