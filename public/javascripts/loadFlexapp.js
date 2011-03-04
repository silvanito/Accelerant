Event.observe(window, 'load', function() {
  Event.observe('share', 'click', onSubmit);
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

fucntion formSumbmit()
{
  $("my_form").onSubmit();
}
