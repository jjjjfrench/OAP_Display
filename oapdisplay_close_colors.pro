PRO OAPdisplay_close_colors, ev

  common block1

  WIDGET_CONTROL,base_widg2,/destroy

  ; Turn the base widget back on now that new colors have been set
  WIDGET_CONTROL, base_widg, sensitive=1


END