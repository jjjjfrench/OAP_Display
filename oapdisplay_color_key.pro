PRO OAPdisplay_color_key, t1

common block1

; Turn off the display button until the user is done setting habit colors
Display_button_id = WIDGET_INFO(display_button_id,find_by_uname='Display_button')
WIDGET_CONTROL, display_button_id, sensitive=0

; Printing the key on another base widget allows the user to move the key, so they can
; look at the key while also looking at the images.
base_widg2=WIDGET_BASE(title='Habit Color Key',xsize=500,ysize=500)
testing_window=widget_window(base_widg2)
widget_control, testing_window, /REALIZE

; Creates an array of equal size for each habit color
key= bytarr(20,33)
key[*,0:2]=color[0]  
key[*,3:5]=color[1]
key[*,6:8]=color[2]
key[*,9:11]=color[3]
key[*,12:14]=color[4]
key[*,15:17]=color[5]
key[*,18:20]=color[6]
key[*,21:23]=color[7]
key[*,24:26]=color[8]
key[*,27:29]=color[9]
key[*,30:32]=color[10]

image1=image(key, WINDOW_TITLE='Habit Color Key', RGB_TABLE=39, scale_factor=1, /current)
image1.scale, 11,11


droplist[10]= widget_droplist(base_widg2,value=zero_values,event_pro='OAPdisplay_dialog_pickcolor',$
  xoff=140,yoff=50,uvalue=zero_values)
droplist[9]= widget_droplist(base_widg2,value=tiny_values,event_pro='OAPdisplay_dialog_pickcolor',$
  xoff=140,yoff=84,uvalue=tiny_values)
droplist[8]= widget_droplist(base_widg2,value=linear_values,event_pro='OAPdisplay_dialog_pickcolor',$
  xoff=140,yoff=118,uvalue=linear_values)
droplist[7]= widget_droplist(base_widg2,value=centerout_values,event_pro='OAPdisplay_dialog_pickcolor',$
  xoff=140,yoff=151,uvalue=centerout_values)
droplist[6]= widget_droplist(base_widg2,value=oriented_values,event_pro='OAPdisplay_dialog_pickcolor',$
  xoff=140,yoff=184,uvalue=oriented_values)  
droplist[5]= widget_droplist(base_widg2,value=aggregate_values,event_pro='OAPdisplay_dialog_pickcolor',$
  xoff=140,yoff=217,uvalue=aggregate_values)
droplist[4]= widget_droplist(base_widg2,value=graupel_values,event_pro='OAPdisplay_dialog_pickcolor',$
  xoff=140,yoff=251,uvalue=graupel_values)
droplist[3]= widget_droplist(base_widg2,value=spherical_values,event_pro='OAPdisplay_dialog_pickcolor',$
  xoff=140,yoff=285,uvalue=spherical_values)
droplist[2]= widget_droplist(base_widg2,value=hexagonal_values,event_pro='OAPdisplay_dialog_pickcolor',$
  xoff=140,yoff=318.5,uvalue=hexagonal_values)
droplist[1]= widget_droplist(base_widg2,value=irregular_values,event_pro='OAPdisplay_dialog_pickcolor',$
  xoff=140,yoff=352,uvalue=irregular_values)        
droplist[0]= widget_droplist(base_widg2,value=dendrite_values,event_pro='OAPdisplay_dialog_pickcolor',$
  xoff=140,yoff=386,uvalue=dendrite_values)

done_button=WIDGET_BUTTON(base_widg2,value='DONE',event_pro='OAPdisplay_close_colors',$
  xsize=80,ysize=40,xoffset=208,yoffset=450,sensitive=1)

t1=TEXT([0.132,0.144,0.105,0.018,0.058,0.025,0.074,0.0465,0.03,0.0415,0.06], $
  [0.825,0.762,0.695,0.63,0.5665,0.501,0.435,0.37,0.303,0.24,0.1737], $
  ['ZERO','TINY','LINEAR','CENTER-OUT','ORIENTED','AGGREGATE', $
  'GRAUPEL','SPHERICAL','HEXAGONAL','IRREGULAR','DENDRITE'], font_size=14)

END