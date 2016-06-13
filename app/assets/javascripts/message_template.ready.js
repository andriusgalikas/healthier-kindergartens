ready = function() {
  healthChildcare.messageTemplate.wysiwygEditor();
  healthChildcare.messageTemplate.editMessageTemplates();
  healthChildcare.messageTemplate.datepickers();

  $.material.init();
  $(".select").dropdown({ "autoinit" : ".select" });
};

$(document).ready(ready);
