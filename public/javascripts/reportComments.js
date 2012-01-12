document.observe('dom:loaded', pageInit);
function pageInit()
{
    // This code runs as soon as possible once the DOM is available
  parent.document.getElementById('notice').style.display='none';
  parent.document.getElementById('container').style.opacity='1';
}


