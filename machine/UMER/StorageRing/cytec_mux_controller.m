function cytec_mux_controller(string)

% case for user input being a number
if isnumeric(string)
    string = num2str(string);
end

%GPIB Address of the CYTEC Multiplexor
GPIB_addr = 7;

%Create GPIB connection to Cytec MUX
g = gpib('NI', 0, GPIB_addr);

%Opens the connection to the device
fopen(g)

%Selects the specific channel on the MUX that corresponds to the BPM its
%connected to.
switch string
    case '0' %IC2
        fprintf(g, 'X 0') 
    case '1' %RC1
        fprintf(g, 'X 1')
    case '2' %RC2
        fprintf(g, 'X 2')
    case '3' %RC3
        fprintf(g, 'X 3')
    case '5' %RC5
        fprintf(g, 'X 4')
    case '6' %RC6
        fprintf(g, 'X 5')
    case '7' %RC7
        fprintf(g, 'X 6')
    case '8' %RC8
        fprintf(g, 'X 7')
    case '9' %RC9
        fprintf(g, 'X 8')
    case '11' %RC11
        fprintf(g, 'X 9')
    case '12' %RC12
        fprintf(g, 'X 10')
    case '13' %RC13
        fprintf(g, 'X 11')
    case '14' %RC14
        fprintf(g, 'X 12')
    case '15' %RC15
        fprintf(g, 'X 13')
    case '17' %RC17
        fprintf(g, 'X 14')
end

%Closes the connection to the device
fclose(g)




