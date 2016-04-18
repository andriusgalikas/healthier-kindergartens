$(document).ready(function()
{
    healthChildcare.admin.multiSelect();

    soca.animation.loading();
    soca.animation.colourCaveat();
    soca.filter.tableRowTarget();
    soca.misc.multiSelect();
    soca.misc.updateTableHeight();
    soca.mobile.disableTooltips();
    soca.mobile.triggerMenu();

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
});
function remove_fields(link) {
    $(link).prev("input[type=hidden]").val("1");
    $(link).closest(".field").hide();
}

function add_fields(link, association, content) {
    var new_id = new Date().getTime();
    var regexp = new RegExp("new_" + association, "g")
    $(link).parent().next().find('.widget .fields').append(content.replace(regexp, new_id));
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