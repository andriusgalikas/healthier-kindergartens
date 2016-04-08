$(document).ready(function()
{
    healthChildcare.app.departmentSelector();
    healthChildcare.app.multiInput();

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

  $(".menu_icons").click(function(){
    $(".submenu_toggle").toggleClass("dis_block") 
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
    $(link).parent().before(content.replace(regexp, new_id));
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