function [ amp,phase,success ] = get_amp_phase_from_csi( csi_trace )

    csi_entry = csi_trace;
    csi=squeeze(get_scaled_csi(csi_entry));
    original_phase=angle(csi);
    success=0;
%     figure();
%     index=1:30;
%     plot(index,original_phase(1,:),'b-',index,original_phase(2,:),'r-o',index,original_phase(3,:),'g-*');
%     xlabel('���ز����','FontSize',20);
%     ylabel('���ز���λ','FontSize',20);
%     original_phase(1,:)
%     set((legend('���ز�������1����λ','���ز�������2����λ','���ز�������3����λ')),'FontSize',15);

    phase=unwrap(original_phase,pi,2);  %��ʾ�Ծ�����н��н���Ʋ�������������������ȱ�٣�
    amp=abs(csi);   % amp csi�����Ĥ
    
    num=numel(phase);  % ����phase�����е�Ԫ����Ŀ
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
    %���ƽ���Ʋ��������ز��ڲ�ͬ���ߴ�����λ
%     figure();
%     index=1:30;
%     plot(index,phase(1,:),'b-',index,phase(2,:),'r-o',index, phase(3,:),'g-*');
%     xlabel('���ز����','FontSize',20);
%     ylabel('���ز���λ','FontSize',20);
%     set((legend('���ز�������1����λ','���ز�������2����λ','���ز�������3����λ')),'FontSize',15); 
    
end

