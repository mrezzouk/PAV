 % ----------------------------------------------------------------------------
 function M=unit(M)
 % ----------------------------------------------------------------------------
  M=unit_cols(M);


 % ----------------------------------------------------------------------------
 function M=unit_cols(M)
 % ----------------------------------------------------------------------------
  M = M * diag( 1./ sqrt(sum(M.*M)));
