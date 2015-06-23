(function() {
  define(["text!./list-template.html"], function(template) {
    return function(param) {
      var PluginCollection, PluginModel, PluginView, View;
      PluginModel = Backbone.Model.extend({
        title: "",
        description: ""
      });
      PluginCollection = Backbone.Collection.extend({
        model: PluginModel,
        url: "/plugin/backbone",
        comparator: "date"
      });
      PluginView = Backbone.View.extend({
        tagName: "article",
        template: _.template("<h3>{title}</h3> <p>{description}</p> <a href=\"#/plugin/backbone/{articleId}\">more</a>"),
        render: function() {
          return this.$el.html(this.template(this.model.toJSON()));
        },
        initialize: function() {
          return this.render();
        }
      });
      return View = Backbone.View.extend({
        className: "view-two",
        tagName: "section",
        collection: new PluginCollection,
        events: {
          "input .search-plugin": function(event) {
            var value;
            value = event.target.value;
            return router.navigate("#/plugin/backbone" + (router.parseParam({
              find: value
            })));
          }
        },
        render: function() {
          this.$header.text(_.template(this.$header.text(), param));
          this.$searchPlugin.val(param.find);
          return this.collection.fetch({
            success: (function(_this) {
              return function(collection) {
                return collection.forEach(function(plugin) {
                  var pluginView;
                  pluginView = new PluginView({
                    model: plugin
                  });
                  return _this.$articleContainer.append(pluginView.$el);
                });
              };
            })(this)
          });
        },
        update: function(update) {
          this.$searchPlugin.val(update.find);
          this.$articleContainer.html("");
          return this.collection.fetch({
            data: {
              find: update.find
            },
            success: (function(_this) {
              return function(collection) {
                return collection.forEach(function(plugin) {
                  var pluginView;
                  pluginView = new PluginView({
                    model: plugin
                  });
                  return _this.$articleContainer.append(pluginView.$el);
                });
              };
            })(this)
          });
        },
        initialize: function() {
          this.$el.html(template);
          this.$header = this.$el.find(".list-header");
          this.$searchPlugin = this.$el.find(".search-plugin");
          return this.$articleContainer = this.$el.find(".plugin-article-container");
        }
      });
    };
  });

}).call(this);
