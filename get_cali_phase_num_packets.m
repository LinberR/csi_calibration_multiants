function [ Phoff1,Phoff2 ] = get_cali_phase_num_packets( ap_num  )
% 此函数是计算天线之间的相位偏移随着数据包数目的变化分布；
%  Phoff1,Phoff2 天线13之间的相位偏移,天线23之间的相位偏移
%  ap_num AP的数目
    count=1;
    count_num=1;
    for j=1:2
        for k=1:2       
            csilist=['calibration/20191203/csi_cali_',num2str(j),'3_',num2str(k),'_','20191203.dat'];  % 第j个AP收到的第i个位置的CSI
%             csilist=['csi_cali_diff_length12.dat'];
            csi_trace=read_bf_file(csilist);
            len=length(csi_trace);
            for i=1:5
                phase_ant1=[];
                phase_ant2=[];
                phase_ant3=[];
%                 figure();
                for kk=1:i*100 %len-1                   
                     [amp,phase,success]=get_amp_phase_from_csi(csi_trace{kk});
                     if success==0
                         continue;
                     end
                     phase_ant1=[phase_ant1;phase(1,:)];
                     phase_ant2=[phase_ant2;phase(2,:)];
                     phase_ant3=[phase_ant3;phase(3,:)];                        
%                      if j==1
%                         index=1:30;
%                         plot(index,phase(1,:)-phase(3,:),'b.-'); hold on;
%                      end
%                      if j==2
%                         index=1:30;
%                         plot(index,phase(2,:)-phase(3,:),'r.-'); hold on;
%                      end                         
                end 
%                 xlabel('子载波编号','FontSize',20);
%                 ylabel('天线之间的子载波相位偏差','FontSize',20);
%                 set((legend('子载波在天线1的相位','子载波在天线2的相位','子载波在天线3的相位')),'FontSize',15);
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
    figure();
    for i=1:5
        phase_diff_ant1_3_1(i,:)=temp(i,:)-temp(10+i,:);
%         plot(1:30,temp(i,:),'*-',1:30,temp(10+i,:),'.-');hold on;
        plot(1:30,phase_diff_ant1_3_1(i,:),'^-');hold on;
    end
    hold off;
    xlabel('子载波序号','FontSize',20);
    ylabel('天线1和天线3之间的相位偏移','FontSize',20);
    set(legend('100 packets','200 packets','300 packets','400 packets','500 packets'),'FontSize',15);
    
    hold off;
    
    temp=squeeze(avg_phase(:,:,2));
    figure();
    for i=1:5
        phase_diff_ant1_3_2(i,:)=temp(i,:)-temp(10+i,:);
%         plot(1:30,temp(i,:),'*-',1:30,temp(10+i,:),'.-');hold on;
        plot(1:30,phase_diff_ant1_3_2(i,:),'^-');hold on;
    end
    hold off;
    xlabel('子载波序号','FontSize',20);
    ylabel('反接后的天线1和天线3之间的相位偏移','FontSize',20);
    set(legend('100 packets','200 packets','300 packets','400 packets','500 packets'),'FontSize',15);
    
    figure();
    for i=1:5
        Phoff1(i,:)=(phase_diff_ant1_3_1(i,:)+phase_diff_ant1_3_2(i,:))./2;
        plot(1:30,Phoff1(i,:),'^-');hold on;
    end
    hold off;
    xlabel('子载波序号','FontSize',20);
    ylabel('计算后天线1和天线3之间的相位偏移','FontSize',20);
    set(legend('100 packets','200 packets','300 packets','400 packets','500 packets'),'FontSize',15);
    
     % calculate the ant2 and ant3 phase error
    temp=squeeze(avg_phase(:,:,3));
    figure();
    for i=1:5
        phase_diff_ant2_3_1(i,:)=temp(5+i,:)-temp(10+i,:);
%         plot(1:30,temp(5+i,:),'*-',1:30,temp(10+i,:),'.-');hold on;
        plot(1:30,phase_diff_ant2_3_1(i,:),'^-');hold on;
    end
    hold off;
    xlabel('子载波序号','FontSize',20);
    ylabel('天线2和天线3之间的相位偏移','FontSize',20);
    set(legend('100 packets','200 packets','300 packets','400 packets','500 packets'),'FontSize',15);
    
    temp=squeeze(avg_phase(:,:,4));
    figure();
    for i=1:5
        phase_diff_ant2_3_2(i,:)=temp(5+i,:)-temp(10+i,:);
%         plot(1:30,temp(5+i,:),'*-',1:30,temp(10+i,:),'.-');hold on;
        plot(1:30,phase_diff_ant2_3_2(i,:),'^-');hold on;
    end
    hold off;
    xlabel('子载波序号','FontSize',20);
    ylabel('反接后天线2和天线3之间的相位偏移','FontSize',20);
    set(legend('100 packets','200 packets','300 packets','400 packets','500 packets'),'FontSize',15);
    
    figure();
    for i=1:5
        Phoff2(i,:)=(phase_diff_ant2_3_1(i,:)+phase_diff_ant2_3_2(i,:))./2;
        plot(1:30,Phoff2(i,:),'^-');hold on;
    end
    hold off;
    xlabel('子载波序号','FontSize',20);
    ylabel('计算后天线2和天线3之间的相位偏移','FontSize',20);
    
    set(legend('100 packets','200 packets','300 packets','400 packets','500 packets'),'FontSize',15);
    
    
    figure(300);
    plot(Phoff1(1,:),'--*r','MarkerSize',5,'LineWidth',1);hold on;
    plot(Phoff1(2,:),'--*g','MarkerSize',5,'LineWidth',1);hold on;
    plot(Phoff1(3,:),'--*b','MarkerSize',5,'LineWidth',1);hold on;
    plot(Phoff1(4,:),'--*m','MarkerSize',5,'LineWidth',1);hold on;
    plot(Phoff1(5,:),'--*k','MarkerSize',5,'LineWidth',1);hold on;
    title('Phase offset between ant1 and ant3','FontSize',16);
    
    xlabel('子载波序号','FontSize',16);
    ylabel('天线1和天线2之间的相位偏差','FontSize',16);
    axis([1, 30, -3, 3]);
    set(legend('100 packets','200 packets','300 packets','400 packets','500 packets'),'FontSize',12);
    hold off;

    figure(301);
    plot(Phoff2(1,:),'--*r','MarkerSize',5,'LineWidth',1);hold on;
    plot(Phoff2(2,:),'--*g','MarkerSize',5,'LineWidth',1);hold on;
    plot(Phoff2(3,:),'--*b','MarkerSize',5,'LineWidth',1);hold on;
    plot(Phoff2(4,:),'--*m','MarkerSize',5,'LineWidth',1);hold on;
    plot(Phoff2(5,:),'--*k','MarkerSize',5,'LineWidth',1);hold on;
    title('Phase offset between ant2 and ant3','FontSize',16);
    xlabel('子载波序号','FontSize',16);
    ylabel('天线2和天线3之间的相位偏差','FontSize',16);
    axis([1, 30, -3, 3]);
    set(legend('100 packets','200 packets','300 packets','400 packets','500 packets'),'FontSize',12);
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

