healthChildcare.messageTemplate = {

  wysiwygEditor: function() {
    $('#message_template_content').froalaEditor();
  },

  editMessageTemplates: function() {
    var showStage = $('.show-stage');
    var editStage = $('.edit-stage');

    var showMessageHtmlTemplate = $('#show-message-content-template').html();
    var editMessageHtmlTemplate = $('#edit-message-content-template').html();

    $('select#subject_id').on('change', function() {
      var subjectId = $(this).val();
      var subSubjects = $('#sub-subject-filter').find('select option[data-parent_id="' + subjectId + '"]');
      var subSubjectsValue = $.map(subSubjects, function(a) {return parseInt($(a).val())});

      var dropdownjsList = $('#sub-subject-filter').find('.dropdownjs ul li');

      $.each(dropdownjsList, function(idx, subSubjectLi) {
        li = $(subSubjectLi);

        if ($.inArray(li.val(), subSubjectsValue) > -1) {
          li.show();
        }
        else {
          li.hide();
        }

      });

    });

/*
    $('.subject-filter').click(function() {
      var parentSubjectId = $(this).data('subject_id');
      $('.subject-filter').removeClass('active');
      $(this).addClass('active');

      $('.sub-subject-filter').removeClass('active').hide();
      $(".sub-subject-filter[data-parent_subject_id='" + parentSubjectId + "']").show();

      $('.target-role-filter').removeClass('active');
    });

    $('.sub-subject-filter').click(function() {
      $('.sub-subject-filter').removeClass('active');
      $(this).addClass('active');

      $('.target-role-filter').removeClass('active');
    });

    $('.target-role-filter').click(function() {
      $('.target-role-filter').removeClass('active');
      $(this).addClass('active');
    });

    $('#apply-filter-btn').click(function() {
      var subjectId = $('.subject-filter.active').data('subject_id');
      var subSubjectId = $('.sub-subject-filter.active').data('sub_subject_id');
      var targetRole = $('.target-role-filter.active').data('target_role');
      var loader = $('.loader');

      loader.show();
      showStage.show();
      editStage.hide();

      $.ajax(
        {
          url: '/api/message_templates/filter_by',
          data: {subject_id: subjectId, sub_subject_id: subSubjectId, target_role: targetRole},
          type: 'GET',
          dataType: 'json',
          success: function (data)
          {
            showStage.html('');
            if (data.message_template_content) {
              var showTemplate = Handlebars.compile(showMessageHtmlTemplate);
              var html = showTemplate(data);
              showStage.html(html);
            }
            else {
              showStage.html('<h4>' + window.__trans['no_template_for_role'] + '</h4>');
            }
            loader.hide();
          }
        });
    }),

    $('.show-stage, #edit-message-template-btn').on('click', function() {
      var templateId = $(this).data('template_id');
      var loader = $('.loader');

      var templateContent = $('.fr-view').html();
      var editTemplate = Handlebars.compile(editMessageHtmlTemplate);
      var html = editTemplate({message_template_content: templateContent, message_template_id: templateId});

      editStage.html(html);
      $('#message_template_content').froalaEditor();

      showStage.hide();
      editStage.show();
    }),

    $('.edit-stage, input.cancel ').on('click', function() {
      showStage.show();
      editStage.hide();
    }),

    $('.edit-stage, input.submit').on('click', function() {
      $('#apply-filter-btn').click();
    });

//    $('.subject-filter')[0].click();
*/
  }
}
