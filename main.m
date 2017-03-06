clear all,close all,clc;
a = imread('imagen.jpg');

b1=edge(a,'sobel','vertical'); 
b2=edge(a,'sobel','horizontal'); 
b3=edge(a,'sobel'); 

b3 = ~b3;
figure(1);
imshow(b3);
