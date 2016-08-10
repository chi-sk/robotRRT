function [q_path, X_free, parent, cost, Time, success] = extend(q_path, ...
    X_free, parent, cost, Time, X_rand, rank, factor, obstacle, robot)
% This function perform the RRT method 'extend' use.

% input variables:
% q_path: the current free space for joint orbit
% X_free: the current free space for pose orbit
% parent: the father point of each point, take down by rank(in free space)
% cost: the cost function, usually the distance(in free space)
% Time: the time taken to go to each point(in free space)
% X_rand: the random point in space, usually got by method sample()
% rank: rank of current big clcle in RRT while, also the size of extended
%   point of q
% factor: a factor, deciding how many steps should be done in one MLG 
%   cycle(2*factor), and deciding the extending distance(factor / 100)
% obstacle: the obstacle variable
% robot: the structure of robot DH method and so on

% output variables:
% q_path|X_free}parent|cost|Time: after extend the new point into the old tree, 
%   all of this variables are refreshed.
% success: 1 for extending successfully, and 0 for fail.

% �ҳ�X_rand�����X_free(i)
[near_p, near_rank, near_dis] = Nearest_neighbor(X_rand, X_free, rank-1); 
ext_dis = 0.01*factor;
if ext_dis < near_dis
    X_new = near_p + eplsion/near_dist*(X_rand - near_p);
else
    X_new = X_rand;
end

X_new_near = X_new - near_p;
q_initial = q_path(:, near_rank);
cost_min = min(ext_dis, near_dis);
steps = double(int8(2*factor));
% doing MLG, get the joint orbit from q_near to q_new
[q_path,X_path,T_path,~,success] = MLG(q_initial, X_new_near, cost_min, ...
    steps, obstacle, robot);
% if success, extend the new point to the orginal tree
if success
    q_path(:, rank) = q_path(:, steps + 1);
    X_free(:, rank) = X_path(:, steps + 1);
    Time(rank) = Time(near_rank) + T_path(steps + 1);
    cost(rank) = cost(near_rank) + cost_min;
    parent(rank) = near_rank;
end
end