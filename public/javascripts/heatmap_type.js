Event.observe(window, 'load', function() {
  
  Event.observe('has_heatmap', 'click', heatmap_type);
  Event.observe('more_modules', 'click', module_type);
});
function heatmap_type(){
   if ($('heatmap_type').hasClassName('display_none')){
     $('heatmap_type').removeClassName('display_none');
     $('more_modules').hide();
   }else{
    $('heatmap_type').addClassName('display_none');
    $('more_modules').show();
   }
}
function module_type(){
   if ($('module_types').hasClassName('display_none')){
     $('module_types').removeClassName('display_none');
     $('has_heatmap').hide();
   }else{
    $('module_types').addClassName('display_none');
    $('has_heatmap').show();
   }
}

