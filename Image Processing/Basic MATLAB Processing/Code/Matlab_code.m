curdir=pwd; % curdir: main directory that contains folders of images
cd(curdir);
a = dir;
txtfolder=[curdir '\Output_text_files_subtracted'];

if ~exist('Output_text_files_subtracted','dir')
    mkdir('Output_text_files_subtracted') % 'Output_..." is the name of output folder
end
lll=0;
for k=1:size(a,1) % Loop for all folders (folders that contain 001, 002, ...)
    if a(k).isdir && ~strcmp(a(k).name,'.') && ~strcmp(a(k).name,'..')...
            && ~strcmp(a(k).name,'Output_text_files')...
            && ~strcmp(a(k).name,'Output_text_files_subtracted')
        sheet=[(a(k).name)] ;
        numb=0; lll=lll+1; Dpixind=0; Dflocind=0; Total_nf_2dbc=0;
        Dpixsum=0; Dflocsum=0; bin_size=0.1 ;
        Dflocind_phi=0; Total_nf_s3=0; nf_counter=0; Total_nf_s2=0;
        clear numfloc areafloc mingreyfloc maxgreyfloc perimeterfloc ...
            bxfloc byfloc widthfloc heightfloc majorfloc minorfloc ...
            anglefloc circularityfloc arfloc roundfloc solidityfloc ...
            xstartfloc ystartfloc x y b  maxgreyscale_ehsan image_number ...
            entropy_r std_r contrast_r correlation_r energy_r homogeneity_r%ehsan
        
        number_ImageJ(lll)=0;
        
        txtname=[sheet '.txt'];
        
        cd([curdir '\' a(k).name]); % Change directory to 001 or 002 or ...
        oldFolder=pwd;
        files=dir('*.jpg'); % Jpeg of each folder
        txtFileCount = 0;
        for m=1:numel(files) % loop for every single image in each folder
            count=0;
            ll=['(' int2str(m) ').txt'];
            AAA=exist(ll,'file');
            if AAA==0
                continue;
            end
            txtFileCount = txtFileCount + 1;
            [num,area,mingrey,maxgrey,perimeter,bx,by,width,...
                height,major,minor,angle,circularity,...
                ar,round,solidity,xstart,ystart]=...
                textread(ll,...
                '%d %f %d %d %f %d %d %d %d %f %f %f %f %f %f %f %d %d',...
                'headerlines',1); % reads the txt file for each image
            [rows_ImageJ,columns_ImageJ]=size(num);
            number_ImageJ(lll)=number_ImageJ(lll)+rows_ImageJ;
            
            imm=['(' int2str(m) ').jpg'];
            im=imread(imm); % Matlab reads the image
            fim=mat2gray(im); % Matlab converts to gray
            maxgreyscale=zeros(1,numel(num));
            imx=zeros(size(fim,1),size(fim,2));
            imy=zeros(size(fim,1),size(fim,2));
            fimx=zeros(size(im,1),size(im,2));%ryan
            fimy=zeros(size(im,1),size(im,2));%ryan
            entropyR = zeros(1,numel(num));   %ryan
            stdR = zeros(1,numel(num));   %ryan
            contrastR = zeros(1,numel(num));   %ryan
            correlationR= zeros(1,numel(num));   %ryan
            energyR= zeros(1,numel(num));   %ryan
            homogeneityR= zeros(1,numel(num));   %ryan
            for i=1:numel(num) % Loop for each particle within the image
                greyscale=0;
                if bx(i)==0 || by(i)==0 || (by(i)+height(i))>=3000 ...                                       %changed from 1080 to 3000
                        || (bx(i)+width(i))>=4000 % Remove the particles attached to boundaries              %changed from 1920 to 4000
                    continue
                end
                % Defining Region Of Interest for each particle
                ROI=fim(by(i):(by(i)+height(i)),bx(i):(bx(i)+width(i)));
                fROI=im(by(i):(by(i)+height(i)),bx(i):(bx(i)+width(i)));
                cd(curdir);
                
                entropyR(i) = entropy(ROI); %ryan
                stdR(i) = std2(fROI); %ryan
                contrastR(i) = graycoprops(fROI).Contrast; %ryan
                correlationR(i) = graycoprops(fROI).Correlation; %ryan
                energyR(i) = graycoprops(fROI).Energy; %ryan
                homogeneityR(i) = graycoprops(fROI).Homogeneity; %ryan
                
                
                [imx(by(i):(by(i)+height(i)),bx(i):(bx(i)+width(i)))...
                    ,imy(by(i):(by(i)+height(i)),bx(i):(bx(i)+width(i)...
                    ))]=gaussgradient(ROI,2.0); % Check the gradient of each particle
                greyscale=zeros(by(i)+height(i),bx(i)+width(i));
                % Loops for finding the gradients in the ROI
                for j=by(i):(by(i)+height(i))
                    for ki=bx(i):(bx(i)+width(i))
                        greyscale(j,ki)=abs(imx(j,ki))+abs(imy(j,ki));
                    end
                end
                maxgreyscale(i)=max(max(greyscale(:,:)));
              if maxgreyscale(i)<0 % removes out of focus particles ryan changed from 0.7 to 0 to include OOF flocs
                  continue
              end
              clear ROI
                
                               if area(i)<5
                                      continue
                                 end
%                                 end
                
                
%                   if ((mingrey(i) < 173) || (mingrey(i) > 199) || (maxgrey(i) < 236) || (maxgrey(i) > 252))
%                       continue
%                   end
%                if mingrey > 215
 %                   continue
  %              end
                count=count+1 ; numb=numb+1;
                % Name change:
                numfloc(numb)=num(i);areafloc(numb)=area(i);mingreyfloc(numb)=mingrey(i);
                maxgreyfloc(numb)=maxgrey(i);perimeterfloc(numb)=perimeter(i);
                bxfloc(numb)=bx(i);
                byfloc(numb)=by(i);majorfloc(numb)=major(i);minorfloc(numb)=minor(i);
                anglefloc(numb)=angle(i);widthfloc(numb)=width(i);heightfloc(numb)=height(i);
                circularityfloc(numb)=circularity(i);arfloc(numb)=ar(i);
                roundfloc(numb)=round(i);solidityfloc(numb)=solidity(i);
                xstartfloc(numb)=xstart(i);ystartfloc(numb)=ystart(i);maxgreyscale_ehsan(numb)=maxgreyscale(i);image_number(numb)=m;
                entropy_r(numb)=entropyR(i);std_r(numb)=stdR(i);contrast_r(numb)=contrastR(i);correlation_r(numb)=correlationR(i);
                energy_r(numb)=energyR(i);homogeneity_r(numb)=homogeneityR(i);%% ehsan
                
                % Finding the diameter for each particle from the area
                Dpixind(numb)=sqrt(4*areafloc(numb)/pi);
                % In the image: 780 pixels = 1 mm
                Dflocind(numb)=Dpixind(numb)*0.93 ; % Floc Diameter in micron                                                    %changed from /780*1000 to *0.93 micron/px
                Dflocind_phi(numb)=-log2(Dflocind(numb)/1000); % Diamter in phi
                
                Dpixsum=Dpixsum+Dpixind(numb);
                Dflocsum=Dflocsum+Dflocind(numb);
                Dpix(lll)=Dpixsum/numb;
                Dfloc(lll)=Dflocsum/numb; % Average size of all in-focus particles in each folder
            end
            %
            cd(oldFolder);
        end
        
        cd(curdir);
        cd(txtfolder); % Change directory to the output directory
        % Writing the in-focus particles in a new txt file:
        fid = fopen(txtname,'wt+'); % Open or create new file for writing.
%         myformat='%s  %s  %s  %s  %s  %s  %s  %s  %s  %s  %s  %s  %s  %s  %s  %s  %s  %s\n';
%         myformat1='%d  %f  %d  %d  %f  %d  %d  %d  %d  %f  %f  %f  %f  %f  %f  %f  %d  %d\n';
%         fprintf(fid, myformat, 'Number','Area','MinGreyValue','MaxGreyValue',...
%             'Perimeter','BX','BY','Width','Height','Major','Minor',...
%             'Angle','Circularity','AR','Round','Solidity','Xstart','Ystart');

 myformat='%s  %s  %s  %s  %s  %s  %s  %s  %s  %s  %s  %s  %s  %s  %s  %s  %s  %s  %s  %s  %s  %s  %s  %s  %s  %s\n'; %%ehsan added gradient and image name
        myformat1='%d  %f  %d  %d  %f  %d  %d  %d  %d  %f  %f  %f  %f  %f  %f  %f  %d  %d  %f  %d  %f  %f  %f  %f  %f  %f\n'; %%ehsan added gradient and image name
        fprintf(fid, myformat, 'Number','Area','MinGreyValue','MaxGreyValue',...
            'Perimeter','BX','BY','Width','Height','Major','Minor',...
            'Angle','Circularity','AR','Round','Solidity','Xstart','Ystart','Gradient_ehsan','image_name_ehsan',...
            'entropy_r','std_r','contrast_r','correlation_r','energy_r','homogeneity_r');
        if exist('numfloc')==0
            % Reuse vars from previous directory
            numfloc=prev_numfloc;areafloc=prev_areafloc;mingreyfloc=prev_mingreyfloc;
            maxgreyfloc=prev_maxgreyfloc;perimeterfloc=prev_perimeterfloc;
            bxfloc=prev_bxfloc;byfloc=prev_byfloc;majorfloc=prev_majorfloc;
            minorfloc=prev_minorfloc;anglefloc=prev_anglefloc;widthfloc=prev_widthfloc;
            heightfloc=prev_heightfloc;circularityfloc=prev_circularityfloc;
            arfloc=prev_arfloc;roundfloc=prev_roundfloc;solidityfloc=prev_solidityfloc;
            xstartfloc=prev_xstartfloc;ystartfloc=prev_ystartfloc;
            
            num=prev_num;area=prev_area;mingrey=prev_mingrey;maxgrey=prev_maxgrey;
            perimeter=prev_perimeter;bx=prev_bx;by=prev_by;major=prev_major;minor=prev_minor;
            angle=prev_angle;width=prev_width;height=prev_height;circularity=prev_circularity;
            ar=prev_ar;round=prev_round;solidity=prev_solidity;xstart=prev_xstart;ystart=prev_ystart;
            
            Dpixind=prev_Dpixind;Dflocind=prev_Dflocind;Dflocind_phi=prev_Dflocind_phi;
            Dpixsum=prev_Dpixsum;Dflocsum=prev_Dflocsum;Dpix=prev_Dpix;Dfloc=prev_Dfloc;
            numb = prev_numb;
            
            output = previousOutput;
        else
            %Save previous variables for use by the next loop when there is
            %no text file available
%             output=[numfloc;areafloc;mingreyfloc;maxgreyfloc;perimeterfloc;...
%                 bxfloc;byfloc;widthfloc;heightfloc;majorfloc;minorfloc;...
%                 anglefloc;circularityfloc;arfloc;roundfloc;solidityfloc;...
%                 xstartfloc;ystartfloc];
             output=[numfloc;areafloc;mingreyfloc;maxgreyfloc;perimeterfloc;...
                bxfloc;byfloc;widthfloc;heightfloc;majorfloc;minorfloc;...
                anglefloc;circularityfloc;arfloc;roundfloc;solidityfloc;...
                xstartfloc;ystartfloc;maxgreyscale_ehsan;image_number;...
                entropy_r;std_r;contrast_r;correlation_r;energy_r;homogeneity_r]; %ehsan added gradient and image name
            prev_numfloc=numfloc;prev_areafloc=areafloc;prev_mingreyfloc=mingreyfloc;
            prev_maxgreyfloc=maxgreyfloc;prev_perimeterfloc=perimeterfloc;
            prev_bxfloc=bxfloc;prev_byfloc=byfloc;prev_majorfloc=majorfloc;
            prev_minorfloc=minorfloc;prev_anglefloc=anglefloc;prev_widthfloc=widthfloc;
            prev_heightfloc=heightfloc;prev_circularityfloc=circularityfloc;
            prev_arfloc=arfloc;prev_roundfloc=roundfloc;prev_solidityfloc=solidityfloc;
            prev_xstartfloc=xstartfloc;prev_ystartfloc=ystartfloc;
            
            prev_num=num;prev_area=area;prev_mingrey=mingrey;prev_maxgrey=maxgrey;
            prev_perimeter=perimeter;prev_bx=bx;prev_by=by;prev_major=major;
            prev_minor=minor;prev_angle=angle;prev_width=width;prev_height=height;
            prev_circularity=circularity;prev_ar=ar;prev_round=round;
            prev_solidity=solidity;prev_xstart=xstart;prev_ystart=ystart;
            
            prev_Dpixind=Dpixind;prev_Dflocind=Dflocind;prev_Dflocind_phi=Dflocind_phi;
            prev_Dpixsum=Dpixsum;prev_Dflocsum=Dflocsum;prev_Dpix=Dpix;prev_Dfloc=Dfloc;
            
            prev_numb = numb;
            
            previousOutput = output;
        end
        fprintf(fid, myformat1, output);
        fclose(fid);
        
        % Floc size distribution: start
        low=floor(min(Dflocind_phi))-bin_size;
        high=ceil(max(Dflocind_phi))+bin_size;
        numb_bin=(high-low)/bin_size;
        for i=1:numb_bin
            Tot_weight(i)=0;
            x1_phi(i)=low+bin_size*(i-1/2);
            x1_micron(lll,i)=1000/2^x1_phi(i); % Sizes for Cum_finer
        end
        for i=1:numb
            mm=(Dflocind_phi(i)-low)/bin_size;
            mdigit=floor(mm);
            Tot_weight(mdigit)=Tot_weight(mdigit)+Dflocind(i);
        end
        for i=1:numb_bin
            f_weight(i)=Tot_weight(i)/Dflocsum*100 ;
            if i==1
                Cum_coarser(i)=f_weight(i);
            else
                Cum_coarser(i)=Cum_coarser(i-1)+f_weight(i);
            end
            Cum_finer(lll,i)=100-Cum_coarser(i); % Cumulative finer than
        end
        
        x=Cum_finer(lll,1:numb_bin);
        
        [b,qq,qw]=unique(x);   % Removes duplicates from x
        y=x1_micron(lll,1:numb_bin);
        
        D95(lll)=interp1(b,y(qq),95);
        D84(lll)=interp1(b,y(qq),84);
        D50(lll)=interp1(b,y(qq),50);
        D16(lll)=interp1(b,y(qq),16);
        D5(lll)=interp1(b,y(qq),5);
    end
    % End of floc size distribution
    cd(curdir);
end



x=[1:lll];
Dfloc_vertical=Dfloc';
D50vertical=D50';
D84vertical=D84';
D16vertical=D16';

% Reading the number of flocs in each bin (ex. 10 micron bin)
cd(txtfolder); % Change directory to the output folder
llll=0;
files_txt=dir('*.txt');
[Part1,Part2]=strtok(files_txt(1).name,'.');
worksheetnum=numel(files_txt);
begin=str2double(Part1)-1 ;
for llll=1:worksheetnum
    rrr=llll+begin;
    if rrr<10
        sheet=['00' int2str(rrr)];
    elseif rrr<100
        sheet=['0' int2str(rrr)];
    else
        sheet=int2str(rrr);
    end
    Dpixind2=0; Dflocind2=0;
    bin_size2=10 ; % specifies the size of bins (ex. 10 micron)
    
    ll2=[sheet '.txt'];
    AAA=exist(ll2,'file');
    if AAA==0
        continue
    end
    
    % Reading the txt files in the output folder
    [numfloc,areafloc,mingrey,maxgrey,perimeterfloc,bx,by,widthfloc,...
        heightfloc,major,minor,angle,circularity,...
        ar,round,solidity,xstart,ystart]=...
        textread(ll2,...
        '%d %f %d %d %f %d %d %d %d %f %f %f %f %f %f %f %d %d',...
        'headerlines',1);
    [rows,columns]=size(numfloc);
    number_floc(llll)=rows; % number of accepted flocs
    for numb=1:rows
        Dpixind2(numb)=sqrt(4*areafloc(numb)/pi);
        Dflocind2(numb)=Dpixind2(numb)/780*1000 ; %Floc Diameter in micron
        
    end
    
    %     low=floor(min(Dflocind2)/bin_size2)*bin_size2;
    low=0;
    high=ceil(max(Dflocind2)/bin_size2)*bin_size2;
    numb_bin=(high-low)/bin_size2;
    for i=1:numb_bin+1
        x_micron(llll,i)=low+bin_size2*(i-1);
    end
    for i=1:numb_bin
        bin_number(llll,i)=0;
    end
    for i=1:numb
        mm=(Dflocind2(i)-low)/bin_size2;
        mdigit=floor(mm)+1;
        bin_number(llll,mdigit)=bin_number(llll,mdigit)+1;
    end
end
% End of finding number of flocs in each bin

number_floc_vertical=number_floc';
number_ImageJ_vertical=number_ImageJ';
cd(curdir);
save code_subtracted.mat % Saves in a matrix format

% GrandFather=pwd;
% File_GrandFather=dir;
% for m=1:numel(File_GrandFather)
%     if File_GrandFather(m).isdir && ~strcmp(File_GrandFather(m).name,'.') && ~strcmp(File_GrandFather(m).name,'..')...
%             && ~strcmp(File_GrandFather(m).name,'Original')...
%             && ~strcmp(File_GrandFather(m).name,'Output_text_files_subtracted')...
%             && ~strcmp(File_GrandFather(m).name,'1st minute')
%         GrandFatherName=[(File_GrandFather(m).name)];
%         cd([GrandFather '\' GrandFatherName]);
%         delete('*.jpg');
%     end
% end

% figure(1);
% set(gcf,'renderer','paint');
% plot(D50Vertical,'LineWidth',1);
% xlim([0 360]);set(gca,'Xtick',0:30:360,'FontSize',22);
% ylim([0 300]);set(gca,'Ytick',0:50:300,'FontSize',22);
% xlabel('Time (min)');
% ylabel('Floc size (\mum)');