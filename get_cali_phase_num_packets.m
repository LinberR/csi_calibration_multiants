function [ Phoff1,Phoff2 ] = get_cali_phase_average( ap_num  )
%%% 此函数是计算天线之间的相位偏移随着数据包数目的变化分布；
    count=1;
    
    for j=1:2
        for k=1:2       
            csilist=['calibration/csi_cali2_',num2str(j),'3_',num2str(k),'_','20191201.dat'];  % 第j个AP收到的第i个位置的CSI
            csi_trace=read_bf_file(csilist);
            len=length(csi_trace);
            for i=1:5
                phase_ant1=[];
                phase_ant2=[];
                phase_ant3=[];
                
                for kk=1:(i*100) %len-1
                     [amp,phase]=get_amp_phase_from_csi(csi_trace{kk});
                     phase_ant1=[phase_ant1;phase(1,:)];
                     phase_ant2=[phase_ant2;phase(2,:)];
                     phase_ant3=[phase_ant3;phase(3,:)];             
                end 
                avg_phase_ant1(i,:)=mean(phase_ant1);
                avg_phase_ant2(i,:)=mean(phase_ant2);
                avg_phase_ant3(i,:)=mean(phase_ant3);    
%                 figure(102);
%                 plot( avg_phase_ant1(i,:)-avg_phase_ant3(i,:),'--*r','MarkerSize',5,'LineWidth',1);hold on;
%                 plot( avg_phase_ant2(i,:)-avg_phase_ant3(i,:),'--*r','MarkerSize',5,'LineWidth',1);hold off;
            end
            avg_phase(:,:,count)=[avg_phase_ant1;avg_phase_ant2;avg_phase_ant3];
            count=count+1;
        end     
    end

    % Standard phase is based on ant3 
    % calculate the ant1 and ant3 phase error
    temp=squeeze(avg_phase(:,:,1));
    for i=1:5
        phase_diff_ant1_3_1(i,:)=temp(i,:)-temp(10+i,:);
    end
    temp=squeeze(avg_phase(:,:,2));
    for i=1:5
        phase_diff_ant1_3_2(i,:)=temp(i,:)-temp(10+i,:);
    end
    for i=1:5
        Phoff1(i,:)=(phase_diff_ant1_3_1(i,:)+phase_diff_ant1_3_2(i,:))./2;
    end
    
     % calculate the ant2 and ant3 phase error
    temp=squeeze(avg_phase(:,:,3));
    for i=1:5
        phase_diff_ant2_3_1(i,:)=temp(5+i,:)-temp(10+i,:);
    end
    temp=squeeze(avg_phase(:,:,4));
    for i=1:5
        phase_diff_ant2_3_2(i,:)=temp(5+i,:)-temp(10+i,:);
    end
    
    for i=1:5
        Phoff2(i,:)=(phase_diff_ant2_3_1(i,:)+phase_diff_ant2_3_2(i,:))./2;
    end
    
    figure(100);
    plot(Phoff1(1,:),'--*r','MarkerSize',5,'LineWidth',1);hold on;
    plot(Phoff1(2,:),'--*g','MarkerSize',5,'LineWidth',1);hold on;
    plot(Phoff1(3,:),'--*b','MarkerSize',5,'LineWidth',1);hold on;
    plot(Phoff1(4,:),'--*m','MarkerSize',5,'LineWidth',1);hold on;
    plot(Phoff1(5,:),'--*k','MarkerSize',5,'LineWidth',1);hold on;
    title('Phase offset between ant1 and ant3','FontSize',16);
    xlabel('subcarrier index','FontSize',16);
    ylabel('phase offsets','FontSize',16);
    legend('100 packets','200 packets','300 packets','400 packets','500 packets','FontSize',12);
    hold off;

    figure(101);
    plot(Phoff2(1,:),'--*r','MarkerSize',5,'LineWidth',1);hold on;
    plot(Phoff2(2,:),'--*g','MarkerSize',5,'LineWidth',1);hold on;
    plot(Phoff2(3,:),'--*b','MarkerSize',5,'LineWidth',1);hold on;
    plot(Phoff2(4,:),'--*m','MarkerSize',5,'LineWidth',1);hold on;
    plot(Phoff2(5,:),'--*k','MarkerSize',5,'LineWidth',1);hold on;
    title('Phase offset between ant2 and ant3','FontSize',16);
    xlabel('subcarrier index','FontSize',16);
    ylabel('phase offsets','FontSize',16);
    legend('100 packets','200 packets','300 packets','400 packets','500 packets','FontSize',12);
    hold off;
    
    
    
    
%     % calculate the ant2 and ant3 phase error
%     temp=squeeze(avg_phase(:,:,3));
%     for i=1:10
%         phase_diff_ant2_3_1(i,:)=temp(10+i,:)-temp(20+i,:);
%     end
%     temp=squeeze(avg_phase(:,:,4));
%     for i=1:10
%         phase_diff_ant2_3_2(i,:)=temp(10+i,:)-temp(20+i,:);
%     end
%     for i=1:10
%         Phoff2(i,:)=(phase_diff_ant2_3_1(i,:)+phase_diff_ant2_3_2(i,:))./2;
%     end
%     
%     
    
    
    
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

