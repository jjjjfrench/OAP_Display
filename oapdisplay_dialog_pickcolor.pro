PRO OAPdisplay_dialog_pickcolor, value

common block1

; Assigns the user-selected color to the appropriate habit and changes the order of the 
; droplist values so that the user-selected color is now the first option of the droplist.

droplist_id0 = WIDGET_INFO(droplist[0], /Droplist_Select)
WIDGET_CONTROL, droplist[0], get_uvalue=droplist_values0
droplist_id1 = WIDGET_INFO(droplist[1], /Droplist_Select)
WIDGET_CONTROL, droplist[1], get_uvalue=droplist_values1
droplist_id2 = WIDGET_INFO(droplist[2], /Droplist_Select)
WIDGET_CONTROL, droplist[2], get_uvalue=droplist_values2
droplist_id3 = WIDGET_INFO(droplist[3], /Droplist_Select)
WIDGET_CONTROL, droplist[3], get_uvalue=droplist_values3
droplist_id4 = WIDGET_INFO(droplist[4], /Droplist_Select)
WIDGET_CONTROL, droplist[4], get_uvalue=droplist_values4
droplist_id5 = WIDGET_INFO(droplist[5], /Droplist_Select)
WIDGET_CONTROL, droplist[5], get_uvalue=droplist_values5
droplist_id6 = WIDGET_INFO(droplist[6], /Droplist_Select)
WIDGET_CONTROL, droplist[6], get_uvalue=droplist_values6
droplist_id7 = WIDGET_INFO(droplist[7], /Droplist_Select)
WIDGET_CONTROL, droplist[7], get_uvalue=droplist_values7
droplist_id8 = WIDGET_INFO(droplist[8], /Droplist_Select)
WIDGET_CONTROL, droplist[8], get_uvalue=droplist_values8
droplist_id9 = WIDGET_INFO(droplist[9], /Droplist_Select)
WIDGET_CONTROL, droplist[9], get_uvalue=droplist_values9
droplist_id10 = WIDGET_INFO(droplist[10], /Droplist_Select)
WIDGET_CONTROL, droplist[10], get_uvalue=droplist_values10

case droplist_values0[[droplist_id0]] OF
  'red': color[0]=254
  'burnt orange': color[0]=215
  'light green': color[0]=175
  'blue': color[0]=75
  'cyan': color[0]=100
  'dark blue': color[0]=50
  'green': color[0]=150
  'purple': color[0]=27
  'mustard': color[0]=200
  'black': color[0]=0
  'white': color[0]=255
endcase
case droplist_values0[[droplist_id0]] OF
  'red': dendrite_values=['red','burnt orange','light green','blue','cyan','dark blue','green','purple','mustard','black','white']
  'burnt orange': dendrite_values=['burnt orange','red','light green','blue','cyan','dark blue','green','purple','mustard','black','white']
  'light green': dendrite_values=['light green','red','burnt orange','blue','cyan','dark blue','green','purple','mustard','black','white']
  'blue': dendrite_values=['blue','red','burnt orange','light green','cyan','dark blue','green','purple','mustard','black','white']
  'cyan': dendrite_values=['cyan','red','burnt orange','light green','blue','dark blue','green','purple','mustard','black','white']
  'dark blue': dendrite_values=['dark blue','red','burnt orange','light green','blue','cyan','green','purple','mustard','black','white']
  'green': dendrite_values=['green','red','burnt orange','light green','blue','cyan','dark blue','purple','mustard','black','white']
  'purple': dendrite_values=['purple','red','burnt orange','light green','blue','cyan','dark blue','green','mustard','black','white']
  'mustard': dendrite_values=['mustard','red','burnt orange','light green','blue','cyan','dark blue','green','purple','black','white']
  'black': dendrite_values=['black','red','burnt orange','light green','blue','cyan','dark blue','green','purple','mustard','white']
  'white': dendrite_values=['white','red','burnt orange','light green','blue','cyan','dark blue','green','purple','mustard','black']
endcase

