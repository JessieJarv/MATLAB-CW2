% Jessica Jarvis
% egyjj6@nottingham.ac.uk


%% PRELIMINARY TASK - ARDUINO AND GIT INSTALLATION [10 MARKS]

for i = 1:10
    writeDigitalPin(a, 'D8', 1);   % Turn LED on
    pause(0.5);                    % Wait for 0.5 seconds
    writeDigitalPin(a, 'D8', 0);   % Turn LED off
    pause(0.5);                    % Wait for 0.5 seconds
end





%% TASK 1 - READ TEMPERATURE DATA, PLOT, AND WRITE TO A LOG FILE [20 MARKS]
%b) 

duration = 600; %total time (s)
timeData = zeros(1, duration);
voltageData = zeros(1, duration);
temperatureData = zeros(1, duration);

TC = 0.01; % volts per degree Celsius
V1 = 0.5;  % voltage at 0 °C

for t = 1:duration
    voltage = readVoltage(a, 'A1'); % read voltage from sensor
    voltageData(t) = voltage;
    temperature = (voltage - V1) / TC;
    temperatureData(t) = temperature;
    timeData(t) = t; % store time in seconds
    pause(1); % wait 1 second before next reading
end

%c)

plot(timeData, temperatureData); % plot temperature vs time
xlabel('Time (seconds)');        % x-axis label
ylabel('Temperature (°C)');      % y-axis label
title('Temperature Over Time');  % title

%d)

% Header information
dateStr = '5/3/2024';
locationStr = 'Nottingham';

% Start logging
fprintf('Data logging initiated - %s\n', dateStr);
fprintf('Location - %s\n\n', locationStr);

% Print each minute and temperature value
for i = 0:10
    fprintf('Minute\t\t%d\n', i);
    fprintf('Temperature \t%.2f C\n\n', temperatureData(i+1));
end

% Calculate values
maxTemp = max(temperatureData);
minTemp = min(temperatureData);
avgTemp = mean(temperatureData);

% Print values
fprintf('Max temp\t%.2f C\n', maxTemp);
fprintf('Min temp\t%.2f C\n', minTemp);
fprintf('Average temp\t%.2f C\n\n', avgTemp);

% End logging
fprintf('Data logging terminated\n');

%e)

% Info
dateStr = '5/3/2024';
locationStr = 'Nottingham';

% Open file for writing (creates file or checks if it exists)
fileID = fopen('cabin_temperature.txt', 'w');

% Write header
fprintf(fileID, 'Data logging initiated - %s\n', dateStr);
fprintf(fileID, 'Location - %s\n\n', locationStr);

% Write each data point
for i = 0:10
    fprintf(fileID, 'Minute\t\t%d\n', i);
    fprintf(fileID, 'Temperature \t%.2f C\n\n', temperatureData(i+1));
end

% Calculate values again
maxTemp = max(temperatureData);
minTemp = min(temperatureData);
avgTemp = mean(temperatureData);

fprintf(fileID, 'Max temp\t%.2f C\n', maxTemp);
fprintf(fileID, 'Min temp\t%.2f C\n', minTemp);
fprintf(fileID, 'Average temp\t%.2f C\n\n', avgTemp);

% End log
fprintf(fileID, 'Data logging terminated\n');

% Close the file
fclose(fileID);



%% TASK 2 - LED TEMPERATURE MONITORING DEVICE IMPLEMENTATION [25 MARKS]

temp_monitor(a);

%% TASK 3 - ALGORITHMS – TEMPERATURE PREDICTION [25 MARKS]

temp_prediction(a);

%% TASK 4 - REFLECTIVE STATEMENT [5 MARKS]

% During this project I had to gain an understanding in Github
% repositories, further extend my capability in MatLab and continue to 
% make use of loops in order to tackle tasks; such as constant temperature
% checks and flashing the LED lights. At first learning about Github
% appeared to be a challenge having never used it before, however by using
% the coursework documentation and some further reading of Githubs user
% guides, I was able to set up a repository for the project and store a
% local version of this on my desktop. My version control skills were put
% to the test straight away where I initialized the template file ready for
% active work on Matlab. At first I struggled to grasp the difference
% between commits and pushes, presenting a likely limitation on the project
% if not tackled and so instead of jumping straight into development.
% This turned out to be a strength of mine as I could see the value in 
% keeping working versions of the files stored on the repository in case I 
% needed to revert back at a later date. Firstly, I think that my approach 
% to the function was a success but could of had some improvements.
% The biggest improvement I suggest is that I handled all of the problem 
% in these functions  at the time I felt as though this was good practice,
% upon review potentially in my function I handle some parts of the 
% approach  and data that should have otherwise been external to the 
% function and instead parsed in, such as the temperature calculations in
% task 3. This was an oversight at the time, which I would straighten out 
% should I carry out an improvements on the system. Strictly only the 
% temperature prediction would be handled, returning a value for the main 
% template to then handle and output to the user. 
% My biggest weakness during the project was in commenting and documenting 
% the code. Instead of doing this as I wrote new code it was something I 
% overlooked and tried to then do at the end. With functions being written 
% over numerous days or hours, I would sometimes get confused with what I 
% had coded prior and have to take time to work it out, or rewrite it. 
% This was something I realized as I came to the end of the project and 
% will take forward into any future Matlab/coding exercises I am tasked 
% with.


%% TASK 5 - COMMENTING, VERSION CONTROL AND PROFESSIONAL PRACTICE [15 MARKS]

% No need to enter any answershere, but remember to:
% - Comment the code throughout.
% - Commit the changes to your git repository as you progress in your programming tasks.
% - Hand the Arduino project kit back to the lecturer with all parts and in working order.
