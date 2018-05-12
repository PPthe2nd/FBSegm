clear all

bah = 1;
for i=1:1750 
    clear index; 
    index = find(index_train ==i); 
    if isempty(index) == 0 
        training1(bah,:) = dataTrnS1(:,i); 
        bah = bah+1;
    end
end

bah = 1;
for i=1:1750
    clear index; 
    index = find(index_train ==i); 
    if isempty(index) == 0 
        training2(bah,:) = dataTrnS2(:,i); 
        bah = bah+1;
    end
end

 bah = 1;
for i=1:120
    clear index; 
    index = find(index_val ==i); 
    if isempty(index) == 0 
        val2(bah,:) = dataValS2(:,i); 
        bah = bah+1;
    end
end

bah = 1;
for i=1:120
    clear index; 
    index = find(index_val ==i); 
    if isempty(index) == 0 
        val1(bah,:) = dataValS1(:,i); 
        bah = bah+1;
    end
end

berk_respS1 = [training1' val1'];
berk_respS2 = [training2' val2'];

ind_v1 = 1;
ind_v2 = 1;
ind_v3 = 1;
ind_v3a = 1;
ind_v3b = 1;
ind_v4 = 1;
ind_loc = 1;

for i=1:size(berk_respS1,1)
    
    if isnan(berk_respS1(i,:)) ~= 1
    
        if roiS1(i) == 1
            response.V1.s1(ind_v1,:) = berk_respS1(i,:);
            ind_v1 = ind_v1+1;
        elseif roiS1(i) == 2
            response.V2.s1(ind_v2,:) = berk_respS1(i,:);
            ind_v2 = ind_v2+1;
        elseif roiS1(i) == 3
            response.V3.s1(ind_v3,:) = berk_respS1(i,:);
            ind_v3 = ind_v3+1;
        elseif roiS1(i) == 4
            response.V3A.s1(ind_v3a,:) = berk_respS1(i,:);
            ind_v3a = ind_v3a+1;
        elseif roiS1(i) == 5
            response.V3B.s1(ind_v3b,:) = berk_respS1(i,:);
            ind_v3b = ind_v3b+1;
        elseif roiS1(i) == 6
            response.V4.s1(ind_v4,:) = berk_respS1(i,:);
            ind_v4 = ind_v4+1;
        elseif roiS1(i) == 7
            response.LOC.s1(ind_loc,:) = berk_respS1(i,:);
            ind_loc = ind_loc+1;
        end
    end
   
end


ind_v1 = 1;
ind_v2 = 1;
ind_v3 = 1;
ind_v3a = 1;
ind_v3b = 1;
ind_v4 = 1;
ind_loc = 1;

for i=1:size(berk_respS2,1)
    
    if isnan(berk_respS2(i,:)) ~= 1
    
        if roiS2(i) == 1
            response.V1.s2(ind_v1,:) = berk_respS2(i,:);
            ind_v1 = ind_v1+1;
        elseif roiS2(i) == 2
            response.V2.s2(ind_v2,:) = berk_respS2(i,:);
            ind_v2 = ind_v2+1;
        elseif roiS2(i) == 3
            response.V3.s2(ind_v3,:) = berk_respS2(i,:);
            ind_v3 = ind_v3+1;
        elseif roiS2(i) == 4
            response.V3A.s2(ind_v3a,:) = berk_respS2(i,:);
            ind_v3a = ind_v3a+1;
        elseif roiS2(i) == 5
            response.V3B.s2(ind_v3b,:) = berk_respS2(i,:);
            ind_v3b = ind_v3b+1;
        elseif roiS2(i) == 6
            response.V4.s2(ind_v4,:) = berk_respS2(i,:);
            ind_v4 = ind_v4+1;
        elseif roiS2(i) == 7
            response.LOC.s2(ind_loc,:) = berk_respS2(i,:);
            ind_loc = ind_loc+1;
        end
    end
   
end


% V1
V1_s1 = pdist(response.V1.s1','correlation');
V1_s2 = pdist(response.V1.s2','correlation');

RDMs.V1(:,:,1) = squareform(V1_s1);
RDMs.V1(:,:,2) = squareform(V1_s2);

RDMs_medio.V1 = sum(RDMs.V1,3)./2;

% V2
V2_s1 = pdist(response.V2.s1','correlation');
V2_s2 = pdist(response.V2.s2','correlation');

RDMs.V2(:,:,1) = squareform(V2_s1);
RDMs.V2(:,:,2) = squareform(V2_s2);

RDMs_medio.V2 = sum(RDMs.V2,3)./2;

% V3
V3_s1 = pdist(response.V3.s1','correlation');
V3_s2 = pdist(response.V3.s2','correlation');

RDMs.V3(:,:,1) = squareform(V3_s1);
RDMs.V3(:,:,2) = squareform(V3_s2);

RDMs_medio.V3 = sum(RDMs.V3,3)./2;

% V3A
V3A_s1 = pdist(response.V3A.s1','correlation');
V3A_s2 = pdist(response.V3A.s2','correlation');

RDMs.V3A(:,:,1) = squareform(V3A_s1);
RDMs.V3A(:,:,2) = squareform(V3A_s2);

RDMs_medio.V3A = sum(RDMs.V3A,3)./2;

% V3AB
V3B_s1 = pdist(response.V3B.s1','correlation');
V3B_s2 = pdist(response.V3B.s2','correlation');

RDMs.V3B(:,:,1) = squareform(V3B_s1);
RDMs.V3B(:,:,2) = squareform(V3B_s2);

RDMs_medio.V3B = sum(RDMs.V3B,3)./2;

% V4
V4_s1 = pdist(response.V4.s1','correlation');
V4_s2 = pdist(response.V4.s2','correlation');

RDMs.V4(:,:,1) = squareform(V4_s1);
RDMs.V4(:,:,2) = squareform(V4_s2);

RDMs_medio.V4 = sum(RDMs.V4,3)./2;

% LOC
LOC_s1 = pdist(response.LOC.s1','correlation');
LOC_s2 = pdist(response.LOC.s2','correlation');

RDMs.LOC(:,:,1) = squareform(LOC_s1);
RDMs.LOC(:,:,2) = squareform(LOC_s2);

RDMs_medio.LOC = sum(RDMs.LOC,3)./2;

save('RDMs_medio.mat','RDMs_medio')
pause(2)
clear all