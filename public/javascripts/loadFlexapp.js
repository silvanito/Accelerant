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
  movie = thisMovie("HeatMap");
  if (movie != undefined || movie != null){
    thisMovie("HeatMap").onSubmit();
  }
}


function hasData(data){
  heatmapData = data;
  if(heatmapData == true){
    $('share').disabled = false;
  }else{
    $('share').disabled = true;
    alert("please, could you answer the heatmap");
    new Effect.ScrollTo($('HeatMap'));

  }
}

