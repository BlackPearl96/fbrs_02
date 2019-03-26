$(document).ready() {
  $("form").submit(function(event){
    event.preventDefault();

    var action = $(this).attr('action');
    var method = $(this).attr('method');

    var created_at = $(this).find('#review_created_at').val("");
    var user_name = $(this).find('#review_user_name').val("");
    var rate = $(this).find('#review_rate').val("");
    var content = $(this).find('#review_content').val("");

    $.ajax({
      method: method,
      url: action,
      data: { user_name: user_name, rate: rate, created_at: created_at, content: content },
      dataType: 'json'
    });
  });
};

