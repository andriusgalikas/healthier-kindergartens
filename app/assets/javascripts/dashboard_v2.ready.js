$(document).ready(function() {

  $.material.init();

  $(".multiple-select").select2();

  $('.datepicker').datetimepicker({
    format: 'd/m/Y',
    timepicker: false
  });

  healthChildcare.message.initTemplateParser();
  healthChildcare.message.initMessageTemplateEditor();
  healthChildcare.message.initMessageEditor();
  healthChildcare.message.initMessageListFilters();
  healthChildcare.message.setSubSubjectFilter();
  healthChildcare.message.setRoleFilter();
  healthChildcare.message.initMessagePrinter();
  healthChildcare.message.initTruncator();
});
