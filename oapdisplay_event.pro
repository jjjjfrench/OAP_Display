PRO OAPdisplay_event,ev

  common block1

  plot_widg_id=WIDGET_INFO(ev.top,find_by_uname='plot_widg')
  WIDGET_CONTROL, plot_widg_id, GET_VALUE=graphicWin
  graphicWin.erase

  ;get the user-set start time and the end times to show
  stt_widg_id =  WIDGET_INFO(ev.top,find_by_uname='stt_widg')
  WIDGET_CONTROL, get_value=tmp, stt_widg_id
  IF (LONG(tmp) LT hhmmss[0]) THEN tmp = STRTRIM( STRING(hhmmss[0]), 2)
  IF (LONG(tmp) GT hhmmss[fileinfo.nparts-1]) THEN tmp = STRTRIM( STRING(hhmmss[fileinfo.nparts-1]), 2)
  six_hhmmss=STRTRIM(STRING(tmp),2)
  six_hhmmss= '000000' + six_hhmmss
  six_hhmmss= six_hhmmss.substring(-6)
  tmp= six_hhmmss
  WIDGET_CONTROL, set_value = tmp, stt_widg_id
  stt_hhmmss = LONG((tmp)[0])
  stp_widg_id =  WIDGET_INFO(ev.top,find_by_uname='stp_widg')
  WIDGET_CONTROL, get_value=tmp, stp_widg_id
  IF (LONG(tmp) LT hhmmss[0]) THEN tmp = STRTRIM( STRING(hhmmss[fileinfo.nparts-1]), 2)
  IF (LONG(tmp) GT hhmmss[fileinfo.nparts-1]) THEN tmp = STRTRIM( STRING(hhmmss[fileinfo.nparts-1]), 2)
  six_hhmmss=STRTRIM(STRING(tmp),2)
  six_hhmmss= '000000' + six_hhmmss
  six_hhmmss= six_hhmmss.substring(-6)
  tmp= six_hhmmss
  WIDGET_CONTROL, set_value = tmp, stp_widg_id
  stp_hhmmss = LONG((tmp)[0])
  IF (stp_hhmmss LE stt_hhmmss) THEN BEGIN
    MSG = 'Stop Time must be greater than Start Time'
    plot_widg_id =  WIDGET_INFO(ev.top,find_by_uname='plot_widg')
    res = DIALOG_MESSAGE(MSG, /ERROR, DIALOG_PARENT=plot_widg_id)
    RETURN
  ENDIF

  ;get the minimum and maximum diameter to consider
  minD_widg_id =  WIDGET_INFO(ev.top,find_by_uname='minD_widg')
  WIDGET_CONTROL, get_value=tmp, minD_widg_id
  IF (LONG(tmp) LT 0) THEN tmp = STRTRIM( STRING(0),2)
  IF (LONG(tmp) GT 1200) THEN tmp = STRTRIM( STRING(1200),2)
  WIDGET_CONTROL, set_value=tmp, minD_widg_id
  minD = LONG((tmp)[0]) / 1000. ; change minD to mm
  
  maxD_widg_id =  WIDGET_INFO(ev.top,find_by_uname='maxD_widg')
  WIDGET_CONTROL, get_value=tmp, maxD_widg_id
  IF (LONG(tmp) LT 1) THEN tmp = STRTRIM( STRING(1),2)
  IF (LONG(tmp) GT 2000) THEN tmp = STRTRIM( STRING(2000),2)
  WIDGET_CONTROL, set_value=tmp, maxD_widg_id
  maxD = LONG((tmp)[0]) / 1000. ; change maxD to mm
  IF maxD LE minD Then Begin
    Error_message= 'Maximum diameter must be greater than minimum diameter'
    plot_widg_id =  WIDGET_INFO(ev.top,find_by_uname='plot_widg')
    res2 = DIALOG_MESSAGE(Error_message, /ERROR, DIALOG_PARENT=plot_widg_id)
    Return
  ENDIF

  ;get the nth particle to display
  nth_part_widg_id = WIDGET_INFO(ev.top,find_by_uname='nth_part_widg')
  WIDGET_CONTROL, get_value=tmp, nth_part_widg_id
  IF (LONG(tmp) LT 1) THEN tmp=STRTRIM(STRING(1),2)
  IF (LONG(tmp) GT 1000)THEN tmp=STRTRIM(STRING(1000),2)
  WIDGET_CONTROL, set_value=tmp, nth_part_widg_id
  nth = LONG((tmp)[0])


  ;get the habits to plot
  hab_widg_id = WIDGET_INFO(ev.top,find_by_uname='hab_widg')
  WIDGET_CONTROL, get_value=hab_sel, hab_widg_id
  
  ;checks to see if timestamps are selected to display
  Timestamp_widg_id = WIDGET_INFO(ev.top,find_by_uname='timestamp_widg')
  WIDGET_CONTROL, get_value=timestamp_sel, Timestamp_widg_id
  
  ;checks to see if habit colors are selected to display
  ;hab_colors_widg_id = WIDGET_INFO(display_info.hab_colors_widg_id, /Droplist_Select)
  ;WIDGET_CONTROL, display_info.hab_colors_widg_id, get_uvalue=hab_color_option


  ;determine the indices of the particles within the timerange requested and number of particles
  inds = WHERE( (hhmmss GE stt_hhmmss) AND (hhmmss LE stp_hhmmss))
  npart = N_ELEMENTS(inds)

  ;by default the first particle is the first index and the last particle is the last index, these
  ;   will get re-caluclated in OAPdisplay_get2DS_buffers
  first = inds[0]
  last = inds[npart-1]

  ;the next procedure gets the data and fills four display buffers
  ;currently only setup to get 2DS data -- when we add CIP data, we will need to add a CASE statement here
  OAPdisplay_get2DS_buffers, tmp, minD, maxD, inds, npart, hab_sel, first, last

  ;the next procedure unpacks the data in the display buffers and draws the display
  OAPdisplay_showbuffers, tmp
  
  
  hhmmss_first=STRTRIM(STRING(hhmmss[first]),2)
  hhmmss_first= '000000' + hhmmss_first
  hhmmss_first= hhmmss_first.substring(-6)
  
  hhmmss_last=STRTRIM(STRING(hhmmss[last]),2)
  hhmmss_last= '000000' + hhmmss_last
  hhmmss_last= hhmmss_last.substring(-6)

  
   ;write information about the images displayed (percentage,start & end times, minimum & maximum diameter shown)
  ImageInfo_id = WIDGET_INFO(ev.top,find_by_uname='Percent')
  display_info.image_percent = '% of accepted particles shown: '+STRTRIM(STRING(percentage),2) + '%'
  WIDGET_CONTROL, set_value=display_info.image_percent, ImageINFO_id
  ImageSTT_id = WIDGET_INFO(ev.top,find_by_uname='imgSTT')
  display_info.img_stt = 'Image Start: '+ hhmmss_first
  WIDGET_CONTROL, set_value=display_info.img_stt, ImageSTT_id
  ImageSTP_id = WIDGET_INFO(ev.top,find_by_uname='imgSTP')
  display_info.img_stp = 'Image Stop: '+ hhmmss_last
  WIDGET_CONTROL, set_value=display_info.img_stp, ImageSTP_id
  ImageMIND_id = WIDGET_INFO(ev.top,find_by_uname='imgMIND')
  display_info.img_mind = 'Image MinD: '+STRTRIM(STRING(LONG(minD*1000)),2)
  WIDGET_CONTROL, set_value=display_info.img_minD, ImageMIND_id
  ImageMAXD_id = WIDGET_INFO(ev.top,find_by_uname='imgMAXD')
  display_info.img_maxd = 'Image MaxD: '+STRTRIM(STRING(LONG(maxD*1000)),2)
  WIDGET_CONTROL, set_value=display_info.img_maxD, ImageMAXD_id
  

  ;if the last particle shown is not at the end of the requested time period,
  ;  then turn the stepforward button on
  Fwd_button_id = WIDGET_INFO(ev.top,find_by_uname='stepfwd_button')
  IF (display_info.buf_full EQ 1) THEN $
    WIDGET_CONTROL, Fwd_button_id, sensitive=1 $
  ELSE WIDGET_CONTROL, Fwd_button_id, sensitive=0

  ;if the first particle shown is not at the beginning of the requested time period,
  ;  then turn the stepbackward button on
  ;*******CURRENTLY NOT AVAILABLE*************
  IF (first GT inds[0]) THEN BEGIN
    Back_button_id = WIDGET_INFO(ev.top,find_by_uname='stepback_button')
    WIDGET_CONTROL, back_button_id, sensitive=0
  ENDIF

  ;Turn the 'Display Particles' button off. It gets turned on only if the user changes
  ;  start or end time or the minDiameter
  Display_button_id = WIDGET_INFO(ev.top,find_by_uname='Display_button')
  WIDGET_CONTROL, display_button_id, sensitive=0

  ;Write to the display_info structure the index of the first and last particle displayed
  display_info.first = first
  display_info.last = last

  hab_selection=!Null  ; reset habit selection for next run
  
  
  RETURN
END
