(function() {
  define([], function() {
    var speed;
    speed = 5;
    return {
      first: function(view) {
        var animate;
        if (!view.animationParams.opacity) {
          view.animationParams.opacity = 0;
        }
        if (!view.animationParams.translateZ) {
          view.animationParams.translateZ = -120;
        }
        animate = new TimelineMax({
          paused: true,
          onUpdate: function() {
            return view.$el.css({
              opacity: view.animationParams.opacity,
              transform: "translateZ(" + view.animationParams.translateZ + "px)"
            });
          }
        });
        animate.to(view.animationParams, 1.6 / speed, {
          opacity: 1,
          translateZ: -180
        });
        animate.to(view.animationParams, 2 / speed, {
          delay: 0.5 / speed,
          ease: Sine.easeOut,
          translateZ: 0
        });
        return animate.play();
      },
      last: function(view, done) {
        var animate;
        if (!view.animationParams.opacity) {
          view.animationParams.opacity = 1;
        }
        if (!view.animationParams.translateZ) {
          view.animationParams.translateZ = 0;
        }
        animate = new TimelineMax({
          paused: true,
          onUpdate: function() {
            return view.$el.css({
              opacity: view.animationParams.opacity,
              transform: "translateZ(" + view.animationParams.translateZ + "px)"
            });
          },
          onComplete: function() {
            return done();
          }
        });
        animate.to(view.animationParams, 1.6 / speed, {
          opacity: 0.999,
          translateZ: -180
        });
        animate.to(view.animationParams, 2 / speed, {
          delay: 0.5 / speed,
          ease: Sine.easeOut,
          opacity: 0,
          translateZ: -120
        });
        return animate.play();
      },
      centerLeft: function(view, done) {
        var animate;
        if (!view.animationParams.opacity) {
          view.animationParams.opacity = 1;
        }
        if (!view.animationParams.translateZ) {
          view.animationParams.translateZ = 0;
        }
        if (!view.animationParams.translateX) {
          view.animationParams.translateX = 0;
        }
        if (!view.animationParams.rotateY) {
          view.animationParams.rotateY = 0;
        }
        view.$el.css({
          transformOrigin: "100% 0"
        });
        animate = new TimelineMax({
          paused: true,
          onUpdate: function() {
            return view.$el.css({
              opacity: view.animationParams.opacity,
              transform: "translateZ(" + view.animationParams.translateZ + "px) translateX(" + view.animationParams.translateX + "%) rotateY(" + view.animationParams.rotateY + "deg"
            });
          },
          onComplete: function() {
            return done();
          }
        });
        animate.to(view.animationParams, 1.6 / speed, {
          opacity: 0.999,
          translateZ: -180
        });
        animate.to(view.animationParams, 1.6 / speed, {
          ease: Sine.easeInOut,
          translateX: -105,
          rotateY: 30
        });
        animate.to(view.animationParams, 2 / speed, {
          delay: 0.5 / speed,
          ease: Sine.easeOut,
          opacity: 0,
          translateZ: 0
        });
        return animate.play();
      },
      leftCenter: function(view) {
        var animate;
        if (!view.animationParams.opacity) {
          view.animationParams.opacity = 0;
        }
        if (!view.animationParams.translateZ) {
          view.animationParams.translateZ = 0;
        }
        if (!view.animationParams.translateX) {
          view.animationParams.translateX = -105;
        }
        if (!view.animationParams.rotateY) {
          view.animationParams.rotateY = 30;
        }
        view.$el.css({
          transformOrigin: "100% 0"
        });
        animate = new TimelineMax({
          paused: true,
          onUpdate: function() {
            return view.$el.css({
              opacity: view.animationParams.opacity,
              transform: "translateZ(" + view.animationParams.translateZ + "px) translateX(" + view.animationParams.translateX + "%) rotateY(" + view.animationParams.rotateY + "deg"
            });
          }
        });
        animate.to(view.animationParams, 1.6 / speed, {
          opacity: 0.999,
          translateZ: -180
        });
        animate.to(view.animationParams, 1.6 / speed, {
          ease: Sine.easeInOut,
          translateX: 0,
          rotateY: 0
        });
        animate.to(view.animationParams, 2 / speed, {
          delay: 0.5 / speed,
          ease: Sine.easeOut,
          opacity: 1,
          translateZ: 0
        });
        return animate.play();
      },
      centerRight: function(view, done) {
        var animate;
        if (!view.animationParams.opacity) {
          view.animationParams.opacity = 1;
        }
        if (!view.animationParams.translateZ) {
          view.animationParams.translateZ = 0;
        }
        if (!view.animationParams.translateX) {
          view.animationParams.translateX = 0;
        }
        if (!view.animationParams.rotateY) {
          view.animationParams.rotateY = 0;
        }
        view.$el.css({
          transformOrigin: "0 0"
        });
        animate = new TimelineMax({
          paused: true,
          onUpdate: function() {
            return view.$el.css({
              opacity: view.animationParams.opacity,
              transform: "translateZ(" + view.animationParams.translateZ + "px) translateX(" + view.animationParams.translateX + "%) rotateY(" + view.animationParams.rotateY + "deg)"
            });
          },
          onComplete: function() {
            return done();
          }
        });
        animate.to(view.animationParams, 1.6 / speed, {
          opacity: 1,
          translateZ: -180
        });
        animate.to(view.animationParams, 1.6 / speed, {
          ease: Sine.easeInOut,
          translateX: 105,
          rotateY: -30
        });
        animate.to(view.animationParams, 2 / speed, {
          delay: 0.5 / speed,
          ease: Sine.easeOut,
          translateZ: 0
        });
        return animate.play();
      },
      rightCenter: function(view) {
        var animate;
        if (!view.animationParams.opacity) {
          view.animationParams.opacity = 0;
        }
        if (!view.animationParams.translateZ) {
          view.animationParams.translateZ = 0;
        }
        if (!view.animationParams.translateX) {
          view.animationParams.translateX = 105;
        }
        if (!view.animationParams.rotateY) {
          view.animationParams.rotateY = -30;
        }
        view.$el.css({
          transformOrigin: "0 0"
        });
        animate = new TimelineMax({
          paused: true,
          onUpdate: function() {
            return view.$el.css({
              opacity: view.animationParams.opacity,
              transform: "translateZ(" + view.animationParams.translateZ + "px) translateX(" + view.animationParams.translateX + "%) rotateY(" + view.animationParams.rotateY + "deg)"
            });
          }
        });
        animate.to(view.animationParams, 1.6 / speed, {
          opacity: 1,
          translateZ: -180
        });
        animate.to(view.animationParams, 1.6 / speed, {
          ease: Sine.easeInOut,
          translateX: 0,
          rotateY: 0
        });
        animate.to(view.animationParams, 2 / speed, {
          delay: 0.5 / speed,
          ease: Sine.easeOut,
          translateZ: 0
        });
        return animate.play();
      }
    };
  });

}).call(this);
