define ->

  class shapeRightBox

    constructor: (container, selector) ->

      $shapeRightBox = container.find selector
      
      shapeResizeHandler = ->
      
        $shapeBoxRightParent = $shapeRightBox.parent()
        $shapeBoxRightParentHeight = $shapeBoxRightParent.height()
    
        shapeTopBound = $shapeBoxRightParentHeight - 450 + 15
        shapeBottomBound = $shapeBoxRightParentHeight + 15
    
        $shapeRightBox.css "-webkit-shape-outside": "polygon(600px #{shapeTopBound}px, 600px #{shapeBottomBound}px, 200px #{shapeBottomBound}px)"
      
      $(window).on "resize", (event) ->
        event.stopPropagation()
      
        shapeResizeHandler event
    
      setTimeout -> shapeResizeHandler()