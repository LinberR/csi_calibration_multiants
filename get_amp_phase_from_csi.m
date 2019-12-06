function [ amp,phase,success ] = get_amp_phase_from_csi( csi_trace )

    csi_entry = csi_trace;
    csi=squeeze(get_scaled_csi(csi_entry));
    original_phase=angle(csi);
    success=0;
%     figure();
%     index=1:30;
%     plot(index,original_phase(1,:),'b-',index,original_phase(2,:),'r-o',index,original_phase(3,:),'g-*');
%     xlabel('子载波编号','FontSize',20);
%     ylabel('子载波相位','FontSize',20);
%     original_phase(1,:)
%     set((legend('子载波在天线1的相位','子载波在天线2的相位','子载波在天线3的相位')),'FontSize',15);

    phase=unwrap(original_phase,pi,2);  %表示对矩阵的行进行解卷绕操作，第三个参数不能缺少！
    amp=abs(csi);   % amp csi矩阵的膜
    
    num=numel(phase);  % 返回phase数组中的元素数目
    if num>90
        success=0;
        return;
    end
    
    p=polyfit(1:30,phase(3,:),1);
    if p(1) >= -0.5
        success=0;
    else 
        success=1;
    end
    %绘制解卷绕操作后子载波在不同天线处的相位
%     figure();
%     index=1:30;
%     plot(index,phase(1,:),'b-',index,phase(2,:),'r-o',index, phase(3,:),'g-*');
%     xlabel('子载波编号','FontSize',20);
%     ylabel('子载波相位','FontSize',20);
%     set((legend('子载波在天线1的相位','子载波在天线2的相位','子载波在天线3的相位')),'FontSize',15); 
    
end

