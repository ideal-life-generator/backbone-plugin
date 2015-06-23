(function() {
  define(["text!./article-template.html"], function(template) {
    return function(param) {
      var ArticleModel, View;
      ArticleModel = Backbone.Model.extend({
        title: "",
        body: "",
        url: "/plugin/" + param.technology + "/" + param._id
      });
      return View = Backbone.View.extend({
        className: "view-two",
        tagName: "article",
        model: new ArticleModel,
        render: function(article) {
          this.$header.text(_.template(this.$header.text(), article.toJSON()));
          return this.$body.text(_.template(this.$body.text(), article.toJSON()));
        },
        initialize: function() {
          this.$el.html(template);
          this.$header = this.$el.find(".article-title");
          this.$body = this.$el.find(".article-body");
          return this.model.fetch({
            success: (function(_this) {
              return function(article) {
                return _this.render(article);
              };
            })(this)
          });
        }
      });
    };
  });

}).call(this);
