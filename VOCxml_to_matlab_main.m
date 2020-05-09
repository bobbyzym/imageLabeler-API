function  outputTable = VOCxml_to_matlab_main()
% ���ܣ���������VOC-xml��ʽ�ļ���matlab��
% ���룺��: ����ʽѡ��xml·����
% �����outputTable: ���Ե��뵽MATLAB appԤ��/�޸ĵ�table�������ݡ�
%
% Example: 
%        outputTable = VOCxml_to_matlab_main('F:\imagesData\stopSignImages\*.xml')
%
% if nargin<1
%     error('�������̫�٣�')
% end
global folder_name;
folder_name = uigetdir('','��ѡ�����VOC-xml����ļ�·��(�ļ���)��');
if ~folder_name
    warndlg('��ǰ��ûѡ���κ��ļ���','����')
    return;
end
xmls_path = fullfile(folder_name,'*.xml');
s = dir(xmls_path);
numSamples = length(s);

waitbar(0,'Please wait...');
steps = numSamples;
for i =1:numSamples
    xml_path = fullfile(folder_name,s(i).name);
    rowTable = xml_to_matlab(xml_path);
    structTem = table2struct(rowTable);
    if i == 1
        ss(1) = structTem;
        prevNames = fieldnames(structTem);
        continue;
    else
        currentNames = fieldnames(structTem);
        index = ismember(currentNames,prevNames);
        
        for j = 1:length(index)
            ss(i).(currentNames{j}) = structTem.(currentNames{j});
        end
        prevNames = fieldnames(ss);
    end
    waitbar(i / steps);
end
outputTable = struct2table(ss);

function output = xml_to_matlab(xmlName)
% ���ܣ���ȡVOC-xml��׼��ʽ�ļ���ת��ΪMATLAB table�������ݣ����뵽APP�У�
% ����Ԥ����ǻ���ж��α���޸�,�˺���ֻ�ܶԵ���ͼƬ���д���,���������xml_to_matlab_main.m����
%
% ���룺xmlName������xml�ı�ע�ļ�
% �����Output,���Ϊtable��������,��ֱ�Ӽ��ص�App��ע�����в鿴
%
% example:
%       output = xml_to_matlab('image001.xml')
% 
global folder_name;
if nargin<1
    error('����������٣�');
end

structLabel = xml_read(xmlName);
if isfield(structLabel,'path')
    imageFilenames = structLabel.path;
elseif isfield(structLabel,'filename')
    imageFilenames = fullfile(folder_name,structLabel.filename);
else
    error('����ͼ��xml��·�����Ƿ���ȷ��')
end
outputStu.imageFilename = imageFilenames;%��ȡ����·��

if ~isfield(structLabel,'object')
    output = struct2table(outputStu);
    return;
end
labelNum = length(structLabel.object);
names = cell(labelNum,1);
rects = cell(labelNum,1);

for i = 1:labelNum
    stuCON = structLabel.object(i);   
    names{i} = stuCON.name;
    rects{i} = [stuCON.bndbox.xmin+1,stuCON.bndbox.ymin+1,...
        stuCON.bndbox.xmax-stuCON.bndbox.xmin,...
        stuCON.bndbox.ymax-stuCON.bndbox.ymin];   
end

%
variableNames = unique(names);%cell
variableNum = length(variableNames);

varRect = cell(1,variableNum);
for i = 1:length(names)
    index = strcmp(names{i},variableNames);
    varRect{index} = [varRect{index};rects{i}]; 
end
for i = 1:variableNum
    field = variableNames{i};
    outputStu.(field) = varRect(i);
end
output = struct2table(outputStu);
