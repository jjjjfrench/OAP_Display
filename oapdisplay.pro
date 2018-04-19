PRO OAPdisplay

  RESOLVE_ROUTINE,['oapdisplay_quit_event','OAPdisplay_getfile_event','OAPdisplay_settime_event','OAPdisplay_event',$
    'OAPdisplay_get2ds_buffers','OAPdisplay_showbuffers','OAPdisplay_step_event']
  RESOLVE_ROUTINE,'oapdisplay_particle_criteria_event',/IS_FUNCTION

  common block1, fileinfo, display_info, prbtype, hhmmss, pos, scnt, rec, diam, nth, hab, hab_selection, auto_reject

  fileinfo = {ncid_base:-999L, ncid_proc:-999L, nparts: 0L, data_varid:0L }

  display_info = {fname_base:'No File Selected', fname_proc:'No File Selected', path:'/kingair_data/snowie17/2DS/', $
    nrec: 'No Records to Show', range_time:'hhmmss -- hhmmss', $
    stt_time:'hhmmss', stp_time:'hhmmss', min_size:'100', max_size:'500', nth_part:'1', $
    img_stt:'Image Start: hhmmss', img_stp:'Image Stop: hhmmss', img_minD:'Image MinD: 100',  img_maxD:'Image MaxD: 500',  img_nth:'Image nth: 1', $
    first:-999L, last:-999L, buf_full:0L}

  hhmmss=0L & pos=0L & scnt=0L & rec=0L & diam=0L & prbtype =''



  widgtit = 'OAP Display'
  ;set up base widget
  base_widg=WIDGET_BASE(title=widgtit,xsize=1095,ysize=590)

  ;set file selection and file display widget
  file_button_id=WIDGET_BUTTON(base_widg,value='New File Set',event_pro='OAPdisplay_getfile_event',$
    xsize=80,ysize=60,xoffset=10,yoffset=10, uname='file_button')
  path_label_id=WIDGET_LABEL(base_widg,value='Filepath:',xsize=80,ysize=15,xoff=100,yoff=15,  /ALIGN_RIGHT)
  path_widg_id=WIDGET_TEXT(base_widg,xsize=58,xoff=180,yoff=10, value=display_info.path,$
    uname='path_widg')
  fbase_label_id=WIDGET_LABEL(base_widg,value='Base nc file:',xsize=80,ysize=15,xoff=100,yoff=45,  /ALIGN_RIGHT)
  fbase_widg_id=WIDGET_TEXT(base_widg,xsize=58,xoff=180,yoff=40,value=display_info.fname_base,$
    uname='fbase_widg')
  fbase_label_id=WIDGET_LABEL(base_widg,value='Proc nc file:',xsize=80,ysize=15,xoff=100,yoff=75,  /ALIGN_Right)
  fproc_widg_id=  WIDGET_TEXT(base_widg,xsize=58,xoff=180,yoff=70,value=display_info.fname_proc,$
    uname='fproc_widg')

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
  maxD_widg_id=WIDGET_TEXT(base_widg, value=display_info.max_size, event_pro='OAPdisplay_maxD_event',$
    xsize=10,xoff=900,yoff=103, uname='maxD_widg')
  nth_part_label_id=WIDGET_LABEL(base_widg,value='Every nth',xsize=80,ysize=15,xoff=980,yoff=79, /ALIGN_Right)
  nth_part_widg_id=WIDGET_TEXT(base_widg,value=display_info.nth_part,event_func='OAPdisplay_particle_criteria_event',$
    uname='nth_part_widg',xsize=2,xoff=1060,yoff=75)
  hab_button_names=['Zero','Tiny','Linear','Center-Out','Oriented','Aggregate','Graupel',$
    'Sphere','Hexagonal','Irregular','Dendrite']
  hab_widg_id=CW_BGROUP(base_widg,hab_button_names,Column=3,/NonExclusive,LABEL_TOP='Habit',$
    xoff=552,/FRAME,ysize=105,uname='hab_widg', event_funct='OAPdisplay_particle_criteria_event',set_value=[0,0,1,1,1,1,1,1,1,1,1])

  Display_button_id=WIDGET_BUTTON(base_widg,value='Display Particles',event_pro='OAPdisplay_event',$
    xsize=110,ysize=60,xoffset=980,yoffset=10, sensitive=0, uname='Display_button')


  quit_button=WIDGET_BUTTON(base_widg,value='Quit',event_pro='OAPdisplay_quit_event',$
    xsize=80,ysize=30,xoffset=10,yoffset=80)


  ;set up plot window
  plot_widg_id = WIDGET_WINDOW(base_widg, UNAME='plot_widg' ,XOFFSET=5  $
    ,YOFFSET=140 ,XSIZE=1085 ,YSIZE=400)


  ;Image Information
  ImageInfo_id=WIDGET_LABEL(base_widg,value='Image Information---',xsize=120,ysize=15,xoff=10,yoff=560, /ALIGN_LEFT)
  ImageSTT_id=WIDGET_LABEL(base_widg,value=display_info.img_stt,xsize=120,ysize=15,xoff=150,yoff=560, /ALIGN_LEFT,$
    uname='imgSTT')
  ImageSTP_id=WIDGET_LABEL(base_widg,value=display_info.img_stp,xsize=120,ysize=15,xoff=320,yoff=560, /ALIGN_LEFT,$
    uname='imgSTP')
  ImageMIND_id=WIDGET_LABEL(base_widg,value=display_info.img_minD,xsize=120,ysize=15,xoff=470,yoff=560, /ALIGN_LEFT,$
    uname='imgMIND')
  ImageMAXD_id=WIDGET_LABEL(base_widg,value=display_info.img_maxD,xsize=110,ysize=15,xoff=585,yoff=560, /ALIGN_LEFT,$
    uname='imgMAXD')
  Fwd_button_id=WIDGET_BUTTON(base_widg,value='Step Forward',event_pro='OAPdisplay_step_event',$
    xsize=110,ysize=30,xoffset=850,yoffset=550, sensitive=0, uname='stepfwd_button')
  Back_button_id=WIDGET_BUTTON(base_widg,value='Step Backward',event_pro='OAPdisplay_step_event',$
    xsize=110,ysize=30,xoffset=700,yoffset=550, sensitive=0, uname='stepback_button')


  widget_control,/realize,/hourglass,base_widg
  WIDGET_CONTROL, plot_widg_id, GET_VALUE=graphicWin

  graphicWin.select

  T1 = TEXT(0.5,0.5, ' ', Alignment=0.5)


  XMANAGER,'WCLdisplay',base_widg


END

