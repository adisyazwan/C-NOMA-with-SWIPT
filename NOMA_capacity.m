clc; clear variables; close all;

N = 10^5;

d1 = 1000; d2 = 500;    %Distances of users from base station (BS)
a1 = 0.75; a2 = 0.25;   %Power allocation factors
eta = 4;                %Path loss exponent

%Generate rayleigh fading coefficient for both users
h1 = sqrt(d1^-eta)*(randn(1,N)+1i*randn(1,N))/sqrt(2);
h2 = sqrt(d2^-eta)*(randn(1,N)+1i*randn(1,N))/sqrt(2);

g1 = (abs(h1)).^2;
g2 = (abs(h2)).^2;

Pt = 0:2:40;                %Transmit power in dBm
pt = (10^-3)*10.^(Pt/10);   %Transmit power in linear scale
BW = 10^6;                  %System bandwidth
No = -174 + 10*log10(BW);   %Noise power (dBm)
no = (10^-3)*10.^(No/10);   %Noise power (linear scale)

p = length(Pt);
p1 = zeros(1,length(Pt));
p2 = zeros(1,length(Pt));

rate1 = 1; rate2 = 2;       %Target rate of users in bps/Hz
for u = 1:p
    %Calculate SNRs
    gamma_1 = a1*pt(u)*g1./(a2*pt(u)*g1+no);
    gamma_12 = a1*pt(u)*g2./(a2*pt(u)*g2+no);
    gamma_2 = a2*pt(u)*g2/no;
    
    %Calculate achievable rates
    R1 = log2(1+gamma_1);
    R12 = log2(1+gamma_12);
    R2 = log2(1+gamma_2);
    
    %Find average of achievable rates
    R1_av(u) = mean(R1);
    R12_av(u) = mean(R12);
    R2_av(u) = mean(R2);
    
    %Check for outage
    for k = 1:N
        if R1(k) < rate1
            p1(u) = p1(u)+1;
        end
        if (R12(k) < rate1)||(R2(k) < rate2)
            p2(u) = p2(u)+1;
        end
    end
end

pout1 = p1/N; 
pout2 = p2/N;

figure;
semilogy(Pt, pout1, 'linewidth', 1.5); hold on; grid on;
semilogy(Pt, pout2, 'linewidth', 1.5);
xlabel('Transmit power (dBm)');
ylabel('Outage probability');
legend('User 1 (far user)','User 2 (near user)');

figure;
plot(Pt, R1_av, 'linewidth', 1.5); hold on; grid on;
plot(Pt, R12_av, 'linewidth', 1.5);
plot(Pt, R2_av, 'linewidth', 1.5);
xlabel('Transmit power (dBm)');
ylabel('Achievable capacity (bps/Hz)');
legend('R_1','R_{12}','R_2')


