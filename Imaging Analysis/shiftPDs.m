function z = shiftPDs(x,y)
%function to shift preferred directions from MOM imaging sessions to lie
%along cardinal directions, using degrees.

if nargin < 2 || isempty(y)
    y = 30;
end

z = bsxfun(@minus,x,y);

under0 = z < 0;
z(under0) = z(under0) + 360;

over360 = z > 360;
z(over360) = z(over360) - 360;

end
