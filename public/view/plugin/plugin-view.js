(function() {
  define(["text!./plugin-template.html"], function(template) {
    return function(param) {
      var View;
      return View = Backbone.View.extend({
        className: "view-one",
        initialize: function() {
          return this.$el.html(template);
        }
      });
    };
  });

}).call(this);
