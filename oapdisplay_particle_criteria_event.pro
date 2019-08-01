FUNCTION OAPdisplay_particle_criteria_event,ev

  common block1

  CASE 1 of
    (ev.ID EQ (WIDGET_INFO(ev.top,find_by_uname='habit_widg')) ) : BEGIN
      WIDGET_CONTROL, get_value=tmp, ev.id
      habit_selection=tmp
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
      IF (LONG(tmp) GT 5000) THEN tmp = STRTRIM( STRING(5000),2)
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
    (ev.ID EQ (WIDGET_INFO(ev.top,find_by_uname='PTE_widg')) ) : BEGIN
      WIDGET_CONTROL, get_value=tmp, ev.id
      PTE_selection=tmp
    END
    (ev.ID EQ (WIDGET_INFO(ev.top,find_by_uname='reject_widg')) ) : BEGIN
      WIDGET_CONTROL, get_value=tmp, ev.id
      reject_selection=tmp
    END
    (ev.ID EQ (WIDGET_INFO(ev.top,find_by_uname='colors_widg')) ) : BEGIN
      WIDGET_CONTROL, get_value=tmp, ev.id
      color_selection=tmp
    END
    (ev.ID EQ (WIDGET_INFO(ev.top,find_by_uname='holes_widg')) ) : BEGIN
      WIDGET_CONTROL, get_value=tmp, ev.id
      holes_selection=tmp
    END
  ENDCASE


  Display_button_id = WIDGET_INFO(ev.top,find_by_uname='Display_button')
  WIDGET_CONTROL, display_button_id, sensitive=1
  Fwd_button_id = WIDGET_INFO(ev.top,find_by_uname='stepfwd_button')
  WIDGET_CONTROL, Fwd_button_id, sensitive=0
  Back_button_id = WIDGET_INFO(ev.top,find_by_uname='stepback_button')
  WIDGET_CONTROL, Back_button_id, sensitive=0
  
END