case droplist_values1[[droplist_id1]] OF
  'red': color[1]=254
  'burnt orange': color[1]=215
  'light green': color[1]=175
  'blue': color[1]=75
  'cyan': color[1]=100
  'dark blue': color[1]=50
  'green': color[1]=150
  'purple': color[1]=27
  'mustard': color[1]=200
  'black': color[1]=0
  'white': color[1]=255
endcase
case droplist_values1[[droplist_id1]] OF
  'red': irregular_values=['red','burnt orange','light green','blue','cyan','dark blue','green','purple','mustard','black','white']
  'burnt orange': irregular_values=['burnt orange','red','light green','blue','cyan','dark blue','green','purple','mustard','black','white']
  'light green': irregular_values=['light green','red','burnt orange','blue','cyan','dark blue','green','purple','mustard','black','white']
  'blue': irregular_values=['blue','red','burnt orange','light green','cyan','dark blue','green','purple','mustard','black','white']
  'cyan': irregular_values=['cyan','red','burnt orange','light green','blue','dark blue','green','purple','mustard','black','white']
  'dark blue': irregular_values=['dark blue','red','burnt orange','light green','blue','cyan','green','purple','mustard','black','white']
  'green': irregular_values=['green','red','burnt orange','light green','blue','cyan','dark blue','purple','mustard','black','white']
  'purple': irregular_values=['purple','red','burnt orange','light green','blue','cyan','dark blue','green','mustard','black','white']
  'mustard': irregular_values=['mustard','red','burnt orange','light green','blue','cyan','dark blue','green','purple','black','white']
  'black': irregular_values=['black','red','burnt orange','light green','blue','cyan','dark blue','green','purple','mustard','white']
  'white': irregular_values=['white','red','burnt orange','light green','blue','cyan','dark blue','green','purple','mustard','black']
endcase

case droplist_values2[[droplist_id2]] OF
  'red': color[2]=254
  'burnt orange': color[2]=215
  'light green': color[2]=175
  'blue': color[2]=75
  'cyan': color[2]=100
  'dark blue': color[2]=50
  'green': color[2]=150
  'purple': color[2]=27
  'mustard': color[2]=200
  'black': color[2]=0
  'white': color[2]=255
endcase
case droplist_values2[[droplist_id2]] OF
  'red': hexagonal_values=['red','burnt orange','light green','blue','cyan','dark blue','green','purple','mustard','black','white']
  'burnt orange': hexagonal_values=['burnt orange','red','light green','blue','cyan','dark blue','green','purple','mustard','black','white']
  'light green': hexagonal_values=['light green','red','burnt orange','blue','cyan','dark blue','green','purple','mustard','black','white']
  'blue': hexagonal_values=['blue','red','burnt orange','light green','cyan','dark blue','green','purple','mustard','black','white']
  'cyan': hexagonal_values=['cyan','red','burnt orange','light green','blue','dark blue','green','purple','mustard','black','white']
  'dark blue': hexagonal_values=['dark blue','red','burnt orange','light green','blue','cyan','green','purple','mustard','black','white']
  'green': hexagonal_values=['green','red','burnt orange','light green','blue','cyan','dark blue','purple','mustard','black','white']
  'purple': hexagonal_values=['purple','red','burnt orange','light green','blue','cyan','dark blue','green','mustard','black','white']
  'mustard': hexagonal_values=['mustard','red','burnt orange','light green','blue','cyan','dark blue','green','purple','black','white']
  'black': hexagonal_values=['black','red','burnt orange','light green','blue','cyan','dark blue','green','purple','mustard','white']
  'white': hexagonal_values=['white','red','burnt orange','light green','blue','cyan','dark blue','green','purple','mustard','black']
endcase

case droplist_values3[[droplist_id3]] OF
  'red': color[3]=254
  'burnt orange': color[3]=215
  'light green': color[3]=175
  'blue': color[3]=75
  'cyan': color[3]=100
  'dark blue': color[3]=50
  'green': color[3]=150
  'purple': color[3]=27
  'mustard': color[3]=200
  'black': color[3]=0
  'white': color[3]=255
