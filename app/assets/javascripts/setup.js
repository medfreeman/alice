var ALICE = ALICE || {};
ALICE.attachedCallbacks = [];
ALICE.attach = function(callback){
  this.attachedCallbacks.push(callback);
};
ALICE.apply = function(context){
  for(var i = 0; i < this.attachedCallbacks.length; i++){
    this.attachedCallbacks[i](context, i);
  }
};
ALICE.attach(function(context, i){
  $('.ui.modal', context).modal('attach events', '#login-link');
  $('.ui.dropdown:not(.custom)', context).dropdown({
    on: 'click hover'
  });

  $('.message .close', context)
  .on('click', function() {
    $(this)
      .closest('.message')
      .transition('fade')
    ;
  });

  $('.ui.accordion', context).accordion();
  if(window.innerWidth < 767)
  {
    $('.list-header').click(function(){
      $(this).next().slideToggle();
    });
  }
});
$(document).on('ready page:load',function(){
  ALICE.apply();
});
