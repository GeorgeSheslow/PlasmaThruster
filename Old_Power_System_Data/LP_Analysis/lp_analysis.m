

T = readtable("lp_data.txt");

sgtitle("Langmuir Probe Aanlysis with 1.5mF Cathode/Anode Main Capacitor")
subplot(3,1,1)
plot(T.Time, T.ChannelLP1.*10)
title("Langmuir Probe Output Voltage")
xlabel("Time (us)")
ylabel("Voltage (V)")

subplot(3,1,2)
plot(T.Time, T.ChannelCurrent.*2000)
title("Cathode Current")
xlabel("Time (us)")
ylabel("Current (A)")

subplot(3,1,3)
plot(T.Time, T.ChannelVoltage.*20 - 10)
title("Cathode Voltage")
xlabel("Time (us)")
ylabel("Voltage (V)")
