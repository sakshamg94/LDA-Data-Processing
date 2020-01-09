function [u,w]= rotateVelocities(LDA1,LDA2,angle)
% [u,w]= rotateVelocities(LDA1,LDA2,angle)
% rotateVelocities rotates raw LDA data COUNTER!clockwise by angle theta
% (assumed to be in degrees)
%
% Tracy Mandel (tmandel@stanford.edu)
% Last updated: 23 April 2015

% Convert degrees to radians
theta= angle*pi/180;

% Make sure LDA1 and LDA2 are row vectors
[~,nc]= size(LDA1);
if nc==1
    LDA1= LDA1';
    LDA2= LDA2';
end

% CCW rotation matrix
C= [cos(theta), -sin(theta);
    sin(theta), cos(theta)];

out= C*[LDA1;LDA2];
u= out(1,:)';
w= out(2,:)';

