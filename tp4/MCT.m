function X_chapeau = MCT(x,y)

A(:,1) = x.^2;
A(:,2) = y.*x;
A(:,3) = y.^2;
A(:,4) = x;
A(:,5) = y;
A(:,6) = 1;

[U,S,V] = svd(A);
[S,I] = sort(diag(S), 'descend');
V = V(:,I);
X_chapeau = V(:,size(V,2));