%%����matlab�Դ���NEWFF�ϰ汾��д�ĳ���

clc
clear
close

%ԭʼ���ݶ���
data_raw=xlsread('C:\Users\28625\Documents\GitHub\BP\test.csv');

%���������Ŀ�������
p=data_raw(2:124,3:6)';  %������ת������Ϊmatlab�Դ��ĺ���Ҫ��ÿ�������������룬����excel�еİ�������
t=data_raw(2:124,13)';  %ͬ��

%����������Ŀ�������й�һ��
y_max=1;  y_min=-1;                    %��һ�����ֵ����Сֵ         
[pn,pPS]=mapminmax(p,y_min,y_max);  %�ú�����һ����ʽ��pn=2*(p-minp)/(maxp-minp)-1��ӳ������Ϊ[-1,1];y = (ymax-ymin)*(x-xmin)/(xmax-xmin) + ymin
[tn,tPS]=mapminmax(t,y_min,y_max); 
dx=ones(size(pn,1),2);      
dx(:,1)=dx(:,1).*y_min;  dx(:,2)=dx(:,2).*y_max;   %��һ��������ֵ����Сֵ����Ӧ�������newff�ĵ�һ������ʹ�ã��ϰ汾��

%����matlab�Դ����������bp����ѵ��
net=newff(dx,[10,15,1],{'tansig','tansig','purelin'},'traingdx');  %�ݶ��½���
net.trainParam.show=1000;   %1000����ʾһ�ν��
net.trainParam.Lr=0.02;     %ѧϰ����Ϊ0.05
net.trainParam.epochs=50000


;%���ѵ���ֻ�Ϊ50000��
net.trainParam.goal=0.65*10^(-3);  %�������
net=train(net,pn,tn);       %��ʼѵ��

data_raw2=xlsread('C:\Users\28625\Documents\GitHub\BP\test2.csv');
p2=data_raw2(1:302,3:6)';  %������ת������Ϊmatlab�Դ��ĺ���Ҫ��ÿ�������������룬����excel�еİ�������

y_max=1;  y_min=-1;                    %��һ�����ֵ����Сֵ         
[pn2,pPS2]=mapminmax(p2,y_min,y_max);  %�ú�����һ����ʽ��pn=2*(p-minp)/(maxp-minp)-1��ӳ������Ϊ[-1,1];y = (ymax-ymin)*(x-xmin)/(xmax-xmin) + ymin
%����
an=sim(net,pn2);     %ͨ��ѵ������õ�ѵ�����
%a=postmnmx(an,mint,maxt);  %�ѷ���õ������ݻ�ԭΪԭʼ������
a=mapminmax('reverse',an,tPS);

%���չʾ
x=1:302;
newk=a(1,:) %��һά���������interest
b=newk;
b(b>4)=4;
b(b<0)=0;
b=round(b)
%newh=a(2,:);  %�ڶ�ά���������������
figure(2);
subplot(2,1,1);plot(x,newk,'*');
legend('����Ԥ�����');
xlabel('��ҵ���');ylabel('��������');

% title('matlab�Դ�����ѵ����Ŀ������Ա�ͼ')
% subplot(2,1,2);plot(x,newh,'r-o',x,t(2,:),'b--+');
% legend('�������������','ʵ�ʻ�����')
% xlabel('���');ylabel('������/����')
% title('matlab�Դ�����ѵ����Ļ������Ա�ͼ')






