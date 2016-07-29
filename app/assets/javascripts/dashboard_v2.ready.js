$(document).ready(function() {

  $.material.init();

  $(".select").dropdown({ "autoinit" : ".select" });

  $(".multiple-select").select2();

  $('.datepicker').datetimepicker({
    format: 'd/m/Y',
    timepicker: false
  });
});
