function X_chapeau = MCO(x,y)

A(:,1) = x.*y;
A(:,2) =  (y.^2) - (x.^2);
A(:,3) = x;
A(:,4) = y;
A(:,5) = 1;

b = - x .^ 2;
Xc = A \ b;
X_chapeau(1) = 1 - Xc(2);
X_chapeau(2:6,1) = Xc';

end