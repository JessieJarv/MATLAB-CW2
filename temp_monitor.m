function temp_monitor(a)
%TEMP_MONITOR Summary of this function goes here
% This function reads temperature data from an analog pin of the Arduino,
% updates a live graph, and blinks LEDs based on the temperature range.
% - Green LED: 18–24 °C (constant ON)
% - Yellow LED: <18 °C (blink 0.5 s)
% - Red LED: >24 °C (blink 0.25 s)
% Call using: temp_monitor(a)
% where "a" is the Arduino object

greenPin = 'D8';
yellowPin = 'D9';
redPin = 'D10';
tempPin = 'A0';

% Setup pins as outputs
configurePin(a, greenPin, 'DigitalOutput');
configurePin(a, yellowPin, 'DigitalOutput');
configurePin(a, redPin, 'DigitalOutput');

timeElapsed = [];
temperatureHistory = [];

startTime = datetime('now');

figure;
title('Live Temperature Monitoring');
xlabel('Time (s)');
ylabel('Temperature (°C)');
xlim([0 60]);
ylim([0 50]);
grid on;

while true
    voltage = readVoltage(a, tempPin);
    temperature = (voltage - 0.5) / 0.01;
    fprintf("live temp is %.2f C \n",temperature);

    timeNow = seconds(datetime('now') - startTime);
    timeElapsed(end+1) = timeNow;
    temperatureHistory(end+1) = temperature;

    % Update live plot
    plot(timeElapsed, temperatureHistory, 'b-', 'LineWidth', 1.5);
    xlabel('Time (s)');
    ylabel('Temperature (°C)');
    title('Live Temperature Monitoring');
    xlim([max(0, timeNow - 60), timeNow + 5]);  % Scroll window of 60s
    ylim([min(temperatureHistory)-2, max(temperatureHistory)+2]);
    grid on;
    drawnow;

    % LED control
    if temperature < 18
        writeDigitalPin(a, greenPin, 0);
        writeDigitalPin(a, redPin, 0);
        writeDigitalPin(a, yellowPin, 1);
        pause(0.5);
        writeDigitalPin(a, yellowPin, 0);
        pause(0.5);
        
    elseif temperature > 24
        writeDigitalPin(a, greenPin, 0);
        writeDigitalPin(a, yellowPin, 0);
        writeDigitalPin(a, redPin, 1);
        pause(0.25);
        writeDigitalPin(a, redPin, 0);
        pause(0.25);
        
    else
        writeDigitalPin(a, redPin, 0);
        writeDigitalPin(a, yellowPin, 0);
        writeDigitalPin(a, greenPin, 1);
        pause(1);
    end

end

