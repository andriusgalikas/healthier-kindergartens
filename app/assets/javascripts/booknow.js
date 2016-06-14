$(document).ready(function()
{

$(function() {
$('.pro').hover(function() { 
    $('.pink').show(); 
}, function() { 
    $('.all').hide(); 
    $('.blue').hide(); 
});
});    

$(function() {
$('.commit').hover(function() { 
    $('.blue').show(); 
    $('.pink').show();
}, function() { 
    $('.all').hide(); 
});
});    

$(function() {
$('.acc').hover(function() { 
    $('.blue').show(); 
    $('.pink').show();
    $('.all').show();
});
});

});    