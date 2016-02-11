% Function to run cubic smoothing splines with smoothing parameter selected
% by GCV, among lambda_vec = (lamb_min : lamb_step : lamb_max)

%% Input
% Y_cgrid, response cells
% T_cgrid, common grid cells
% SS_lamb_min, min smoothing parameter value = 0.99;
% SS_lamb_step, step of smoothing parameter value;
% SS_lamb_max, max smoothing parameter value = 0.999;
%% Output
% Ycsp_opt: smoothed signal matrix p by n.

%%
function [Ycsp_opt] = css_gcv(Y_cgrid, T_cgrid, lamb_min, lamb_max, lamb_step)

lambda_vec = lamb_min : lamb_step : lamb_max;


SS_p = length(T_cgrid{1}); % all curves has the same length
SS_n = size(Y_cgrid, 2); % total number of curves

% using data of common grid, convert to p by n matrix
Ycsp_opt = zeros(SS_p, SS_n);

for i = 1:SS_n
    t0 = T_cgrid{i};
    error_rmse = zeros(1, length(lambda_vec));
    
    for k = 1:length(lambda_vec)
        Ycsp = zeros(SS_p, 1);
        for SS_j= 1:SS_p 
            Ymat2 = Y_cgrid{i};
            Ymat2(SS_j)=[];
            t2 = t0;
            t1=t0(SS_j);
            t2(SS_j)=[];
            Ycsp(SS_j) = csaps(t2, Ymat2, lambda_vec(k), t1);
        end 
     error_rmse(k) = rmse(Y_cgrid{i}', Ycsp); 
    end
    [min_rmse, opt_k] = min(error_rmse);
    lambda_opt = lambda_vec(opt_k);
    Ycsp_opt(:, i) = csaps(t0, Y_cgrid{i}, lambda_opt, t0);
end

end


