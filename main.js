var FIREBASE_INSTANCE = new Firebase('https://dazzling-fire-7228.firebaseio.com/');

function handleFileSelect() {
  var f = $("#camera-button")[0].files[0];

  var isImage = f.type.indexOf("image") == 0;
  blob_to_base64(f, function(b64_data) {
    if (isImage) {
      FIREBASE_INSTANCE.push({name: 'Andy', image: b64_data});
    } else {
      FIREBASE_INSTANCE.push({name: 'Andy', video: b64_data});
    }
  });
}

// some handy methods for converting blob to base 64 and vice versa
// for performance bench mark, please refer to http://jsperf.com/blob-base64-conversion/5
// note useing String.fromCharCode.apply can cause callstack error
var blob_to_base64 = function(blob, callback) {
  var reader = new FileReader();
  reader.onload = function() {
    var dataUrl = reader.result;
    var base64 = dataUrl.split(',')[1];
    callback(base64);
  };
  reader.readAsDataURL(blob);
};

var base64_to_blob = function(base64) {
  var binary = atob(base64);
  var len = binary.length;
  var buffer = new ArrayBuffer(len);
  var view = new Uint8Array(buffer);
  for (var i = 0; i < len; i++) {
    view[i] = binary.charCodeAt(i);
  }
  var blob = new Blob([view]);
  return blob;
};

$("body").delegate(".send-friend-name", "click", function() {
  if ($(this).hasClass("selected")) {
    $(this).removeClass("selected");
  } else {
    $(this).addClass("selected");
  }
});

$("body").delegate("#send-photo-link", "click", function() {
  handleFileSelect();
  PUSH({ url: 'index.html', transition: 'slide-in'});
  $("#camera-button").show();
});

$("body").delegate(".index_back", "click", function() {
  PUSH({url:'index.html', transition: 'slide-out' });
  $("#camera-button").show();
});

$("body").delegate('#messageInput', "keypress", function (e) {
  if (e.keyCode == 13) {
    var text = $('#messageInput').val();
    FIREBASE_INSTANCE.push({name: 'Andy', text: text});
    $('#messageInput').val('');
  }
});

FIREBASE_INSTANCE.on('child_added', function(snapshot) {
  var message = snapshot.val();
  if (message.text) {
    displayChatMessage(message.name, message.text);
  } else if (message.image) {
    displayImageMessage(message.name, message.image);
  } else {
    displayVideoMessage(message.name, message.video);
  }
});

$("body").delegate("#camera-button", "click", function() {
  PUSH({url: 'camera.html', transition: 'slide-in'});
  $("#camera-button").hide();
});

function displayChatMessage(name, text) {
  if ($("#chatbox").length == 0) return;

  var appendText = '<div class="bubble bubble--alt">'+text+'</div>'
  $("#chatbox").append(appendText);
  $('.messagesDiv')[0].scrollTop = $('.messagesDiv')[0].scrollHeight;
}

function displayImageMessage(name, image) {
  if ($("#chatbox").length == 0) return;

  var src = URL.createObjectURL(base64_to_blob(image));
  var appendText = '<img class="img" src="'+src+'" />';
  $("#chatbox").append(appendText);
  $('.messagesDiv')[0].scrollTop = $('.messagesDiv')[0].scrollHeight;
}

function displayVideoMessage(name, video) {
  if ($("#chatbox").length == 0) return;

  var videoDOM = document.createElement("video");
  videoDOM.autoplay = true;
  videoDOM.controls = true; // optional
  videoDOM.loop = true;
  videoDOM.width = 250;

  var source = document.createElement("source");
  source.src =  URL.createObjectURL(base64_to_blob(video)) + "?dl=1";
  source.type =  "video/mp4";

  videoDOM.appendChild(source);

  var videoContainer = $('<div class="video-container">');
  $("#chatbox").append(videoContainer.append(videoDOM));
}