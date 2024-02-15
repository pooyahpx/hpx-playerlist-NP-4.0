window.addEventListener("message", function (e) {
  e = e.data
  switch (e.type) {
    case "OPEN":
      return openMenu(e.data)
    case "CLOSE":
      return closeNUI()
      case "UPDATE":
        return update(e.data)
    default:
      return;
  }
});



function openMenu(data){
  $("body").show()
  $(".online-list").empty()
  $(".onlineplayers").html(`${data["activePlayers"].length}`)
  $(".disconnectedplayers").html(`${data["disconnectedPlayers"].length}`)
  $.each(data["activePlayers"], function (i, v) { 
     $(".online-list").append(`
    <div class="online-box">
      <div class="left-box"><i class="fa fa-user"  aria-hidden="true"></i></div>
      <div class="right-box"><div class="name">${v.name} [${v.id}]</div><div class="steam"><span>${v.identifier.substring(0,12)}...</span></div></div>
    </div>
     `);
  });
}


function append(variable) { 
  $.post(`http://ac-playerlist/getData`, JSON.stringify({variable }), function (x) {
    $(".online-list").empty()
    $.each(x, function (i, v) { 
      $(".online-list").append(`
      <div class="online-box">
        <div class="left-box"><i class="fa fa-user"  aria-hidden="true"></i></div>
        <div class="right-box"><div class="name">${v.name} [${v.id}]</div><div class="steam"><span>${v.identifier.substring(0,12)}...</span></div></div>
      </div>
      `);
    });
  })
}

function closeNUI() {
  $("body").hide()
  $.post("http://ac-playerlist/close", JSON.stringify({}));
}

function update() { 
  append("online")
  append("disconnected")
}


$(document).on('click', '.online', function (e) {
  type = $(this).data("type");
  append(type)
  $(".online").css({color: "rgb(154 87 89)",textShadow: "0px 0px 10px rgb(122, 118, 118)",backgroundColor: "rgb(53 54 63)",border: "none"})
  $(this).css({color: "rgb(66, 201, 176)",textShadow: "0px 0px 10px rgba(66, 201, 176)",backgroundColor: "rgba(10,242,184,0.1)",border: "1px solid rgb(42 117 108)" })
})

$(document).on('click', '.exit', function (e) {
  closeNUI()
})


document.addEventListener('keydown', function(event) {

  if (event.key === 'Escape') {
      closeNUI();
  }
});
