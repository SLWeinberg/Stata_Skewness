capture program drop summskew
program define summskew                 

syntax varname[, by(varname)]             
capture drop n skew seskew skew_ratio
capture confirm variable `by'
if _rc {
quietly summarize `varlist', detail
capture gen n = r(N)
capture gen skew = r(skewness)
capture gen seskew = sqrt((6*(n)*(n - 1))/((n - 2)*(n + 1)*(n + 3)))
capture gen skew_ratio = skew/seskew
display "skewness = " %7.3f skew "; seskew = " %7.3f seskew " ;             ///
         skewness ratio = " %7.3f skew_ratio

}
else {

qui {                               
summarize `by', detail
display "the maximum code for the grouping variable = " r(max)
display "the minimum code for the grouping variable = " r(min)
global k = r(max)
global m = r(min)
}

forval i = $m (1) $k {
qui {
summarize `varlist' if `by' == `i', detail
capture drop n skew seskew skew_ratio
capture gen n = r(N)
capture gen skew = r(skewness)
capture gen seskew = sqrt((6*(n)*(n - 1))/((n - 2)*(n + 1)*(n + 3)))
capture gen skew_ratio = skew/seskew
}
display "For `by' = " `i' ": skewness = " %7.3f skew " ; seskew = "          ///
         %7.3f seskew " ; skewness ratio = " %7.3f skew_ratio                
display ""                        
}

end
exit