endcase
case droplist_values3[[droplist_id3]] OF
  'red': spherical_values=['red','burnt orange','light green','blue','cyan','dark blue','green','purple','mustard','black','white']
  'burnt orange': spherical_values=['burnt orange','red','light green','blue','cyan','dark blue','green','purple','mustard','black','white']
  'light green': spherical_values=['light green','red','burnt orange','blue','cyan','dark blue','green','purple','mustard','black','white']
  'blue': spherical_values=['blue','red','burnt orange','light green','cyan','dark blue','green','purple','mustard','black','white']
  'cyan': spherical_values=['cyan','red','burnt orange','light green','blue','dark blue','green','purple','mustard','black','white']
  'dark blue': spherical_values=['dark blue','red','burnt orange','light green','blue','cyan','green','purple','mustard','black','white']
  'green': spherical_values=['green','red','burnt orange','light green','blue','cyan','dark blue','purple','mustard','black','white']
  'purple': spherical_values=['purple','red','burnt orange','light green','blue','cyan','dark blue','green','mustard','black','white']
  'mustard': spherical_values=['mustard','red','burnt orange','light green','blue','cyan','dark blue','green','purple','black','white']
  'black': spherical_values=['black','red','burnt orange','light green','blue','cyan','dark blue','green','purple','mustard','white']
  'white': spherical_values=['white','red','burnt orange','light green','blue','cyan','dark blue','green','purple','mustard','black']
endcase

case droplist_values4[[droplist_id4]] OF
  'red': color[4]=254
  'burnt orange': color[4]=215
  'light green': color[4]=175
  'blue': color[4]=75
  'cyan': color[4]=100
  'dark blue': color[4]=50
  'green': color[4]=150
  'purple': color[4]=27
  'mustard': color[4]=200
  'black': color[4]=0
  'white': color[4]=255
endcase
case droplist_values4[[droplist_id4]] OF
  'red': graupel_values=['red','burnt orange','light green','blue','cyan','dark blue','green','purple','mustard','black','white']
  'burnt orange': graupel_values=['burnt orange','red','light green','blue','cyan','dark blue','green','purple','mustard','black','white']
  'light green': graupel_values=['light green','red','burnt orange','blue','cyan','dark blue','green','purple','mustard','black','white']
  'blue': graupel_values=['blue','red','burnt orange','light green','cyan','dark blue','green','purple','mustard','black','white']
  'cyan': graupel_values=['cyan','red','burnt orange','light green','blue','dark blue','green','purple','mustard','black','white']
  'dark blue': graupel_values=['dark blue','red','burnt orange','light green','blue','cyan','green','purple','mustard','black','white']
  'green': graupel_values=['green','red','burnt orange','light green','blue','cyan','dark blue','purple','mustard','black','white']
  'purple': graupel_values=['purple','red','burnt orange','light green','blue','cyan','dark blue','green','mustard','black','white']
  'mustard': graupel_values=['mustard','red','burnt orange','light green','blue','cyan','dark blue','green','purple','black','white']
  'black': graupel_values=['black','red','burnt orange','light green','blue','cyan','dark blue','green','purple','mustard','white']
  'white': graupel_values=['white','red','burnt orange','light green','blue','cyan','dark blue','green','purple','mustard','black']
endcase

case droplist_values5[[droplist_id5]] OF
  'red': color[5]=254
  'burnt orange': color[5]=215
  'light green': color[5]=175
  'blue': color[5]=75
  'cyan': color[5]=100
  'dark blue': color[5]=50
  'green': color[5]=150
  'purple': color[5]=27
  'mustard': color[5]=200
  'black': color[5]=0
  'white': color[5]=255
