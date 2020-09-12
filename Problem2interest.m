%%基于matlab自带的NEWFF老版本编写的程序

clc
clear
close

%原始数据读入
data_raw=xlsread('C:\Users\28625\Documents\GitHub\BP\test.csv');

%输入矩阵与目标矩阵构造
p=data_raw(2:124,3:6)';  %带矩阵转置是因为matlab自带的函数要求每个样本按列输入，而非excel中的按行输入
t=data_raw(2:124,13)';  %同上

%对输入矩阵和目标矩阵进行归一化
y_max=1;  y_min=-1;                    %归一化最大值与最小值         
[pn,pPS]=mapminmax(p,y_min,y_max);  %该函数归一化公式：pn=2*(p-minp)/(maxp-minp)-1，映射区间为[-1,1];y = (ymax-ymin)*(x-xmin)/(xmax-xmin) + ymin
[tn,tPS]=mapminmax(t,y_min,y_max); 
dx=ones(size(pn,1),2);      
dx(:,1)=dx(:,1).*y_min;  dx(:,2)=dx(:,2).*y_max;   %归一化后的最大值与最小值，供应给下面的newff的第一个参数使用（老版本）

%利用matlab自带工具箱进行bp网络训练
net=newff(dx,[10,15,1],{'tansig','tansig','purelin'},'traingdx');  %梯度下降法
net.trainParam.show=1000;   %1000轮显示一次结果
net.trainParam.Lr=0.02;     %学习速率为0.05
net.trainParam.epochs=50000


;%最大训练轮回为50000次
net.trainParam.goal=0.65*10^(-3);  %均方误差
net=train(net,pn,tn);       %开始训练

data_raw2=xlsread('C:\Users\28625\Documents\GitHub\BP\test2.csv');
p2=data_raw2(1:302,3:6)';  %带矩阵转置是因为matlab自带的函数要求每个样本按列输入，而非excel中的按行输入

y_max=1;  y_min=-1;                    %归一化最大值与最小值         
[pn2,pPS2]=mapminmax(p2,y_min,y_max);  %该函数归一化公式：pn=2*(p-minp)/(maxp-minp)-1，映射区间为[-1,1];y = (ymax-ymin)*(x-xmin)/(xmax-xmin) + ymin
%仿真
an=sim(net,pn2);     %通过训练网络得到训练输出
%a=postmnmx(an,mint,maxt);  %把仿真得到的数据还原为原始数量级
a=mapminmax('reverse',an,tPS);

%结果展示
x=1:302;
newk=a(1,:) %第一维度输出，即interest
b=newk;
b(b>4)=4;
b(b<0)=0;
b=round(b)
%newh=a(2,:);  %第二维度输出，即货运量
figure(2);
subplot(2,1,1);plot(x,newk,'*');
legend('网络预测输出');
xlabel('企业编号');ylabel('利率类型');

% title('matlab自带网络训练额的客运量对比图')
% subplot(2,1,2);plot(x,newh,'r-o',x,t(2,:),'b--+');
% legend('网络输出货运量','实际货运量')
% xlabel('年份');ylabel('客运量/万人')
% title('matlab自带网络训练额的货运量对比图')






