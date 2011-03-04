Event.observe(window, 'load', function() {
  
  Event.observe('my_form', 'submit', onSubmit);
});
function thisMovie(movieName) {
      if (navigator.appName.indexOf("Microsoft") != -1) {
          return window[movieName];

      } else {
          return document[movieName];
      }
}

function onSubmit()
{
 if( $("HeatMap") !=null)
  {
   thisMovie("HeatMap").onSubmit();
   return false
  }else{
    document.forms["my_form"].submit();
  }
}

function formSumbmit()
{
  document.my_form.submit();
}
