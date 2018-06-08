Function sec2hhmmss, hhmmss

hhmmss=long(hhmmss)
hours=hhmmss/3600L
minutes=(hhmmss-(hours*3600))/60L
seconds=(hhmmss-(hours*3600)-(minutes*60))
hhmmss=(hours*10000)+(minutes*100)+seconds
Return, hhmmss

END