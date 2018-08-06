function  e = elem_data(e,str,fid)
%ELEM_DATA: decode the element data
% e = elem_data(e,t_id,str,fid)
%-------------------------------------------------------------------------------
% Author:
%  Chang, Ho-Ping (also known as Peace Chang)
%  National Synchrotron Radiation Research Center
%  101 Hsin-Ann Road, Hsinchu Science Park, Hsinchu 30077, Taiwan
%  E-mail: peace@nsrrc.org.tw
% Terminology and Category: for new_element
%--------------------------------------------------------------------------
global Lattice_DB

numFields = 0;
% dc.type: 1) word 2) value 3) separator 4) comment
dc = decoding(0,str,'',0,'',0,',=;','&!');
data_flag = 0;
terminator = 0;
new_str = 1;
field = '';
value = 0;
while new_str == 1
    new_str = 0;
    for i = 1:dc.n
        switch dc.type(i)
            case 1 % word
                if data_flag ~= 0
                    ff = lower(field);
                    if strmatch(ff,'type','exact')
                        data_flag = 2;
                        value = dc.data{i};
                    else
                        error('ELEM_DATA ERROR: <syntax error> ,WORD = value')
                    end
                else
                    data_flag = 1;
                    field = dc.data{i};
                end
            case 2 % value
                if data_flag ~= 1
                    error('ELEM_DATA ERROR: <syntax error> ,word = VALUE')
                end
                data_flag = 2;
                value = dc.data{i};
            case 3 % seperator ',' '=' ';'
                separator = dc.data{i};
                if separator == ';' % terminator
                    terminator = 1;
                    break
                end
                continue
            case 4 % comment
                comment = dc.data{i};
                if comment(1) == '&'
                    new_str = 1;
                else % When comment character '!' does not locate at the beginning, take it as terminator. 
                    terminator = 1;
                end
        end
        if terminator == 1
            break
        end
        if (new_str == 1) && (feof(fid) == 0)
            str = fgetl(fid);
            dc = decoding(0,str,'',0,'',0,',=;','&!');
            break
        end
        if data_flag == 2 % (field = value)
            numFields = numFields+1;
            field_value = Lattice_DB.Field;
            field_value.Name = field;
            field_value.Value = value;
            Fields(numFields) = field_value;
            data_flag = 0;
        end
    end
end

