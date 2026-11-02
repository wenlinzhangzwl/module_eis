%% 1 - Impedance of individual battery cells
clear
clc
close all

% Healthy cells
folder = (".\Data\Plotting\G1\");
files = dir(folder + "*.mat"); 
meas_healthy_Zimag = [];
meas_healthy_Zreal = []; 
for i = 1:height(files)
    load(files(i).folder + "\" + files(i).name)
    meas_healthy_Zreal = [meas_healthy_Zreal; meas.Zreal]; 
    meas_healthy_Zimag = [meas_healthy_Zimag; meas.Zimag]; 
end

figure; 
hold on
plot(meas_healthy_Zreal*1000, -meas_healthy_Zimag*1000, "*", color = "#0072BD");

% Aged cells
folder = (".\Data\Plotting\G2\");
files = dir(folder + "*.mat"); 
meas_aged_Zimag = [];
meas_aged_Zreal = []; 
for i = 1:height(files)
    load(files(i).folder + "\" + files(i).name)
    meas_aged_Zreal = [meas_aged_Zreal; meas.Zreal]; 
    meas_aged_Zimag = [meas_aged_Zimag; meas.Zimag]; 
end

hold on
plot(meas_aged_Zreal*1000, -meas_aged_Zimag*1000, "o", color = "#D95319");

xlabel("Z' (m{\Omega})"); ylabel('- Z" (m{\Omega})'); grid on; 
legend("Healthy", "Aged", Location="southeast")

%% 2 - Module impedance spectra w/ transition frequency
clear
clc
close all

% Group 1
folder = (".\Data\Plotting\G3\");
files = dir(folder + "*.mat"); 

figure; subplot(2, 1, 1); hold on

for i = 1:height(files)
    load(files(i).folder + "\" + files(i).name)
    plot(meas.Zreal*1000, -meas.Zimag*1000, "o", 'MarkerSize',5);

    % Find transition frequency    
    [~, ind_i] = findpeaks(meas.Zimag);
    if isempty(ind_i)
        ind_i = height(meas); % Take the last point for now
    elseif height(ind_i) ~= 1
        ind_i = ind_i(end);
    end
    data.trans_freq(i) = meas.Frequency(ind_i);
    data.trans_Zreal(i) = meas.Zreal(ind_i);
    data.trans_Zimag(i) = meas.Zimag(ind_i); 

end

xlabel("Z' (m{\Omega})"); ylabel('- Z" (m{\Omega})'); grid on; ylim([-1, 13])
hold on; plot(data.trans_Zreal*1000, -data.trans_Zimag*1000, "x", 'MarkerSize',10, color = 'red', LineWidth=2)
legend("M1 (SOH = 94.9%)", "M2 (SOH = 90.3%)", "M3 (SOH = 87.1%)", "M4 (SOH = 86.3%)", Location="southeast")

% Group 2
folder = (".\Data\Plotting\G4\");
files = dir(folder + "*.mat"); 

subplot(2, 1, 2); hold on

for i = 1:height(files)
    load(files(i).folder + "\" + files(i).name)
    plot(meas.Zreal*1000, -meas.Zimag*1000, "o", 'MarkerSize',5);

    % Find transition frequency    
    [~, ind_i] = findpeaks(meas.Zimag);
    if isempty(ind_i)
        ind_i = height(meas); % Take the last point for now
    elseif height(ind_i) ~= 1
        ind_i = ind_i(end);
    end
    data.trans_freq(i) = meas.Frequency(ind_i);
    data.trans_Zreal(i) = meas.Zreal(ind_i);
    data.trans_Zimag(i) = meas.Zimag(ind_i); 

end

xlabel("Z' (m{\Omega})"); ylabel('- Z" (m{\Omega})'); grid on; ylim([-1, 13])
hold on; plot(data.trans_Zreal*1000, -data.trans_Zimag*1000, "x", 'MarkerSize',10, color = 'red', LineWidth=2)
legend("M5 (SOH = 95.6%)", "M6 (SOH = 89.8%)", "M7 (SOH = 88.0%)", "M8 (SOH = 86.7%)", Location="southeast")

%% 3 - Impedance of M1- M4 at different SOCs
clear
clc
close all

folder = (".\Data\Plotting\G5\");
files = dir(folder + "*.mat"); 

for i = 1:height(files)
    data(i).meas = load(files(i).folder + "\" + files(i).name);

    filename_i = split(files(i).name, "_");

    SOC_nom_i = split(filename_i(3), "SOC");
    SOC_nom_i = split(SOC_nom_i(2), ".");
    data(i).SOC_nom = str2double(SOC_nom_i(1));

    module_i = split(filename_i(2), "M");
    data(i).ModuleNum = str2double(module_i(2));
end
data = struct2table(data); 

mod_num = [100, 50, 0];
figure;
for i = 1:length(mod_num)
    ind = find(data.SOC_nom(1:end) == mod_num(i));

    subplot(length(mod_num), 1, i); hold on

    for j = 1:height(ind)
        meas = data.meas(ind(j)).meas; 
        plot(meas.Zreal*1000, -meas.Zimag*1000, "*"); 
    end

    title("SOC = " + mod_num(i) + "%")
    legend("Module #" + string(data.ModuleNum(ind)), Location="southeast"); 
    xlabel("Z' (m{\Omega})"); ylabel('- Z" (m{\Omega})'); grid on;
    xlim([8, 55]); ylim([-1, 16])

end


%% 4 - Repeatability test results
clear
clc
% close all

folder = (".\Data\Plotting\G6\");
files = dir(folder + "*.mat"); 

for i = 1:height(files)
    data(i).meas = load(files(i).folder + "\" + files(i).name);

    filename_i = split(files(i).name, "_");

    SOC_nom_i = split(filename_i(3), "SOC");
    SOC_nom_i = split(SOC_nom_i(2), ".");
    data(i).SOC_nom = str2double(SOC_nom_i(1));

    module_i = split(filename_i(2), "M");
    data(i).ModuleNum = str2double(module_i(2));
end
data = struct2table(data); 

mod_num = [1:8];
figure;hold on

for i = 1:length(mod_num)
    ind = find(data.ModuleNum(1:end) == mod_num(i)); 

    subplot(4, 2, i); hold on

    meas = data.meas(ind(1)).meas;
    for j = 2:height(ind)
        meas = [meas; data.meas(ind(j)).meas]; 
    end

    plot(meas.Zreal*1000, -meas.Zimag*1000, "o"); 

    title("Module #" + string(mod_num(i)))
%     legend("Module #" + string(mod_num), Location="southeast"); 
    xlabel("Z' (m{\Omega})"); ylabel('- Z" (m{\Omega})'); grid on;  
end


% xlim([8, 55]); ylim([-1, 16])