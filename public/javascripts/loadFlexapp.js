Event.observe(window, 'load', function() {
  
 return Event.observe('my_form', 'submit', onSubmit);
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
  thisMovie("HeatMap").onSubmit();
}
