function validateForm()
{
  var has_heatmap = document.forms["top_form"]["has_heatmap"].checked

  if (has_heatmap)
  {
    var file = document.forms["top_form"]["new_discussion_media"].value
    if (file.length == 0){
      alert("if you want a heatmap response, First select a file!");
      return false;
    }
  }
  var image = $('new_discussion_heatmap_type_id_1').checked;
  var text = $('new_discussion_heatmap_type_id_2').checked;
  if (image==false && text==false){
    alert("if you want a heatmap response, Please select a heatmap type!");
    return false;
  }

}

