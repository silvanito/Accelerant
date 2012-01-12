document.observe("dom:loaded", function(){
  $('my_form').hide();
  $('new_module_response').show();
});
function enableSubmit() {
  $('my_form').show();
  $('module_response_submit').disabled = false;
}

