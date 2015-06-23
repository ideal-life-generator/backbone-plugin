define [
  "text!./plugin-template.html"
], (
  template
) ->

  (param) ->

    View = Backbone.View.extend
      className: "view-one"
      
      initialize: ->
        @$el.html template
