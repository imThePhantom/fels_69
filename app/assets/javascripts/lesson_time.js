function time_remaining(times){
  if(times > 0){
    var minutes = Math.floor(times / 60);
    var seconds = times % 60;
    $("#time-remaining").text(minutes + " : " + seconds);
    setTimeout(function(){time_remaining(times - 1)}, 1000);
  }else if(times == 0){
    $("form").submit();
  }
}
