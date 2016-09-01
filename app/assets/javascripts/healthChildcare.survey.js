healthChildcare.survey = {
  submitSurveyModule: function()
  {
    $("body").on("submit", '.submit-attempt', function() {
      var tabId = $(this).attr('data-tab');

      $.ajax(
        {
          url: $(this).attr('action'),
          type: 'POST',
          data: $(this).serialize(),
          dataType: 'json',
          success: function (data)
          {
            click_tab(tabId);
          }
        });
      return false;
    });
  },

  updateSurveyAttemptSubject: function() {
    $('.retake-radio').change(function() {
      var subjectId = $(this).val();
      $('#retake-form').attr('action', '/subjects/' + subjectId + '/attempts/new')
    });
  },

  showSurveySubjectResult: function() {
    $('input.retake-radio').on('click', function() {
      var subjectId = $(this).val();
      var progressDiv = $('#progress_charts_partial');
      var currentRole = $(this).data('current_role');
      var url = '/subjects/' + subjectId + '/results';

      if (currentRole && currentRole.length > 0) {
        url = '/' + currentRole + url;
      }

      $.ajax({
        url: url,
        type: 'GET',
        success: function(resultHtml) {
          progressDiv.html(resultHtml);
        }
      });
    });
  },

  showSingleSurveyResult: function() {
    $('.get-single-user-result').on('click', function() {
      var userId = $(this).attr('data-id'),
          subjectId = $('input[name="subject_id"]:checked').val(),
          _this = this;

      $.ajax(
        {
          url: '/manager/subjects/' + subjectId + '/user_result?user_id=' + userId,
          type: 'GET',
          success: function (html)
          {
            $('#progress_charts_partial').html(html);
            $('.panel-body').find('a').removeClass('active');
            $(_this).addClass('active');
          }
        });
      return false;
    });
  },

  showGroupSurveyResult: function() {
    $('.get-group-result').on('click', function() {
      var subjectId = $('input[name="subject_id"]:checked').val(),
          subjectGroup = $(this).data('subject_group'),
          _this = this;

      $.ajax(
        {
          url: '/manager/subjects/' + subjectId + '/group_result?role=' + subjectGroup,
          type: 'GET',
          success: function (html)
          {
            $('#progress_charts_partial').html(html);
            $('.panel-body').find('a').removeClass('active');
            $(_this).addClass('active');
          }
        });
      return false;
    });
  },

  showGroupSurveyMembers: function() {
    $('.group-header').on('click', function() {
      $(this).siblings('.group-members').slideToggle();
    });
  }

}
