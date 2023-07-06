document.addEventListener('DOMContentLoaded', function() {
  var swiperOptions = {
    slidesPerView: 'auto',
    spaceBetween: 5,
    navigation: {
      nextEl: '.swiper-button-next',
      prevEl: '.swiper-button-prev',
    },
    scrollbar: {
      el: '.swiper-scrollbar',
      hide: true,
    },
    observer: true,
    observeParents: true
  };

  var swiperPopularCommunity = new Swiper('.popular_community .swiper-container', swiperOptions);
  var swiperTodayActor = new Swiper('.today_actor .swiper-container', swiperOptions);
  var swiperProgressMusical = new Swiper('.progress-musical .swiper-container', swiperOptions);
  
  swiperPopularCommunity.init();  // Swiper 인스턴스 초기화
  swiperTodayActor.init();
  swiperProgressMusical.init();
});