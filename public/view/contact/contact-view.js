(function() {
  define(["text!./contact-template.html"], function(template, ShapeRightPanelBox) {
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
