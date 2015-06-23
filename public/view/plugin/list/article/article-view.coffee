define [
  "text!./article-template.html"
], (
  template
) ->

  (param) ->

    ArticleModel = Backbone.Model.extend
      title: ""
      body: ""
      url: "/plugin/#{param.technology}/#{param._id}"
  
    View = Backbone.View.extend
      className: "view-two"
      tagName: "article"
      
      model: new ArticleModel

      render: (article) ->
        @$header.text _.template @$header.text(), article.toJSON()
        @$body.text _.template @$body.text(), article.toJSON()
  
      initialize: ->
        @$el.html template

        @$header = @$el.find ".article-title"
        @$body = @$el.find ".article-body"

        @model.fetch
          success: (article) =>
            @render article