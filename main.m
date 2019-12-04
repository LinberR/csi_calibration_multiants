clear;
clc;
ap_num=1; % the number of AP
target_location=[0,0];   % location of target
ap_location=[100,100;200,200;300,300;400,400];  % location of AP
[ap_row,ap_col]=size(ap_location);
[target_row,target_col]=size(target_location);
target_length=target_row;
ap_length=ap_row;
% calibration data is different between NICs
[ Phoff1,Phoff2 ] = get_cali_phase_average( ap_num  );  

