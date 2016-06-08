healthChildcare.admin =
{
    multiSelect: function()
    {
        $('select.chosen').chosen();
    },

  multiStepForm: function () {
    var current_fs, next_fs, previous_fs; //fieldsets
    var left, opacity, scale; //fieldset properties which we will animate
    var animating; //flag to prevent quick multi-click glitches

    $('.new_subject_btn').click(function() {
      $('.choose_subject').toggle();
      $('.create_subject').toggle();
    }),

    $('select#parent_subject_id').change(function() {
      var selectedParentId = $(this).val();
      $('select#message_template_sub_subject_id').find('option').hide();
      $('select#message_template_sub_subject_id').find("[data-parent_id='" + selectedParentId + "']").toggle();
    }),

    $('.new_sub_subject_btn').click(function() {
      $('.choose_sub_subject').toggle();
      $('.create_sub_subject').toggle();
    }),

    $(".next").click(function(){
	    if(animating) return false;
	    animating = true;
      console.log(animating);
	    current_fs = $(this).parent();
	    next_fs = $(this).parent().next();

	    //activate next step on progressbar using the index of next_fs
	    $("#progressbar li").eq($("fieldset").index(next_fs)).addClass("active");

	    //show the next fieldset
	    next_fs.show();

	    //hide the current fieldset with style
	    current_fs.animate({opacity: 0}, {
		    step: function(now, mx) {
			    //as the opacity of current_fs reduces to 0 - stored in "now"
			    //1. scale current_fs down to 80%
			    scale = 1 - (1 - now) * 0.2;

          //2. bring next_fs from the right(50%)
			    left = (now * 50)+"%";

			    //3. increase opacity of next_fs to 1 as it moves in
			    opacity = 1 - now;
			    current_fs.css({'transform': 'scale('+scale+')'});
			    next_fs.css({'left': left, 'opacity': opacity});
		    },
		    duration: 400,
		    complete: function(){
			    current_fs.hide();
			    animating = false;
		    },
	    });
    });

    $(".previous").click(function(){
	    if(animating) return false;
	    animating = true;

	    current_fs = $(this).parent();
	    previous_fs = $(this).parent().prev();

	    //de-activate current step on progressbar
	    $("#progressbar li").eq($("fieldset").index(current_fs)).removeClass("active");

	    //show the previous fieldset
	    previous_fs.show();
	    //hide the current fieldset with style
	    current_fs.animate({opacity: 0}, {
		    step: function(now, mx) {
			    //as the opacity of current_fs reduces to 0 - stored in "now"
			    //1. scale previous_fs from 80% to 100%
			    scale = 0.8 + (1 - now) * 0.2;

			    //2. take current_fs to the right(50%) - from 0%
			    left = ((1-now) * 50)+"%";
			    //3. increase opacity of previous_fs to 1 as it moves in

			    opacity = 1 - now;
			    current_fs.css({'left': left});
			    previous_fs.css({'transform': 'scale('+scale+')', 'opacity': opacity});
		    },
		    duration: 400,
		    complete: function(){
			    current_fs.hide();
			    animating = false;
		    },
	    });
    });

  },

  wysiwygEditor: function() {
    $('#message_template_content').froalaEditor();
  },

  editMessageTemplates: function() {
    var showStage = $('.show-stage');
    var editStage = $('.edit-stage');

    var showMessageHtmlTemplate = $('#show-message-content-template').html();
    var editMessageHtmlTemplate = $('#edit-message-content-template').html();

    var showTemplate = Handlebars.compile(showMessageHtmlTemplate);
    var editTemplate = Handlebars.compile(editMessageHtmlTemplate);

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

    $('.subject-filter')[0].click();

  }

}
