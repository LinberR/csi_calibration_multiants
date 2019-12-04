function [Phoff1_2,Phoff1_3]=cali_arrayTrack(APi)%返回天线2和天线1的差值，天线3和天线1的差值
    %csilist={'data_12.11/csi5_data_chen_12.11_cali1-2.dat','data_12.11/csi5_data_chen_12.11_cali1-3.dat','data_12.11/csi5_data_chen_12.11_cali1-2_2.dat','data_12.11/csi5_data_chen_12.11_cali1-3_2.dat'};%12.13
    %csilist={'data_12.14/csi2_12.14_cali1-2.dat','data_12.14/csi2_12.14_cali1-3.dat','data_12.14/csi2_12.14_cali1-2_2.dat','data_12.14/csi2_12.14_cali1-3_2.dat'};%12.14
    %csilist={'data_12.15/csi2_1215_cali1-2_3.dat','data_12.15/csi2_1215_cali1-3_3.dat','data_12.15/csi2_1215_cali1-2_4.dat','data_12.15/csi2_1215_cali1-3_4.dat'};%12.15_closed
    csilist={['data_12.29_cali/csi',num2str(APi),'_cali_1_2.dat'],['data_12.29_cali/csi',num2str(APi),'_cali_1_3.dat'],['data_12.29_cali/csi',num2str(APi),'_cali_2_1.dat'],['data_12.29_cali/csi',num2str(APi),'_cali_3_1.dat']};%12.14
    csi_trace1_2_1=read_bf_file(csilist{1});
    csi_trace1_2_2=read_bf_file(csilist{3});
    csi_trace1_3_1=read_bf_file(csilist{2});
    csi_trace1_3_2=read_bf_file(csilist{4});
    for i=1:2
        if i==1
            csi_entry1_2 = csi_trace1_2_1{125};
            csi_entry1_3 = csi_trace1_3_1{1};
        else
            csi_entry1_2 = csi_trace1_2_2{13};
            csi_entry1_3 = csi_trace1_3_2{1};
        end
        csi1_2=squeeze(get_scaled_csi(csi_entry1_2));
        csi1_3=squeeze(get_scaled_csi(csi_entry1_3));
        num1_2=numel(csi1_2);
        num1_3=numel(csi1_3);
        if num1_2>90
            csi1_2(:,:)=squeeze(csi1_2(1,:,:));
        end
        if num1_3>90
            csi1_3(:,:)=squeeze(csi1_3(1,:,:));
        end
        sample_csi_trace1_2_1=csi1_2(1,:);
        sample_csi_trace1_2_2=csi1_2(2,:);
        phase1_2_1=unwrap(angle(sample_csi_trace1_2_1));
        phase1_2_2=unwrap(angle(sample_csi_trace1_2_2));
        sample_csi_trace1_3_1=csi1_3(1,:);
        sample_csi_trace1_3_2=csi1_3(3,:);
        phase1_3_1=unwrap(angle(sample_csi_trace1_3_1));
        phase1_3_2=unwrap(angle(sample_csi_trace1_3_2));
        phoff1_2=phase1_2_1-phase1_2_2;
        phoff1_3=phase1_3_1-phase1_3_2;
        Phoff_temp1_2(i,:)=phoff1_2;
        Phoff_temp1_3(i,:)=phoff1_3;
    end
    Phoff1_2=(Phoff_temp1_2(1,:)+Phoff_temp1_2(2,:))./2;
    Phoff1_3=(Phoff_temp1_3(1,:)+Phoff_temp1_3(2,:))./2;
end
