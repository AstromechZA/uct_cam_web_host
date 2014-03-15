$(function(){
    $.each(imagearray, function(i, e) {
        $('#past_images').append('<a href="img/store/'+e[1]+'"><div class="imageoverlay"><img style="margin:5px;" src="img/store/'+e[2]+'" alt="'+e[0]+'" class="img-thumbnail" /><p>'+e[0]+'</p></div></a>')
    });
    if (imagearray.length > 0) {
        $('#currentimgts').html(imagearray[0][0])
    }
});