PRO OAPdisplay_color_key, ev

common block1

  ; Turn off the base widget until the user is done setting habit colors
  WIDGET_CONTROL, base_widg, sensitive=0

  ; Printing the key on another base widget allows the user to move the key, so they can
  ; look at the key while also looking at the images.
  base_widg2=WIDGET_BASE(title='Habit Color Key',xsize=260,ysize=400)
  WIDGET_CONTROL, /REALIZE, base_widg2
  colors_plot=WIDGET_WINDOW(base_widg2, XOFFSET=150, YOFFSET=10, XSIZE=100, YSIZE=330)

  ; Creates an array of equal size for each habit color
  key= bytarr(20,33)
  FOR i=0,10 DO BEGIN
    key[*,(i*3):(i*3)+2] = color[i]
  ENDFOR

  image1=image(key, WINDOW_TITLE='Habit Color Key', RGB_TABLE=39, /current)
  image1.scale, 10,10

  xoff=70 & yoff=8 & ydist=30
  droplist[10]= widget_droplist(base_widg2,value=zero_values,event_pro='OAPdisplay_dialog_pickcolor',$
    xoff=xoff,yoff=yoff+(0*ydist),uvalue=zero_values)
  droplist[9]= widget_droplist(base_widg2,value=tiny_values,event_pro='OAPdisplay_dialog_pickcolor',$
    xoff=xoff,yoff=yoff+(1*ydist),uvalue=tiny_values)
  droplist[8]= widget_droplist(base_widg2,value=linear_values,event_pro='OAPdisplay_dialog_pickcolor',$
    xoff=xoff,yoff=yoff+(2*ydist),uvalue=linear_values)
  droplist[7]= widget_droplist(base_widg2,value=centerout_values,event_pro='OAPdisplay_dialog_pickcolor',$
    xoff=xoff,yoff=yoff+(3*ydist),uvalue=centerout_values)
  droplist[6]= widget_droplist(base_widg2,value=oriented_values,event_pro='OAPdisplay_dialog_pickcolor',$
    xoff=xoff,yoff=yoff+(4*ydist),uvalue=oriented_values)  
  droplist[5]= widget_droplist(base_widg2,value=aggregate_values,event_pro='OAPdisplay_dialog_pickcolor',$
    xoff=xoff,yoff=yoff+(5*ydist),uvalue=aggregate_values)
  droplist[4]= widget_droplist(base_widg2,value=graupel_values,event_pro='OAPdisplay_dialog_pickcolor',$
    xoff=xoff,yoff=yoff+(6*ydist),uvalue=graupel_values)
  droplist[3]= widget_droplist(base_widg2,value=spherical_values,event_pro='OAPdisplay_dialog_pickcolor',$
    xoff=xoff,yoff=yoff+(7*ydist),uvalue=spherical_values)
  droplist[2]= widget_droplist(base_widg2,value=hexagonal_values,event_pro='OAPdisplay_dialog_pickcolor',$
    xoff=xoff,yoff=yoff+(8*ydist),uvalue=hexagonal_values)
  droplist[1]= widget_droplist(base_widg2,value=irregular_values,event_pro='OAPdisplay_dialog_pickcolor',$
    xoff=xoff,yoff=yoff+(9*ydist),uvalue=irregular_values)        
  droplist[0]= widget_droplist(base_widg2,value=dendrite_values,event_pro='OAPdisplay_dialog_pickcolor',$
    xoff=xoff,yoff=yoff+(10*ydist),uvalue=dendrite_values)

  yoff=yoff+10
  tmplabel_id = WIDGET_LABEL(base_widg2,value='ZERO', xsize=80, yoffset=yoff+(0*ydist), /ALIGN_RIGHT)
  tmplabel_id = WIDGET_LABEL(base_widg2,value='TINY',  xsize=80, yoffset=yoff+(1*ydist), /ALIGN_RIGHT)
  tmplabel_id = WIDGET_LABEL(base_widg2,value='LINEAR',  xsize=80, yoffset=yoff+(2*ydist), /ALIGN_RIGHT)
  tmplabel_id = WIDGET_LABEL(base_widg2,value='CENTER-OUT', xsize=80, yoffset=yoff+(3*ydist), /ALIGN_RIGHT)
  tmplabel_id = WIDGET_LABEL(base_widg2,value='ORIENTED',  xsize=80, yoffset=yoff+(4*ydist), /ALIGN_RIGHT)
  tmplabel_id = WIDGET_LABEL(base_widg2,value='AGGREGATE',  xsize=80, yoffset=yoff+(5*ydist), /ALIGN_RIGHT)
  tmplabel_id = WIDGET_LABEL(base_widg2,value='GRAUPEL',  xsize=80, yoffset=yoff+(6*ydist), /ALIGN_RIGHT)
  tmplabel_id = WIDGET_LABEL(base_widg2,value='SPHERICAL',  xsize=80, yoffset=yoff+(7*ydist), /ALIGN_RIGHT)
  tmplabel_id = WIDGET_LABEL(base_widg2,value='HEXAGONAL',  xsize=80, yoffset=yoff+(8*ydist), /ALIGN_RIGHT)
  tmplabel_id = WIDGET_LABEL(base_widg2,value='IRREGULAR',  xsize=80, yoffset=yoff+(9*ydist), /ALIGN_RIGHT)
  tmplabel_id = WIDGET_LABEL(base_widg2,value='DENDRITE',  xsize=80, yoffset=yoff+(10*ydist), /ALIGN_RIGHT)

  done_button=WIDGET_BUTTON(base_widg2,value='DONE',event_pro='OAPdisplay_close_colors',$
    xsize=80,ysize=40,xoffset=170,yoffset=350,sensitive=1)



END
