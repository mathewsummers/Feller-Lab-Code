function d = grabTif(fn)
%For loop to grab each frame of a tif stack, assumes each frame has equal
%width and height. Input is filename string, output is 3d matrix.

info = imfinfo(fn); %metadata struct
[nFrames,~] = size(info);
info(1).Width;

d = NaN(info(1).Width,info(1).Height,nFrames);

for i = 1:nFrames
    d(:,:,i) = imread(fn,i);
end

end