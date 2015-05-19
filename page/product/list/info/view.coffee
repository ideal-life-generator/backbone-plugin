define [
  "text!./template.html"
], (
  template
) ->

  View = Backbone.View.extend
    className: "view"
    initialize: ->
      @$el.css({ opacity: 0 })
      @$el.html(template)