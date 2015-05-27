define [
  "text!./template.html"
  "global/shapeRightPanelBox"
], (
  template
  ShapeRightPanelBox
) ->

  User = Backbone.Model.extend
    name: ""

  View = Backbone.View.extend
    className: "view-one"

    model: new User

    render: (user) ->
      @$user.text _.template(@$user.text()) user: user

    initialize: ->
      @$el.html template
      @$user = @$el.find ".user"

      new ShapeRightPanelBox @$el, ".shape-right-box"