clc
clear all

nodes = 1001;
length = 1; %in meters
xcoord = linspace(0,length,nodes);
timeStep = .000001;
timeEnd = .1;
numTimeSteps = floor(timeEnd/timeStep);
time = linspace(0,timeEnd, numTimeSteps);
stiffness = 100000;%not sure of these units yet...(related to c^2 of wave eq)

observedNode = 500;%node we are observing over time
observedRec = zeros(1, numTimeSteps);

%initial condition (absolute value curve with some randomness)
ycoord = zeros(1, nodes);
wavevy = zeros(1, nodes);
initialPluckx = .5;
initialPlucky = .002;
for i=1:size(xcoord,2)
    if(xcoord(i) < initialPluckx)
        varSlope = initialPlucky/initialPluckx;
        ycoord(i) = varSlope*xcoord(i) + random('Normal',-.0001,.0001);
    else
        varSlope = -initialPlucky/(length - initialPluckx);
        varOffset = (initialPlucky*length)/(length - initialPluckx);
        ycoord(i) = varSlope*xcoord(i)+ varOffset + random('Normal',-.0001,.0001);
    end
end

%calculating for every timestep
for t=1:size(time,2)
    %for every node, get the acceleration
    for i=1:size(ycoord,2)
        %boundary condition
        if(i==1 || i==nodes)
            ycoord(i) = 0;
            wavevy(i) = 0;
        else %getting differences in node distance between neighboring nodes to get curvature
            %assumes nodes are infinitely close together (no need for x difference calculation)
            wavevy(i) = wavevy(i) -stiffness*(2*ycoord(i) - (ycoord(i-1) + ycoord(i+1)));
        end
    end
    %use acceleration to calculate new displacement
    for i=1:size(ycoord,2)
        ycoord(i) = ycoord(i) + wavevy(i)*timeStep;
    end
    %record on node of interest
    observedRec(t) = ycoord(observedNode);
end

plot(time,observedRec);
%soundsc(observedRec,16000);
%plot(xcoord,ycoord);