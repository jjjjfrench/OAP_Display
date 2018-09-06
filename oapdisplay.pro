PRO OAPdisplay

  RESOLVE_ROUTINE,['oapdisplay_quit_event','OAPdisplay_getfile_event','OAPdisplay_settime_event','OAPdisplay_event',$
    'OAPdisplay_get_buffers','OAPdisplay_showbuffers','OAPdisplay_step_event','OAPdisplay_save_image', $
    'OAPdisplay_color_key','OAPdisplay_dialog_pickcolor','OAPdisplay_close_colors']
  RESOLVE_ROUTINE, ['oapdisplay_particle_criteria_event','hhmmss2sec'],/IS_FUNCTION

  common block1, fileinfo, base_widg, display_info, prbtype, hhmmss, pos, scnt, rec, diam, percentage, nth, hab, hab_selection, timestamp_selection, timestamp_sel, hab_color_option,$ 
   PTE_sel, hab_colors_widg_id, i, auto_reject, touching_edge, time_disp, pos_disp, color_array, color_key_widg, color, Display_button_id, base_widg2, droplist, dendrite_values,$ 
   irregular_values, hexagonal_values, spherical_values, graupel_values, aggregate_values, oriented_values, centerout_values, linear_values, tiny_values, zero_values
  

  fileinfo = {ncid_base:-999L, ncid_proc:-999L, nparts: 0L, data_varid:0L }

  display_info = {fname_base:'No File Selected', fname_proc:'No File Selected', path:'/kingair_data/snowie17/2DS/', output_path:'/home', $
    nrec: 'No Records to Show', range_time:'hhmmss -- hhmmss', hab_colors_widg_id:0L,$
    image_percent:'% of accepted particles shown: --%', stt_time:'hhmmss', stp_time:'hhmmss', min_size:'0', max_size:'2000', nth_part:'1', $
    img_stt:'Image Start: hhmmss', img_stp:'Image Stop: hhmmss', img_minD:'Image MinD: 0',  img_maxD:'Image MaxD: 2000', $ 
    first:-999L, last:-999L, buf_full:0L}

  hhmmss=0L & pos=0L & scnt=0L & rec=0L & diam=0L & prbtype =''

  droplist= LONARR(11)
  color= LONARR(11)

  color[0]=254  ; Dendrite
  color[1]=215  ; Irregular
  color[2]=175  ; Hexagonal
  color[3]=75  ; Spherical
  color[4]=100  ; Graupel
  color[5]=50  ; Aggregate
  color[6]=150  ; Oriented
  color[7]=27  ; Center-out
  color[8]=200 ; Linear
  color[9]=0  ; Tiny
  color[10]=255  ; Zero