endcase
case droplist_values5[[droplist_id5]] OF
  'red': aggregate_values=['red','burnt orange','light green','blue','cyan','dark blue','green','purple','mustard','black','white']
  'burnt orange': aggregate_values=['burnt orange','red','light green','blue','cyan','dark blue','green','purple','mustard','black','white']
  'light green': aggregate_values=['light green','red','burnt orange','blue','cyan','dark blue','green','purple','mustard','black','white']
  'blue': aggregate_values=['blue','red','burnt orange','light green','cyan','dark blue','green','purple','mustard','black','white']
  'cyan': aggregate_values=['cyan','red','burnt orange','light green','blue','dark blue','green','purple','mustard','black','white']
  'dark blue': aggregate_values=['dark blue','red','burnt orange','light green','blue','cyan','green','purple','mustard','black','white']
  'green': aggregate_values=['green','red','burnt orange','light green','blue','cyan','dark blue','purple','mustard','black','white']
  'purple': aggregate_values=['purple','red','burnt orange','light green','blue','cyan','dark blue','green','mustard','black','white']
  'mustard': aggregate_values=['mustard','red','burnt orange','light green','blue','cyan','dark blue','green','purple','black','white']
  'black': aggregate_values=['black','red','burnt orange','light green','blue','cyan','dark blue','green','purple','mustard','white']
  'white': aggregate_values=['white','red','burnt orange','light green','blue','cyan','dark blue','green','purple','mustard','black']
endcase

case droplist_values6[[droplist_id6]] OF
  'red': color[6]=254
  'burnt orange': color[6]=215
  'light green': color[6]=175
  'blue': color[6]=75
  'cyan': color[6]=100
  'dark blue': color[6]=50
  'green': color[6]=150
  'purple': color[6]=27
  'mustard': color[6]=200
  'black': color[6]=0
  'white': color[6]=255
endcase
case droplist_values6[[droplist_id6]] OF
  'red': oriented_values=['red','burnt orange','light green','blue','cyan','dark blue','green','purple','mustard','black','white']
  'burnt orange': oriented_values=['burnt orange','red','light green','blue','cyan','dark blue','green','purple','mustard','black','white']
  'light green': oriented_values=['light green','red','burnt orange','blue','cyan','dark blue','green','purple','mustard','black','white']
  'blue': oriented_values=['blue','red','burnt orange','light green','cyan','dark blue','green','purple','mustard','black','white']
  'cyan': oriented_values=['cyan','red','burnt orange','light green','blue','dark blue','green','purple','mustard','black','white']
  'dark blue': oriented_values=['dark blue','red','burnt orange','light green','blue','cyan','green','purple','mustard','black','white']
  'green': oriented_values=['green','red','burnt orange','light green','blue','cyan','dark blue','purple','mustard','black','white']
  'purple': oriented_values=['purple','red','burnt orange','light green','blue','cyan','dark blue','green','mustard','black','white']
  'mustard': oriented_values=['mustard','red','burnt orange','light green','blue','cyan','dark blue','green','purple','black','white']
  'black': oriented_values=['black','red','burnt orange','light green','blue','cyan','dark blue','green','purple','mustard','white']
  'white': oriented_values=['white','red','burnt orange','light green','blue','cyan','dark blue','green','purple','mustard','black']
endcase

case droplist_values7[[droplist_id7]] OF
  'red': color[7]=254
  'burnt orange': color[7]=215
  'light green': color[7]=175
  'blue': color[7]=75
  'cyan': color[7]=100
  'dark blue': color[7]=50
  'green': color[7]=150
  'purple': color[7]=27
  'mustard': color[7]=200
  'black': color[7]=0
  'white': color[7]=255
endcase
case droplist_values7[[droplist_id7]] OF
  'red': centerout_values=['red','burnt orange','light green','blue','cyan','dark blue','green','purple','mustard','black','white']
  'burnt orange': centerout_values=['burnt orange','red','light green','blue','cyan','dark blue','green','purple','mustard','black','white']
  'light green': centerout_values=['light green','red','burnt orange','blue','cyan','dark blue','green','purple','mustard','black','white']
  'blue': centerout_values=['blue','red','burnt orange','light green','cyan','dark blue','green','purple','mustard','black','white']
  'cyan': centerout_values=['cyan','red','burnt orange','light green','blue','dark blue','green','purple','mustard','black','white']
  'dark blue': centerout_values=['dark blue','red','burnt orange','light green','blue','cyan','green','purple','mustard','black','white']
  'green': centerout_values=['green','red','burnt orange','light green','blue','cyan','dark blue','purple','mustard','black','white']
  'purple': centerout_values=['purple','red','burnt orange','light green','blue','cyan','dark blue','green','mustard','black','white']
  'mustard': centerout_values=['mustard','red','burnt orange','light green','blue','cyan','dark blue','green','purple','black','white']
  'black': centerout_values=['black','red','burnt orange','light green','blue','cyan','dark blue','green','purple','mustard','white']
  'white': centerout_values=['white','red','burnt orange','light green','blue','cyan','dark blue','green','purple','mustard','black']
