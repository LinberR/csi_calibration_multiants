function [ Phoff1,Phoff2 ] = get_cali_phase_1( ap_num  )
%%% 
    count=1;
    
    for j=1:2
        for k=1:2       
            csilist=['calibration/csi_cali_',num2str(j),'3_',num2str(k),'_','20191201.dat'];  % 第j个AP收到的第i个位置的CSI
            csi_trace=read_bf_file(csilist);
            len=length(csi_trace);
            phase_ant1=[];
            phase_ant2=[];
            phase_ant3=[];
            
            for i=1:5
                for kk=1:i*100 %len-1
                     [amp,phase]=get_amp_phase_from_csi(csi_trace{kk});
                     phase_ant1=[phase_ant1;phase(1,:)];
                     phase_ant2=[phase_ant2;phase(2,:)];
                     phase_ant3=[phase_ant3;phase(3,:)];             
                end 
                avg_phase_ant1=mean(phase_ant1);
                avg_phase_ant2=mean(phase_ant2);
                avg_phase_ant3=mean(phase_ant3); 
                avg_phase(:,:,count)=[avg_phase_ant1;avg_phase_ant2;avg_phase_ant3];
                count=count+1;
            end
        end   
    end

    % Standard phase is based on ant3 
    % calculate the ant1 and ant3 phase error
    temp=squeeze(avg_phase(:,:,1));
    phase_diff_ant1_3_1=temp(1,:)-temp(3,:);
    temp=squeeze(avg_phase(:,:,2));
    phase_diff_ant1_3_2=temp(1,:)-temp(3,:);
    Phoff1(1,:)=(phase_diff_ant1_3_1+phase_diff_ant1_3_2)./2;
    
    
    
    
    
    
    
%     % calculate the ant1 and ant3 phase error in NIC2
%     temp=squeeze(avg_phase(:,:,3));
%     phase_diff_ant2_3_1=temp(2,:)-temp(3,:);
%     temp=squeeze(avg_phase(:,:,4));
%     phase_diff_ant2_3_2=temp(2,:)-temp(3,:);
%     Phoff2(1,:)=(phase_diff_ant2_3_1+phase_diff_ant2_3_2)./2;
    
    
    
    
    
%     % calculate the ant1 and ant2 phase error in NIC2
%     temp=squeeze(avg_phase(:,:,5));
%     phase_diff_ant1_2_1=temp(2,:)-temp(1,:);
%     temp=squeeze(avg_phase(:,:,6));
%     phase_diff_ant1_2_2=temp(2,:)-temp(1,:);
%     Phoff2(1,:)=(phase_diff_ant1_2_1+phase_diff_ant1_2_2)./2;
%     % calculate the ant1 and ant3 phase error in NIC2
%     temp=squeeze(avg_phase(:,:,7));
%     phase_diff_ant1_3_1=temp(3,:)-temp(1,:);
%     temp=squeeze(avg_phase(:,:,8));
%     phase_diff_ant1_3_2=temp(3,:)-temp(1,:);
%     Phoff2(2,:)=(phase_diff_ant1_3_1+phase_diff_ant1_3_2)./2;
%     % calculate the ant2 and ant3 phase error in NIC2
%     Phoff2(2,:)=Phoff2(2,:)-Phoff2(1,:);
%     Phoff(:,:,2)=Phoff2;
%     
%     % calculate the ant1 and ant2 phase error in NIC3
%     temp=squeeze(avg_phase(:,:,9));
%     phase_diff_ant1_2_1=temp(2,:)-temp(1,:);
%     temp=squeeze(avg_phase(:,:,10));
%     phase_diff_ant1_2_2=temp(2,:)-temp(1,:);
%     Phoff3(1,:)=(phase_diff_ant1_2_1+phase_diff_ant1_2_2)./2;
%     % calculate the ant1 and ant3 phase error in NIC3
%     temp=squeeze(avg_phase(:,:,11));
%     phase_diff_ant1_3_1=temp(3,:)-temp(1,:);
%     temp=squeeze(avg_phase(:,:,12));
%     phase_diff_ant1_3_2=temp(3,:)-temp(1,:);
%     Phoff3(2,:)=(phase_diff_ant1_3_1+phase_diff_ant1_3_2)./2;
%     % calculate the ant2 and ant3 phase error in NIC3
%     Phoff3(2,:)=Phoff3(2,:)-Phoff3(1,:);
%     Phoff(:,:,3)=Phoff3;
%     
%     % calculate the ant1 and ant2 phase error in NIC4
%     temp=squeeze(avg_phase(:,:,13));
%     phase_diff_ant1_2_1=temp(2,:)-temp(1,:);
%     temp=squeeze(avg_phase(:,:,14));
%     phase_diff_ant1_2_2=temp(2,:)-temp(1,:);
%     Phoff4(1,:)=(phase_diff_ant1_2_1+phase_diff_ant1_2_2)./2;
%     % calculate the ant1 and ant3 phase error in NIC4
%     temp=squeeze(avg_phase(:,:,15));
%     phase_diff_ant1_3_1=temp(3,:)-temp(1,:);
%     temp=squeeze(avg_phase(:,:,16));
%     phase_diff_ant1_3_2=temp(3,:)-temp(1,:);
%     Phoff4(2,:)=(phase_diff_ant1_3_1+phase_diff_ant1_3_2)./2;
%      % calculate the ant2 and ant3 phase error in NIC4
%     Phoff4(2,:)=Phoff4(2,:)-Phoff4(1,:);
%     Phoff(:,:,4)=Phoff4;
end

