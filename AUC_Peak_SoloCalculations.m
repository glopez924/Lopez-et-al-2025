% Plot Graph!
figure('Name', 'Mean PSTH', 'Color',[1 1 1])
hold on
set(gca, 'Fontsize', 18)
xlim ([-5,15]);
%ylim([-2, 2]);
%h1 = plot(timeAxis, meanPsthA, 'b-', 'linewidth', 1);
%h1 = plot(timeAxis, GroupMeanPsthA, 'b-', 'linewidth', 1);
%h1 = plot(timeAxis, CueAvoidPSTHA, 'b-', 'linewidth', 1);
%h1 = plot(timeAxis, CueEscapePSTHA, 'b-', 'linewidth', 1);
h1 = plot(timeAxis, GroupEscapePsthA, 'b-', 'linewidth', 1);
%fill([timeAxis, fliplr(timeAxis)],[meanErrPosA, fliplr(meanErrNegA)], [0,0,1],'FaceAlpha', 0.2, 'EdgeColor', 'none');
%fill([timeAxis, fliplr(timeAxis)],[AvoidErrPosA, fliplr(AvoidErrNegA)], [0,0,1],'FaceAlpha', 0.2, 'EdgeColor', 'none');
%fill([timeAxis, fliplr(timeAxis)],[EscapeErrPosA, fliplr(EscapeErrNegA)], [0,0,1],'FaceAlpha', 0.2, 'EdgeColor', 'none');
xlabel('Time(s)');
ylabel('Z-Score');

% Calculate AUC
x = timeAxis;
%y = meanPsthA;
%y = GroupMeanPsthA;
%y = CueAvoidPSTHA;
%y = CueEscapePSTHA;
y = GroupEscapePsthA;
range1 = x >= 0 & x <= 5;
range2 = x >= 5 & x <= 10;
x1 = x(range1);
x2 = x(range2);
y1 = y(range1);
y2 = y(range2);
yy = zeros(1,length(x1));
yy(:) = 0;

zci_y1 = find(diff(sign(y1)));
zci_y2 = find(diff(sign(y2)));

g = max(zci_y1);
zerocross1 = x1(g);

h = min(zci_y2);
zerocross2 = x2(h);

i = max(zci_y2);
zerocross3 = x2(i);

timezero = find(diff(sign(x)));
zscore_timezero = y(timezero+1);

% Cue
y_posa = y1; y_posa(y1<0) = 0;  % focus on area above x-axis
res1a = trapz(x1, y_posa);
y_nega = y1; y_nega(y1>0) = 0; % focus on area below x-axis
res2a = trapz(x1, y_nega);

% Post-Cross
y_posb = y2; y_posb(y2<0) = 0;  % focus on area above x-axis
res1b = trapz(x2, y_posb);
y_negb = y2; y_negb(y2>0) = 0; % focus on area below x-axis
res2b = trapz(x2, y_negb);

area_1 = trapz(x1, y1);                       % Calculate ?Area #1?                       % Calculate ?Area #2?
area_2 = trapz(x2, y2);
BeforeCross = area_1;
AfterCross = area_2;

% Area Plot (original)
figure('Name', 'PSTH', 'Color',[1 1 1])
hold on
set(gca, 'Fontsize', 14);
xlim ([-2,15]);
h1 = plot(x1, y1, 'b-', 'linewidth', 2);
hold on
ha1 = area(x1, y1, 'FaceColor','g');
ha2 = area(x2, y2, 'FaceColor','m');
hold off
A1str = sprintf('Area 1 = %6.3f', area_1);
A2str = sprintf('Area 2 = %6.3f', area_2);
legend([ha1 ha2], A1str, A2str)

% Calculate Peaks
[pksBeforeCross, locsBeforeCross] = findpeaks(-y1);
MaxBefore5secs_neg = -max(pksBeforeCross);

[pksAfterCross, locsAfterEsp] = findpeaks(y2);
MaxAfter5secs_pos = max(pksAfterCross);

[pksBeforeCross, locsAvdBeforeEsp] = findpeaks(y1);
MaxBefore5secs_pos = max(pksBeforeCross);

[pksAfterCross, locsShkAfterEsp] = findpeaks(-y2);
MaxAfter5secs_neg = -max(pksAfterCross);

MinBefore5secs_pos = min(pksBeforeCross);
