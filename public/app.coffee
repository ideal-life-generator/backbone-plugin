define [
  "plugin/parse-query"
  "plugin/router-c"
  "animation/view-container-one-animation"
  "animation/view-container-two-animation"
], (
  parseQuery
  Router
  viewContainerOneAnimation
  viewContainerTwoAnimation
) ->

  router = new Router
    "id-1:plugin":
      url: "view/plugin/plugin-view"
      init: (PluginView) -> new PluginView
      update: (pluginView) ->
      destroy: (pluginView) -> pluginView.remove()
    "id-1:plugin>id-2:main":
      url: "view/plugin/main/main-view"
      init: (MainView) -> new MainView
      update: (mainView) ->
      destroy: (mainView) -> mainView.remove()
    "id-1:plugin>id-2:list":
      url: "view/plugin/list/list-view"
      init: (ListView) -> new ListView
      update: (listView) ->
      destroy: (listView) -> listView.remove()
    "id-1:plugin>id-2:main>id-3:info":
      url: "view/contact/contact-view"
      init: (InfoView) -> new InfoView
      update: (infoView) ->
      destroy: (infoView) -> infoView.remove()
    "id-1:contact":
      url: "view/contact/contact-view"
      init: (ContactView) -> new ContactView
      update: (contactView) ->
      destroy: (contactView) -> contactView.remove()
  ,
    animations:
      "id-1":
        animation: viewContainerOneAnimation
        alwaysRun: off
        inOrder: off
      "id-2":
        animation: viewContainerTwoAnimation
        alwaysRun: off
        inOrder: off
    priorities:
      "id-1:plugin": "00"
      "id-1:plugin>id-2:main": "00"
      "id-1:plugin>id-2:list": "10"
      "id-1:contact": "10"


  PageRoute = Backbone.Router.extend
    routes:
      "plugin": ->

        router.go
          "id-1:plugin": technology: "backbone"
          "id-1:plugin>id-2:main": _id: "556f617d01ca723665618d79"
          "id-1:plugin>id-2:main>id-3:info": page: 1

  pageRoute = new PageRoute
  
  Backbone.history.start()

  pageRoute