$(document).ready(function()
{
    healthChildcare.app.departmentSelector();
    healthChildcare.app.multiInput();
    healthChildcare.app.toggleMenu();
    healthChildcare.app.printTodo();
    healthChildcare.app.datepickers();
    healthChildcare.app.submitSurveyModule();
    healthChildcare.app.showRegisteredChildcaresNotification();
    healthChildcare.app.showUpgradedChildcaresNotification();

    $('.graph-bar').each(function() {
        var dataWidth = $(this).data('value');
        $(this).css("width", dataWidth + "%");
    });
    $('.retake-radio').change(function()
    {
        var subjectId = $(this).val();
        $('#retake-form').attr('action', '/subjects/' + subjectId + '/attempts/new')
    });
    $('.iteration-selector').change(function()
    {
        var value = $(this).val();
        if (value === 'single')
        {
            $('.frequency-fields').hide();
        }
        else
        {
            $('.frequency-fields').show();
        }

    });
    $('.get-single-user-result').on('click', function()
    {
        var userId = $(this).attr('data-id'),
            subjectId = $(this).attr('data-subject-id');

        $.ajax(
        {
            url: '/manager/subjects/' + subjectId + '/user_result?user_id=' + userId,
            type: 'GET',
            dataType: 'json',
            success: function (data)
            {
                $('#bar_graph_partial').html(data.partial);
            }
        });
        return false;
    });
    $('.group-logo').on('click', function()
    {
        var subjectId = $(this).attr('data-subject-id');

        $.ajax(
        {
            url: '/manager/subjects/' + subjectId + '/group_result',
            type: 'GET',
            dataType: 'json',
            success: function (data)
            {
                $('#bar_graph_partial').html(data.partial);
            }
        });
        return false;
    });
    $('#allocation-slider').on("input change", function()
    {
        var planAllocation = $(this).val();
        $.ajax(
        {
            url: '/api/plans/' + planAllocation,
            type: 'GET',
            dataType: 'json',
            success: function (data)
            {
                $('.wizard-form2').attr('action', '/plans/' + data.id + '/subscriptions/new');
                $('.plan-value').html(data.allocation);
                $('.plan-price').html('$' + data.price);
            }
        });
    });

  $.notifyDefaults({
    element: 'body',
    position: null,
    type: 'warning',
    icon_type: 'image',
    allow_dismiss: true,
    delay: 9000,
    newest_on_top: true,
    placement: {
      from: "top",
      align: "right"
    },
    animate: {
      enter: 'animated fadeInDown',
      exit: 'animated fadeOutDown'
    },
    template: '<div data-notify="container" class="col-xs-12 col-sm-4 alert alert-{0}" role="alert">' +
      '<button type="button" aria-hidden="true" class="close" data-notify="dismiss">×</button>' +
      '<img data-notify="icon" class="img-circle pull-left" ></span> ' +
      '<span data-notify="title">{1}</span> ' +
      '<span data-notify="message">{2}</span>' +
      '</div>'
  });

});
function remove_fields(link) {
    $(link).prev("input[type=hidden]").val("1");
    $(link).closest(".fields").hide();
    return false;
}

function add_fields(link, association, content) {
    var new_id = new Date().getTime();
    var regexp = new RegExp("new_" + association, "g")
    $(link).parent().append(content.replace(regexp, new_id));
    $('.datepicker').datetimepicker({
        formatDate: 'd-m-Y',
        formatTime: '',
        theme:'default',
        timepicker: false
    });
    return false;
}
function resizeIframe(obj) {
     // debugger
    obj.style.width = '100%';
    obj.style.height = '650px';
}
function click_tab(id){
        $('.jcmc-tab').removeClass('jcmc-active-tab');
        $('.jcmc-tabs li').removeClass('jcmc-active-link');
        $("#li_"+id).addClass('jcmc-active-link');
        $('.jcmc-active-link').prev().addClass("jcmc-enabled");
        $('#tab_'+id).addClass("jcmc-active-tab");
    }

