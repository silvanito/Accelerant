function show_labels(){
  if ($('labels_wrapper').hasClassName('hide_labels')){
    $('edit_labels').innerHTML = "Would you like hide labels";
    $('labels_wrapper').removeClassName('hide_labels');
    
   }else{
    $('edit_labels').innerHTML = "Would you like to edit the labels";
    $('labels_wrapper').addClassName('hide_labels');

  }
}
