clear;clc;
%% ��ʼ�����ߴ���������device
%.�������ڵ��������
envSize=10;
%�����ڴ���������
global numOfNodes;

global devices;
global isBroaded;
isBroaded = zeros(1,numOfNodes);
numOfNodes=100;

global radius;%���÷�Χ
radius=1.5;
global xLocation;   
global yLocation;   
xLocation = rand(numOfNodes,1) * envSize;
yLocation = rand(numOfNodes,1) * envSize;   %x,y����

% ����·���������yֵ
roady1 = rand(1,1)* envSize;
roady2 = rand(1,1)*envSize;

global visited;%��ǽڵ��Ƿ񱻷��ʹ�
visited=zeros(1,numOfNodes);%��ʼʱ��δ������

global route;%��¼����·��
route=[];
global GW;
global numOfGW;
numOfGW=0;

device.id = 0;
device.x=0;
device.y=0;
device.next=0;
device.dataAmount=0;
device.hop=0;
device.isGateway = 0;
device.neighbor = [];

devices=repmat(device,[1 100]);

% ����device
for i=1:100
    devices(i).id = i;
    devices(i).x = xLocation(i);
    devices(i).y = yLocation(i);
    devices(i).next = 0;
    devices(i).dataAmount = 0;
    devices(i).hop = 0;
    devices(i).isGateway = 0;
    devices(i).neighbor = [];
end

% ����device�������
disofall = zeros(100,100);
for i=1:100
    for j=1:i-1
        a1 = [xLocation(i) yLocation(i)];
        a2 =  [xLocation(j) yLocation(j)];
        disofall(i,j)=distance(a1,a2);
        if (disofall(i,j)<=radius)
            devices(i).neighbor(end+1)=j;
            devices(j).neighbor(end+1)=i;
        end
    end
end

% ��ÿ��device��ͨ�ŷ�Χ
%for i = 1:numOfNodes
    
   %rectangle('Position',[devices(i).x-radius,devices(i).y-radius,2*radius,2*radius],'Curvature',[1,1]);
   
%end

% ȷ��gateway,y = kx+b
Q1 = [0 roady1];
Q2 = [envSize roady2];
for i=1:100
    P = [xLocation(i) yLocation(i)];
    juli = abs(det([Q2-Q1;P-Q1]))/norm(Q2-Q1);
    if(juli<radius)
        devices(i).isGateway=1;
        numOfGW = numOfGW +1;
        
 %       isBroaded(i)=1;
 
        text(xLocation(i),yLocation(i),'G');
    else
        devices(i).hop=inf;
    end
end
GW = zeros(1,numOfGW);
current = 1;
for i=1:numOfNodes
    if(devices(i).isGateway>0)
        GW(current) = i;
        current = current +1;
    end   
end

%% ������gateway��·��
 queueForBroad(GW);


%% ��ͼ
figure(1);hold on;
plot([0 10], [roady1 roady2], 'r');
plot(xLocation, yLocation, '.');

% ��routing·��
for i = 1:numOfNodes
    if(devices(i).next>0)
         plot([devices(i).x devices(devices(i).next).x],[devices(i).y devices(devices(i).next).y],'K');
     end
end




