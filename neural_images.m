clear all

load('results_nette_regress_demean_boot_perm_retest.mat', 'corrs_weigth')
load('results_regress_filt_separati.mat')
load('Berk_stimuli.mat')
load('index_all.mat')
%addpath(genpath('/DATA/Lab/STRUMENTI/MATLAB/'));

beta_temps = squeeze(mean(betas_weigth_step,3));
for roi =1:7
    for f = 1:3
        series_b{roi,f} = [(mean(corrs_weigth{1}(:,roi)));(squeeze(mean(r_test_modello_step(:,2,f,:,roi),4)));(mean(corrs_weigth{2}(:,roi)))];
        series_f{roi,f} = [(mean(corrs_weigth{1}(:,roi)));(squeeze(mean(r_test_modello_step(:,1,f,:,roi),4)));(mean(corrs_weigth{3}(:,roi)))];
    end
end

for roi = 1:7
    for f = 1:3
        max_b(roi,f) = find(series_b{roi,f} == max(series_b{roi,f}));
        max_f(roi,f) = find(series_f{roi,f} == max(series_f{roi,f}));
    end
end

ranges_con = linspace(0.01,1,6);
ranges_pass = logspace(0.0043,2.698,6);

eh = 7;
name = strcat('stim',mat2str(eh));
pippo = Shape.(name);
genny = Berk.(name);
rsm_orig = sqrt(sum(genny(:).^2));
amin = double(min2(genny));
amax = double(max2(genny));
ciao = [1;2;3;6;7];
ind_ = [7];

name = strcat('stim',mat2str(7));
pippo = Shape.(name);
genny = Berk.(name);
rsm_orig = sqrt(sum(genny(:).^2));
amin = double(min2(genny));
amax = double(max2(genny));
for i = 1:5
    roi = ciao(i);
    clear bin_cB bin_cF b_low bin_low rsm_new_low rsm_fin_low bin_low b_high b_high rsm_new_high rsm_fin_high bin_high background
    if max_b(roi) ~= 1
        %contr
        bin_cB = double(1-pippo);
        bin_cB(bin_cB == 1) = ranges_con(6-max_b(roi,1)+1);
        %low pass
        b_low = imagefilter(genny,constructbutterfilter(500, [0.01 ranges_pass(6-max_b(roi,2)+1)],5));
        bin_low = b_low.*double(1-pippo);
        rsm_new_low = sqrt(sum(bin_low(:).^2));
        rsm_fin_low = rsm_orig/rsm_new_low;
        bin_low = bin_low.*rsm_fin_low;
        %high pass
        b_high = imagefilter(genny,constructbutterfilter(500, [ranges_pass(max_b(roi,2)+1) 500],5)); % [1 ranges(j)] = add high freq; [ranges(j) 500] = add low freq
        bin_high = b_high.*double(1-pippo);
        rsm_new_high = sqrt(sum(bin_high(:).^2));
        rsm_fin_high = rsm_orig/rsm_new_high;
        bin_high = bin_high.*rsm_fin_high;
        %total
        background = (bin_low + bin_high)./2;
    else
        bin_cB = ones([500 500]);
        background = genny.*(1-pippo);
    end
    clear b_low bin_low rsm_new_low rsm_fin_low bin_low b_high b_high rsm_new_high rsm_fin_high bin_high foreground
    if max_f(roi) ~= 1
        %contr
        bin_cF = double(pippo);
        bin_cF(bin_cF == 1) = ranges_con(6-max_f(roi,1)+1);
        %low pass
        b_low = imagefilter(genny,constructbutterfilter(500, [0.01 ranges_pass(6-max_f(roi,2)+1)],5));
        bin_low = b_low.*double(pippo);
        rsm_new_low = sqrt(sum(bin_low(:).^2));
        rsm_fin_low = rsm_orig/rsm_new_low;
        bin_low = bin_low.*rsm_fin_low;
        %high pass
        b_high = imagefilter(genny,constructbutterfilter(500, [ranges_pass(max_f(roi,3)+1) 500],5)); % [1 ranges(j)] = add high freq; [ranges(j) 500] = add low freq
        bin_high = b_high.*double(pippo);
        rsm_new_high = sqrt(sum(bin_high(:).^2));
        rsm_fin_high = rsm_orig/rsm_new_high;
        bin_high = bin_high.*rsm_fin_high;
        %total
        foreground = (bin_low + bin_high)./2;
    else
        bin_cF = ones([500 500]);
        foreground = genny.*(pippo);
    end
    subplot(1,5,i)
    imagesc((bin_cB.*background)+(bin_cF.*foreground));
    colormap(gray);caxis([-.5 .5]); axis square; axis off;
end