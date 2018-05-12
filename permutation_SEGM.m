% Script per il permutation delle segmentazioni

clear all
warning off

load('index_all.mat')
load('Berk_stimuli.mat')
load('RDMs_medio.mat')

ordine = zeros([1000 334]);
rng(21)
for i = 1:1000
    ordine(i,:) = randperm(334);
end

parpool(6)

for permutazio = 1:1000
    tic
    clear ind_perm GIST_feat PHOG_feat LBP_feat RDM_gist RDM_phog RDM_lbp n_gist n_phog n_lbp n_app corr_rois_temp filename_temp_corr
    ind_perm = index_all(ordine(permutazio,:));

    parfor pic=1:334

        %clear eh prova bingo Img Img1 name g p l

        eh = ind_perm(pic);
        name = strcat('stim',mat2str(index_all(pic)));
        name_perm = strcat('stim',mat2str(eh));
        stim = Berk.(name);
        perm_segm = Shape.(name_perm);
        perm_stim = stim.*perm_segm;
        good_stim = stim.*(Shape.(name));
        rsm_orig = sqrt(sum(good_stim(:).^2));
        rsm_new = sqrt(sum(perm_stim(:).^2));
        rsm_fin = rsm_orig/rsm_new;
        perm_stim = perm_stim.*rsm_fin;

        param = [];
        param.imageSize = [256 256]; % it works also with non-square images
        param.orientationsPerScale = [8 8 8 8];
        param.numberBlocks = 4;
        param.fc_prefilt = 4;

        bin = 40;
        angle = 360;
        L=4;
        roi = [1;300;1;300];

        Img = mat2gray(perm_stim);
        Img1 = single(vl_imdown(Img)) ;
        p = anna_phog(Img,bin,angle,L,roi);
        [f,d] = vl_dsift(Img1,'size',78,'Fast');
        l = lbp(Img);
        [g, param] = LMgist(Img, '', param);
        GIST_feat(pic,:) = g;
        DSIFT_feat(pic,:) = d(:)';
        PHOG_feat(pic,:) = p;
        LBP_feat(pic,:) = l;

%         Stim_perm.(name_perm).(name) = bingo;
    end

%     Feats.(name_perm).Gist = GIST_feat;
%     Feats.(name_perm).Dsift = DENSE;
%     Feats.(name_perm).Phog = PHOG_feat;
%     Feats.(name_perm).Lbp = LBP_feat;

    RDM_gist = pdist(GIST_feat,'correlation');
    RDM_phog = pdist(PHOG_feat,'correlation');
    RDM_lbp = pdist(LBP_feat,'correlation');
    RDM_dsift = pdist(DSIFT_feat,'correlation');

    n_gist = (RDM_gist - min(RDM_gist))/(max(RDM_gist) - min(RDM_gist));
    n_lbp = (RDM_lbp - min(RDM_lbp))/(max(RDM_lbp) - min(RDM_lbp));
    n_phog = (RDM_phog - min(RDM_phog))/(max(RDM_phog) - min(RDM_phog));
    n_dsift = (RDM_dsift - min(RDM_dsift))/(max(RDM_dsift) - min(RDM_dsift));

    n_app = ([n_phog;n_gist;n_lbp;n_dsift]);

    names = {'V1','V2','V3','V3A','V3B','V4','LOC'};
    rng(21)
    indices = crossvalind('KFold',55611);
    for cv = 1:5
        clear ind_perm ind_perm_ts y_temp
        ind_perm = (indices ~= cv);
        ind_perm_ts = (indices == cv);
        x_weigth = n_app(:,ind_perm)';
        x_weigth = x_weigth-mean(x_weigth);
        x_weigth_ts = n_app(:,ind_perm_ts)';
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

            betas_weigth(permutazio,cv,roi,:) = B;
            weigth_cv = B'*x_weigth_ts';

            r_test_modello_all(permutazio,cv,roi) = corr(y_brain_ts,weigth_cv','type','Spearman');
        end
    end

    permutazio
    toc
end
pause(2)
save('tutto_segm_perm_rms_good.mat','r_test_modello_all','betas_weigth');
pause(5)
clear all
