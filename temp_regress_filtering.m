clear all
%addpath(genpath('/DATA/Lab/STRUMENTI/MATLAB/'));

load('feats_cntr_back.mat')
load('feats_cntr_fore.mat')
load('feats_high_back.mat')
load('feats_high_fore.mat')
load('feats_low_back.mat')
load('feats_low_fore.mat')
load('RDMs_medio.mat')

for step = 1:4
    reg = 1;
        steps(step,reg,:,:) = [feats_cntr_fore{6-step}; feats_low_fore{6-step}; feats_high_fore{step+1}];
    reg = 2;
        steps(step,reg,:,:) = [feats_cntr_back{6-step}; feats_low_back{6-step}; feats_high_back{step+1}];
end

names = {'V1','V2','V3','V3A','V3B','V4','LOC'};
rng(21)
indices = crossvalind('KFold',55611);
for step = 1:4
    for reg = 1:2
        clear step_temp_all
        step_temp_all = squeeze(steps(step,reg,:,:));
        for f = 1:3
            clear step_temp
            step_temp = step_temp_all(f*4-3:f*4,:);
            for cv = 1:5
                clear ind_perm ind_perm_ts y_temp
                ind_perm = (indices ~= cv);
                ind_perm_ts = (indices == cv);
                x_weigth = step_temp(:,ind_perm)';
                x_weigth = x_weigth-mean(x_weigth);
                x_weigth_ts = step_temp(:,ind_perm_ts)';
                x_weigth_ts = x_weigth_ts-mean(x_weigth_ts);
                for roi = 1:7
                    clear name_temp y_temp y_brain y_brain_ts B STATS weight_cv
                    name_temp = names{roi};
                    y_temp = squareform(RDMs_medio.(name_temp))';
                    y_brain = y_temp(ind_perm);
                    y_brain = y_brain-mean(y_brain);
                    y_brain_ts = y_temp(ind_perm_ts);
                    y_brain_ts = y_brain_ts-mean(y_brain_ts);

                    B = regress(y_brain,x_weigth);

                    betas_weigth_step(step,reg,f,cv,roi,:) = B;

                    weigth_cv = B'*x_weigth_ts';

                    r_test_modello_step(step,reg,f,cv,roi) = corr(y_brain_ts,weigth_cv','type','Spearman');
                end
            end
        end
    end
end


load('results_nette_regress_demean_boot_perm_retest.mat', 'corrs_weigth','boots_weigth')
load('colormap_figa.mat')
for i = 1:7
    for f = 1:3
        figure;imagesc(squeeze(mean(betas_weigth_step(:,1,f,:,i,:),4))); caxis([-.1 .1]); colormap(cmap)
        figure;imagesc(squeeze(mean(betas_weigth_step(:,2,f,:,i,:),4))); caxis([-.1 .1]); colormap(cmap)
    end
end

for roi =1:7
    for f = 1:3
        series_b{roi,f} = [(mean(corrs_weigth{1}(:,roi)));(squeeze(mean(r_test_modello_step(:,2,f,:,roi),4)));(mean(corrs_weigth{2}(:,roi)))];
        series_f{roi,f} = [(mean(corrs_weigth{1}(:,roi)));(squeeze(mean(r_test_modello_step(:,1,f,:,roi),4)));(mean(corrs_weigth{3}(:,roi)))];
    end
end

load('Boot_rois_snr_1000_OK.mat')

for i = 1:7
    ceil_std(i) = std(Boot{i});
    ceil_mean(i) = mean(Boot{i});
end

for f = 1:3
    figure;
    for roi = 1:7
        subplot(1,7,roi)
        plot(series_b{roi,f});
        hold on;
        plot(series_f{roi,f});
        errorbar(ones([1 6]).*ceil_mean(roi)',ones([1 6]).*ceil_std(roi))
        ylim([0 .12]);xlim([.5 6.5])
    end
end

% You can be satisfied with that, or you can compute also bootsrapped CIs
% and significance

%If satisfied: start commenting here!!

rng(21)
for i = 1:1000
    boot_ind(i,:) = randi(11122,[1 11122]);
end

parfor z = 1:1000
    warning off
    for step = 1:4
        for reg = 1:2
            %clear step_temp_all step_temp
            step_temp_all = squeeze(steps(step,reg,:,:));
            for f = 1:3
                %clear step_temp
                step_temp = step_temp_all(f*4-3:f*4,:);
                for cv = 1:5
                    %                 clear ind_perm ind_perm_ts y_temp
                    ind_perm = (indices ~= cv);
                    ind_perm_ts = (indices == cv);
                    x_weigth = step_temp(:,ind_perm)';
                    x_weigth = x_weigth-mean(x_weigth);
                    x_weigth_ts = step_temp(:,ind_perm_ts)';
                    for roi = 1:7
                        %                     clear name_temp y_temp y_brain y_brain_ts B STATS weight_cv
                        boot_temp = (boot_ind(z,:));
                        name_temp = names{roi};
                        y_temp = squareform(RDMs_medio.(name_temp))';
                        y_brain = y_temp(ind_perm);
                        y_brain = y_brain-mean(y_brain);
                        y_brain_ts = y_temp(ind_perm_ts);

                        B = regress(y_brain,x_weigth);

                        betas_weigth_boot(z,step,reg,f,cv,roi,:) = B;

                        weigth_cv = B'*x_weigth_ts';

                        r_test_modello_boot(z,step,reg,f,cv,roi) = corr(y_brain_ts(boot_temp),weigth_cv(boot_temp)','type','Spearman');
                    end
                end
            end
        end
    end
end


for roi =1:7
    for f = 1:3
        series_boot_b{roi,f} = [(std(mean(boots_weigth{1}(:,:,roi),2)));(squeeze(std(mean(r_test_modello_boot(:,:,2,f,:,roi),5))))';(std(mean(boots_weigth{2}(:,:,roi),2)))];
        series_boot_f{roi,f} = [(std(mean(boots_weigth{1}(:,:,roi),2)));(squeeze(std(mean(r_test_modello_boot(:,:,1,f,:,roi),5))))';(std(mean(boots_weigth{3}(:,:,roi),2)))];
    end
end

for f = 1:3
    figure;
    for roi = 1:7
        subplot(1,7,roi)
        errorbar(series_b{roi,f},series_boot_b{roi,f});
        hold on;
        errorbar(series_f{roi,f},series_boot_f{roi,f});
        errorbar(ones([1 6]).*ceil_mean(roi)',ones([1 6]).*ceil_std(roi))
        ylim([0 .12]);xlim([.5 6.5])
    end
end

load('distro_nulla_Null_1000_snr_V1V2.mat', 'Null')

nperms = 1000;
parfor z = 1:nperms
    for step = 1:4
        for reg = 1:2
            %clear step_temp_all step_temp
            step_temp_all = squeeze(steps(step,reg,:,:));
            for f = 1:3
                %clear step_temp
                step_temp = step_temp_all(f*4-3:f*4,:);
                for cv = 1:5
                    %                 clear ind_perm ind_perm_ts y_temp
                    ind_perm = (indices ~= cv);
                    ind_perm_ts = (indices == cv);
                    x_weigth = step_temp(:,ind_perm)';
                    x_weigth = x_weigth-mean(x_weigth);
                    x_weigth_ts = step_temp(:,ind_perm_ts)';
                    for roi = 1:7
                        name1 = names{roi};
                        nullo = Null.(name1)(z,:);
                        y_nullo = nullo(ind_perm)-mean(nullo(ind_perm));
                        y_nullo_ts = nullo(ind_perm_ts);

                        B = regress(y_nullo',x_weigth);

                        betas_weigth_perm(z,step,reg,f,cv,roi,:) = B;

                        weigth_cv = B'*x_weigth_ts';

                        r_test_modello_perm(z,step,reg,f,cv,roi) = corr(y_nullo_ts',weigth_cv','type','Spearman');

                    end
                end
            end
        end
    end
end

for step = 1:4
    for reg = 1:2
        for f = 1:3
            for roi = 1:7
                temp_perm = squeeze(mean(r_test_modello_perm(:,:,:,f,:,:),5));
                temp_perm_sort = squeeze(temp_perm(:,step,reg,roi));
                temp_perm_sort = sort(temp_perm_sort);
                step_temp = squeeze(mean(r_test_modello_step(step,reg,f,:,roi),4));
                if isempty(find(temp_perm_sort(temp_perm_sort >= step_temp))) == 1
                    pvals_step(step,reg,roi,f) = 0;
                else
                    p_temp = max(find(temp_perm_sort(temp_perm_sort >= step_temp)));
                    pvals_step(step,reg,roi,f) = (1/nperms*p_temp);
                end
            end
        end
    end
end

%Stop commenting here!!

save results_regress_filt_separati.mat