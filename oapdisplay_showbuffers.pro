PRO OAPdisplay_showbuffers, tmp, prbtype

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

  i=image(transpose(LONG(data_record[0,*,*])), /current, POSITION=[0,0.75,1,1])
  i=image(transpose(LONG(data_record[1,*,*])), /current, POSITION=[0,0.5,1,0.75])
  i=image(transpose(LONG(data_record[2,*,*])), /current, POSITION=[0,0.25,1,0.5])
  i=image(transpose(LONG(data_record[3,*,*])), /current, POSITION=[0,0.0,1,0.25])



END
