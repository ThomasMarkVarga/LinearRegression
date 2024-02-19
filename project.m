%% 
close all
clear all
clc
load proj_fit_23.mat

% given data
x1 = id.X{1};
x2 = id.X{2};
y = id.Y;
figure;
mesh(x1,x2,y);
title('Identification dataset')

% variable for the reshaped y
y_new = [];

% dimensions
N = id.dims(1);
G = id.dims(2);

% power of the polynomial
for n = 2 : 25
    phi = [];
    y_new = [];
    % generation of phi
    k = 1; % numering the lines
    for i = 1:N

        % reshaping y
        y_new = [y_new, y(i,:)];

        for j = 1:G
            l = 1; % numbering the columns
            for a = 0:n
                for b = 0:n
                    for c = 0:n
                        if a + b + c == n
                            phi(k, l) = (1^a)*(x1(i)^b)*(x2(j)^c);
                            l = l + 1; % incrementing columns after placing number
                        end
                    end
                end
            end
            k = k + 1; % incrementing lines after finishing 
        end
    end

    teta = phi \ y_new';
    yhat = phi * teta;

    yhat = reshape(yhat, N, G)'; % we transpose the reshape because 
    % ( nu stiu explica in engleza, vector 1 2 3 4 devine matricea 1 3; 2 4, nu
    % 1 2; 3 4 ) inglish 101;

    if(n == 4)
        figure;
        mesh(x1,x2,yhat);
        title('Identification visualition for Polynomial Power: n = 4 (Underfit)')
    end

    sum = 0;
    for i = 1:N
        for j = 1:G
            sum = sum + (yhat(i,j) - y(i,j))^2;
        end
    end
    MSE(n) = sum / (N*G);

    k = 1;  
    for i = 1:val.dims(1)
        for j = 1:val.dims(2)
            l = 1; % numbering the columns
            for a = 0:n
                for b = 0:n
                    for c = 0:n
                        if a + b + c == n
                            phi_val(k, l) = (1^a)*(val.X{1}(i)^b)*(val.X{2}(j)^c);
                            l = l + 1; % incrementing columns after placing number
                        end
                    end
                end
            end
            k = k + 1; % incrementing lines after finishing 
        end
    end

    yhat_val = phi_val * teta;

    yhat_val = reshape(yhat_val, val.dims(1), val.dims(2))';

    sum = 0;
    for i = 1:val.dims(1)
        for j = 1:val.dims(2)
            sum = sum + (yhat_val(i,j) - val.Y(i,j))^2;
        end
    end
    MSE_val(n) = sum / (val.dims(1) * val.dims(2));
end
figure;
plot(MSE);
hold on
plot(MSE_val)
legend('MSE id','MSE val')

hold off

% ploting regression for optimal MSE

x1 = val.X{1};
x2 = val.X{2};
y = val.Y;
figure;
mesh(x1,x2,y);
title('Validation dataset')

N = val.dims(1);
G = val.dims(2);

% Optimal Polynomial Power 
n = 7;

y_new = [];
phi = [];
k = 1; % numering the lines
for i = 1:N

    % reshaping y
    y_new = [y_new, y(i,:)];

    for j = 1:G
        l = 1; % numbering the columns
        for a = 0:n
            for b = 0:n
                for c = 0:n
                    if a + b + c == n
                        phi(k, l) = (1^a)*(x1(i)^b)*(x2(j)^c);
                        l = l + 1; % incrementing columns after placing number
                    end
                end
            end
        end
        k = k + 1; % incrementing lines after finishing 
    end
end

teta = phi \ y_new';
yhat = phi * teta;

yhat = reshape(yhat, N, G)';

figure;
mesh(x1,x2,yhat)
title('Regression for validation dataset with Polynomial Power: n = 7')