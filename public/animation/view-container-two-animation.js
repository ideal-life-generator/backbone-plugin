(function() {
  define([], function() {
    var speed;
    speed = 5;
    return {
      first: function(view) {
        var animate;
        view.animationParams.opacity = 0;
        view.animationParams.scaleX = 0.9;
        view.animationParams.scaleY = 0.9;
        animate = new TimelineMax({
          paused: true,
          onUpdate: function() {
            return view.$el.css({
              opacity: view.animationParams.opacity,
              transform: "scale(" + view.animationParams.scaleX + ", " + view.animationParams.scaleY + ")"
            });
          }
        });
        animate.to(view.animationParams, 1 / speed, {
          opacity: 1,
          scaleX: 1,
          scaleY: 1
        });
        return animate.play();
      },
      last: function(view) {
        var animate;
        view.animationParams.opacity = 1;
        view.animationParams.scaleX = 1;
        view.animationParams.scaleY = 1;
        animate = new TimelineMax({
          paused: true,
          onUpdate: function() {
            return view.$el.css({
              opacity: view.animationParams.opacity,
              transform: "scale(" + view.animationParams.scaleX + ", " + view.animationParams.scaleY + ")"
            });
          }
        });
        animate.to(view.animationParams, 1 / speed, {
          opacity: 0,
          scaleX: 0.9,
          scaleY: 0.9
        });
        return animate.play();
      },
      centerTop: function(view, done) {
        var animate;
        view.animationParams.opacity = 1;
        view.animationParams.translateY = 0;
        view.animationParams.rotateX = 0;
        animate = new TimelineMax({
          paused: true,
          onUpdate: function() {
            return view.$el.css({
              opacity: view.animationParams.opacity,
              transform: "translateY(" + view.animationParams.translateY + "%) rotateX(" + view.animationParams.rotateX + "deg)"
            });
          },
          onComplete: function() {
            return done();
          }
        });
        animate.to(view.animationParams, 1.6 / speed, {
          ease: Sine.easeOut,
          opacity: 0,
          translateY: -100,
          rotateX: 90
        });
        return animate.play();
      },
      topCenter: function(view) {
        var animate;
        view.animationParams.opacity = 0;
        view.animationParams.translateY = -100;
        view.animationParams.rotateX = 90;
        animate = new TimelineMax({
          paused: true,
          onUpdate: function() {
            return view.$el.css({
              opacity: view.animationParams.opacity,
              transform: "translateY(" + view.animationParams.translateY + "%) rotateX(" + view.animationParams.rotateX + "deg)"
            });
          }
        });
        animate.to(view.animationParams, 1.6 / speed, {
          ease: Sine.easeOut,
          opacity: 1,
          translateY: 0,
          rotateX: 0
        });
        return animate.play();
      },
      centerBottom: function(view, done) {
        var animate;
        view.animationParams.opacity = 1;
        view.animationParams.translateY = 0;
        view.animationParams.rotateX = 0;
        animate = new TimelineMax({
          paused: true,
          onUpdate: function() {
            return view.$el.css({
              opacity: view.animationParams.opacity,
              transform: "translateY(" + view.animationParams.translateY + "%) rotateX(" + view.animationParams.rotateX + "deg)"
            });
          },
          onComplete: function() {
            return done();
          }
        });
        animate.to(view.animationParams, 1.6 / speed, {
          ease: Sine.easeOut,
          opacity: 0,
          translateY: 100,
          rotateX: -90
        });
        return animate.play();
      },
      bottomCenter: function(view) {
        var animate;
        view.animationParams.opacity = 0;
        view.animationParams.translateY = 100;
        view.animationParams.rotateX = -90;
        animate = new TimelineMax({
          paused: true,
          onUpdate: function() {
            return view.$el.css({
              opacity: view.animationParams.opacity,
              transform: "translateY(" + view.animationParams.translateY + "%) rotateX(" + view.animationParams.rotateX + "deg)"
            });
          }
        });
        animate.to(view.animationParams, 1.6 / speed, {
          ease: Sine.easeOut,
          opacity: 1,
          translateY: 0,
          rotateX: 0
        });
        return animate.play();
      },
      centerLeft: function(view, done) {
        var animate;
        view.animationParams.opacity = 1;
        view.animationParams.translateX = 0;
        view.animationParams.rotateY = 0;
        animate = new TimelineMax({
          paused: true,
          onUpdate: function() {
            return view.$el.css({
              opacity: view.animationParams.opacity,
              transform: "translateX(" + view.animationParams.translateX + "%) rotateY(" + view.animationParams.rotateY + "deg)"
            });
          },
          onComplete: function() {
            return done();
          }
        });
        animate.to(view.animationParams, 1.6 / speed, {
          ease: Sine.easeOut,
          opacity: 0,
          translateX: -100,
          rotateY: -90
        });
        return animate.play();
      },
      leftCenter: function(view, done) {
        var animate;
        view.animationParams.opacity = 0;
        view.animationParams.translateX = -100;
        view.animationParams.rotateY = -90;
        animate = new TimelineMax({
          paused: true,
          onUpdate: function() {
            return view.$el.css({
              opacity: view.animationParams.opacity,
              transform: "translateX(" + view.animationParams.translateX + "%) rotateY(" + view.animationParams.rotateY + "deg)"
            });
          }
        });
        animate.to(view.animationParams, 1.6 / speed, {
          ease: Sine.easeOut,
          opacity: 1,
          translateX: 0,
          rotateY: 0
        });
        return animate.play();
      },
      centerRight: function(view, done) {
        var animate;
        view.animationParams.opacity = 1;
        view.animationParams.translateX = 0;
        view.animationParams.rotateY = 0;
        animate = new TimelineMax({
          paused: true,
          onUpdate: function() {
            return view.$el.css({
              opacity: view.animationParams.opacity,
              transform: "translateX(" + view.animationParams.translateX + "%) rotateY(" + view.animationParams.rotateY + "deg)"
            });
          },
          onComplete: function() {
            return done();
          }
        });
        animate.to(view.animationParams, 1.6 / speed, {
          ease: Sine.easeOut,
          opacity: 0,
          translateX: 100,
          rotateY: 90
        });
        return animate.play();
      },
      rightCenter: function(view, done) {
        var animate;
        view.animationParams.opacity = 0;
        view.animationParams.translateX = 100;
        view.animationParams.rotateY = 90;
        animate = new TimelineMax({
          paused: true,
          onUpdate: function() {
            return view.$el.css({
              opacity: view.animationParams.opacity,
              transform: "translateX(" + view.animationParams.translateX + "%) rotateY(" + view.animationParams.rotateY + "deg)"
            });
          }
        });
        animate.to(view.animationParams, 1.6 / speed, {
          ease: Sine.easeOut,
          opacity: 1,
          translateX: 0,
          rotateY: 0
        });
        return animate.play();
      }
    };
  });

}).call(this);
