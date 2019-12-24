function [] = SunMercuryEarthMoon(years,framerate)
%% SunMercuryEarthMoon
% The purpose of this function is to plot the orbits of the sun, mercury, earth, and
% moon over a specified time period (Note that time periods in excess of 20
% years will require large runtimes). 
%
% Inputs:
%   years     = Observation Time Period (years)
%   framerate = Video Speed (typically between 1 and 1000)

%% Clean Up
close all
clc

%% Initializaion
x_earth = 147300000000; % [m]
v_earth = 30257; % [m/s]
r_sat = 384748000; % earth surface [m]
r_earth = 6367000; % earth radius [m]
v_sat = 1023; % relative velocity from earth [m/s]
a = 5.145; % Angle to vertical (y) axis 
b = 90; % Angle to horizontal (x) axis in xz plane

x_mer = 57.9*10^9; % [m]
v_mer = 47360; % [m/s]

x_earth_o = [x_earth; 0; 0];
x_sun_o = [0; 0; 0];
x_sat_o = [x_earth+r_sat; 0; 0];
v_earth_o = [0; v_earth; 0];
v_sun_o = [0; 0; 0];
v_sat_o = v_sat*[cos(pi/180*b)*sin(pi/180*a); cos(pi/180*a); sin(pi/180*b)*sin(pi/180*a)] + v_earth_o;
interval = years*[0 31536000];

x_mer_o = [x_mer; 0; 0];
v_mer_o = [0; v_mer; 0];

%% Error Control
h = [0.01 36000];
tol = 100000;
Options.AbsTol = tol;
Options.MaxStep = h(2);
Options.InitialStep = h(1);

%% Analysis
ao = [x_earth_o; v_earth_o; x_sun_o; v_sun_o; x_sat_o; v_sat_o; x_mer_o; v_mer_o]; 
[t, x] = ode45(@earthfinal,interval,ao,Options);
for i = 1:length(t)
    R1(i) = (x(i,13)-x(i,1));
    R2(i) = (x(i,14)-x(i,2));
    R3(i) = (x(i,15)-x(i,3));
    R(i) = sqrt(R1(i)^2+R2(i)^2+R3(i)^2);
end
T_index_earth = find([1; x(:,4)].*[x(:,4);1]<=0);
T_index_moon = find([1; R2(:)].*[R2(:); 1]<=0);
for i = 4:length(T_index_earth)
    T_earth_semi(i-3) = (t(T_index_earth(i)-1)-t(T_index_earth(i-2)-1))/24/60/60;
end
T_earth = mean(T_earth_semi);
for i = 4:length(T_index_moon)
    T_moon_semi(i-3) = (t(T_index_moon(i)-1)-t(T_index_moon(i-2)-1))/24/60/60;
end
T_moon = mean(T_moon_semi);
D_earth = 0;
for i = 2:(T_index_earth(4)-1)
    D_earth = D_earth + sqrt((x(i,1)-x(i-1,1))^2+(x(i,2)-x(i-1,2))^2+(x(i,3)-x(i-1,3))^2);
end
D_moon = 0;
for i = 2:(T_index_moon(4)-1)
    D_moon = D_moon + sqrt((R1(i)-R1(i-1))^2+(R2(i)-R2(i-1))^2+(R3(i)-R3(i-1))^2);
end

