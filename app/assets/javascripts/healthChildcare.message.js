healthChildcare.message = {

  applyFilters: function() {

    $('#apply-message-filters').on('click', function() {
      var startDate = $('#start_date').val();
      var endDate = $('#end_date').val();
      var targetRole = $('#target_role').val();

      $.ajax({
        url: '/admin/messages/sent_messages',
        type: 'GET',
        data: {start_date: startDate, end_date: endDate, target_role: targetRole},
        success: function(data) {
          $('.message-list').html(data);
        }
      });
    });
  },

  minimizeMessages: function() {
    $('.message-content-stage').shorten({
      showChars: 500
    });
  }
}
