PRO OAPdisplay_get2DS_buffers, tmp, minD, maxD, inds, npart, hab_sel, first, last, direction

  common block1

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
  
  FOR i = first, last DO BEGIN
    IF (scnt[i] LT 1) THEN CONTINUE           ;particle has no slice count, skip it
    IF (auto_reject[i] GT 50) THEN CONTINUE   ;auto reject of 48 is accepted, all others are rejected
    tot_parts=tot_parts+1
    IF (diam[i] LT minD) THEN CONTINUE        ;particle is too small, skip it
    IF (diam[i] GT maxD) THEN CONTINUE        ;particle is too large, skip it
    IF (i mod nth NE 0) THEN CONTINUE         ;if particle index not multiple of nth value, skip it
    bad_habit=1                          ;CHECK IF PARTICLE PARTICLE HABIT IS SELECTED TO DISPLAY
    CASE HAB[I] OF                       ; if hab_sel is set to display then 'BAD_HABIT' is 0 (False) and we keep the particle
      77  : IF (HAB_SEL[0]) THEN BAD_HABIT=0        ;Zero Image 'M'
      116 : IF (HAB_SEL[1]) THEN BAD_HABIT=0        ;Tiny Image 't'
      108 : IF (HAB_SEL[2]) THEN BAD_HABIT=0        ;Linear Image 'l'
      67  : IF (HAB_SEL[3]) THEN BAD_HABIT=0        ;Center-out Image 'C'
      111 : IF (HAB_SEL[4]) THEN BAD_HABIT=0        ;Oriented Image 'o'
      97  : IF (HAB_SEL[5]) THEN BAD_HABIT=0        ;Aggregate Image 'a'
      103 : IF (HAB_SEL[6]) THEN BAD_HABIT=0        ;Graupel Image 'g'
      115 : IF (HAB_SEL[7]) THEN BAD_HABIT=0        ;Sphere Image 's'
      104 : IF (HAB_SEL[8]) THEN BAD_HABIT=0        ;Hexagonal Image 'h'
      105 : IF (HAB_SEL[9]) THEN BAD_HABIT=0        ;Irregular Image 'i'
      100 : IF (HAB_SEL[10]) THEN BAD_HABIT=0       ;Dendrite Image 'd'
    ENDCASE
    IF (BAD_HABIT) THEN CONTINUE

    ;IF WE MAKE IT HERE THE PARTICLE IS GOOD TO DISPLAY
    disp_parts=disp_parts+1
    time_disp[TOT_BUF, part_cnt] = hhmmss[i]
    pos_disp[TOT_BUF, part_cnt] = tot_slice
    tot_slice = tot_slice+scnt[i]        ;particle is accepted add slices to the buffer
    part_cnt=part_cnt+1
    ;;;;;;;
    IF (stt[tot_buf] EQ -1) THEN stt[tot_buf] = i   ;if this is the first particle in buffer, set stt
    stp[tot_buf] = i                     ;assume it is last particle in buffer (this will get overwritten on next iteration if it is not)
    ;;;;;;;
    ;If we have more than 1700 slices, are buffer is full
    IF (TOT_SLICE GT 1700) THEN BEGIN
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
  ENDFOR
  fraction= FLOAT(disp_parts)/FLOAT(tot_parts)*100
  percentage=STRING(fraction, format='(D6.2)')
  
  

  ;set the indices for first and last particle in our buffers
  first = stt[0]
  IF (stp[3] NE -1) THEN last=stp[3] ELSE last=i
  ;Determine how many data records to retrieve
  rec_cnt = rec[last]-rec[first]+1
  
  ;get the data and put the good particles in the display buffers
  varid = NCDF_VARID(fileinfo.ncid_base, 'data')
  NCDF_VARGET, fileinfo.ncid_base, varid, tmp_data, OFFSET=[0,0,rec[first]],COUNT=[8,1700,rec_cnt]
  tmp = LONARR(4,8,1700)
  FOR k= 0, TOT_BUF DO BEGIN
    arr_pos = 0
    FOR i = stt[k], stp[k] DO BEGIN
      IF (scnt[i] LT 1) THEN CONTINUE
      IF (auto_reject[i] GT 50) THEN CONTINUE  ;auto reject of 48 is accepted, all others are rejected
      IF (diam[i] LT minD) THEN CONTINUE
      IF (diam[i] GT maxD) THEN CONTINUE
      IF (i mod nth NE 0) THEN CONTINUE
      bad_habit=1                          ;CHECK IF PARTICLE PARTICLE HABIT IS SELECTED TO DISPLAY
      CASE HAB[I] OF                       ; if hab_sel is set to display then 'BAD_HABIT' is 0 (False) and we keep the particle
        77  : IF (HAB_SEL[0]) THEN BAD_HABIT=0        ;Zero Image 'M'
        116 : IF (HAB_SEL[1]) THEN BAD_HABIT=0        ;Tiny Image 't'
        108 : IF (HAB_SEL[2]) THEN BAD_HABIT=0        ;Linear Image 'l'
        67  : IF (HAB_SEL[3]) THEN BAD_HABIT=0        ;Center-out Image 'C'
        111 : IF (HAB_SEL[4]) THEN BAD_HABIT=0        ;Oriented Image 'o'
        97  : IF (HAB_SEL[5]) THEN BAD_HABIT=0        ;Aggregate Image 'a'
        103 : IF (HAB_SEL[6]) THEN BAD_HABIT=0        ;Graupel Image 'g'
        115 : IF (HAB_SEL[7]) THEN BAD_HABIT=0        ;Sphere Image 's'
        104 : IF (HAB_SEL[8]) THEN BAD_HABIT=0        ;Hexagonal Image 'h'
        105 : IF (HAB_SEL[9]) THEN BAD_HABIT=0        ;Irregular Image 'i'
        100 : IF (HAB_SEL[10]) THEN BAD_HABIT=0       ;Dendrite Image 'd'
      ENDCASE
      IF (BAD_HABIT) THEN CONTINUE

      tmp[k,*,arr_pos:arr_pos+scnt[i]-1] = tmp_data[*,pos[1,i]-scnt[i]+1:pos[1,i],rec[i]-rec[first]]
      arr_pos = arr_pos+scnt[i]
    ENDFOR
  ENDFOR
  
  
END