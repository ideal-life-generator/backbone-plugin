(function() {
  define(["plugin/parse-query", "plugin/router-c", "animation/view-container-one-animation", "animation/view-container-two-animation"], function(parseQuery, Router, viewContainerOneAnimation, viewContainerTwoAnimation) {
    var PageRoute, pageRoute, router;
    router = new Router({
      "id-1:plugin": {
        url: "view/plugin/plugin-view",
        init: function(PluginView) {
          return new PluginView;
        },
        update: function(pluginView) {},
        destroy: function(pluginView) {
          return pluginView.remove();
        }
      },
      "id-1:plugin>id-2:main": {
        url: "view/plugin/main/main-view",
        init: function(MainView) {
          return new MainView;
        },
        update: function(mainView) {},
        destroy: function(mainView) {
          return mainView.remove();
        }
      },
      "id-1:plugin>id-2:list": {
        url: "view/plugin/list/list-view",
        init: function(ListView) {
          return new ListView;
        },
        update: function(listView) {},
        destroy: function(listView) {
          return listView.remove();
        }
      },
      "id-1:plugin>id-2:main>id-3:info": {
        url: "view/contact/contact-view",
        init: function(InfoView) {
          return new InfoView;
        },
        update: function(infoView) {},
        destroy: function(infoView) {
          return infoView.remove();
        }
      },
      "id-1:contact": {
        url: "view/contact/contact-view",
        init: function(ContactView) {
          return new ContactView;
        },
        update: function(contactView) {},
        destroy: function(contactView) {
          return contactView.remove();
        }
      }
    }, {
      animations: {
        "id-1": {
          animation: viewContainerOneAnimation,
          alwaysRun: false,
          inOrder: false
        },
        "id-2": {
          animation: viewContainerTwoAnimation,
          alwaysRun: false,
          inOrder: false
        }
      },
      priorities: {
        "id-1:plugin": "00",
        "id-1:plugin>id-2:main": "00",
        "id-1:plugin>id-2:list": "10",
        "id-1:contact": "10"
      }
    });
    PageRoute = Backbone.Router.extend({
      routes: {
        "plugin": function() {
          return router.go({
            "id-1:plugin": {
              technology: "backbone"
            },
            "id-1:plugin>id-2:main": {
              _id: "556f617d01ca723665618d79"
            },
            "id-1:plugin>id-2:main>id-3:info": {
              page: 1
            }
          });
        }
      }
    });
    pageRoute = new PageRoute;
    Backbone.history.start();
    return pageRoute;
  });

}).call(this);
