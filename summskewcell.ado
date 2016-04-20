capture program drop summskewcell
program define summskewcell                

syntax varlist(min=3 max=3)
***var1 = dv; var2 = factor1; var3 = factor3
qui {
local var1: word 1 of `varlist'
local var2: word 2 of `varlist'
local var3: word 3 of `varlist'

summarize `var2', detail
display "maximum number of groups = " r(max)
display "minimum number of groups = " r(min)
global k1 = r(max)
global m1 = r(min)
summarize `var3', detail
display "maximum number of groups = " r(max)
display "minimum number of groups = " r(min)
global k2 = r(max)
global m2 = r(min)
forval i = $m1 (1) $k1 {
forval j = $m2 (1) $k2 {
quietly summarize `var1' if `var2'== `i' & `var3' == `j', detail
capture drop n skew seskew skew_ratio
gen n = r(N)
gen skew  = r(skewness)
gen seskew  = sqrt((6*(n)*(n - 1))/((n - 2)*(n + 1)*(n + 3)))
gen skew_ratio = skew/seskew
noi display "For `var2' = " `i' " and `var3' = " `j' ": N = " n             ///
             "; skewness = " %7.3f skew "; seskew = " %7.3f seskew          ///
	         "; skewness ratio = " %7.3f skew_ratio 
}


end
exit
