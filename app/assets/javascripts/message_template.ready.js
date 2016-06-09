ready = function() {
  $.material.init();
  $(".select").dropdown({ "autoinit" : ".select" });


  healthChildcare.messageTemplate.wysiwygEditor();
  healthChildcare.messageTemplate.editMessageTemplates();

};

$(document).ready(ready);
