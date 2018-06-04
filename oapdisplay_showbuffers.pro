PRO OAPdisplay_showbuffers, tmp ; Had to remove ', prbtype' in order to make timestamps work

common block1
 
  data_record = BYTARR(4,128,1700)

  ;The follow statements build the data records based on probe type
  
  CASE 1 of 
    prbtype EQ '2DS' : BEGIN
      ;convert to binary
      FOR m=0,3 DO BEGIN
        FOR k=0,1700-1 DO BEGIN
          FOR j=0,7 DO BEGIN
            FOR i = 16, 31 DO BEGIN
              pow2 = 2L^(i-16)
              IF (LONG(tmp[m,j,k]) AND pow2) NE 0 THEN $
                data_record[m,j*16L+(i-16),k]=0 ELSE data_record[m,j*16L+(i-16),k]=1
            ENDFOR
            ;data_tmp=data_record
            data_record[m,j*16L:j*16L+15,k] = REVERSE(data_record[m,j*16L:j*16L+15,k],2)
          ENDFOR
        ENDFOR
      ENDFOR

      data_record = REFORM(data_record)
      ;for 2DS data, if all diodes are blocked, the cdf file shows everything unblocked....following fixes that
      FOR m=0,3 DO BEGIN
        end_buf=1
        FOR i=1700-1,0,-1 DO BEGIN
          CASE end_buf of
            0: IF(TOTAL(data_record[m,*,i]) EQ 128 ) THEN data_record[m,*,i]=0
            1: IF(TOTAL(data_record[m,*,i]) NE 128 ) THEN end_buf=0
          ENDCASE
        ENDFOR
      ENDFOR    
    END
  ENDCASE


  ;the following draws a border around the buffer
  tmp = data_record
  data_record=LONARR(4,134,1706)
  data_record[*,3:130,3:1702]=tmp
  
  i=image(transpose(LONG(data_record[0,*,*])), /current, POSITION=[0,0.76,1,1])                                             ; Prints the 4 buffer images
  i=image(transpose(LONG(data_record[1,*,*])), /current, POSITION=[0,0.515,1,0.75])
  i=image(transpose(LONG(data_record[2,*,*])), /current, POSITION=[0,0.27,1,0.5])
  i=image(transpose(LONG(data_record[3,*,*])), /current, POSITION=[0,0.03,1,0.25])

