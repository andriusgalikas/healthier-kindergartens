healthChildcare.discussion = {

  newCommentSubmit: function() {
    $('form.new_discussion').on('ajax:success', function(e, data, status, xhr) {
      $('.discussions').append(data);
      $('.discussions').animate({scrollTop: $('.discussions').prop("scrollHeight")}, 500);

      $(this).find('textarea').val('');
    });
  },

  inviteCollaborator: function() {
    $('#submit-invite-form').on('click', function() {
      $('#new_collaboration_invite').trigger('submit');
    });

    $('#invite-collaborator-modal').modal('hide');
  },

  newCollaborationInviteSubmit: function() {
    $('form.new_collaboration_invite').on('ajax:success', function(e, data, status, xhr) {
      $('li.collaborator').after(data);
      $('#invite-collaborator-modal').modal('hide');

      $('form.new_collaboration_invite')[0].reset();
    });
  }

}