dendrite_values=['red','burnt orange','light green','blue','cyan','dark blue','green','purple','mustard','black','white']
irregular_values=['burnt orange','red','light green','blue','cyan','dark blue','green','purple','mustard','black','white']
hexagonal_values=['light green','red','burnt orange','blue','cyan','dark blue','green','purple','mustard','black','white']
spherical_values=['blue','red','burnt orange','light green','cyan','dark blue','green','purple','mustard','black','white']
graupel_values=['cyan','red','burnt orange','light green','blue','dark blue','green','purple','mustard','black','white']
aggregate_values=['dark blue','red','burnt orange','light green','blue','cyan','green','purple','mustard','black','white']
oriented_values=['green','red','burnt orange','light green','blue','cyan','dark blue','purple','mustard','black','white']
centerout_values=['purple','red','burnt orange','light green','blue','cyan','dark blue','green','mustard','black','white']
linear_values=['mustard','red','burnt orange','light green','blue','cyan','dark blue','green','purple','black','white']
tiny_values=['black','red','burnt orange','light green','blue','cyan','dark blue','green','purple','mustard','white']
zero_values=['white','Do not alter']


  widgtit = 'OAP Display'
  ;set up base widget
  base_widg=WIDGET_BASE(title=widgtit,xsize=1095,ysize=590)
  
  ;set file selection and file display widget
  file_button_id=WIDGET_BUTTON(base_widg,value='New File Set',event_pro='OAPdisplay_getfile_event',$
    xsize=80,ysize=60,xoffset=10,yoffset=06, uname='file_button')
  path_label_id=WIDGET_LABEL(base_widg,value='Filepath:',xsize=80,ysize=15,xoff=100,yoff=15,  /ALIGN_RIGHT)
  path_widg_id=WIDGET_TEXT(base_widg,xsize=58,xoff=180,yoff=10, value=display_info.path,$
    uname='path_widg')
  fbase_label_id=WIDGET_LABEL(base_widg,value='Base nc file:',xsize=80,ysize=15,xoff=100,yoff=45,  /ALIGN_RIGHT)
  fbase_widg_id=WIDGET_TEXT(base_widg,xsize=58,xoff=180,yoff=40,value=display_info.fname_base,$
    uname='fbase_widg')
  fbase_label_id=WIDGET_LABEL(base_widg,value='Proc nc file:',xsize=80,ysize=15,xoff=100,yoff=75,  /ALIGN_Right)
  fproc_widg_id=  WIDGET_TEXT(base_widg,xsize=58,xoff=180,yoff=70,value=display_info.fname_proc,$
    uname='fproc_widg')
  save_button_id=WIDGET_BUTTON(base_widg,value='Save Image',event_pro='OAPdisplay_save_image',$
    xsize=80,ysize=30,xoffset=10,yoffset=105, uname='save_button')

  timerange_widg_id=WIDGET_LABEL(base_widg,value=display_info.range_time,xsize=100,ysize=15,xoff=180,yoff=106,  /ALIGN_LEFT, uname='timerange_widg')
  

  sttlabel_widg_id=WIDGET_LABEL(base_widg,value='Start Time',xsize=80,ysize=15,xoff=820,yoff=15, /ALIGN_Right)
  stt_widg_id=WIDGET_TEXT(base_widg, value=display_info.stt_time, event_pro='OAPdisplay_settime_event',$
    xsize=10,xoff=900,yoff=10, uname='stt_widg')
  stplabel_widg_id=WIDGET_LABEL(base_widg,value='Stop Time',xsize=80,ysize=15,xoff=820,yoff=47, /ALIGN_Right)
  stp_widg_id=WIDGET_TEXT(base_widg, value=display_info.stp_time, event_pro='OAPdisplay_settime_event',$
    xsize=10,xoff=900,yoff=41, uname='stp_widg')


  minDlabel_id=WIDGET_LABEL(base_widg,value='MinD (micron)',xsize=80,ysize=15,xoff=820,yoff=79, /ALIGN_Right)
  minD_widg_id=WIDGET_TEXT(base_widg, value=display_info.min_size, event_func='OAPdisplay_particle_criteria_event',$
    xsize=10,xoff=900,yoff=72, uname='minD_widg')
  maxDlabel_id=WIDGET_LABEL(base_widg,value='MaxD (micron)',xsize=80,ysize=15,xoff=820,yoff=111, /ALIGN_Right)
  maxD_widg_id=WIDGET_TEXT(base_widg, value=display_info.max_size, event_func='OAPdisplay_particle_criteria_event',$
    xsize=10,xoff=900,yoff=103, uname='maxD_widg')
  nth_part_label_id=WIDGET_LABEL(base_widg,value='Every nth',xsize=80,ysize=15,xoff=980,yoff=77, /ALIGN_Right)
  nth_part_widg_id=WIDGET_TEXT(base_widg,value=display_info.nth_part, event_func='OAPdisplay_particle_criteria_event',$
    uname='nth_part_widg',xsize=2,xoff=1060,yoff=71)
  hab_button_names=['Zero','Tiny','Linear','Center-Out','Oriented','Aggregate','Graupel',$
    'Sphere','Hexagonal','Irregular','Dendrite']
  hab_widg_id=CW_BGROUP(base_widg,hab_button_names,Column=3,/NonExclusive,LABEL_TOP='Habit',$
    xoff=552,/FRAME,ysize=105,uname='hab_widg', event_funct='OAPdisplay_particle_criteria_event',set_value=[1,1,1,1,1,1,1,1,1,1,1])
  Timestamp_widg_id=CW_BGROUP(base_widg,'Timestamps', Column=1,/NONEXCLUSIVE,$
    xoff=995,/FRAME,yoff=105,xsize=80,ysize=25, uname='timestamp_widg', event_funct='OAPdisplay_particle_criteria_event', set_value=1)
  PTE_widg_id=CW_BGROUP(base_widg,'Entire-In', Column=1,/NONEXCLUSIVE,$
    xoff=92,/FRAME,yoff=105,xsize=75,ysize=25, uname='PTE_widg', event_funct='OAPdisplay_particle_criteria_event', set_value=1)
  
  hab_color_options=['Habit Colors Off','Habit Colors On']
  display_info.hab_colors_widg_id=WIDGET_DROPLIST(base_widg,value=hab_color_options,uvalue=hab_color_options, $ 
   event_func='OAPdisplay_particle_criteria_event',xoff=403,yoff=101,sensitive=1,uname='hab_colors_widg')

  color_key_widg=WIDGET_BUTTON(base_widg,value='Set Habit Colors',event_pro= 'OAPdisplay_color_key' , $
      xsize=118,ysize=30,xoffset=285,yoffset=104, sensitive=0,uname='color_key_button')

  Display_button_id=WIDGET_BUTTON(base_widg,value='Display Particles',event_pro='OAPdisplay_event',$
    xsize=110,ysize=60,xoffset=980,yoffset=10, sensitive=0, uname='Display_button')

  quit_button=WIDGET_BUTTON(base_widg,value='Quit',event_pro='OAPdisplay_quit_event',$
    xsize=80,ysize=30,xoffset=10,yoffset=70)


  ;set up plot window
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  plot_widg_id = WIDGET_WINDOW(base_widg, UNAME='plot_widg' ,XOFFSET=5  $
    ,YOFFSET=140 ,XSIZE=1085 ,YSIZE=400)
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
  

  ;Image Information
  ImageInfo_id=WIDGET_LABEL(base_widg,value=display_info.image_percent,xsize=270,ysize=15,xoff=10,yoff=558, /ALIGN_LEFT,$
    uname='Percent')
  ImageSTT_id=WIDGET_LABEL(base_widg,value=display_info.img_stt,xsize=120,ysize=15,xoff=280,yoff=558, /ALIGN_LEFT,$
    uname='imgSTT')
  ImageSTP_id=WIDGET_LABEL(base_widg,value=display_info.img_stp,xsize=120,ysize=15,xoff=425,yoff=558, /ALIGN_LEFT,$
    uname='imgSTP')
  ImageMIND_id=WIDGET_LABEL(base_widg,value=display_info.img_minD,xsize=120,ysize=15,xoff=580,yoff=558, /ALIGN_LEFT,$
    uname='imgMIND')
  ImageMAXD_id=WIDGET_LABEL(base_widg,value=display_info.img_maxD,xsize=110,ysize=15,xoff=700,yoff=558, /ALIGN_LEFT,$
    uname='imgMAXD')
  Fwd_button_id=WIDGET_BUTTON(base_widg,value='Step Forward',event_pro='OAPdisplay_step_event',$
    xsize=110,ysize=30,xoffset=970,yoffset=550, sensitive=0, uname='stepfwd_button')
  Back_button_id=WIDGET_BUTTON(base_widg,value='Step Backward',event_pro='OAPdisplay_step_event',$
    xsize=110,ysize=30,xoffset=830,yoffset=550, sensitive=0, uname='stepback_button')

  widget_control,/realize,/hourglass,base_widg
  WIDGET_CONTROL, plot_widg_id, GET_VALUE=graphicWin

  graphicWin.select



  T1 = TEXT(0.5,0.5, ' ', Alignment=0.5)

  XMANAGER,'WCLdisplay',base_widg


END

