# Signal Generation Patterns

Complete MATLAB code patterns for generating each signal type. All patterns produce column vectors compatible with `timeseries(data, t)` or timetable construction.

## Time Vector Construction

```matlab
stopTime = str2double(get_param(mdl, 'StopTime'));
solverType = get_param(mdl, 'SolverType');
if strcmp(solverType, 'Fixed-step')
    dtVal = str2double(get_param(mdl, 'FixedStep'));
    if isnan(dtVal)
        dt = stopTime / 1000;
    else
        dt = dtVal;
    end
else
    dt = stopTime / 1000;
end
t = (0:dt:stopTime)';
```

## Constant

```matlab
data = value * ones(size(t));
```

For boolean: `data = true(size(t));` or `data = false(size(t));`

## Step

```matlab
data = startValue * ones(size(t));
data(t >= stepTime) = endValue;
```

Multi-step (staircase):

```matlab
data = values(1) * ones(size(t));
for k = 1:length(times)
    data(t >= times(k)) = values(k + 1);
end
```

## Ramp

```matlab
data = startValue + slope * max(t - startTime, 0);
```

Clamped ramp (ramp to target then hold):

```matlab
rampDuration = endTime - startTime;
slope = (endValue - startValue) / rampDuration;
data = startValue + slope * max(min(t - startTime, rampDuration), 0);
```

## Sine

```matlab
data = offset + amplitude * sin(2*pi*frequency*t + phase);
```

Damped sine:

```matlab
data = amplitude * exp(-damping*t) .* sin(2*pi*frequency*t);
```

## Chirp (Linear Frequency Sweep)

```matlab
T = t(end) - t(1);
k = (freqEnd - freqStart) / T;
phase = 2*pi * (freqStart*t + 0.5*k*t.^2);
data = amplitude * sin(phase);
```

## Pulse / Square Wave

```matlab
phase = mod(t, period) / period;
data = amplitude * double(phase < dutyCycle);
```

## Noise

```matlab
rng(seed);
data = stddev * randn(size(t));
```

## Sawtooth

```matlab
data = amplitude * (mod(t, period) / period);
```

## Triangle Wave

```matlab
phase = mod(t, period) / period;
data = amplitude * (2 * abs(2*phase - 1) - 1);
```

## Exponential Decay

```matlab
data = amplitude * (1 - exp(-(t - startTime) / tau)) .* (t >= startTime);
```

## Composition: Piecewise Segments

```matlab
data = zeros(size(t));
% Segment 1: ramp from 0 to 80 over 0-5s
mask = t <= 5;
data(mask) = 80 * (t(mask) / 5);
% Segment 2: hold at 80 from 5-20s
mask = (t > 5) & (t <= 20);
data(mask) = 80;
% Segment 3: ramp down from 80 to 0 over 20-25s
mask = (t > 20) & (t <= 25);
data(mask) = 80 * (1 - (t(mask) - 20) / 5);
```

## Composition: Superposition

```matlab
% Base signal + noise
data = genRamp + stddev * randn(size(t));

% Multi-frequency
data = sin(2*pi*0.5*t) + 0.3*sin(2*pi*5*t);
```

## Type Casting

Use `cast(data, 'like', origEl.Data)` to match the scaffold's data type — works universally for double, single, integer, and fixed-point:

```matlab
signalData = cast(myWaveform, 'like', origEl.Data);
```

For boolean inports, use `true(size(t))` or `false(size(t))` directly (cast does not produce logical).

## Multi-dimensional Signals

For vector/matrix inports, generate each element or use phased patterns:

```matlab
% 3-element vector inport, phased sine
data = zeros(length(t), 3);
for k = 1:3
    data(:, k) = sin(2*pi*1*t + (k - 1)*2*pi/3);
end
ts = timeseries(data, t, 'Name', 'ThreePhaseInput');
```

## Dataset Assembly (timeseries)

```matlab
origEl = ds{k};
ts = timeseries(signalData, t, 'Name', origEl.Name);
ts.DataInfo.Interpolation = origEl.DataInfo.Interpolation;
ts.DataInfo.Units = origEl.DataInfo.Units;
ds{k} = ts;
```

## Dataset Assembly (timetable)

```matlab
origEl = ds{k};
tt = timetable(seconds(t), signalData, 'VariableNames', {'Data'});
tt.Properties.VariableContinuity = origEl.Properties.VariableContinuity;
ds = ds.setElement(k, tt, origEl.Properties.Description);
```

----

Copyright 2026 The MathWorks, Inc.

----
