%Tinash
%partial SEP Chart
clc;close all; clear;
%Insructions______________________
%Use excel file with name inputs.xlsx and input the parameters in cells
%B1-B13 with B(3)= AR e.t.c
%SAVE matlab file in same directy as excel file.
%SAVE CHANGES TO EXCEL FILE
%run MATLAB SCRIPT
VargI=xlsread('inputs.xlsx');%excel inputs
Mass=VargI(1);Sref=VargI(2);AR=VargI(3);e=VargI(4);cdo=VargI(5);
clmax=VargI(6);nmax=VargI(7);sigma=VargI(8);load_steps=VargI(9);
MinR=VargI(11);MaxR=VargI(12);stepsR=VargI(13);
A=(2*Mass*9.81)/(1.225*sigma*Sref);Vsound=VargI(10);Thrust=VargI(14);
Mach=0.002:0.002:1;
Loads=1:load_steps:nmax;steps=size(Loads,2);
TurnRadius=MinR:stepsR:MaxR;%turn radii in meters
MaxSpeed=VargI(15);
SoundSpeed=Vsound*0.514772;
MachEnd=MaxSpeed/SoundSpeed;
%_________________________________________________________________________

%NB FOR thrust that is variant with time, replace thrust with your own
%thrust model that is variant with time.
%LOAD FACTOR LINES_________________________________________________####
StallSpeeds=[];StallW=[];
TempOmega=zeros(1,500);
res=0.00002;
for i=1:steps;
    n=Loads(i);Xv=[];Yw=[];%store mach and omega to plot
    for V=0.002:res:MachEnd;
        k=Vsound*0.514772*V;%Mach to KTAS to m/s
        CL=A*n/(k^2);%check if the CL is greater than CLmax
        if CL<=clmax;
            w=(180*9.81*(n^2-1)^0.5/(k*pi()));
            Xv(end+1)=V;Yw(end+1)=w;%store mach number and turn rate
        end
            
            
    end
    %StallSpeeds(end+1)=Xv(1);StallW(end+1)=Yw(1);%stall speeds are first entries
    plot(Xv,Yw,'b');
    hold on;
    %plot(StallSpeeds,StallW,'r');%PLOT STALL LINE
    
end
plot([MachEnd MachEnd],[0 Yw(end)]);
hold on;
ylimit=max(Yw);
%_____stall_line__
for n=1:0.01:nmax
    k=(A*n/clmax)^0.5;
    w=(180*9.81*(n^2-1)^0.5/(k*pi()));
    V=k/(Vsound*.514772);
    StallSpeeds(end+1)=V;
    StallW(end+1)=w;
    
    hold on;
end
plot(StallSpeeds,StallW,'r');%PLOT STALL LINE
%__________________________________________
%%%%turn radius lines<using fact that they all go to the origin>
%%%%limit to max load factor line using tun radius eq to find V
%____
xlimit=0.4;
C=0.514772*Vsound;
for R=MinR: stepsR :MaxR
    mR=[ ] ;wR=[ ];    
    for n=1: 0.0001:nmax
        V=(R*9.81*(n^2-1)^0.5 )^0.5;
       if V>MaxSpeed;
           break;
       end
        m=V/C;
        if m<= xlimit;
            CL=2*Mass*9.81*n/(1.225*Sref*sigma*V^2); 
            if CL<=clmax;
                w=180*V/(pi*R);
                wR(end+1)=w;
                mR(end+1)=m;
                
            end
        end
    end
    
    plot (mR,wR, 'k' ) ;
hold on
RR=num2str(R) ;
RR=strcat(RR, 'm' ) ;
text(m,w+0.2 ,RR) ;
end

hold on;
xlabel('Mach Number');
ylabel('Turn Rate \omega degrees/sec');


