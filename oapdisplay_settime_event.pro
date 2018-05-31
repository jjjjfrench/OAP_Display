PRO OAPdisplay_settime_event,ev

  common block1


  CASE 1 of
    (ev.ID EQ (WIDGET_INFO(ev.top,find_by_uname='stt_widg')) ) : BEGIN
      WIDGET_CONTROL, get_value=tmp, ev.id
      IF (LONG(tmp) LT hhmmss[0]) THEN tmp = STRTRIM( STRING(hhmmss[0]), 2)
      IF (LONG(tmp) GT hhmmss[fileinfo.nparts-1]) THEN tmp = STRTRIM( STRING(hhmmss[fileinfo.nparts-1]), 2)
      WIDGET_CONTROL, set_value = tmp, ev.id
    END
    (ev.ID EQ (WIDGET_INFO(ev.top,find_by_uname='stp_widg')) ) : BEGIN
      WIDGET_CONTROL, get_value=tmp, ev.id
      IF (LONG(tmp) LT hhmmss[0]) THEN tmp = STRTRIM( STRING(hhmmss[fileinfo.nparts-1]), 2)
      IF (LONG(tmp) GT hhmmss[fileinfo.nparts-1]) THEN tmp = STRTRIM( STRING(hhmmss[fileinfo.nparts-1]), 2)
      WIDGET_CONTROL, set_value = tmp, ev.id
    END
  ENDCASE

  Display_button_id = WIDGET_INFO(ev.top,find_by_uname='Display_button')
  WIDGET_CONTROL, display_button_id, sensitive=1
  Fwd_button_id = WIDGET_INFO(ev.top,find_by_uname='stepfwd_button')
  WIDGET_CONTROL, Fwd_button_id, sensitive=0
  Back_button_id = WIDGET_INFO(ev.top,find_by_uname='stepback_button')
  WIDGET_CONTROL, Back_button_id, sensitive=0
 
END
