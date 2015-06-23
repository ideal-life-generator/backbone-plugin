define [
  "text!./list-template.html"
], (
  template
) ->

  (param) ->

    PluginModel = Backbone.Model.extend
      title: ""
      description: ""
  
    PluginCollection = Backbone.Collection.extend
      model: PluginModel
      url: "/plugin/backbone"
      comparator: "date"
  
    PluginView = Backbone.View.extend
      tagName: "article"
  
      template: _.template "
        <h3>{title}</h3>
        <p>{description}</p>
        <a href=\"#/plugin/backbone/{articleId}\">more</a>
      "

      render: ->
        @$el.html @template @model.toJSON()
  
      initialize: ->
        @render()
  
    View = Backbone.View.extend
      className: "view-two"
      tagName: "section"
  
      collection: new PluginCollection

      events:
        "input .search-plugin": (event) ->
          value = event.target.value
          router.navigate "#/plugin/backbone#{router.parseParam find: value}"
  
      render: ->
        @$header.text _.template @$header.text(), param

        @$searchPlugin.val param.find
  
        @collection.fetch
          success: (collection) =>
            collection.forEach (plugin) =>
              pluginView = new PluginView model: plugin
              @$articleContainer.append pluginView.$el

      update: (update) ->
        @$searchPlugin.val update.find

        @$articleContainer.html ""

        @collection.fetch
          data:
            find: update.find
          success: (collection) =>
            collection.forEach (plugin) =>
              pluginView = new PluginView model: plugin
              @$articleContainer.append pluginView.$el
  
      initialize: ->
        @$el.html template
        @$header = @$el.find ".list-header"
        @$searchPlugin = @$el.find ".search-plugin"
        @$articleContainer = @$el.find ".plugin-article-container"