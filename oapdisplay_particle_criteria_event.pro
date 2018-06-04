FUNCTION OAPdisplay_particle_criteria_event,ev

  common block1

  CASE 1 of
    (ev.ID EQ (WIDGET_INFO(ev.top,find_by_uname='hab_widg')) ) : BEGIN
      WIDGET_CONTROL, get_value=tmp, ev.id
      hab_selection=tmp
    END
    (ev.ID EQ (WIDGET_INFO(ev.top,find_by_uname='minD_widg')) ) : BEGIN
      WIDGET_CONTROL, get_value=tmp, ev.id
      IF (LONG(tmp) LT 0) THEN tmp = STRTRIM( STRING(0),2)
      IF (LONG(tmp) GT 1200) THEN tmp = STRTRIM( STRING(1200),2)
      WIDGET_CONTROL, set_value=tmp, ev.id
    END
    (ev.ID EQ (WIDGET_INFO(ev.top,find_by_uname='maxD_widg')) ) : BEGIN
      WIDGET_CONTROL, get_value=tmp, ev.id
      IF (LONG(tmp) LT 1) THEN tmp = STRTRIM( STRING(1),2)
      IF (LONG(tmp) GT 2000) THEN tmp = STRTRIM( STRING(2000),2)
      WIDGET_CONTROL, set_value=tmp, ev.id
    END
    (ev.ID EQ (WIDGET_INFO(ev.top,find_by_uname='nth_part_widg')) ) : BEGIN
      WIDGET_CONTROL, get_value=tmp, ev.id
      IF (LONG(tmp) LT 1) THEN tmp = STRTRIM(STRING(1),2)
      IF (LONG(tmp) GT 1000) THEN tmp = STRTRIM(STRING(1000),2)
      WIDGET_CONTROL, set_value=tmp, ev.id
    END
    (ev.ID EQ (WIDGET_INFO(ev.top,find_by_uname='timestamp_widg')) ) : BEGIN
      WIDGET_CONTROL, get_value=tmp, ev.id
      timestamp_selection=tmp
    END
    (ev.ID EQ (WIDGET_INFO(ev.top,find_by_uname='save_widg')) ) : BEGIN
      WIDGET_CONTROL, get_value=tmp, ev.id
      save_selection=tmp
    END
    (ev.ID EQ (WIDGET_INFO(ev.top,find_by_uname='hab_colors_widg')) ) : BEGIN
      WIDGET_CONTROL, get_uvalue=tmp, ev.id
      hab_colors_selection=tmp
    END
  ENDCASE


  Display_button_id = WIDGET_INFO(ev.top,find_by_uname='Display_button')
  WIDGET_CONTROL, display_button_id, sensitive=1
  Fwd_button_id = WIDGET_INFO(ev.top,find_by_uname='stepfwd_button')
  WIDGET_CONTROL, Fwd_button_id, sensitive=0
  Back_button_id = WIDGET_INFO(ev.top,find_by_uname='stepback_button')
  WIDGET_CONTROL, Back_button_id, sensitive=0
  
END