bad_timestamps=0                                          ; Checks to see if timestamps have been selected to display
IF (timestamp_sel[0]) THEN bad_timestamps=1
IF (bad_timestamps) THEN BEGIN


  buffer1_total_part=where(time_disp[0,*] NE -999)     ; Calculates an array with the total number of particles in each of the four buffers
  buffer2_total_part=where(time_disp[1,*] NE -999)
  buffer3_total_part=where(time_disp[2,*] NE -999)
  buffer4_total_part=where(time_disp[3,*] NE -999)

  buffer1_last_part= MAX(buffer1_total_part)            ; Finds the total number of particles in each of the four buffers
  buffer2_last_part= MAX(buffer2_total_part)            ; as an integer instead of as an array.
  buffer3_last_part= MAX(buffer3_total_part)
  buffer4_last_part= MAX(buffer4_total_part)

  buffer1_first_time= time_disp[0,0]                                     ; Finds the time of the first and the last particle in each of the four buffers.
  buffer1_last_time= time_disp[0,buffer1_last_part]                      
  buffer2_first_time= time_disp[1,0]
  buffer2_last_time= time_disp[1,buffer2_last_part]
  buffer3_first_time= time_disp[2,0]
  buffer3_last_time= time_disp[2,buffer3_last_part]
  buffer4_first_time= time_disp[3,0]
  buffer4_last_time= time_disp[3,buffer4_last_part]

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; First Buffer

  buffer1_total_time = buffer1_last_time - buffer1_first_time             
   buffer1_spacing= ceil((buffer1_total_time)/6)   ; Determines the amount of time between timestamps.
  CASE buffer1_spacing OF
    0: buffer1_spacing=1   ; If the total time of the buffer is less than 6, then there should be one second between timestamps.
    ELSE: buffer1_spacing=buffer1_spacing
  ENDCASE
  
  IF (buffer1_total_time LT 1) THEN buffer1_first_time=buffer1_first_time   ; If the buffer is less than one second long, then print one timestamp.
  IF (buffer1_total_time GE 1) THEN buffer1_first_time = buffer1_first_time + 1   ; If it is at least one second long, then the first timestamp is at the first new second.
  buffer1_second_time = buffer1_first_time + buffer1_spacing
  buffer1_third_time = buffer1_second_time + buffer1_spacing
  buffer1_fourth_time = buffer1_third_time + buffer1_spacing
  buffer1_fifth_time = buffer1_fourth_time + buffer1_spacing
  buffer1_sixth_time = buffer1_fifth_time + buffer1_spacing
  
  
  
  
  buffer1_first_time_part = where(time_disp[0,*] GE buffer1_first_time)
  buffer1_part_prior_to_first_time = buffer1_first_time_part[0]                     
  buffer1_first_time_slicnt = pos_disp[0, buffer1_part_prior_to_first_time]
 
  buffer1_second_time_part = where(time_disp[0,*] GE buffer1_second_time)             ; Finds the position of the timestamps
  buffer1_part_prior_to_second_time = buffer1_second_time_part[0]                     ; for the first buffer as a slicecount.
  buffer1_second_time_slicnt = pos_disp[0, buffer1_part_prior_to_second_time]
 
  buffer1_third_time_part = where(time_disp[0,*] GE buffer1_third_time)
  buffer1_part_prior_to_third_time = buffer1_third_time_part[0]
  buffer1_third_time_slicnt = pos_disp[0, buffer1_part_prior_to_third_time]
  
  buffer1_fourth_time_part = where(time_disp[0,*] GE buffer1_fourth_time)
  buffer1_part_prior_to_fourth_time = buffer1_fourth_time_part[0]
  buffer1_fourth_time_slicnt = pos_disp[0, buffer1_part_prior_to_fourth_time]
  
  buffer1_fifth_time_part = where(time_disp[0,*] GE buffer1_fifth_time)
  buffer1_part_prior_to_fifth_time = buffer1_fifth_time_part[0]
  buffer1_fifth_time_slicnt = pos_disp[0, buffer1_part_prior_to_fifth_time]
  
  buffer1_sixth_time_part = where(time_disp[0,*] GE buffer1_sixth_time)
  buffer1_part_prior_to_sixth_time = buffer1_sixth_time_part[0]
  buffer1_sixth_time_slicnt = pos_disp[0, buffer1_part_prior_to_sixth_time]
  
  
  
  buffer1_first_location = Float(buffer1_first_time_slicnt)/1700l 
  buffer1_second_location = Float(buffer1_second_time_slicnt)/1700l                 ; Determines the location of the three middle timestamps
  buffer1_third_location = Float(buffer1_third_time_slicnt)/1700l                   ; within the first buffer (as a decimal from 0 to 1).
  buffer1_fourth_location = Float(buffer1_fourth_time_slicnt)/1700l
  buffer1_fifth_location = Float(buffer1_fifth_time_slicnt)/1700l
  buffer1_sixth_location = Float(buffer1_sixth_time_slicnt)/1700l
 
 
 
 
 ; Second Buffer
 
  buffer2_total_time = buffer2_last_time - buffer2_first_time
  buffer2_spacing= ceil((buffer2_total_time)/6)
  CASE buffer2_spacing OF
    0: buffer2_spacing=1
    ELSE: buffer2_spacing=buffer2_spacing
  ENDCASE

  IF (buffer2_total_time LT 1) THEN buffer2_first_time=buffer2_first_time
  IF (buffer2_total_time GE 1) THEN buffer2_first_time = buffer2_first_time + 1
  buffer2_second_time = buffer2_first_time + buffer2_spacing
  buffer2_third_time = buffer2_second_time + buffer2_spacing
  buffer2_fourth_time = buffer2_third_time + buffer2_spacing
  buffer2_fifth_time = buffer2_fourth_time + buffer2_spacing
  buffer2_sixth_time = buffer2_fifth_time + buffer2_spacing


  buffer2_first_time_part = where(time_disp[1,*] GE buffer2_first_time)
  buffer2_part_prior_to_first_time = buffer2_first_time_part[0]
  buffer2_first_time_slicnt = pos_disp[1, buffer2_part_prior_to_first_time]

  buffer2_second_time_part = where(time_disp[1,*] GE buffer2_second_time)             ; Finds the position of the timestamps
  buffer2_part_prior_to_second_time = buffer2_second_time_part[0]                     ; for the second buffer as a slicecount.
  buffer2_second_time_slicnt = pos_disp[1, buffer2_part_prior_to_second_time]

  buffer2_third_time_part = where(time_disp[1,*] GE buffer2_third_time)
  buffer2_part_prior_to_third_time = buffer2_third_time_part[0]
  buffer2_third_time_slicnt = pos_disp[1, buffer2_part_prior_to_third_time]

  buffer2_fourth_time_part = where(time_disp[1,*] GE buffer2_fourth_time)
  buffer2_part_prior_to_fourth_time = buffer2_fourth_time_part[0]
  buffer2_fourth_time_slicnt = pos_disp[1, buffer2_part_prior_to_fourth_time]

  buffer2_fifth_time_part = where(time_disp[1,*] GE buffer2_fifth_time)
  buffer2_part_prior_to_fifth_time = buffer2_fifth_time_part[0]
  buffer2_fifth_time_slicnt = pos_disp[1, buffer2_part_prior_to_fifth_time]

  buffer2_sixth_time_part = where(time_disp[1,*] GE buffer2_sixth_time)
  buffer2_part_prior_to_sixth_time = buffer2_sixth_time_part[0]
  buffer2_sixth_time_slicnt = pos_disp[1, buffer2_part_prior_to_sixth_time]



  buffer2_first_location = Float(buffer2_first_time_slicnt)/1700l
  buffer2_second_location = Float(buffer2_second_time_slicnt)/1700l                   
  buffer2_third_location = Float(buffer2_third_time_slicnt)/1700l                   
  buffer2_fourth_location = Float(buffer2_fourth_time_slicnt)/1700l
  buffer2_fifth_location = Float(buffer2_fifth_time_slicnt)/1700l
  buffer2_sixth_location = Float(buffer2_sixth_time_slicnt)/1700l




