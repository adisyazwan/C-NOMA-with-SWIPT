clc; clear variables; close all;

N = 10^6;

d1 = 1;     %Source to user 1 distance
d2 = 2;     %Source to user 2 distance
d12 = 1;    %User 1 to user 2 distance

eta = 4;    %Path loss exponent
h2 = sqrt(d2^-eta)*(randn(1,N) + 1i*randn(1,N))/sqrt(2);    %source to user 2 channel
h12 = sqrt(d12^-eta)*(randn(1,N) + 1i*randn(1,N))/sqrt(2);  %user 1 to user 2 channel

%Channel gains
g2 = (abs(h2)).^2;
g12 = (abs(h12)).^2;

SNR = 0:40;         %SNR in dB
snr = db2pow(SNR);  %SNR linear

a1 = 0.2; a2 = 0.8;     %Power allocation coefficients
R2 = 1;       %Target rate

p2 = zeros(1,length(snr));
p12 = zeros(1,length(snr));
p_oma = zeros(1,length(snr));
for u = 1:length(snr)
   gamma_2 = a2*snr(u)*g2./(a1*snr(u)*g2 + 1); %SNR for user 2 (direct tx-ion)
   gamma_12 = snr(u)*g12;                       %SNR for user 2 (relayed tx-ion)
   
   C2 = log2(1 + gamma_2);                      %achievable rate of user 2 without cooperation
   C_OMA = 0.5*log2(1 + snr(u)*g2);
   C12 = 0.5*log2(1 + max(gamma_12,gamma_2));   %achievable rate of user 2 with cooperation
   for k = 1:N
       if C2(k)<R2              %Outage for non-cooperative NOMA
           p2(u) = p2(u)+1;
       end
       if C12(k)<R2             %Outage for cooperative NOMA
           p12(u) = p12(u)+1;
       end
       if C_OMA(k)<R2           %Outage for OMA (no NOMA)
           p_oma(u) = p_oma(u)+1;
       end
   end
end

semilogy(SNR,p_oma/N,'linewidth',2); hold on; grid on;
semilogy(SNR,p2/N,'linewidth',2);
semilogy(SNR,p12/N,'k','linewidth',2);

xlabel('SNR'); ylabel('Outage probability');
legend('Far user without NOMA','Far user NOMA without cooperation','Far user NOMA with cooperation');














