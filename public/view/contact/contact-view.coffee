define [
  "text!./contact-template.html"
], (
  template
  ShapeRightPanelBox
) ->

  (param) ->

    View = Backbone.View.extend
      className: "view-one"
      initialize: ->
        @$el.html template