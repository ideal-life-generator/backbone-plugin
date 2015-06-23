define [
  "text!./main-template.html"
], (
  template
) ->

  (param) ->

    View = Backbone.View.extend
      className: "view-two"
      initialize: ->
        @$el.html template