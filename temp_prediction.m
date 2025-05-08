function temp_prediction(a)
%TEMP_PREDICTION Temperature monitoring and prediction system
%   This function continuously monitors temperature from a thermistor,
%   calculates rate of change in °C/min, and predicts temperature in 5 minutes.
%   It provides visual LED alerts: green for stable temperature, red for 
%   rapid increase (>4°C/min), and yellow for rapid decrease (<-4°C/min).
%   Current readings, rates, and predictions are continuously displayed.
%
%   Usage: temp_prediction(a) where 'a' is the Arduino object

    % Define pins for LEDs and temperature sensor
    greenPin = 'D8';
    yellowPin = 'D9';
    redPin = 'D10';
    tempPin = 'A0';

    % Configure pins as digital outputs
    configurePin(a, greenPin, 'DigitalOutput');
    configurePin(a, yellowPin, 'DigitalOutput');
    configurePin(a, redPin, 'DigitalOutput');

    % Define critical rate thresholds in °C/min
    criticalRateIncrease = 4;
    criticalRateDecrease = -4;

    % Initialize arrays
    temperatureHistory = [];
    timeElapsed = [];

    % Print header
    fprintf('Temperature Monitoring System\n');
    fprintf('---------------------------\n');
    fprintf('Time(s) | Current °C | Rate °C/min | Predicted in 5min | Status\n');
    fprintf('--------------------------------------------------------\n');

    % Start timer
    startTime = datetime('now');

    while true
        % Get current time
        timeNow = seconds(datetime('now') - startTime);

        % Read and convert temperature
        voltage = readVoltage(a, tempPin);
        temperature = (voltage - 0.5) / 0.01;

        % Update history
        timeElapsed(end+1) = timeNow;
        temperatureHistory(end+1) = temperature;

        % Calculate rate of change
        if length(temperatureHistory) >= 5
            historyLength = length(temperatureHistory);
            
            % Get the last 10 redings
            if historyLength > 10
                readings = (historyLength - 9):historyLength;
            else
                readings = 1:historyLength;
            end

            % Get tge dy for differentiating
            temps = temperatureHistory(readings);
            % Smooth out the temps so the spikes dont affect the result
            smoothedTemps = movmean(temps, min(5, length(temps)));
            
            % Get the time passed in minutes for dx
            times = timeElapsed(readings);
            timeDiff = (times(end) - times(1)) / 60;

            % Calculate dy/dx if time has passed
            if timeDiff > 0
                rate = (smoothedTemps(end) - smoothedTemps(1)) / timeDiff;
            else
                rate = 0;
            end
        else
            rate = 0;
        end

        % Predict temperature
        predictedTemp = temperature + (rate * 5);

        % LED logic
        if rate > criticalRateIncrease
            writeDigitalPin(a, redPin, 1);
            writeDigitalPin(a, yellowPin, 0);
            writeDigitalPin(a, greenPin, 0);
            status = 'ALERT: Rising too fast';
        elseif rate < criticalRateDecrease
            writeDigitalPin(a, redPin, 0);
            writeDigitalPin(a, yellowPin, 1);
            writeDigitalPin(a, greenPin, 0);
            status = 'ALERT: Falling too fast';
        else
            writeDigitalPin(a, redPin, 0);
            writeDigitalPin(a, yellowPin, 0);
            writeDigitalPin(a, greenPin, 1);
            status = 'Stable';
        end

        % Display data
        fprintf('%7.1f | %10.2f | %11.2f | %17.2f | %s\n', ...
            timeNow, temperature, rate, predictedTemp, status);

        pause(0.5);
    end
end
