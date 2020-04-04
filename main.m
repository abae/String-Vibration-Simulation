clc
clear all

nodes = 101;
length = 1; %in meters
xcoord = linspace(0,length,nodes);
timeStep = .001;
timeEnd = 15.5;
numTimeSteps = floor(timeEnd/timeStep);
time = linspace(0,timeEnd, numTimeSteps);
stiffness = 1000;

observedNode = 50;
observedRec = zeros(1, numTimeSteps);

%initial condition
ycoord = zeros(1, nodes);
wavevy = zeros(1, nodes);
initialPluckx = .5;
initialPlucky = .002;
for i=1:size(xcoord,2)
    if(xcoord(i) < initialPluckx)
        varSlope = initialPlucky/initialPluckx;
        ycoord(i) = varSlope*xcoord(i);
    else
        varSlope = -initialPlucky/(length - initialPluckx);
        varOffset = (initialPlucky*length)/(length - initialPluckx);
        ycoord(i) = varSlope*xcoord(i) + varOffset;
    end
end

for t=1:size(time,2)
    for i=1:size(ycoord,2)
        if(i==1 || i==nodes)
            ycoord(i) = 0;
            wavevy(i) = 0;
        else
            wavevy(i) = wavevy(i) -stiffness*(2*ycoord(i) - (ycoord(i-1) + ycoord(i+1)));
        end
    end
    for i=1:size(ycoord,2)
        ycoord(i) = ycoord(i) + wavevy(i)*timeStep;
    end
    
    observedRec(t) = ycoord(observedNode);
end

plot(time,observedRec);
%plot(xcoord,ycoord);