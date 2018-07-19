PRO OAPdisplay_quit_event,ev

common block1

  IF (image_1 EQ 1) THEN image1.close
  WIDGET_CONTROL,ev.top,/destroy

END