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
//= require slick-carousel/slick/slick.min.js

!function($) {
  $(document).ready(function() {

    $.material.init();
    $(".select").dropdown({ "autoinit" : ".select" });
    $('#message_template_content').froalaEditor({
      heightMin: 200
    });

    $('.slick-carousel').slick({
      infinite: true,
      slidesToShow: 5,
      slidesToScroll: 1,
      autoplay: true,
      autoplaySpeed: 2000
    });

    $('.truncate').shorten({
      showChars: 500
    });

  });
}(jQuery);