; Third Buffer

  buffer3_total_time = buffer3_last_time - buffer3_first_time
  buffer3_spacing= ceil((buffer3_total_time)/6)
  CASE buffer3_spacing OF
    0: buffer3_spacing=1
    ELSE: buffer3_spacing=buffer3_spacing
  ENDCASE

  IF (buffer3_total_time LT 1) THEN buffer3_first_time=buffer3_first_time
  IF (buffer3_total_time GE 1) THEN buffer3_first_time = buffer3_first_time + 1
  buffer3_second_time = buffer3_first_time + buffer3_spacing
  buffer3_third_time = buffer3_second_time + buffer3_spacing
  buffer3_fourth_time = buffer3_third_time + buffer3_spacing
  buffer3_fifth_time = buffer3_fourth_time + buffer3_spacing
  buffer3_sixth_time = buffer3_fifth_time + buffer3_spacing


  buffer3_first_time_part = where(time_disp[2,*] GE buffer3_first_time)
  buffer3_part_prior_to_first_time = buffer3_first_time_part[0]
  buffer3_first_time_slicnt = pos_disp[2, buffer3_part_prior_to_first_time]

  buffer3_second_time_part = where(time_disp[2,*] GE buffer3_second_time)             ; Finds the position of the timestamps
  buffer3_part_prior_to_second_time = buffer3_second_time_part[0]                     ; for the third buffer as a slicecount.
  buffer3_second_time_slicnt = pos_disp[2, buffer3_part_prior_to_second_time]

  buffer3_third_time_part = where(time_disp[2,*] GE buffer3_third_time)
  buffer3_part_prior_to_third_time = buffer3_third_time_part[0]
  buffer3_third_time_slicnt = pos_disp[2, buffer3_part_prior_to_third_time]

  buffer3_fourth_time_part = where(time_disp[2,*] GE buffer3_fourth_time)
  buffer3_part_prior_to_fourth_time = buffer3_fourth_time_part[0]
  buffer3_fourth_time_slicnt = pos_disp[2, buffer3_part_prior_to_fourth_time]

  buffer3_fifth_time_part = where(time_disp[2,*] GE buffer3_fifth_time)
  buffer3_part_prior_to_fifth_time = buffer3_fifth_time_part[0]
  buffer3_fifth_time_slicnt = pos_disp[2, buffer3_part_prior_to_fifth_time]

  buffer3_sixth_time_part = where(time_disp[2,*] GE buffer3_sixth_time)
  buffer3_part_prior_to_sixth_time = buffer3_sixth_time_part[0]
  buffer3_sixth_time_slicnt = pos_disp[2, buffer3_part_prior_to_sixth_time]


  buffer3_first_location = Float(buffer3_first_time_slicnt)/1700l
  buffer3_second_location = Float(buffer3_second_time_slicnt)/1700l
  buffer3_third_location = Float(buffer3_third_time_slicnt)/1700l
  buffer3_fourth_location = Float(buffer3_fourth_time_slicnt)/1700l
  buffer3_fifth_location = Float(buffer3_fifth_time_slicnt)/1700l
  buffer3_sixth_location = Float(buffer3_sixth_time_slicnt)/1700l




