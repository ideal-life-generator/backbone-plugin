define [
  "text!./template.html"
  "global/shapeRightPanelBox"
], (
  template
  ShapeRightPanelBox
) ->

  View = Backbone.View.extend
    className: "view-one"
    initialize: ->
      @$el.html(template)

      new ShapeRightPanelBox @$el, ".shape-right-box"