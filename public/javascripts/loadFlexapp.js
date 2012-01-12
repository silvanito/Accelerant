document.observe("dom:loaded", function(){

  $('my_form').hide();

});
function thisMovie(movieName) {
  if (navigator.appName.indexOf("Microsoft") != -1) {
    return window[movieName];
  } else {
    return document[movieName];
   }
}

function onSubmit(){ 
  var result = false;
  movie = thisMovie("HeatMap");
  if (movie != undefined || movie != null){
    var status = movie.onSubmit();
  }
  return result;
  }

function hasData(data){
  heatmapData = data;
  if(heatmapData == true){
    $('my_form').show();
    $('share_comment').disabled = false;

  }else{
    $('share_comment').disabled = true;
    $('container').hide();
    alert("please, could you answer the heatmap");
    new Effect.ScrollTo($('HeatMap'));

  }
}
function enableSubmit() {
  $('my_form').show();
  $('share_comment').disabled = false;
}

