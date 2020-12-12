clear;clc;
%% 初始化无线传感网各个device
%.传感器节点区域界限
envSize=10;
%区域内传感器数量
global numOfNodes;

global devices;
global isBroaded;
isBroaded = zeros(1,numOfNodes);
numOfNodes=100;

global radius;%作用范围
radius=1.5;
global xLocation;   
global yLocation;   
xLocation = rand(numOfNodes,1) * envSize;
yLocation = rand(numOfNodes,1) * envSize;   %x,y坐标

% 横向路的两个点的y值
roady1 = rand(1,1)* envSize;
roady2 = rand(1,1)*envSize;

global visited;%标记节点是否被访问过
visited=zeros(1,numOfNodes);%初始时都未被访问

global route;%记录传输路径
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

% 创建device
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

% 计算device距离矩阵
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

% 画每个device的通信范围
%for i = 1:numOfNodes
    
   %rectangle('Position',[devices(i).x-radius,devices(i).y-radius,2*radius,2*radius],'Curvature',[1,1]);
   
%end

% 确定gateway,y = kx+b
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

%% 建立到gateway的路由
 queueForBroad(GW);


%% 画图
figure(1);hold on;
plot([0 10], [roady1 roady2], 'r');
plot(xLocation, yLocation, '.');

% 画routing路线
for i = 1:numOfNodes
    if(devices(i).next>0)
         plot([devices(i).x devices(devices(i).next).x],[devices(i).y devices(devices(i).next).y],'K');
     end
end




