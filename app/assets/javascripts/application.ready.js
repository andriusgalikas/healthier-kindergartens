$(document).ready(function()
{
    healthChildcare.app.departmentSelector();
    healthChildcare.app.multiInput();
    healthChildcare.app.toggleMenu();

    $('.datepicker').datetimepicker({
        formatDate: 'd-m-Y',
        formatTime: '',
        theme:'default',
        timepicker: false
    });

    $('.datetimepicker').datetimepicker({
        formatDate: 'd-m-Y',
        theme:'default'
    });

    $("body").on("submit", '.submit-attempt', function() 
    {
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
    $('.graph-bar').each(function() {
        var dataWidth = $(this).data('value');
        $(this).css("width", dataWidth + "%");
    });
    $('.retake-radio').change(function()
    {
        var subjectId = $(this).val();
        $('#retake-form').attr('action', '/subjects/' + subjectId + '/attempts/new')
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
function removeField(link) {
    $(link).prev("input[type=hidden]").val("true");
    tag = $(link).closest("li")
    tag.hide("fade in").addClass("deleted");
}

function addField(link, association, content) {
    var new_id = new Date().getTime();
    var regexp = new RegExp("new_" + association, "g");
    var html = $(content.replace(regexp, new_id)).hide();
    html.appendTo($(link).closest("div.field").find("ol").first()).slideDown("slow");
}
function resizeIframe(obj) {
    obj.style.width = obj.contentWindow.document.body.scrollWidth + 'px';
    obj.style.height = obj.contentWindow.document.body.scrollHeight + 'px';
}
function click_tab(id){
        $('.jcmc-tab').removeClass('jcmc-active-tab');
        $('.jcmc-tabs li').removeClass('jcmc-active-link');
        $("#li_"+id).addClass('jcmc-active-link');
        $('.jcmc-active-link').prev().addClass("jcmc-enabled");
        $('#tab_'+id).addClass("jcmc-active-tab");
    }