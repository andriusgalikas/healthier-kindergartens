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
  },

  toggleSearchChildInvitation: function() {
    $('.toggle-child-invitation-link').on('click', function() {
      $('.find-child-invitation-option').toggle();
      $('.find-child-invitation-link').toggle();
    });
  },

  searchChildInvitation: function() {
    var dataDOM = $('#search-child-invitation');
    var dataSrc = dataDOM.data('child_names');
    var _this = this;
    $(dataDOM).data('child_names', null);

    $(document).find('#invitee_child').typeahead(
      {
        highlight: true,
        minLength: 1
      },
      {
        limit: 0,
        source: _this.substringMatcher(dataSrc)
      }
    );
  },

  substringMatcher: function(strs) {
    return function findMatches(q, cb) {
      var matches, substringRegex;

      // an array that will be populated with substring matches
      matches = [];

      // regex used to determine if a string contains the substring `q`
      substrRegex = new RegExp(q, 'i');

      // iterate through the pool of strings and for any string that
      // contains the substring `q`, add it to the `matches` array
      $.each(strs, function(i, str) {
        if (substrRegex.test(str)) {
          matches.push(str);
        }
      });

      cb(matches);
    }
  }

}
