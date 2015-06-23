(function() {
  require.config({
    paths: {
      text: "libs/text",
      app: "app"
    }
  });

  require(["app"]);

  $.prototype.cloneElement = function($element) {
    return $(this[0].cloneNode());
  };

  _.templateSettings.interpolate = /\{(.+?)\}/g;

}).call(this);
