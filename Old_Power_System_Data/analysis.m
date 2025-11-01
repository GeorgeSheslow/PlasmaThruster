close all
clear

samples = 5;
voltage = 100;

offset = [2,2,2,2,2];
for s = 1:samples
    name = sprintf("Data/%dV_%d.txt", voltage, s);
    % name = sprintf("Data/trigger_%d.txt", s);
    readtable(name)
    
    % smoothing 
    ans.ChannelA = smoothdata(ans.ChannelA, "gaussian",100);
    ans.ChannelB = smoothdata(ans.ChannelB, "gaussian",100);

    % Data Offset and Scaling
    ans.ChannelA = ((ans.ChannelA-10) *10);
    subplot(4,1,1)
    plot(ans.Time, ans.ChannelA);
    hold on
    str_name = sprintf("Thruster at %dV", voltage);
    sgtitle(str_name)
    % title("Thruster with High Voltage Trigger")
    title("Voltage Plot")
    ylabel("Voltage (V)")
    xlabel("Time (us)")
    legend(["Sample 1", "Sample 2","Sample 3","Sample 4","Sample 5"])
    
    subplot(4,1,2)
    ans.ChannelB = (ans.ChannelB *2000);
    plot(ans.Time, ans.ChannelB);
    hold on
    title("Current Plot")
    ylabel("Current (A)")
    xlabel("Time (us)")
    legend(["Sample 1", "Sample 2","Sample 3","Sample 4","Sample 5"])

    subplot(4,1,3)
    resistance = -ans.ChannelA ./ ans.ChannelB;
    offset = 2750;
    resistance(1:offset) = 0;
    semilogy(ans.Time, resistance);
    hold on
    title(str_name)
    ylabel("Impedance")
    xlabel("Time (us)")
    legend(["Sample 1", "Sample 2","Sample 3","Sample 4","Sample 5"])

    subplot(4,1,4)
    power = ans.ChannelB.^2 .* resistance;
    plot(ans.Time, power);
    hold on
    title(str_name)
    ylabel("Power (W)")
    xlabel("Time (us)")
    legend(["Sample 1", "Sample 2","Sample 3","Sample 4","Sample 5"])
end