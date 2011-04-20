// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function delay(){
  new Effect.Opacity('container', { from: 1.0, to: 0.4, duration: 0.4  });
  $('notice').show();
}

