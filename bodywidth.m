function [width,stations] = bodywidth(length)
% calculates body width at stations along the body based on n = 10
% mesomorphic right whales
% ratio means units in == units out 
stations = [0:0.1:0.8]*length;
ratio = [0.07 0.149 0.191 0.226 0.22 0.207 0.176 0.126 0.063];
width = length*ratio;
