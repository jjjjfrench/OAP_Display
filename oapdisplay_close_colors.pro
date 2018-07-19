PRO OAPdisplay_close_colors, ev

  common block1

  WIDGET_CONTROL,base_widg2,/destroy

  ; Turn the display button back on now that new colors have been set
  Display_button_id = WIDGET_INFO(display_button_id,find_by_uname='Display_button')
  WIDGET_CONTROL, display_button_id, sensitive=1

END