clear all

% curdir = pwd;
% direc1='c:\Ehsan\Ehsan2';
% direc1='C:\Users\studentuser\Desktop\Ryan\test_75mm_a1';
direc1=pwd;

 idcs   = strfind(direc1,'\');
 direc2 = direc1(1:idcs(end)-1);

% direc2='C:\Users\studentuser\Desktop\Ryan\';
cd(direc1);
files=dir('*.bmp');
cd(direc2);
All_File_Name={files.name};
Sorted_File_Name=sort_nat(All_File_Name);
count=1; % Number of images per folder
r=floor(numel(files)/count);  % Number of folders
begin=1; % Beginning number for the first image
for i=1:r   % Loop for moving images to the folders
    finish=count+begin-1;
%     bb=[curdir '\' num2str(i)];
        bb=[direc1 '\' num2str(i)];

    if ~exist(bb,'dir')
        mkdir(bb)
    end
    for j=begin:finish
        S=char(Sorted_File_Name(j));
%         cc=S;
        cc=[direc1 '\' S];
        if ~exist(cc,'file')
            break
        end
        dd{j}=cc;
    end
    movefiles(dd(begin:finish),bb,count);
    begin=finish+1;
end


% cd(curdir);
cd(direc1);
a = dir;
for k=1:size(a,1)   % Loop to rename and sort images of each folder from (1), (2), ...
    if a(k).isdir && ~strcmp(a(k).name,'.') && ~strcmp(a(k).name,'..')
%         cd([curdir '\' a(k).name])
        cd([direc1 '\' a(k).name])

        files2=dir('*.bmp');
        for m=1:numel(files2)
            %             y=str2double(files2(m).name);
            ll=['(' int2str(m) ').bmp'];
            movefile(files2(m).name,ll);
            %             java.io.File(files2(m).name).renameTo(java.io.File(ll));
        end
    end
end
% cd(curdir);
cd(direc1);

m=0;
for k=1:size(a,1) % Loop to rename and sort folders from 001, 002, ...
    if a(k).isdir && ~strcmp(a(k).name,'.') && ~strcmp(a(k).name,'..')
        x=str2double(a(k).name);
        if x<10
            ll=['00' num2str(x)];
        elseif x<100
            ll=['0' num2str(x)];
        else
            continue; %ll=num2str(x);
        end
        movefile(a(k).name,ll);
        %             java.io.File(a(k).name).renameTo(java.io.File(ll));
    end
end

% cd(curdir);
cd(direc1);

pwd;
 
status = system('ImageJ.bat');
Matlab_code;
