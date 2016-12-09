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
  
  setPendingSurveyOptions: function() {
    $('.survey-option').on('click', function() {
      var option_id = $(this).val();
      var question_id = $(this).data("question");
      var survey_id = $(this).data("survey");
      var user_id = $(this).data("user");
      var subject_id = $(this).data("subject");

      pending_url = '/add_pending_option';
      $.ajax(
        {
          url: pending_url,
          type: 'POST',
          data: {
            survey_id: survey_id,
            question_id: question_id,
            option_id: option_id,
            user_id: user_id,
            subject_id: subject_id            
          },
          dataType: 'json',
          success: function (data)
          {            
          }
        });
    });
  },

  updateSurveyAttemptSubject: function() {
    $('.retake-radio').change(function() {
      var subjectId = $(this).val();
      $('#retake-form').attr('action', '/subjects/' + subjectId + '/attempts/new')
    });
  },

  switchSurveyAttemptSubject: function() {
    $('.retake-survey-radio').on('click', function() {
      var subjectId = $(this).val();
      if($('#current_subject').val() != subjectId){
        window.location.href = '/subjects/' + subjectId + '/attempts/new';
      }
    });
  },

  trySurveyAttepmtSubject: function() {
    $('.jcmc-buttons .btn-next').on('click', function() {
      $(this).html("Next <i class='fa fa-icon fa-spinner load-animate'></i>");
    });
  },

  showSurveySubjectResult: function() {
    $('input.retake-radio').on('click', function() {
      var subjectId = $(this).val();
      var progressDiv = $('#progress_charts_partial');
      var currentRole = $(this).data('current_role');
      var url = '/subjects/' + subjectId + '/result';

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
