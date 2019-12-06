function [ Phoff1,Phoff2 ] = get_cali_phase_NICs( ap_num  )
% 计算不同网卡的天线之间相位偏移
%  
%  ap_num AP的数目
    channel=[36,44,52,60];
    count=1;
    num_groups=100; %实验分组数目
    packets_per_group=100; %每组实验中的数据包数目
    for j=2:2
        for k=1:2     
            csilist=['calibration/20191205_1/csi_cali_23_1_channel_44_NIC',num2str(k),'.dat']; 
            csi_trace=read_bf_file(csilist);
            len=length(csi_trace);
            for i=1:1
                phase_ant1=[];
                phase_ant2=[];
                phase_ant3=[];
                
                for kk=1:i*100 %len-1
                     [amp,phase,success]=get_amp_phase_from_csi(csi_trace{kk});
                     if success==0
                         continue;
                     end
                     phase_ant1=[phase_ant1;phase(1,:)];
                     phase_ant2=[phase_ant2;phase(2,:)];
                     phase_ant3=[phase_ant3;phase(3,:)];  
                     if k==1
                        h1=plot(1:30,phase(2,:)-phase(3,:),'*b-');
                     end
                     if k==2
                        h2=plot(1:30,phase(2,:)-phase(3,:),'.r-');
                     end
                     hold on;
                end 
                avg_phase_ant1(i,:)=mean(phase_ant1);
                avg_phase_ant2(i,:)=mean(phase_ant2);
                avg_phase_ant3(i,:)=mean(phase_ant3);               
            end
            
            avg_phase(:,:,count)=[avg_phase_ant1;avg_phase_ant2;avg_phase_ant3];
            count=count+1;
        end   
        hold off;
        title('NIC1 and NIC2','FontSize',20);          
        xlabel('子载波编号','FontSize',20);
        ylabel('天线2和天线3之间的子载波相位偏差','FontSize',20);
        set(legend([h1,h2],'NIC1','NIC2'),'FontSize',15);
    end

    % Standard phase is based on ant3 
    % calculate the ant1 and ant3 phase error
    temp=squeeze(avg_phase(:,:,1));
    for i=1:num_groups
        phase_diff_ant1_3_1(i,:)=temp(i,:)-temp(2*packets_per_group+i,:);
    end
    temp=squeeze(avg_phase(:,:,2));
    for i=1:num_groups
        phase_diff_ant1_3_2(i,:)=temp(i,:)-temp(2*packets_per_group+i,:);
    end
    for i=1:num_groups
        Phoff1(i,:)=(phase_diff_ant1_3_1(i,:)+phase_diff_ant1_3_2(i,:))./2;
    end
    % calculate the ant2 and ant3 phase error
    temp=squeeze(avg_phase(:,:,3));
    for i=1:num_groups
        phase_diff_ant2_3_1(i,:)=temp(packets_per_group+i,:)-temp(2*packets_per_group+i,:);
    end
    temp=squeeze(avg_phase(:,:,4));
    for i=1:num_groups
        phase_diff_ant2_3_2(i,:)=temp(packets_per_group+i,:)-temp(2*packets_per_group+i,:);
    end
    
    for i=1:num_groups
        Phoff2(i,:)=(phase_diff_ant2_3_1(i,:)+phase_diff_ant2_3_2(i,:))./2;
    end
    
    figure(100);
%     plot(mean(Phoff1,2),'--*r','MarkerSize',5,'LineWidth',1);hold on;
    plot(mean(Phoff2,2),'--*b','MarkerSize',5,'LineWidth',1);hold on;
%     plot(Phoff1(1,:),'--*r','MarkerSize',5,'LineWidth',1);hold on;
%     plot(Phoff1(2,:),'--*g','MarkerSize',5,'LineWidth',1);hold on;
%     plot(Phoff1(3,:),'--*b','MarkerSize',5,'LineWidth',1);hold on;
%     plot(Phoff1(4,:),'--*m','MarkerSize',5,'LineWidth',1);hold on;
%     plot(Phoff1(5,:),'--*k','MarkerSize',5,'LineWidth',1);hold on;
    title('Phase offset average on 30 subcarriers between ants','FontSize',16);
    xlabel('Experiment index','FontSize',16);
    ylabel('phase offsets','FontSize',16);
    set(legend('phase offsets between ant1 and ant3','phase offsets between ant2 and ant3'),'FontSize',12);
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

