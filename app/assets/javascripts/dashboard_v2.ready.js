$(document).ready(function() {

  $.material.init();

  $(".select").dropdown({ "autoinit" : ".select" });

  $('.truncate').shorten({
    showChars: 500
  });

  $('#message_template_content').froalaEditor({
    heightMin: 200
  });

  $(".multiple-select").select2();

  $('.datepicker').datetimepicker({
    format: 'd/m/Y',
    timepicker: false
  });
});
