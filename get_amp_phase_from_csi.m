function [ amp,phase ] = get_amp_phase_from_csi( csi_trace )

    csi_entry = csi_trace;
    csi=squeeze(get_scaled_csi(csi_entry));
    original_phase=angle(csi);
    phase=unwrap(angle(csi));
    % amp csi矩阵的膜
    amp=abs(csi);
    % 返回phase数组中的元素数目
    num=numel(phase);
    if num>90
        phase=squeeze(phase(1,:,:));
        amp=squeeze(amp(1,:,:));
    end
    
end

