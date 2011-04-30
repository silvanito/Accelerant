function unselectRadio(category_id) {
  Form.getInputs('edit_category_'+category_id, 'radio').each(function(box){box.checked =false});
}
function hideDiscussions(){
 $('discussions').hide();
}
