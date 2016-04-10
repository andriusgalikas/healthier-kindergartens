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
    // $(".previewer").on('change', function(){
    //     readURL(this);
    // });
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
// function readURL(input) {
//     if (input.files && input.files[0]) 
//     {
//         var reader = new FileReader();
//         reader.onload = function (e) {
//           $('.img-preview-container img').attr('src', e.target.result);
//         }
//         reader.readAsDataURL(input.files[0]);
//     }
// }