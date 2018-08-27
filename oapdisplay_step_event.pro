PRO OAPdisplay_step_event,ev

  common block1
  
  plot_widg_id=WIDGET_INFO(ev.top,find_by_uname='plot_widg')
  WIDGET_CONTROL, plot_widg_id, GET_VALUE=graphicWin
  graphicWin.erase

  ;get the user-set start time and the end times to show
  stt_widg_id =  WIDGET_INFO(ev.top,find_by_uname='stt_widg')
  WIDGET_CONTROL, get_value=tmp, stt_widg_id
  stt_hhmmss = LONG((tmp)[0])
  stp_widg_id =  WIDGET_INFO(ev.top,find_by_uname='stp_widg')
  WIDGET_CONTROL, get_value=tmp, stp_widg_id
  stp_hhmmss = LONG((tmp)[0])

  ;get the minimum diameter to consider
  minD_widg_id =  WIDGET_INFO(ev.top,find_by_uname='minD_widg')
  WIDGET_CONTROL, get_value=tmp, minD_widg_id
  minD = LONG((tmp)[0]) / 1000. ; change minD to mm

  ;get the maximum diameter to consider
  maxD_widg_id =  WIDGET_INFO(ev.top,find_by_uname='maxD_widg')
  WIDGET_CONTROL, get_value=tmp, maxD_widg_id
  maxD = LONG((tmp)[0]) / 1000. ; change maxD to mm

  ; get the nth particle to show
  nth_part_widg_id = WIDGET_INFO(ev.top,find_by_uname='nth_part_widg')
  WIDGET_CONTROL, get_value=tmp, nth_part_widg_id
  nth = LONG((tmp)[0])

  ;get the habits to plot
  habit_widg_id = WIDGET_INFO(ev.top,find_by_uname='habit_widg')
  WIDGET_CONTROL, get_value=habit_selection, habit_widg_id

  ;check to see if we need to exclude holes
  holes_widg_id = WIDGET_INFO(ev.top,find_by_uname='holes_widg')
  WIDGET_CONTROL, get_value=holes_selection, holes_widg_id

  inds = WHERE( (hhmmss GE stt_hhmmss) AND (hhmmss LE stp_hhmmss))
  npart = N_ELEMENTS(inds)

  ;commented out the below two statements, this was when we only stepped forward
  ; first = display_info.last
  ; last = inds[npart-1]

  ;determine whether to step forward or backward (statement below should never fail, although if it does then
  ;  direction should be undefined
  CASE 1 of
    (ev.ID EQ (WIDGET_INFO(ev.top,find_by_uname='stepfwd_button')) ) : BEGIN
      direction = 'forward'
      first = display_info.last
      last = inds[npart-1]
    END
    (ev.ID EQ (WIDGET_INFO(ev.top,find_by_uname='stepfwd_button')) ) : BEGIN
      direction = 'back'
      first = inds[0]
      last = display_info.first
    END
  ENDCASE


  ;currently only setup to get 2DS data -- when we add CIP data, we will need to add a CASE statement here
  OAPdisplay_get_buffers, tmp, minD, maxD, inds, npart, hab_sel, first, last, direction

  OAPdisplay_showbuffers, tmp

  ImageSTT_id = WIDGET_INFO(ev.top,find_by_uname='imgSTT')
  display_info.img_stt = 'Image Start: '+STRTRIM(STRING(hhmmss[first]),2)
  WIDGET_CONTROL, set_value=display_info.img_stt, ImageSTT_id
  ImageSTP_id = WIDGET_INFO(ev.top,find_by_uname='imgSTP')
  display_info.img_stp = 'Image Stop: '+STRTRIM(STRING(hhmmss[last]),2)
  WIDGET_CONTROL, set_value=display_info.img_stp, ImageSTP_id
  ImageMIND_id = WIDGET_INFO(ev.top,find_by_uname='imgMIND')
  display_info.img_mind = 'Image MinD: '+STRTRIM(STRING(LONG(minD*1000)),2)
  WIDGET_CONTROL, set_value=display_info.img_minD, ImageMIND_id
  ImageMAXD_id = WIDGET_INFO(ev.top,find_by_uname='imgMAXD')
  display_info.img_maxd = 'Image MaxD: '+STRTRIM(STRING(LONG(maxD*1000)),2)
  WIDGET_CONTROL, set_value=display_info.img_maxD, ImageMAXD_id


  ;  IF (last LT inds[npart-1]) THEN BEGIN
  Fwd_button_id = WIDGET_INFO(ev.top,find_by_uname='stepfwd_button')
  IF (display_info.buf_full EQ 1) THEN $
    WIDGET_CONTROL, Fwd_button_id, sensitive=1 $
  ELSE WIDGET_CONTROL, Fwd_button_id, sensitive=0
  IF (first GT inds[0]) THEN BEGIN
    Back_button_id = WIDGET_INFO(ev.top,find_by_uname='stepback_button')
    WIDGET_CONTROL, back_button_id, sensitive=0
  ENDIF

  display_info.first = first
  display_info.last = last

END

