function removeAD() {
    var banners = new Array('dale_movie_subject_mobile_app_banner','dale_movie_review_mobile_app_banner','dale_movie_mobile_app_banner','dale_movie_photo_mobile_app_banner');
    for (i=0;i<banners.length;i++){
        var idObject = document.getElementById(banners[i]);
        if (idObject != null){
//            alert(idObject);
            idObject.parentNode.removeChild(idObject);
        }
            
    }
}
removeAD();