; Fourth buffer

  buffer4_total_time = buffer4_last_time - buffer4_first_time
  buffer4_spacing= ceil((buffer4_total_time)/6)
  CASE buffer4_spacing OF
    0: buffer4_spacing=1
    ELSE: buffer4_spacing=buffer4_spacing
  ENDCASE

  IF (buffer4_total_time LT 1) THEN buffer4_first_time=buffer4_first_time
  IF (buffer4_total_time GE 1) THEN buffer4_first_time = buffer4_first_time + 1
  buffer4_second_time = buffer4_first_time + buffer4_spacing
  buffer4_third_time = buffer4_second_time + buffer4_spacing
  buffer4_fourth_time = buffer4_third_time + buffer4_spacing
  buffer4_fifth_time = buffer4_fourth_time + buffer4_spacing
  buffer4_sixth_time = buffer4_fifth_time + buffer4_spacing

  buffer4_first_time_part = where(time_disp[3,*] GE buffer4_first_time)
  buffer4_part_prior_to_first_time = buffer4_first_time_part[0]
  buffer4_first_time_slicnt = pos_disp[3, buffer4_part_prior_to_first_time]

  buffer4_second_time_part = where(time_disp[3,*] GE buffer4_second_time)             ; Finds the position of the timestamps
  buffer4_part_prior_to_second_time = buffer4_second_time_part[0]                     ; for the fourth buffer as a slicecount.
  buffer4_second_time_slicnt = pos_disp[3, buffer4_part_prior_to_second_time]

  buffer4_third_time_part = where(time_disp[3,*] GE buffer4_third_time)
  buffer4_part_prior_to_third_time = buffer4_third_time_part[0]
  buffer4_third_time_slicnt = pos_disp[3, buffer4_part_prior_to_third_time]

  buffer4_fourth_time_part = where(time_disp[3,*] GE buffer4_fourth_time)
  buffer4_part_prior_to_fourth_time = buffer4_fourth_time_part[0]
  buffer4_fourth_time_slicnt = pos_disp[3, buffer4_part_prior_to_fourth_time]

  buffer4_fifth_time_part = where(time_disp[3,*] GE buffer4_fifth_time)
  buffer4_part_prior_to_fifth_time = buffer4_fifth_time_part[0]
  buffer4_fifth_time_slicnt = pos_disp[3, buffer4_part_prior_to_fifth_time]

  buffer4_sixth_time_part = where(time_disp[3,*] GE buffer4_sixth_time)
  buffer4_part_prior_to_sixth_time = buffer4_sixth_time_part[0]
  buffer4_sixth_time_slicnt = pos_disp[3, buffer4_part_prior_to_sixth_time]



  buffer4_first_location = Float(buffer4_first_time_slicnt)/1700l
  buffer4_second_location = Float(buffer4_second_time_slicnt)/1700l
  buffer4_third_location = Float(buffer4_third_time_slicnt)/1700l
  buffer4_fourth_location = Float(buffer4_fourth_time_slicnt)/1700l
  buffer4_fifth_location = Float(buffer4_fifth_time_slicnt)/1700l
  buffer4_sixth_location = Float(buffer4_sixth_time_slicnt)/1700l
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
  
  
  buffer1_first_timeline=POLYLINE([(buffer1_first_location),(buffer1_first_location - 0.0000000001)],[0.985,0.775])
  buffer1_second_timeline=POLYLINE([(buffer1_second_location),(buffer1_second_location - 0.0000000001)],[0.985,0.775])
  buffer1_third_timeline=POLYLINE([(buffer1_third_location),(buffer1_third_location - 0.0000000001)],[0.985,0.775])
  buffer1_fourth_timeline=POLYLINE([(buffer1_fourth_location),(buffer1_fourth_location - 0.0000000001)],[0.985,0.775])
  buffer1_fifth_timeline=POLYLINE([(buffer1_fifth_location),(buffer1_fifth_location - 0.0000000001)],[0.985,0.775])
  buffer1_sixth_timeline=POLYLINE([(buffer1_sixth_location),(buffer1_sixth_location - 0.0000000001)],[0.985,0.775])
 
  buffer2_first_timeline=POLYLINE([(buffer2_first_location),(buffer2_first_location - 0.0000000001)],[0.735,0.525])
  buffer2_second_timeline=POLYLINE([(buffer2_second_location),(buffer2_second_location - 0.0000000001)],[0.735,0.525])
  buffer2_third_timeline=POLYLINE([(buffer2_third_location),(buffer2_third_location - 0.0000000001)],[0.735,0.525])
  buffer2_fourth_timeline=POLYLINE([(buffer2_fourth_location),(buffer2_fourth_location - 0.0000000001)],[0.735,0.525])
  buffer2_fifth_timeline=POLYLINE([(buffer2_fifth_location),(buffer2_fifth_location - 0.0000000001)],[0.735,0.525])
  buffer2_sixth_timeline=POLYLINE([(buffer2_sixth_location),(buffer2_sixth_location - 0.0000000001)],[0.735,0.525])
                                                                                                                      ; Creates lines in the buffer to mark each timestamp.
  buffer3_first_timeline=POLYLINE([(buffer3_first_location),(buffer3_first_location - 0.0000000001)],[0.488,0.278])
  buffer3_second_timeline=POLYLINE([(buffer3_second_location),(buffer3_second_location - 0.0000000001)],[0.488,0.278])
  buffer3_third_timeline=POLYLINE([(buffer3_third_location),(buffer3_third_location - 0.0000000001)],[0.488,0.278])
  buffer3_fourth_timeline=POLYLINE([(buffer3_fourth_location),(buffer3_fourth_location - 0.0000000001)],[0.488,0.278])
  buffer3_fifth_timeline=POLYLINE([(buffer3_fifth_location),(buffer3_fifth_location - 0.0000000001)],[0.488,0.278])
  buffer3_sixth_timeline=POLYLINE([(buffer3_sixth_location),(buffer3_sixth_location - 0.0000000001)],[0.488,0.278])
  
  buffer4_first_timeline=POLYLINE([(buffer4_first_location),(buffer4_first_location - 0.0000000001)],[0.242,0.032])
  buffer4_second_timeline=POLYLINE([(buffer4_second_location),(buffer4_second_location - 0.0000000001)],[0.242,0.032])
  buffer4_third_timeline=POLYLINE([(buffer4_third_location),(buffer4_third_location - 0.0000000001)],[0.242,0.032])
  buffer4_fourth_timeline=POLYLINE([(buffer4_fourth_location),(buffer4_fourth_location - 0.0000000001)],[0.242,0.032])
  buffer4_fifth_timeline=POLYLINE([(buffer4_fifth_location),(buffer4_fifth_location - 0.0000000001)],[0.242,0.032])
  buffer4_sixth_timeline=POLYLINE([(buffer4_sixth_location),(buffer4_sixth_location - 0.0000000001)],[0.242,0.032])




    six_buffer1_first_time = STRTRIM(STRING(buffer1_first_time),2)
    six_buffer1_first_time = '000000' + six_buffer1_first_time
    six_buffer1_first_time = six_buffer1_first_time.substring(-6)
    six_buffer1_second_time = STRTRIM(STRING(buffer1_second_time),2)
    six_buffer1_second_time = '000000' + six_buffer1_second_time
    six_buffer1_second_time = six_buffer1_second_time.substring(-6)
    six_buffer1_third_time = STRTRIM(STRING(buffer1_third_time),2)
    six_buffer1_third_time = '000000' + six_buffer1_third_time
    six_buffer1_third_time = six_buffer1_third_time.substring(-6)
    six_buffer1_fourth_time = STRTRIM(STRING(buffer1_fourth_time),2)
    six_buffer1_fourth_time = '000000' + six_buffer1_fourth_time
    six_buffer1_fourth_time = six_buffer1_fourth_time.substring(-6)
    six_buffer1_fifth_time = STRTRIM(STRING(buffer1_fifth_time),2)
    six_buffer1_fifth_time = '000000' + six_buffer1_fifth_time
    six_buffer1_fifth_time = six_buffer1_fifth_time.substring(-6)
    six_buffer1_sixth_time = STRTRIM(STRING(buffer1_sixth_time),2)
    six_buffer1_sixth_time = '000000' + six_buffer1_sixth_time
    six_buffer1_sixth_time = six_buffer1_sixth_time.substring(-6)
    
    
    
    six_buffer2_first_time = STRTRIM(STRING(buffer2_first_time),2)
    six_buffer2_first_time = '000000' + six_buffer2_first_time
    six_buffer2_first_time = six_buffer2_first_time.substring(-6)
    six_buffer2_second_time = STRTRIM(STRING(buffer2_second_time),2)
    six_buffer2_second_time = '000000' + six_buffer2_second_time
    six_buffer2_second_time = six_buffer2_second_time.substring(-6)
    six_buffer2_third_time = STRTRIM(STRING(buffer2_third_time),2)
    six_buffer2_third_time = '000000' + six_buffer2_third_time
    six_buffer2_third_time = six_buffer2_third_time.substring(-6)
    six_buffer2_fourth_time = STRTRIM(STRING(buffer2_fourth_time),2)
    six_buffer2_fourth_time = '000000' + six_buffer2_fourth_time
    six_buffer2_fourth_time = six_buffer2_fourth_time.substring(-6)
    six_buffer2_fifth_time = STRTRIM(STRING(buffer2_fifth_time),2)
    six_buffer2_fifth_time = '000000' + six_buffer2_fifth_time
    six_buffer2_fifth_time = six_buffer2_fifth_time.substring(-6) 
    six_buffer2_sixth_time = STRTRIM(STRING(buffer2_sixth_time),2)
    six_buffer2_sixth_time = '000000' + six_buffer2_sixth_time
    six_buffer2_sixth_time = six_buffer2_sixth_time.substring(-6)
    
                                                                      ; Makes sure that the timestamps are in the form 'hhmmss'.
    
    six_buffer3_first_time = STRTRIM(STRING(buffer3_first_time),2)
    six_buffer3_first_time = '000000' + six_buffer3_first_time
    six_buffer3_first_time = six_buffer3_first_time.substring(-6)
    six_buffer3_second_time = STRTRIM(STRING(buffer3_second_time),2)
    six_buffer3_second_time = '000000' + six_buffer3_second_time
    six_buffer3_second_time = six_buffer3_second_time.substring(-6)
    six_buffer3_third_time = STRTRIM(STRING(buffer3_third_time),2)
    six_buffer3_third_time = '000000' + six_buffer3_third_time
    six_buffer3_third_time = six_buffer3_third_time.substring(-6)
    six_buffer3_fourth_time = STRTRIM(STRING(buffer3_fourth_time),2)
    six_buffer3_fourth_time = '000000' + six_buffer3_fourth_time
    six_buffer3_fourth_time = six_buffer3_fourth_time.substring(-6)
    six_buffer3_fifth_time = STRTRIM(STRING(buffer3_fifth_time),2)
    six_buffer3_fifth_time = '000000' + six_buffer3_fifth_time
    six_buffer3_fifth_time = six_buffer3_fifth_time.substring(-6)
    six_buffer3_sixth_time = STRTRIM(STRING(buffer3_sixth_time),2)
    six_buffer3_sixth_time = '000000' + six_buffer3_sixth_time
    six_buffer3_sixth_time = six_buffer3_sixth_time.substring(-6)
   
   
   
    six_buffer4_first_time = STRTRIM(STRING(buffer4_first_time),2)
    six_buffer4_first_time = '000000' + six_buffer4_first_time
    six_buffer4_first_time = six_buffer4_first_time.substring(-6)
    six_buffer4_second_time = STRTRIM(STRING(buffer4_second_time),2)
    six_buffer4_second_time = '000000' + six_buffer4_second_time
    six_buffer4_second_time = six_buffer4_second_time.substring(-6)
    six_buffer4_third_time = STRTRIM(STRING(buffer4_third_time),2)
    six_buffer4_third_time = '000000' + six_buffer4_third_time
    six_buffer4_third_time = six_buffer4_third_time.substring(-6)
    six_buffer4_fourth_time = STRTRIM(STRING(buffer4_fourth_time),2)
    six_buffer4_fourth_time = '000000' + six_buffer4_fourth_time
    six_buffer4_fourth_time = six_buffer4_fourth_time.substring(-6)
    six_buffer4_fifth_time = STRTRIM(STRING(buffer4_fifth_time),2)
    six_buffer4_fifth_time = '000000' + six_buffer4_fifth_time
    six_buffer4_fifth_time = six_buffer4_fifth_time.substring(-6)
    six_buffer4_sixth_time = STRTRIM(STRING(buffer4_sixth_time),2)
    six_buffer4_sixth_time = '000000' + six_buffer4_sixth_time
    six_buffer4_sixth_time = six_buffer4_sixth_time.substring(-6)


 
  buffer1_timestamp1= TEXT(buffer1_first_location,0.74, FONT_SIZE=10.5 , six_buffer1_first_time)
  buffer1_timestamp2= TEXT(buffer1_second_location,0.74, FONT_SIZE=10.5, six_buffer1_second_time)
  buffer1_timestamp3= TEXT(buffer1_third_location,0.74, FONT_SIZE=10.5, six_buffer1_third_time)
  buffer1_timestamp4= TEXT(buffer1_fourth_location,0.74, FONT_SIZE=10.5, six_buffer1_fourth_time)
  buffer1_timestamp5= TEXT(buffer1_fifth_location,0.74, FONT_SIZE=10.5, six_buffer1_fifth_time)
  buffer1_timestamp6= TEXT(buffer1_sixth_location,0.74, FONT_SIZE=10.5, six_buffer1_sixth_time)

  
  buffer2_timestamp1= TEXT(buffer2_first_location,0.4925, FONT_SIZE=10.5, six_buffer2_first_time)
  buffer2_timestamp2= TEXT(buffer2_second_location,0.4925, FONT_SIZE=10.5, six_buffer2_second_time)
  buffer2_timestamp3= TEXT(buffer2_third_location,0.4925, FONT_SIZE=10.5, six_buffer2_third_time)
  buffer2_timestamp4= TEXT(buffer2_fourth_location,0.4925, FONT_SIZE=10.5, six_buffer2_fourth_time)
  buffer2_timestamp5= TEXT(buffer2_fifth_location,0.4925, FONT_SIZE=10.5, six_buffer2_fifth_time)
  buffer2_timestamp6= TEXT(buffer2_sixth_location,0.4925, FONT_SIZE=10.5, six_buffer2_sixth_time)
                                                                                                      ; Prints the timestamps.
 
  buffer3_timestamp1= TEXT(buffer3_first_location,0.248, FONT_SIZE=10.5, six_buffer3_first_time)
  buffer3_timestamp2= TEXT(buffer3_second_location,0.248, FONT_SIZE=10.5, six_buffer3_second_time)
  buffer3_timestamp3= TEXT(buffer3_third_location,0.248, FONT_SIZE=10.5, six_buffer3_third_time)
  buffer3_timestamp4= TEXT(buffer3_fourth_location,0.248, FONT_SIZE=10.5, six_buffer3_fourth_time)
  buffer3_timestamp5= TEXT(buffer3_fifth_location,0.248, FONT_SIZE=10.5, six_buffer3_fifth_time)
  buffer3_timestamp6= TEXT(buffer3_sixth_location,0.248, FONT_SIZE=10.5, six_buffer3_sixth_time)
 
  buffer4_timestamp1= TEXT(buffer4_first_location,0, FONT_SIZE=10.5, six_buffer4_first_time)
  buffer4_timestamp2= TEXT(buffer4_second_location,0, FONT_SIZE=10.5, six_buffer4_second_time)
  buffer4_timestamp3= TEXT(buffer4_third_location,0, FONT_SIZE=10.5, six_buffer4_third_time)
  buffer4_timestamp4= TEXT(buffer4_fourth_location,0, FONT_SIZE=10.5, six_buffer4_fourth_time)
  buffer4_timestamp5= TEXT(buffer4_fifth_location,0, FONT_SIZE=10.5, six_buffer4_fifth_time)
  buffer4_timestamp6= TEXT(buffer4_sixth_location,0, FONT_SIZE=10.5, six_buffer4_sixth_time)
 ENDIF
 
END
