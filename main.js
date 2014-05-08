var FIREBASE_INSTANCE = new Firebase('https://dazzling-fire-7228.firebaseio.com/');

function handleFileSelect() {
  var f = $("#camera-button")[0].files[0];

  var isImage = f.type.indexOf("image") != 0;
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