%% Plots
q = framerate;
scrsz = get(0,'ScreenSize');
figure('position', [0.05*scrsz(3) 0.05*scrsz(4) 0.75*scrsz(3) 0.85*scrsz(4)])
set(gcf,'name','Sun, Mercury, Earth, and Moon Orbits')
for i = 1:length(t)/q
    subplot(2,2,1)
    plot3(x(1:i*q,1),x(1:i*q,2),x(1:i*q,3),'g', x(1:i*q,13),x(1:i*q,14),x(1:i*q,15),'b')
    axis(1.1*[min(x(:,1)) max(x(:,1)) min(x(:,2)) max(x(:,2)) 2*min(x(:,15)) 2*max(x(:,15))])
    xlabel('Universal X Coordinate (m)')
    ylabel('Universal Y Coordinate (m)')
    zlabel('Universal Z Coordinate (m)')
    title('Relative Orbits of Earth and Moon')
    legend('Earth','Moon')
    hold on
    plot3(x(i*q,1),x(i*q,2),x(i*q,3),'g-o',x(i*q,13),x(i*q,14),x(i*q,15),'b-o')
    hold off
    
   % subplot(2,2,2)
   % plot3(R1(1:i*q),R2(1:i*q),R3(1:i*q),'b',zeros(1,i*q),zeros(1,i*q),zeros(1,i*q),'g')
   % axis(1.5*[min(R1) max(R1) min(R2) max(R2) min(R3) max(R3)])
   % xlabel('Universal X Coordinate (m)')
   % ylabel('Universal Y Coordinate (m)')
   % zlabel('Universal Z Coordinate (m)')
   % title('Relative Moon Orbit About Earth')
   % hold on
   % plot3(R1(i*q),R2(i*q),R3(i*q),'b-o',0,0,0,'g-o')
   % text(0,1.45*max(R2),1.40*max(R3),sprintf('Orbital Period, T = %3.5g days',T_moon))
   % text(0,1.45*max(R2),1.15*max(R3),sprintf('Orbital Circumference, D = %3.5g gigameters',D_moon*1e-9))
   % hold off
    
    subplot(2,2,3)
    plot(x(1:i*q,1),x(1:i*q,2),'g',x(1:i*q,7),x(1:i*q,8),'r',x(1:i*q,19),x(1:i*q,20),'b')
    axis(1.5*[min(x(:,1)) max(x(:,1)) min(x(:,2)) max(x(:,2))])
    xlabel('Universal X Coordinate (m)')
    ylabel('Universal Y Coordinate (m)')
    title('Relative Orbits of Earth & Mercury About Sun')
    legend('Earth','Sun', 'Mercury')
    hold on
    plot(x(i*q,1),x(i*q,2),'g-o',x(i*q,7),x(i*q,8),'r-o', x(i*q,19),x(i*q,20),'b-o')
    text(1.45*min(x(:,1)),1.40*max(x(:,2)),sprintf('Orbital Period, T = %3.5g days',T_earth))
    text(1.45*min(x(:,1)),1.25*max(x(:,2)),sprintf('Orbital Circumference, D = %3.5g gigameters',D_earth*1e-9))
    text(1.45*min(x(:,1)),1.40*min(x(:,2)),sprintf('Time, t = %3.3g days',round(t(q*i)/24/60/60)))
    hold off
    
   % subplot(2,2,4)
   % plot(t(1:i*q)/(60*60*24),R(1:i*q)/1000,'b')
   % axis([t(1)/24/60/60 t(end)/24/60/60 0.999*min(R)/1000 1.001*max(R)/1000])
   % xlabel('Time,t (days)')
   % ylabel('Orbit Radius, R (km)')
   % title('Moon-Earth Distance')
   % hold on
   % plot(t(i*q)/(60*60*24),R(i*q)/1000,'b-o')
   % hold off
    
    drawnow
end
end

%% Differential Equation Function
function [udot]= earthfinal(t,u)
m_earth = 5.9742e24; % [kg]
m_sun = 1.98892e30; % [kg]
m_sat = 11110; % [kg]
G = 6.67300e-11; %[(m)^3(kg)^-1(s)^-2];

m_mer = 0.33011e24; % [kg]

d_earth_sun = sqrt((u( 7,1)-u(1,1))^2+(u( 8,1)-u(2,1))^2+(u( 9,1)-u(3,1))^2);
d_earth_sat = sqrt((u(13,1)-u(1,1))^2+(u(14,1)-u(2,1))^2+(u(15,1)-u(3,1))^2);
d_sun_sat =   sqrt((u(13,1)-u(7,1))^2+(u(14,1)-u(8,1))^2+(u(15,1)-u(9,1))^2);

