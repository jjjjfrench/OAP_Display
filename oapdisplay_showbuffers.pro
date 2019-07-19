PRO OAPdisplay_showbuffers, tmp

common block1

  ;The follow statements build the data records based on probe type
  
   CASE 1 of 
    prbtype EQ '2DS' : BEGIN
      data_record = BYTARR(4,128,1700)
      ;convert to binary
      FOR m=0,3 DO BEGIN
        FOR k=0,1700-1 DO BEGIN
          FOR j=0,7 DO BEGIN
            FOR i = 16, 31 DO BEGIN
              pow2 = 2L^(i-16)
              IF (LONG(tmp[m,j,k]) AND pow2) NE 0 THEN $
                data_record[m,j*16L+(i-16),k]=color_array[k,m] ELSE data_record[m,j*16L+(i-16),k]=255
            ENDFOR
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
            0: IF(TOTAL(data_record[m,*,i]) EQ 128 ) THEN data_record[m,*,i]=1
            1: IF(TOTAL(data_record[m,*,i]) NE 128 ) THEN end_buf=0
          ENDCASE
        ENDFOR
      ENDFOR   
       
      ;the following draws a border around the buffer
      tmp = data_record
      data_record=LONARR(4,134,1706)
      data_record[*,3:130,3:1702]=tmp
     
    END
    
    
    
    prbtype EQ 'CIP' : BEGIN
      data_record=BYTARR(4,64,850)
      ;convert to binary
      FOR m=0,3 DO BEGIN
        FOR k=0,850-1 DO BEGIN
          FOR j=0,7 DO BEGIN
            FOR i = 24, 31 DO BEGIN
              pow2 = 2L^(i-24)
              IF (LONG(tmp[m,j,k]) AND pow2) NE 0 THEN $
                data_record[m,j*8L+(i-24),k]=255 ELSE data_record[m,j*8L+(i-24),k]=color_array[k,m]
            ENDFOR
            data_record[m,j*8L:j*8L+7,k] = REVERSE(data_record[m,j*8L:j*8L+7,k],2)
          ENDFOR
        ENDFOR
      ENDFOR

      data_record = REFORM(data_record)
      ;for CIP data, if all diodes are blocked, the cdf file shows everything unblocked....following fixes that
      FOR m=0,3 DO BEGIN
        end_buf=1
        FOR i=850-1,0,-1 DO BEGIN
          CASE end_buf of
            0: IF(TOTAL(data_record[m,*,i]) EQ 64 ) THEN data_record[m,*,i]=1
            1: IF(TOTAL(data_record[m,*,i]) NE 64 ) THEN end_buf=0
          ENDCASE
        ENDFOR
      ENDFOR

      ;the following draws a border around the buffer
      tmp = data_record
      data_record=LONARR(4,68,854)
      data_record[*,2:65,2:851]=tmp

    END
    
    
    prbtype EQ 'CIPG' : BEGIN
      data_record=BYTARR(4,64,850)
      ;convert to binary
      FOR m=0,3 DO BEGIN
        FOR k=0,850-1 DO BEGIN
          FOR j=0,63 DO BEGIN
              IF (LONG(tmp[m,j,k]) LE 2) THEN $
                data_record[m,j,k]=color_array[k,m] ELSE data_record[m,j,k]=255
            data_record[m,j,k] = REVERSE(data_record[m,j,k],2)
          ENDFOR
        ENDFOR
      ENDFOR

      data_record = REFORM(data_record)
      ;for CIP data, if all diodes are blocked, the cdf file shows everything unblocked....following fixes that
      FOR m=0,3 DO BEGIN
        end_buf=1
        FOR i=850-1,0,-1 DO BEGIN
          CASE end_buf of
            0: IF(TOTAL(data_record[m,*,i]) EQ 64 ) THEN data_record[m,*,i]=1
            1: IF(TOTAL(data_record[m,*,i]) NE 64 ) THEN end_buf=0
          ENDCASE
        ENDFOR
      ENDFOR

      ;the following draws a border around the buffer
      tmp = data_record
      data_record=LONARR(4,68,854)
      data_record[*,2:65,2:851]=tmp

    END
  ENDCASE
  
  i=image(transpose(LONG(data_record[0,*,*])), /current, POSITION=[0,0.76,1,1], RGB_TABLE=39)                      ; Prints the 4 buffer images
  i=image(transpose(LONG(data_record[1,*,*])), /current, POSITION=[0,0.515,1,0.75], RGB_TABLE=39)
  i=image(transpose(LONG(data_record[2,*,*])), /current, POSITION=[0,0.27,1,0.5], RGB_TABLE=39)
  i=image(transpose(LONG(data_record[3,*,*])), /current, POSITION=[0,0.03,1,0.25], RGB_TABLE=39)

  
