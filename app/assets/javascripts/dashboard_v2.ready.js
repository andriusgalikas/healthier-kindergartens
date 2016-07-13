$(document).ready(function() {

  $.material.init();

  $(".select").dropdown({ "autoinit" : ".select" });

  $('.truncate').shorten({
    showChars: 500
  });

  $('#message_template_content').froalaEditor({
    heightMin: 200
  });

});
