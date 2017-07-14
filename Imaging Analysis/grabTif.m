function d = grabTif(fn)
%For loop to grab each frame of a tif stack, assumes each frame has equal
%width and height. Input is filename string, output is 3d matrix.

info = imfinfo(fn); %metadata struct
[nFrames,~] = size(info);
H = info(1).Height;
W = info(1).Width;

d = NaN(H,W,nFrames);

for i = 1:nFrames
    d(:,:,i) = imread(fn,'Index',i,'Info',info);
end

end