d_earth_mer = sqrt((u(19,1)-u(1,1))^2+(u(20,1)-u(2,1))^2+(u(21,1)-u(3,1))^2);
d_sun_mer = sqrt((u(19,1)-u(7,1))^2+(u(20,1)-u(8,1))^2+(u(21,1)-u(9,1))^2);
d_sat_mer = sqrt((u(19,1)-u(13,1))^2+(u(20,1)-u(14,1))^2+(u(21,1)-u(15,1))^2);

% Earth motion
udot( 1,1) = u(4,1);
udot( 2,1) = u(5,1);
udot( 3,1) = u(6,1);
udot( 4,1) = m_mer*G*(u(19,1)-u(1,1))/d_earth_mer^3 + m_sun*G*(u(7,1)-u(1,1))/d_earth_sun^3 + m_sat*G*(u(13,1)-u(1,1))/d_earth_sat^3;
udot( 5,1) = m_mer*G*(u(20,1)-u(2,1))/d_earth_mer^3 + m_sun*G*(u(8,1)-u(2,1))/d_earth_sun^3 + m_sat*G*(u(14,1)-u(2,1))/d_earth_sat^3;
udot( 6,1) = m_mer*G*(u(21,1)-u(3,1))/d_earth_mer^3 + m_sun*G*(u(9,1)-u(3,1))/d_earth_sun^3 + m_sat*G*(u(15,1)-u(3,1))/d_earth_sat^3;
% Sun Motion
udot( 7,1) = u(10,1);
udot( 8,1) = u(11,1);
udot( 9,1) = u(12,1);
udot(10,1) = m_mer*G*(u(19,1)-u(7,1))/d_sun_mer^3 + m_earth*G*(u(1,1)-u(7,1))/d_earth_sun^3 + m_sat*G*(u(13,1)-u(7,1))/d_sun_sat^3;
udot(11,1) = m_mer*G*(u(20,1)-u(8,1))/d_sun_mer^3 + m_earth*G*(u(2,1)-u(8,1))/d_earth_sun^3 + m_sat*G*(u(14,1)-u(8,1))/d_sun_sat^3;
udot(12,1) = m_mer*G*(u(21,1)-u(9,1))/d_sun_mer^3 + m_earth*G*(u(3,1)-u(9,1))/d_earth_sun^3 + m_sat*G*(u(15,1)-u(9,1))/d_sun_sat^3;
% Satellite Motion
udot(13,1) = u(16,1);
udot(14,1) = u(17,1);
udot(15,1) = u(18,1);
udot(16,1) = m_mer*G*(u(19,1)-u(13,1))/d_sat_mer^3 + m_earth*G*(u(1,1)-u(13,1))/d_earth_sat^3 + m_sun*G*(u(7,1)-u(13,1))/d_sun_sat^3;
udot(17,1) = m_mer*G*(u(20,1)-u(14,1))/d_sat_mer^3 + m_earth*G*(u(2,1)-u(14,1))/d_earth_sat^3 + m_sun*G*(u(8,1)-u(14,1))/d_sun_sat^3;
udot(18,1) = m_mer*G*(u(21,1)-u(15,1))/d_sat_mer^3 + m_earth*G*(u(3,1)-u(15,1))/d_earth_sat^3 + m_sun*G*(u(9,1)-u(15,1))/d_sun_sat^3;

% Mercury Motion
udot(19,1) = u(22,1);
udot(20,1) = u(23,1);
udot(21,1) = u(24,1);
udot(22,1)= m_earth*G*(u(1,1)-u(19,1))/d_earth_mer^3 + m_sun*G*(u(7,1)-u(19,1))/d_sun_mer^3 + m_sat*G*(u(13,1)-u(19,1))/d_sat_mer^3;
udot(23,1)= m_earth*G*(u(2,1)-u(20,1))/d_earth_mer^3 + m_sun*G*(u(8,1)-u(20,1))/d_sun_mer^3 + m_sat*G*(u(14,1)-u(20,1))/d_sat_mer^3;
udot(24,1)= m_earth*G*(u(3,1)-u(21,1))/d_earth_mer^3 + m_sun*G*(u(9,1)-u(21,1))/d_sun_mer^3 + m_sat*G*(u(15,1)-u(21,1))/d_sat_mer^3;
end