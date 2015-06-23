(function() {
  define([], function() {
    var NameModel;
    return NameModel = Backbone.Model.extend({
      defaults: function() {
        return {
          result: "",
          errorCode: ""
        };
      }
    });
  });

}).call(this);
