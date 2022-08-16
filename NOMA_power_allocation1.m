clc; clear variables; 

N = 5*10^5;
Pt = 20;
No = -114;

pt = (10^-3)*db2pow(Pt);
no = (10^-3)*db2pow(No);

a1 = 0:0.01:1;
a2 = 1 - a1;

d1 = 1000; d2 = 500;

eta = 4;
h1 = sqrt(d1^-eta)*(randn(1,N) + 1i*randn(1,N))/sqrt(2);
h2 = sqrt(d2^-eta)*(randn(1,N) + 1i*randn(1,N))/sqrt(2);

g1 = (abs(h1)).^2;
g2 = (abs(h2)).^2;

%Generate noise samples for both users
w1 = sqrt(no)*(randn(1,N)+1i*randn(1,N))/sqrt(2);
w2 = sqrt(no)*(randn(1,N)+1i*randn(1,N))/sqrt(2);

data1 = randi([0 1],1,N);
data2 = randi([0 1],1,N);

x1 = 2*data1 - 1;
x2 = 2*data2 - 1;

for u = 1:length(a1)
    x = sqrt(pt)*(sqrt(a1(u))*x1 + sqrt(a2(u))*x2);
    y1 = x.*h1 + w1;
    y2 = x.*h2 + w2;
    
    %Equalize 
    eq1 = y1./h1;
    eq2 = y2./h2;
    
    %AT USER 1--------------------
    %Direct decoding of x1 from y1
    x1_hat = zeros(1,N);
    x1_hat(eq1>0) = 1;
    
    %Compare decoded x1_hat with data1 to estimate BER
    ber1(u) = biterr(data1,x1_hat)/N;
    
     %----------------------------------
    
    %AT USER 2-------------------------
    %Direct decoding of x1 from y2
    x12_hat = ones(1,N);
    x12_hat(eq2<0) = -1;
    
    y2_dash = eq2 - sqrt(a1(u)*pt)*x12_hat;
    x2_hat = zeros(1,N);
    x2_hat(real(y2_dash)>0) = 1;
    
    ber2(u) = biterr(x2_hat, data2)/N;
    %-----------------------------------   
end

semilogy(a1, ber1,'--r', 'linewidth',1.5); hold on; grid on;
semilogy(a1, ber2,'--b', 'linewidth',1.5);
xlabel('\alpha_1');
ylabel('BER');

legend('Far user','Near user');










