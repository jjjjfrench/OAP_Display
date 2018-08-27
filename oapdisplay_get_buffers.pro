PRO OAPdisplay_get_buffers, tmp, minD, maxD, inds, npart, hab_sel, first, last, direction

  common block1
  
  position= make_array(1701,4, VALUE=-999)
  assigned_color= make_array(1701,4, VALUE=255)
  x=0
  color_array= make_array(1700,4, VALUE=255)
  
  
  ;Initialize pertinent variables
  display_info.buf_full = 0  ;display buffers are not all full
  TOT_SLICE = 0              ;Number of slices in current buffer (1700 total available)
  TOT_BUF=0                  ;Number of Buffers currently used (4 total -- 0 through 3)
  stp=LONARR(4)-1            ;Particle indices for last particle in each of the 4 buffers
  stt=LONARR(4)-1            ;Particle indices for first particle in each of the 4 buffers

  ;Loop over all particles -- first and last are provided and currently represent the first
  ;  and last *possible* particle to be displayed based on start and end times and what is
  ;  being currently displayed (if anything)
  time_disp= LONARR(4,1700)-999
  pos_disp = LONARR(4,1700)-999
  part_cnt = 0L
  tot_parts=(0L)
  disp_parts=(0L)

  CASE 1 OF 
    prbtype EQ '2DS' : BEGIN
      data_length = 1700
      data_width = 8
      tmp_length = 1700
      tmp_width = 8
    END
    prbtype EQ 'CIP' : BEGIN
      data_length = 1700
      data_width = 8
      tmp_length = 850
      tmp_width = 8      
    END
    prbtype EQ 'CIPG' : BEGIN
      data_length = 512
      data_width = 64
      tmp_length = 850
      tmp_width = 64      
    END
  ENDCASE
    
  
  FOR i = first, last DO BEGIN
    IF (scnt[i] LT 1) THEN CONTINUE           ;particle has no slice count, skip it
    IF (touching_edge[i] GT 1) THEN CONTINUE  ;image cannot be touching the edge
    IF (auto_reject[i] GT 50) THEN CONTINUE   ;auto reject of 48 is accepted, all others are rejected
    tot_parts=temporary(tot_parts)+1
    IF (diam[i] LT minD) THEN CONTINUE        ;particle is too small, skip it
    IF (diam[i] GT maxD) THEN CONTINUE        ;particle is too large, skip it
    IF (i mod nth NE 0) THEN CONTINUE         ;if particle index not multiple of nth value, skip it
    ;holes_selection -- 0 to plot all parts, 1 to not plot holes, 2 to plot only holes
    skip = 0
    CASE holes_selection OF
      0 : skip = 0                                ;we plot all particles, do nothing
      1 : IF (hole_diam[i] GT 1) THEN skip=1      ;not plot holes & this particle has a hole, skip it
      2 : IF (hole_diam[i] LT 0.5) THEN skip=1    ;plot only holes & this particle has no hole, skip it      
    ENDCASE
    IF (skip) THEN CONTINUE
    bad_habit=1                          ;CHECK IF PARTICLE PARTICLE HABIT IS SELECTED TO DISPLAY
    CASE HAB[I] OF                       ; if habit_selection is set to display then 'BAD_HABIT' is 0 (False) and we keep the particle
      77  : IF (habit_selection[0]) THEN BAD_HABIT=0        ;Zero Image 'M'
      116 : IF (habit_selection[1]) THEN BAD_HABIT=0        ;Tiny Image 't'
      108 : IF (habit_selection[2]) THEN BAD_HABIT=0        ;Linear Image 'l'
      67  : IF (habit_selection[3]) THEN BAD_HABIT=0        ;Center-out Image 'C'
      111 : IF (habit_selection[4]) THEN BAD_HABIT=0        ;Oriented Image 'o'
      97  : IF (habit_selection[5]) THEN BAD_HABIT=0        ;Aggregate Image 'a'
      103 : IF (habit_selection[6]) THEN BAD_HABIT=0        ;Graupel Image 'g'
      115 : IF (habit_selection[7]) THEN BAD_HABIT=0        ;Sphere Image 's'
      104 : IF (habit_selection[8]) THEN BAD_HABIT=0        ;Hexagonal Image 'h'
      105 : IF (habit_selection[9]) THEN BAD_HABIT=0        ;Irregular Image 'i'
      100 : IF (habit_selection[10]) THEN BAD_HABIT=0       ;Dendrite Image 'd'
    ENDCASE
    IF (BAD_HABIT) THEN CONTINUE

    ;IF WE MAKE IT HERE THE PARTICLE IS GOOD TO DISPLAY
    
    
    
    disp_parts=temporary(disp_parts)+1
    time_disp[TOT_BUF, part_cnt] = hhmmss[i]
    pos_disp[TOT_BUF, part_cnt] = tot_slice
    tot_slice = tot_slice+scnt[i]        ;particle is accepted add slices to the buffer
    
   
    ;;;;;;;
    IF (stt[tot_buf] EQ -1) THEN stt[tot_buf] = i   ;if this is the first particle in buffer, set stt
    stp[tot_buf] = i                     ;assume it is last particle in buffer (this will get overwritten on next iteration if it is not)
    ;;;;;;;
    ;If we have more than tmp_length slices, our buffer is full (this depends on probe type)
    IF (TOT_SLICE GE tmp_length) THEN BEGIN
      stp[tot_buf]=i-1
      time_disp[TOT_BUF, part_cnt] = -999
      pos_disp[TOT_BUF, part_cnt] = -999     
      ;If we are on our fourth buffer (#3) we are out of buffers
      IF (TOT_BUF LT 3) THEN BEGIN
        tot_buf = tot_buf+1              ;We still have buffers left, increment by one
        tot_slice = 0                    ;reset slices
        part_cnt = 0
        time_disp[TOT_BUF, part_cnt] = hhmmss[i]
        pos_disp[TOT_BUF, part_cnt] = tot_slice
        i=i-1                            ;set particle back by one
        CONTINUE                         ;go back to start of loop
      ENDIF ELSE BEGIN
        display_info.buf_full = 1        ;all of our display buffers are full
        BREAK                            ;get outta here!
      ENDELSE
    ENDIF
    part_cnt=temporary(part_cnt)+1
  ENDFOR

  fraction= FLOAT(disp_parts)/FLOAT(tot_parts)*100
  percentage=STRING(fraction, format='(D6.2)')
  
  

  ;set the indices for first and last particle in our buffers
  first = stt[0]
  IF (stp[3] NE -1) THEN last=stp[3] ELSE last=i
  ;Determine how many data records to retrieve
  rec_cnt = rec[[last]]-rec[[first]]+1
  
  ;get the data and put the good particles in the display buffers
  varid = NCDF_VARID(fileinfo.ncid_base, 'data')
  NCDF_VARGET, fileinfo.ncid_base, varid, tmp_data, OFFSET=[0,0,rec[first]],COUNT=[data_width,data_length,rec_cnt]
  tmp = LONARR(4,tmp_width,tmp_length)
  FOR k= 0, TOT_BUF DO BEGIN
    x=0
    arr_pos = 0
    FOR i = stt[k], stp[k] DO BEGIN
      IF (scnt[i] LT 1) THEN CONTINUE
      IF (touching_edge[i] GT 1) THEN CONTINUE
      IF (auto_reject[i] GT 50) THEN CONTINUE  ;auto reject of 48 is accepted, all others are rejected
      IF (diam[i] LT minD) THEN CONTINUE
      IF (diam[i] GT maxD) THEN CONTINUE
      IF (i mod nth NE 0) THEN CONTINUE
      ;holes_selection -- 0 to plot all parts, 1 to not plot holes, 2 to plot only holes
      skip = 0
      CASE holes_selection OF
        0 : skip = 0                                ;we plot all particles, do nothing
        1 : IF (hole_diam[i] GT 1) THEN skip=1      ;not plot holes & this particle has a hole, skip it
        2 : IF (hole_diam[i] LT 0.5) THEN skip=1    ;plot only holes & this particle has no hole, skip it      
      ENDCASE
      IF (skip) THEN CONTINUE
      bad_habit=1                          ;CHECK IF PARTICLE PARTICLE HABIT IS SELECTED TO DISPLAY
      CASE HAB[I] OF                       ; if hab_sel is set to display then 'BAD_HABIT' is 0 (False) and we keep the particle
        77  : IF (habit_selection[0]) THEN BAD_HABIT=0        ;Zero Image 'M'
        116 : IF (habit_selection[1]) THEN BAD_HABIT=0        ;Tiny Image 't'
        108 : IF (habit_selection[2]) THEN BAD_HABIT=0        ;Linear Image 'l'
        67  : IF (habit_selection[3]) THEN BAD_HABIT=0        ;Center-out Image 'C'
        111 : IF (habit_selection[4]) THEN BAD_HABIT=0        ;Oriented Image 'o'
        97  : IF (habit_selection[5]) THEN BAD_HABIT=0        ;Aggregate Image 'a'
        103 : IF (habit_selection[6]) THEN BAD_HABIT=0        ;Graupel Image 'g'
        115 : IF (habit_selection[7]) THEN BAD_HABIT=0        ;Sphere Image 's'
        104 : IF (habit_selection[8]) THEN BAD_HABIT=0        ;Hexagonal Image 'h'
        105 : IF (habit_selection[9]) THEN BAD_HABIT=0        ;Irregular Image 'i'
        100 : IF (habit_selection[10]) THEN BAD_HABIT=0       ;Dendrite Image 'd'
      ENDCASE
      IF (BAD_HABIT) THEN CONTINUE


      IF (color_selection) THEN BEGIN     ;habit colors are turned on
        ; Attribute a color to each particle type
        CASE HAB[I] OF
          77  : assign= color[10]        ;Zero Image 'M'
          116 : assign= color[9]       ;Tiny Image 't'
          108 : assign= color[8]        ;Linear Image 'l'
          67  : assign= color[7]         ;Center-out Image 'C'
          111 : assign= color[6]      ;Oriented Image 'o'
          97  : assign= color[5]      ;Aggregate Image 'a'
          103 : assign= color[4]     ;Graupel Image 'g'
          115 : assign= color[3]        ;Spherical Image 's'
          104 : assign= color[2]        ;Hexagonal Image 'h'
          105 : assign= color[1]      ;Irregular Image 'i'
          100 : assign= color[0]        ;Dendrite Image 'd'
        ENDCASE
        colors=assign
      ENDIF ELSE BEGIN
        colors= 0
      ENDELSE

      
      tmp[k,*,arr_pos:arr_pos+scnt[i]-1] = tmp_data[*,pos[1,i]-scnt[i]+1:pos[1,i],rec[i]-rec[first]]
      arr_pos = arr_pos+scnt[i] 
      

      case k of 
        0:position[x,0]=arr_pos
        1:position[x,1]=arr_pos
        2:position[x,2]=arr_pos
        3:position[x,3]=arr_pos
      endcase 
      case k of
        0:assigned_color[x,0]=colors
        1:assigned_color[x,1]=colors
        2:assigned_color[x,2]=colors
        3:assigned_color[x,3]=colors
      endcase
      x=x+1
      
    ENDFOR
  ENDFOR
  
 where=where(position[*,0] NE -999)
 where2=where(assigned_color[*,0] NE 255)

 where_buf2=where(position[*,1] NE -999)
 where2_buf2=where(assigned_color[*,1] NE 255)
 
 where_buf3=where(position[*,2] NE -999)
 where2_buf3=where(assigned_color[*,2] NE 255)
 
 where_buf4=where(position[*,3] NE -999)
 where2_buf4=where(assigned_color[*,3] NE 255)
 
 
 ; Assigns a color to each slicecount position in each buffer. The color array contains color 
 ; values (254,254,254,0,0,75,75,75,75,75,etc...) for all 1700 slices in each buffer and this info gets passed on to showbuffers.
v=lonarr(1)
 x=0
 y=0
 z=0
 For x=0, N_ELEMENTS(where)-1 DO BEGIN
  v[0]=LONG(position[x,0]) 
  For z= y, v[0] DO BEGIN
  color_array[z,0]= assigned_color[[where2[x]],0]
  Endfor
 y=v[0]
 ENDFOR

x=0
y=0
z=0
For x=0, N_ELEMENTS(where_buf2)-1 DO BEGIN
  v[0]=LONG(position[[where_buf2[x]],1])
  For z= y, v[0] DO BEGIN
    color_array[z,1]= assigned_color[[where2_buf2[x]],1]
  Endfor
  y=v[0] + 1
ENDFOR

x=0
y=0
z=0
For x=0, N_ELEMENTS(where_buf3)-1 DO BEGIN
  v[0]=LONG(position[[where_buf3[x]],2])
  For z= y, v[0] DO BEGIN
    color_array[z,2]= assigned_color[[where2_buf3[x]],2]
  Endfor
  y=v[0]
ENDFOR

x=0
y=0
z=0
For x=0, N_ELEMENTS(where_buf4)-1 DO BEGIN
  v[0]=LONG(position[[where_buf4[x]],3])
  For z= y, v[0] DO BEGIN
    color_array[z,3]= assigned_color[[where2_buf4[x]],3]
  Endfor
  y=v[0]
ENDFOR

END