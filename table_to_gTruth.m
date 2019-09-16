function gTruth = table_to_gTruth(mytable)
% ���ܣ���imageLabeler��ǹ��ߵ�����table��ʽת��ΪgroundTruth����(17b���Ժ�汾����)
% 17b�汾ֻ�����ָ�ʽ������ʾ�����txt_to_matlab��������ʾ��matlab�У�������α༭������
% ���룺mytable����ע�õ��ļ���rectangle�����ע��table
% �����gTruth,ת�����gTruth���ͣ�����ͬ��mytalbe
%
% step1
source = mytable.imageFilename;
gtSource = groundTruthDataSource(source);
% step2
names = (mytable.Properties.VariableNames(2:end))';
types = repmat(labelType('Rectangle'),length(names),1);
labelDefs = table(names,types,'VariableNames',{'Name','Type'});
% step3
labelData = mytable(:,2:end);

% last convert to "groundTruth" objects
gTruth = groundTruth(gtSource,labelDefs,labelData);