;********************************************************************************************************************************

; Checks to see if timestamps have been selected to display and if so put them in...
IF (timestamp_selection) THEN BEGIN

  CASE 1 OF
    prbtype EQ '2DS' : BEGIN
      buf_length = 1700L
    END
    prbtype EQ 'CIP' : BEGIN
      buf_length = 850L
    END
    prbtype EQ 'CIPG' : BEGIN
      buf_length = 850L
    END
  ENDCASE
  

For m=0,3 DO BEGIN
  
buffer_total_part=where(time_disp[m,*] NE -999)
buffer_last_part= MAX(buffer_total_part)
buffer_first_time= time_disp[m,0]
buffer_last_time= time_disp[m,buffer_last_part]
forward_function hhmmss2sec
forward_function sec2hhmmss
buffer_first_time=hhmmss2sec(buffer_first_time)
buffer_last_time=hhmmss2sec(buffer_last_time)
buffer_total_time = buffer_last_time - buffer_first_time
IF (buffer_total_time LT 1) THEN buffer_first_time=buffer_first_time         ; If the buffer is less than one second long, then print one timestamp.
IF (buffer_total_time GE 1) THEN buffer_first_time = buffer_first_time + 1   ; If it is at least one second long, then the first timestamp is at the first new second.
buffer_first_time=sec2hhmmss(buffer_first_time)
buffer_time=buffer_first_time
buffer_last_time=sec2hhmmss(buffer_last_time)


buffer_spacing= ceil((buffer_total_time)/6)   ; Determines the amount of time between timestamps.
CASE buffer_spacing OF
  0: buffer_spacing=1   ; If the total time of the buffer is less than 6, then there should be one second between timestamps.
  ELSE: buffer_spacing=buffer_spacing
ENDCASE


CASE m OF
  0: BEGIN
    location= [0.985,0.775]
    yloc= 0.74
  END
  1: BEGIN
    location= [0.735,0.525]
    yloc=0.4925
  END
  2: BEGIN
    location= [0.488,0.278]
    yloc=0.248
  END
  3: BEGIN
    location=[0.242,0.032]
    yloc=0
  END
ENDCASE


FOR z=0,5 DO BEGIN

IF buffer_time EQ buffer_first_time THEN BEGIN
  buffer_time_part = where(time_disp[m,*] GE buffer_time)
  buffer_part_prior_to_time = buffer_time_part[0]
  buffer_time_slicnt = pos_disp[m, buffer_part_prior_to_time]
  buffer_location = Float(buffer_time_slicnt)/buf_length
  buffer_timeline=POLYLINE([(buffer_location),(buffer_location - 0.0000000001)],location)
  six_buffer_time = STRTRIM(STRING(buffer_time),2)
  six_buffer_time = '000000' + six_buffer_time
  six_buffer_time = six_buffer_time.substring(-6)
  buffer_timestamp= TEXT(buffer_location,yloc, FONT_SIZE=10.5 , six_buffer_time)
  buffer_time=hhmmss2sec(buffer_time)
  buffer_time = buffer_time + buffer_spacing
  buffer_time=sec2hhmmss(buffer_time)
ENDIF ELSE BEGIN
IF buffer_time LE (buffer_last_time) THEN BEGIN
buffer_time_part = where(time_disp[m,*] GE buffer_time)
buffer_part_prior_to_time = buffer_time_part[0]
buffer_time_slicnt = pos_disp[m, buffer_part_prior_to_time]
buffer_location = Float(buffer_time_slicnt)/buf_length
buffer_timeline=POLYLINE([(buffer_location),(buffer_location - 0.0000000001)],location)
six_buffer_time = STRTRIM(STRING(buffer_time),2)
six_buffer_time = '000000' + six_buffer_time
six_buffer_time = six_buffer_time.substring(-6)
buffer_timestamp= TEXT(buffer_location,yloc, FONT_SIZE=10.5 , six_buffer_time)
buffer_time=hhmmss2sec(buffer_time)
buffer_time = buffer_time + buffer_spacing
buffer_time=sec2hhmmss(buffer_time)
ENDIF
ENDELSE

ENDFOR

ENDFOR
ENDIF
 
;  IF (color_selection) THEN BEGIN     ;habit colors are turned on
;    color_key_widg= WIDGET_INFO(color_key_widg,find_by_uname='color_key_button')
;    Widget_control, color_key_widg, sensitive=1
;  ENDIF
 
END
