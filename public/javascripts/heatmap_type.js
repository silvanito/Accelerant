Event.observe(window, 'load', function() {
  
  Event.observe('has_heatmap', 'click', heatmap_type);
});
function heatmap_type(){
   if ($('heatmap_type').hasClassName('display_none')){
     $('heatmap_type').removeClassName('display_none');
   }else{
    $('heatmap_type').addClassName('display_none');
   }
}
