class AnimateView
  constructor: (@element, @delay, @speed) ->

  show: ->
    TweenMax.to @element, @speed, transform: "translateY(0%)", @delay

  hide: ->
    TweenMax.to @element, @speed, transform: "translateY(-100%)", @delay

class AnimateViewDecorator extends AnimateView
  constructor: (@element, @delay, @speed, animateView) ->
    @delay += animateView.delay + animateView.speed


viewOne = new AnimateView $(".view-one"), 0.3, 1.6

console.log viewOne

viewTwo = new AnimateViewDecorator $(".view-two"), 0.3, 1, viewOne

console.log viewTwo