switch e.Type(1)
    case 1 % DRIFT
        e.ElemData.PassMethod = 'DriftPass';
        for i=1:numFields
            idx = search_keyword2(Fields(i).Name,Lattice_DB.eTypeFields{e.Type(1)});
            if idx(1) == 1
                e.ElemData.MAD_Type = Fields(i).Value;
            elseif idx(1) == 2
                e.ElemData.Length = Fields(i).Value;
            else
                display(['ELEM_DATA ERROR: DRIFT ' Fields(i).Name]); 
                display('No such DRIFT parameter is provided.');
            end
        end
    case 2 % BEND
        e.ElemData.PassMethod = 'BendLinearPass';
        %e.ElemData.S6.MaxOrder	= 3;
        %e.ElemData.S6.NumIntSteps = 10;
        for i=1:numFields
            idx = search_keyword2(Fields(i).Name,Lattice_DB.eTypeFields{e.Type(1)});
            if idx(1) == 1
                e.ElemData.MAD_Type = Fields(i).Value;
            elseif idx(1) == 2
                e.ElemData.Length = Fields(i).Value;
            elseif idx(1) == 3 % Angle
                e.ElemData.Pt.BendingAngle = Fields(i).Value;
                e.ElemData.V6(1) = e.ElemData.Pt.BendingAngle;
            elseif idx(1) == 4 % B0(1/Rho) => Angle = L*B0
                e.ElemData.Pt.BendingAngle = e.ElemData.Length/Fields(i).Value;
                e.ElemData.V6(1) = e.ElemData.Pt.BendingAngle;
            elseif idx(1) == 5 %
                e.ElemData.Pt.EntranceAngle = Fields(i).Value;
                e.ElemData.V6(2) = e.ElemData.Pt.EntranceAngle;
            elseif idx(1) == 6 %
                e.ElemData.Pt.ExitAngle = Fields(i).Value;
                e.ElemData.V6(3) = e.ElemData.Pt.ExitAngle;
            elseif idx(1) == 7 % K1
                e.ElemData.P2.PolynomB(2) = Fields(i).Value;
            elseif idx(1) == 8 % K2
                e.ElemData.P2.PolynomB(3) = Fields(i).Value;
            elseif idx(1) == 9 % K3
                e.ElemData.P2.PolynomB(4) = Fields(i).Value;
            elseif idx(1) == 10 % tilt
                if Fields(i).Value ~= 0 % skew ?
                    temp_Polynom = e.ElemData.P2.PolynomB;
                    e.ElemData.P2.PolynomB = e.ElemData.P2.PolynomS;
                    e.ElemData.P2.PolynomB = temp_Polynom;
                end
            elseif idx(1) == 11 % MAD's H1
                display(['ELEM_DATA message: BEND ' Fields(i).Name ' is skipped.']);
            elseif idx(1) == 12 % MAD's H2
                display(['ELEM_DATA message: BEND ' Fields(i).Name ' is skipped.']);
            elseif idx(1) == 12 % MAD's FINT
                display(['ELEM_DATA message: BEND ' Fields(i).Name ' is skipped.']);
            else
                display(['ELEM_DATA ERROR: BEND ' Fields(i).Name]); 
                display('No such BEND parameter is provided.');
            end
        end
    case 3 % QUADUPOLE
        e.ElemData.PassMethod = 'QuadLinearPass';
        %e.ElemData.S6.MaxOrder	= 3;
        %e.ElemData.S6.NumIntSteps = 10;
        for i=1:numFields
            idx = search_keyword2(Fields(i).Name,Lattice_DB.eTypeFields{e.Type(1)});
            if idx(1) == 1
                e.ElemData.MAD_Type = Fields(i).Value;
            elseif idx(1) == 2
                e.ElemData.Length = Fields(i).Value;
            elseif idx(1) == 3 % K1
                e.ElemData.Pt.K = Fields(i).Value;
                e.ElemData.V6(1) = e.ElemData.Pt.K;
                e.ElemData.P2.PolynomB(2) = e.ElemData.Pt.K;
            elseif idx(1) == 4 % tilt
                if Fields(i).Value ~= 0 % skew ?
                    temp_Polynom = e.ElemData.P2.PolynomB;
                    e.ElemData.P2.PolynomB = e.ElemData.P2.PolynomS;
                    e.ElemData.P2.PolynomB = temp_Polynom;
                end
            else
                display(['ELEM_DATA ERROR: QUAD ' Fields(i).Name]); 
                display('No such QUAD parameter is provided.');
            end
        end
    case 4 % SEXT
        e.ElemData.PassMethod = 'StrMPoleSymplectic4Pass';
        %e.ElemData.S6.MaxOrder	= 3;
        %e.ElemData.S6.NumIntSteps = 10;
        for i=1:numFields
            idx = search_keyword2(Fields(i).Name,Lattice_DB.eTypeFields{e.Type(1)});
            if idx(1) == 1
                e.ElemData.MAD_Type = Fields(i).Value;
            elseif idx(1) == 2
                e.ElemData.Length = Fields(i).Value;
            elseif idx(1) == 3 % K2
                e.ElemData.Pt.K = Fields(i).Value;
                e.ElemData.V6(1) = e.ElemData.Pt.K;
                e.ElemData.P2.PolynomB(3) = e.ElemData.Pt.K;
            elseif idx(1) == 4 % tilt
                if Fields(i).Value ~= 0 % skew ?
                    temp_Polynom = e.ElemData.P2.PolynomB;
                    e.ElemData.P2.PolynomB = e.ElemData.P2.PolynomS;
                    e.ElemData.P2.PolynomB = temp_Polynom;
                end
            else
                display(['ELEM_DATA ERROR: SEXT ' Fields(i).Name]); 
                display('No such SEXT parameter is provided.');
            end
        end
    case 5 % OCTU
        e.ElemData.PassMethod = 'StrMPoleSymplectic4Pass';
        %e.ElemData.S6.MaxOrder	= 3;
        %e.ElemData.S6.NumIntSteps = 10;
        for i=1:numFields
            idx = search_keyword2(Fields(i).Name,Lattice_DB.eTypeFields{e.Type(1)});
            if idx(1) == 1
                e.ElemData.MAD_Type = Fields(i).Value;
            elseif idx(1) == 2
                e.ElemData.Length = Fields(i).Value;
            elseif idx(1) == 3 % K3
                e.ElemData.Pt.K = Fields(i).Value;
                e.ElemData.V6(1) = e.ElemData.Pt.K;
                e.ElemData.P2.PolynomB(4) = e.ElemData.Pt.K;
            elseif idx(1) == 4 % tilt
                if Fields(i).Value ~= 0 % skew ?
                    temp_Polynom = e.ElemData.P2.PolynomB;
                    e.ElemData.P2.PolynomB = e.ElemData.P2.PolynomS;
                    e.ElemData.P2.PolynomB = temp_Polynom;
                end
            else
                display(['ELEM_DATA ERROR: OCTU ' Fields(i).Name]); 
                display('No such OCTU parameter is provided.');
            end
        end
        if e.ElemData.Length == 0
            e.ElemData.PassMethod = 'ThinMPolePass';
        end
    case 6 % MULTIPOLE
        e.ElemData.PassMethod = 'ThinMPolePass';
        %e.ElemData.S6.MaxOrder	= 3;
        %e.ElemData.S6.NumIntSteps = 10;
        for i=1:numFields
            idx = search_keyword2(Fields(i).Name,Lattice_DB.eTypeFields{e.Type(1)});
            if idx(1) == 1
                e.ElemData.MAD_Type = Fields(i).Value;
            elseif idx(1) == 2 % K0L
                e.ElemData.P2.PolynomB(1) = Fields(i).Value;
            elseif idx(1) == 3 % K1L
                e.ElemData.P2.PolynomB(2) = Fields(i).Value;
            elseif idx(1) == 4 % K2L
                e.ElemData.P2.PolynomB(3) = Fields(i).Value;
            elseif idx(1) == 5 % K3L
                e.ElemData.P2.PolynomB(4) = Fields(i).Value;
            elseif idx(1) == 6 % SK0L
                e.ElemData.P2.PolynomA(1) = Fields(i).Value;
            elseif idx(1) == 7 % SK1L
                e.ElemData.P2.PolynomA(2) = Fields(i).Value;
            elseif idx(1) == 8 % SK2L
                e.ElemData.P2.PolynomA(3) = Fields(i).Value;
            elseif idx(1) == 9 % SK3L
                e.ElemData.P2.PolynomA(4) = Fields(i).Value;
            else
                display(['ELEM_DATA ERROR: MULTIPOLE ' Fields(i).Name]); 
                display('No such MULTIPOLE parameter is provided.');
            end
        end
        if e.ElemData.Length == 0
            e.ElemData.PassMethod = 'ThinMPolePass';
        end
    case 7 % CORRECTOR H(3,5) V(4,6)
        e.ElemData.PassMethod = 'CorrectorPass';
        for i=1:numFields
            idx = search_keyword2(Fields(i).Name,Lattice_DB.eTypeFields{e.Type(1)});
            if idx(1) == 1
                e.ElemData.MAD_Type = Fields(i).Value;
            elseif idx(1) == 2 % L
                e.ElemData.Length = Fields(i).Value;
            elseif idx(1) == 3 % Kx
                e.ElemData.Pt.KickAngle(1) = Fields(i).Value;
                e.ElemData.V6(1) = e.ElemData.Pt.KickAngle(1);
            elseif idx(1) == 4 % Ky
                ee.ElemData.Pt.KickAngle(2) = Fields(i).Value;
                e.ElemData.V6(2) = e.ElemData.Pt.KickAngle(1);
            elseif idx(1) == 5 % K
                if (e.Type(2) == 3) || (e.Type(2) == 5)
                    e.ElemData.Pt.KickAngle(1) = Fields(i).Value;
                    e.ElemData.V6(1) = e.ElemData.Pt.KickAngle(1);
                elseif (e.Type(2) == 4) || (e.Type(2) == 6)
                    e.ElemData.Pt.KickAngle(2) = Fields(i).Value;
                    e.ElemData.V6(2) = e.ElemData.Pt.KickAngle(2);
                else
                    e.ElemData.Pt.KickAngle(1) = Fields(i).Value;
                    e.ElemData.V6(1) = e.ElemData.Pt.KickAngle(1);
                    e.ElemData.Pt.KickAngle(2) = Fields(i).Value;
                    e.ElemData.V6(2) = e.ElemData.Pt.KickAngle(2);
                end
            else
                display(['ELEM_DATA ERROR: CORRECTOR ' Fields(i).Name]); 
                display('No such CORRECTOR parameter is provided.');
            end
        end
    case 8 % CAVITY
        e.ElemData.PassMethod = 'CavityPass';
        for i=1:numFields
            idx = search_keyword2(Fields(i).Name,Lattice_DB.eTypeFields{e.Type(1)});
            if idx(1) == 1
                e.ElemData.MAD_Type = Fields(i).Value;
            elseif idx(1) == 2 % L
                e.ElemData.Length = Fields(i).Value;
            elseif idx(1) == 3 % Voltage
                e.ElemData.Pt.Voltage = Fields(i).Value;
                e.ElemData.V6(1) = e.ElemData.Pt.Voltage;
            elseif idx(1) == 4 % Frequency
                ee.ElemData.Pt.Frequency = Fields(i).Value;
                e.ElemData.V6(2) = e.ElemData.Pt.Frequency;
            elseif idx(1) == 5 % HarmNumber
                e.ElemData.Pt.HarmNumber = Fields(i).Value;
                e.ElemData.V6(3) = e.ElemData.Pt.HarmNumber;
            elseif idx(1) == 6 % PhaseLag
                e.ElemData.Pt.PhaseLag = Fields(i).Value;
                e.ElemData.V6(4) = e.ElemData.Pt.PhaseLag;
            else
                display(['ELEM_DATA ERROR: CAVITY ' Fields(i).Name]); 
                display('No such CAVITY parameter is provided.');
            end
        end
    case 9 % SOLENOID
        e.ElemData.PassMethod = 'SolenoidLinearPass';
        %e.ElemData.S6.MaxOrder	= 3;
        %e.ElemData.S6.NumIntSteps = 10;
        for i=1:numFields
            idx = search_keyword2(Fields(i).Name,Lattice_DB.eTypeFields{e.Type(1)});
            if idx(1) == 1
                e.ElemData.MAD_Type = Fields(i).Value;
            elseif idx(1) == 2 % L
                e.ElemData.Length = Fields(i).Value;
            elseif idx(1) == 3 % Ks
                e.ElemData.Pt.K = Fields(i).Value;
                e.ElemData.V6(1) = e.ElemData.Pt.K;
            else
                display(['ELEM_DATA ERROR: SOLENOID ' Fields(i).Name]); 
                display('No such SOLENOID parameter is provided.');
            end
        end
    case 10 % MONITOR
        e.ElemData.PassMethod = 'DriftPass';
        for i=1:numFields
            idx = search_keyword2(Fields(i).Name,Lattice_DB.eTypeFields{e.Type(1)});
            if idx(1) == 1
                e.ElemData.MAD_Type = Fields(i).Value;
            elseif idx(1) == 2 % L
                e.ElemData.Length = Fields(i).Value;
            else
                display(['ELEM_DATA ERROR: MONITOR ' Fields(i).Name]); 
                display('No such MONITOR parameter is provided.');
            end
        end
        if (e.Type(2) == 1) || (e.Type(2) == 4) || (e.Type(2) == 7)
            e.ElemData.Pt.Name = 'BPM';
            e.ElemData.V6(1) = 1;
            e.ElemData.V6(2) = 1;
        elseif (e.Type(2) == 2) || (e.Type(2) == 5) || (e.Type(2) == 8)
            e.ElemData.Pt.Name = 'HBPM';
            e.ElemData.V6(1) = 1;
        elseif (e.Type(2) == 3) || (e.Type(2) == 6) || (e.Type(2) == 9)
            e.ElemData.Pt.Name = 'HBPM';
            e.ElemData.V6(2) = 1;
        else
            display(['ELEM_DATA ERROR: MONITOR-Type ' Fields(i).Name]); 
        end
        if e.ElemData.Length == 0
            e.ElemData.PassMethod = 'IdentityPass';
        end
    case 11 % ROTATION
    case 12 % SHIFT
    case 13 % LIMITATION
        e.ElemData.PassMethod = 'DriftPass';
        for i=1:numFields
            idx = search_keyword2(Fields(i).Name,Lattice_DB.eTypeFields{e.Type(1)});
            if idx(1) == 1
                e.ElemData.MAD_Type = Fields(i).Value;
            elseif idx(1) == 2 % L
                e.ElemData.Length = Fields(i).Value;
            elseif idx(1) == 3 % X-size
                e.ElemData.Pt.Limits(1) = -Fields(i).Value;
                e.ElemData.Pt.Limits(2) = Fields(i).Value;
            elseif idx(1) == 4 % Y-size
                e.ElemData.Pt.Limits(3) = -Fields(i).Value;
                e.ElemData.Pt.Limits(4) = Fields(i).Value;
            elseif idx(1) == 5 % Xmin
                e.ElemData.Pt.Limits(1) = Fields(i).Value;
            elseif idx(1) == 6 % Xmax
                e.ElemData.Pt.Limits(2) = Fields(i).Value;
            elseif idx(1) == 7 % Ymin
                e.ElemData.Pt.Limits(3) = Fields(i).Value;
            elseif idx(1) == 8 % Ymax
                e.ElemData.Pt.Limits(4) = Fields(i).Value;
            else
                display(['ELEM_DATA ERROR: LIMITATION ' Fields(i).Name]); 
                display('No such LIMITATION parameter is provided.');
            end
        end
        if e.ElemData.Length == 0
            e.ElemData.PassMethod = 'IdentityPass';
        end
    case 14 % INSERTION (wiggler,undulator)
        e.ElemData.PassMethod = 'LieMapPass';
        for i=1:numFields
            idx = search_keyword2(Fields(i).Name,Lattice_DB.eTypeFields{e.Type(1)});
            if idx(1) == 1
                e.ElemData.MAD_Type = Fields(i).Value;
            elseif idx(1) == 2 % L
                e.ElemData.Length = Fields(i).Value;
            elseif idx(1) == 3 % N-poles (2-poles = 1-period) (Lw = L/N-poles)
                e.ElemData.Pt.Lw = e.ElemData.Length/Fields(i).Value;
                e.ElemData.V6(1) = Fields(i).Value;
            elseif idx(1) == 4 % Bmax
                e.ElemData.Pt.Bmax = Fields(i).Value;
                e.ElemData.V6(2) = e.ElemData.Pt.Bmax;
                e.ElemData.P2.PolynomB(1) = Fields(i).Value;
            elseif idx(1) == 5 % Nstep
                e.ElemData.Pt.Nstep = Fields(i).Value;
                e.ElemData.V6(3) = e.ElemData.Pt.Nstep;
            elseif idx(1) == 6 % Nmesh
                e.ElemData.Pt.Nmesh = Fields(i).Value;
                e.ElemData.V6(4) = e.ElemData.Pt.Nmesh;
            elseif idx(1) == 7 % NHharm
                e.ElemData.Pt.NHharm = Fields(i).Value;
                e.ElemData.V6(5) = e.ElemData.Pt.NHharm;
            elseif idx(1) == 8 % NVharm
                e.ElemData.Pt.NVharm = Fields(i).Value;
                e.ElemData.V6(6) = e.ElemData.Pt.NVharm;
            elseif idx(1) == 9 % Bx
                e.ElemData.P2.PolynomA(1) = Fields(i).Value;
            elseif idx(1) == 10 % By
                e.ElemData.P2.PolynomB(1) = Fields(i).Value;
            else
                display(['ELEM_DATA ERROR: INSERTION ' Fields(i).Name]); 
                display('No such INSERTION parameter is provided.');
            end
        end
        %for i=1:ElemData.NHharm
        %    kx = By(3,i); ky = By(4,i); kz = By(5,i);
        %    dk = sqrt(abs(ky*ky - kz*kz - kx*kx))/abs(kz);
        %    if ( dk > GWIG_EPS ) then
        %        error([' Wiggler (H): kx^2 + kz^2 - ky^2 != 0!, i = ', num2str(i,3)]);
        %    end;
        %end
        %for i=1:ElemData.NVharm
        %    kx = Bx(3,i); ky = Bx(4,i); kz = Bx(5,i);
        %    dk = sqrt(abs(kx*kx - kz*kz - ky*ky))/abs(kz);
        %    if ( dk > GWIG_EPS ) then
        %        error([' Wiggler (V): ky^2 + kz^2 - kx^2 != 0!, i = ', num2str(i,3)]);
        %    end;
        %end
    case 15 % MARKER
        e.ElemData.PassMethod = 'IdentityPass';
    case 16
        e.ElemData.PassMethod = 'DriftPass';
        for i=1:numFields
            idx = search_keyword2(Fields(i).Name,Lattice_DB.eTypeFields{e.Type(1)});
            if idx(1) == 1
                e.ElemData.MAD_Type = Fields(i).Value;
            elseif idx(1) == 2 % L
                e.ElemData.Length = Fields(i).Value;
            else
                display(['ELEM_DATA ERROR: INJECTION ' Fields(i).Name]); 
                display('No such INJECTION parameter is provided.');
            end
        end
        if e.ElemData.Length == 0
            e.ElemData.PassMethod = 'IdentityPass';
        end
    otherwise
        display('ELEM_DATA ERROR: Undefined Element-Type in Lattice_DB.');
end    
