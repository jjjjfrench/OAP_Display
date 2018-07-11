
Function sec2hhmmss, hhmmss

  hhmmss=long(hhmmss)
  hours=hhmmss/3600L
  minutes=(hhmmss-(hours*3600))/60L
  seconds=(hhmmss-(hours*3600)-(minutes*60))
  hhmmss=(hours*10000)+(minutes*100)+seconds
  Return, hhmmss

END

;******************************************************************************

Function hhmmss2sec, hhmmss
 
hhmmss=long(hhmmss)
hours= hhmmss/10000L
minutes=(hhmmss-(hours*10000L))/100L
seconds=(hhmmss-(hours*10000L)-(minutes*100L))
total_sec=(hours*3600)+(minutes*60)+seconds
hhmmss=total_sec
Return, hhmmss
END


