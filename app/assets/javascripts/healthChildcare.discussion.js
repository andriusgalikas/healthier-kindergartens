healthChildcare.discussion = {

  newCommentSubmit: function() {
    $('form.new_discussion').on('ajax:success', function(e, data, status, xhr) {
      $('.discussions').append(data);
      $('.discussions').animate({scrollTop: $('.discussions').prop("scrollHeight")}, 500);

      $(this).find('textarea').val('');
    });
  }
}
