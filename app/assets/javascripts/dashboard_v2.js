//= require jquery
//= require jquery_ujs
//= require jquery.datetimepicker
//= require turbolinks
//= require bootstrap-material-design/dist/js/material.min.js
//= require bootstrap-material-design/dist/js/ripples.min.js
//= require froala_editor.min.js
//= require plugins/colors.min.js
//= require plugins/draggable.min.js
//= require plugins/file.min.js
//= require plugins/font_family.min.js
//= require plugins/font_size.min.js
//= require plugins/image.min.js
//= require plugins/image_manager.min.js
//= require plugins/inline_style.min.js
//= require plugins/link.min.js
//= require plugins/lists.min.js
//= require plugins/paragraph_format.min.js
//= require plugins/paragraph_style.min.js
//= require plugins/inline_style.min.js
//= require plugins/quick_insert.min.js
//= require jquery.dropdown.js
//= require jquery.shorten.min.js
//= require printThis.js
//= require message_template.ready
//= require jquery.steps/build/jquery.steps.min.js
//= require dashboard_v2/illnesses.js

!function($) {
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
}(jQuery);