endcase

case droplist_values8[[droplist_id8]] OF
  'red': color[8]=254
  'burnt orange': color[8]=215
  'light green': color[8]=175
  'blue': color[8]=75
  'cyan': color[8]=100
  'dark blue': color[8]=50
  'green': color[8]=150
  'purple': color[8]=27
  'mustard': color[8]=200
  'black': color[8]=0
  'white': color[8]=255
endcase
case droplist_values8[[droplist_id8]] OF
  'red': linear_values=['red','burnt orange','light green','blue','cyan','dark blue','green','purple','mustard','black','white']
  'burnt orange': linear_values=['burnt orange','red','light green','blue','cyan','dark blue','green','purple','mustard','black','white']
  'light green': linear_values=['light green','red','burnt orange','blue','cyan','dark blue','green','purple','mustard','black','white']
  'blue': linear_values=['blue','red','burnt orange','light green','cyan','dark blue','green','purple','mustard','black','white']
  'cyan': linear_values=['cyan','red','burnt orange','light green','blue','dark blue','green','purple','mustard','black','white']
  'dark blue': linear_values=['dark blue','red','burnt orange','light green','blue','cyan','green','purple','mustard','black','white']
  'green': linear_values=['green','red','burnt orange','light green','blue','cyan','dark blue','purple','mustard','black','white']
  'purple': linear_values=['purple','red','burnt orange','light green','blue','cyan','dark blue','green','mustard','black','white']
  'mustard': linear_values=['mustard','red','burnt orange','light green','blue','cyan','dark blue','green','purple','black','white']
  'black': linear_values=['black','red','burnt orange','light green','blue','cyan','dark blue','green','purple','mustard','white']
  'white': linear_values=['white','red','burnt orange','light green','blue','cyan','dark blue','green','purple','mustard','black']
endcase

case droplist_values9[[droplist_id9]] OF
  'red': color[9]=254
  'burnt orange': color[9]=215
  'light green': color[9]=175
  'blue': color[9]=75
  'cyan': color[9]=100
  'dark blue': color[9]=50
  'green': color[9]=150
  'purple': color[9]=27
  'mustard': color[9]=200
  'black': color[9]=0
  'white': color[9]=255
endcase
case droplist_values9[[droplist_id9]] OF
  'red': tiny_values=['red','burnt orange','light green','blue','cyan','dark blue','green','purple','mustard','black','white']
  'burnt orange': tiny_values=['burnt orange','red','light green','blue','cyan','dark blue','green','purple','mustard','black','white']
  'light green': tiny_values=['light green','red','burnt orange','blue','cyan','dark blue','green','purple','mustard','black','white']
  'blue': tiny_values=['blue','red','burnt orange','light green','cyan','dark blue','green','purple','mustard','black','white']
  'cyan': tiny_values=['cyan','red','burnt orange','light green','blue','dark blue','green','purple','mustard','black','white']
  'dark blue': tiny_values=['dark blue','red','burnt orange','light green','blue','cyan','green','purple','mustard','black','white']
  'green': tiny_values=['green','red','burnt orange','light green','blue','cyan','dark blue','purple','mustard','black','white']
  'purple': tiny_values=['purple','red','burnt orange','light green','blue','cyan','dark blue','green','mustard','black','white']
  'mustard': tiny_values=['mustard','red','burnt orange','light green','blue','cyan','dark blue','green','purple','black','white']
  'black': tiny_values=['black','red','burnt orange','light green','blue','cyan','dark blue','green','purple','mustard','white']
  'white': tiny_values=['white','red','burnt orange','light green','blue','cyan','dark blue','green','purple','mustard','black']
endcase

; There is no case statement for the zero habit because it should stay set as white, the default color.

 WIDGET_CONTROL,base_widg2,/destroy
 oapdisplay_color_key

END