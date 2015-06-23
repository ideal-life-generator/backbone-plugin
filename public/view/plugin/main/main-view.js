(function() {
  define(["text!./main-template.html"], function(template) {
    return function(param) {
      var View;
      return View = Backbone.View.extend({
        className: "view-two",
        initialize: function() {
          return this.$el.html(template);
        }
      });
    };
  });

}).call(this);
