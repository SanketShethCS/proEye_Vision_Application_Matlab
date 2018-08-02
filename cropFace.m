
% Step 1 Read Image
    
% Step 2 Check Face
imgR = imread('C:\Users\nolan\Desktop\hackmathworks\image5.jpg');
faceAns=checkFace(imgR);    
[imag1,BB]=upperCrop(imgR);
[imag2,BB2]=faceCrop(imag1);
faceRemoved=removeFace(imag1,BB2);
coverageAns=coverage(imag1,imag2);
f=removeForeground(faceRemoved,BB,BB2);
[saturationAns,hueAns]=hsv(f);

function [imag1,BB]=upperCrop(imgR)
    [imag1,BB]=upperbody(imgR);
    figure(4);
    imshow(imag1);
end

function [imag2,BB2]=faceCrop(imag1)
    [imag2, BB2]=face(imag1);
    figure(5);
    imshow(imag2);
end
function faceRemoved=removeFace(imag1,BB2)
    faceRemoved = imag1;
    faceRemoved(BB2(2):BB2(2)+BB2(4), BB2(1):BB2(1)+BB2(3),:) = 0;
    figure(6);
    imshow(faceRemoved);
end


function f=removeForeground(faceRemoved,BB,BB2)
    f=faceRemoved;
    f(BB2(3)+BB2(2):BB(3),1:BB(3),:) = 0;
    figure(7);
    imshow(f);
end


function [saturationAns,hueAns]=hsv(f)
    newI=rgb2hsv(f);
    H=newI(:,:,1);
    H= round(H,1);
    S=newI(:,:,2);
    saturationAns=saturation(S);
    hueAns=hue(H);
end


function answer=hue(H)
    totalBracket1=sum(sum((0.1972>H&H>0)));
    totalBracket2=sum(sum((0.3916>H&H>0.1972)));
    totalBracket3=sum(sum((0.5916>H&H>0.3916)));
    totalBracket4=sum(sum((0.7888>H&H>0.5916)));
    totalBracket5=sum(sum((0.9972>H&H>0.7888)));
    TotalHues=totalBracket1+totalBracket2+totalBracket3+totalBracket4+totalBracket5;
    M=[totalBracket1,totalBracket2,totalBracket3,totalBracket4,totalBracket5];
    Maximum=max(M);
    index=find(M==Maximum);
    M(index) = 0;
    SecondMax=max(M);
    diff=Maximum-SecondMax;
    if diff/TotalHues < 0.7
        answer="Fail Hue";
        disp(final);
    else
        answer="Pass Hue";
    end
end

function answer=saturation(S)
    totalFound=sum(sum((S>0.6)));
    totalOverall=sum(sum((S>0)));
    percentS=totalFound/totalOverall;
    if percentS > 0.05
        answer="Fail Saturation";
        %disp(final);
    else
        answer="Pass Saturation";
    end
end

function answer=coverage(imag1,imag2)
    sizeBigImage=size(imag1);
    overalPixels=sizeBigImage(1)*sizeBigImage(2);
    sizeFaceImage=size(imag2);
    FacePixels=sizeFaceImage(1)*sizeFaceImage(2);
    TotalRemovedPixels=FacePixels*4;
    PercentageRemoved=TotalRemovedPixels/overalPixels;
    if  PercentageRemoved < 0.5
    answer="Fail Coverage";
    %disp(final);
    else
    answer="Pass Coverage";
    end
end

function [x, BB2]=face(imag1) 
img = imag1;
 FaceDetect = vision.CascadeObjectDetector;
 FaceDetect.MergeThreshold = 7 ; 
 BB2 = step(FaceDetect,img);
 for i = 1:size(BB2,1)
    rectangle('Position',BB2(i,:),'LineWidth',3,'LineStyle','-','EdgeColor','r'); 
 end
 for i = 1:size(BB2,1)
     J= imcrop(img,BB2(i,:));
 end
 x=J;
end


function [f,BB]=upperbody(img) 
 checkFace(img);
 FaceDetect = vision.CascadeObjectDetector('UpperBody');
 FaceDetect.MergeThreshold = 7 ; 
 BB = step(FaceDetect,img);
 for i = 1:size(BB,1)
    rectangle('Position',BB(i,:),'LineWidth',3,'LineStyle','-','EdgeColor','r'); 
 end
 for i = 1:size(BB,1)
     J= imcrop(img,BB(i,:));
 end
 f=J;
end



function x=checkFace(img)
I=img;
FDetect = vision.CascadeObjectDetector;
%Returns Bounding Box values based on number of objects
BB = step(FDetect,I);
% % hold on
for i = 1:size(BB,1)
    rectangle('Position',BB(i,:),'LineWidth',5,'LineStyle','-','EdgeColor','r');
end
% title('Face Detection');
% hold off;

%To detect Nose
NoseDetect = vision.CascadeObjectDetector('Nose','MergeThreshold',16);
BB1=step(NoseDetect,I);

for i = 1:size(BB,1)
    rectangle('Position',BB(i,:),'LineWidth',4,'LineStyle','-','EdgeColor','b');
end
% title('Nose Detection');
% hold off;

%To detect Mouth
MouthDetect = vision.CascadeObjectDetector('Mouth','MergeThreshold',16);

BB2=step(MouthDetect,I);

for i = 1:size(BB,1)
 rectangle('Position',BB(i,:),'LineWidth',4,'LineStyle','-','EdgeColor','r');
end
% title('Mouth Detection');
% hold off;

%Check if the image has a face
if isempty(BB) || isempty(BB1) || isempty(BB2)
    x = 'Fail Check Face';
    %disp(x);
else
    x = 'Pass Check Face';
end
end
