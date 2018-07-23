PRO OAPdisplay_getfile_event,ev

  common block1


  fbase_widg_id = WIDGET_INFO(ev.top,find_by_uname='fbase_widg')
  fproc_widg_id = WIDGET_INFO(ev.top,find_by_uname='fproc_widg')
  path_widg_id = WIDGET_INFO(ev.top,find_by_uname='path_widg')

  WIDGET_CONTROL, /hourglass
  WIDGET_CONTROL, get_value=tmp, path_widg_id
  display_info.path = tmp

filters1= ['DIMG.base*.cdf;DIMG*.CIP.cdf']
  fname_b = DIALOG_PICKFILE(FILTER=filters1, PATH=display_info.path, GET_PATH=tmp, $
    TITLE='Choose base netCDF File', /READ, /MUST_EXIST)
  IF (fname_b eq '') THEN BEGIN
    display_info.fname_base = 'No File Selected'
    WIDGET_CONTROL,set_value=display_info.fname_base,fbase_widg_id
    display_info.fname_proc = 'No File Selected'
    WIDGET_CONTROL,set_value=display_info.fname_proc,fproc_widg_id
    RETURN
  ENDIF
  display_info.path = tmp
  WIDGET_CONTROL,set_value=display_info.path,path_widg_id
  display_info.fname_base = STRMID(fname_b,STRLEN(display_info.path))
  WIDGET_CONTROL,set_value=display_info.fname_base,fbase_widg_id

filters2= ['cat.DIMG*.proc.cdf']
  fname_p = DIALOG_PICKFILE(FILTER=filters2, PATH=display_info.path, GET_PATH=tmp, $
    TITLE='Choose proc netCDF File', /READ, /MUST_EXIST)
  IF (fname_p eq '') THEN BEGIN
    display_info.fname_base = 'No File Selected'
    WIDGET_CONTROL,set_value=display_info.fname_base,fbase_widg_id
    display_info.fname_proc = 'No File Selected'
    WIDGET_CONTROL,set_value=display_info.fname_proc,fproc_widg_id
    RETURN
  ENDIF
  display_info.path = tmp
  WIDGET_CONTROL,set_value=display_info.path,path_widg_id
  display_info.fname_proc = STRMID(fname_p,STRLEN(display_info.path))
  WIDGET_CONTROL,set_value=display_info.fname_proc,fproc_widg_id

  ;using the filename -- check and set the probe type
  IF (STRPOS(fname_p, '2DS') GE 0) THEN  prbtype = '2DS'
  IF (STRPOS(fname_p, 'CIP') GE 0) THEN  prbtype = 'CIP'
  IF (((STRPOS(fname_p, '2DS')) AND (STRPOS(fname_p, 'CIP'))) LT 0) THEN BEGIN
    PRINT, 'Unsupported Probetype'
    RETURN
  ENDIF
  

  ;now open the files
  fileinfo.ncid_base = NCDF_OPEN(fname_b)
  fileinfo.ncid_proc = NCDF_OPEN(fname_p)
  ;and get times from the proc file....this may take a while
  varid = NCDF_VARID(fileinfo.ncid_proc, 'Time') ;;;;;NOTE THAT THIS IS THE TIME OF THE START OF THE BUFFER!!!
  NCDF_VARGET, fileinfo.ncid_proc, varid, proc_time
  hhmmss = LONG(proc_time)
  varid = NCDF_VARID(fileinfo.ncid_proc, 'position')
  NCDF_VARGET, fileinfo.ncid_proc, varid, pos
  pos=pos-1
  IF (prbtype EQ '2DS') THEN BEGIN                         ; Slicecount is read-in normally for the 2DS
  varid = NCDF_VARID(fileinfo.ncid_proc, 'SliceCount')
  NCDF_VARGET, fileinfo.ncid_proc, varid, scnt
  ENDIF
  IF (prbtype EQ 'CIP') THEN scnt = pos[1,*]-pos[0,*] ; CIP files determine scnt using the difference between the beginning and the end of each particle
  varid = NCDF_VARID(fileinfo.ncid_proc, 'parent_rec_num')
  NCDF_VARGET, fileinfo.ncid_proc, varid, rec
  rec=rec-1 ;idl counts from zero, the files count from 1
  varid = NCDF_VARID(fileinfo.ncid_proc, 'image_diam_minR')
  NCDF_VARGET, fileinfo.ncid_proc, varid, diam
  varid = NCDF_VARID(fileinfo.ncid_proc, 'holroyd_habit')
  NCDF_VARGET, fileinfo.ncid_proc, varid, hab
  hab=double(hab)
  varid = NCDF_VARID(fileinfo.ncid_proc, 'image_auto_reject')
  NCDF_VARGET, fileinfo.ncid_proc, varid, auto_reject
  varid = NCDF_VARID(fileinfo.ncid_proc, 'image_touching_edge')
  NCDF_VARGET, fileinfo.ncid_proc, varid, touching_edge


  fileinfo.nparts = N_ELEMENTS(hhmmss)
  start_time = STRTRIM( STRING(hhmmss[0]), 2)
  six_hhmmss=STRTRIM(STRING(start_time),2)
  six_hhmmss= '000000' + six_hhmmss
  start_time= six_hhmmss.substring(-6)
  tmp= six_hhmmss
  stop_time = STRTRIM( STRING(hhmmss[fileinfo.nparts-1]), 2)
  six_hhmmss=STRTRIM(STRING(stop_time),2)
  six_hhmmss= '000000' + six_hhmmss
  stop_time= six_hhmmss.substring(-6)
  tmp= six_hhmmss
  display_info.range_time = start_time + ' -- ' + stop_time
  timerange_widg_id = WIDGET_INFO(ev.top,find_by_uname='timerange_widg')
  WIDGET_CONTROL, set_value =display_info.range_time, timerange_widg_id
  
  
  stt_widg_id = WIDGET_INFO(ev.top,find_by_uname='stt_widg')
  WIDGET_CONTROL, set_value =start_time, stt_widg_id, Editable=1
  stp_widg_id = WIDGET_INFO(ev.top,find_by_uname='stp_widg')
  WIDGET_CONTROL, set_value =stop_time, stp_widg_id, Editable=1
  minD_widg_id = WIDGET_INFO(ev.top,find_by_uname='minD_widg')
  WIDGET_CONTROL, minD_widg_id, Editable=1
  maxD_widg_id = WIDGET_INFO(ev.top,find_by_uname='maxD_widg')
  WIDGET_CONTROL, maxD_widg_id, Editable=1
  nth_part_widg_id = WIDGET_INFO(ev.top,find_by_uname='nth_part_widg')
  WIDGET_CONTROL, nth_part_widg_id, Editable=1
  
  ; Turn on the 'Set Habit Colors' button once a file has been chosen
  color_key_widg = WIDGET_INFO(color_key_widg,find_by_uname='color_key_button')
  WIDGET_CONTROL, color_key_widg, sensitive=1

  Display_button_id = WIDGET_INFO(ev.top,find_by_uname='Display_button')
  WIDGET_CONTROL, display_button_id, sensitive=1

END
