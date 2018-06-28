PRO OAPdisplay_save_image,ev

common block1

filters = ['*.jpg;*.jpeg;*.tif;*.tiff;*.png']
output_file = Dialog_Pickfile(FILTER = filters, PATH=display_info.output_path, GET_PATH=tmp, $
  TITLE='Choose directory and enter image name and type (ex. ".png")', /WRITE, /OVERWRITE_PROMPT)
display_info.output_path = tmp

    i.save, output_file
    MSG1 = 'Image Saved'
    res = DIALOG_MESSAGE(MSG1, /INFORMATION, /CENTER, DIALOG_PARENT=plot_widg_id)

END
