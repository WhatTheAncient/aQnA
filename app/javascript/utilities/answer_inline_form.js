$(document).on('turbolinks:load', function(){
  console.log('file loaded')
  $('.answers').on('click', '.edit-answer-link', function(e) {
    e.preventDefault();
    $(this).hide();
    var answerId = $(this).data('answerId');
    console.log(answerId);
    $('form#edit-answer-' + answerId).removeClass('hidden');
  })
});
