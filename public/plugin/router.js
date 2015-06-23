(function() {
  var hasProp = {}.hasOwnProperty;

  define(function() {
    var Route;
    return Route = (function() {
      var State, StatesComposition, StatesContainer, StatesCoordinator, _find, _parseNested;

      _parseNested = function(config, selectorCallback, viewCallback, settings) {
        var results, selectorCallbackResult, selectorName, selectorViews, viewName, viewSetting;
        results = [];
        for (selectorName in config) {
          if (!hasProp.call(config, selectorName)) continue;
          selectorViews = config[selectorName];
          selectorCallbackResult = selectorCallback(selectorName, selectorViews, settings);
          results.push((function() {
            var results1;
            results1 = [];
            for (viewName in selectorViews) {
              if (!hasProp.call(selectorViews, viewName)) continue;
              viewSetting = selectorViews[viewName];
              results1.push(viewCallback(viewName, viewSetting, function(config, settings) {
                return _parseNested(config, selectorCallback, viewCallback, settings);
              }, selectorCallbackResult));
            }
            return results1;
          })());
        }
        return results;
      };

      _find = function(findObject, findSelectorName, findViewName, findCallback) {
        return _parseNested(findObject, function(selectorName, selectorSettings) {
          if (findSelectorName === selectorName) {
            return true;
          }
        }, function(viewName, viewSetting, next, selectorCondition) {
          if (selectorCondition && findViewName === viewName) {
            return findCallback(viewSetting);
          } else if (viewSetting.childrens) {
            return next(viewSetting.childrens);
          }
        });
      };

      State = (function() {
        function State(setting) {
          this.url = setting.url;
          this.init = setting.init;
          this.update = setting.update;
          this.destroy = setting.destroy;
          this.cache = null;
          this.view = null;
        }

        State.prototype.get = function(callback) {
          if (!this.view) {
            return require(this.url, function(loadedView) {
              return callback(this.view = this.init(loadedView));
            });
          } else {
            return callback(this.view);
          }
        };

        return State;

      })();

      StatesComposition = (function() {
        function StatesComposition() {}

        StatesComposition.prototype.add = function(nameState, stateObject) {
          return this[nameState] = stateObject;
        };

        StatesComposition.prototype.get = function(stateName) {
          var i, len, ref, state;
          ref = this.states;
          for (i = 0, len = ref.length; i < len; i++) {
            state = ref[i];
            if (state.name === stateName) {
              return state;
            }
          }
        };

        return StatesComposition;

      })();

      StatesContainer = (function() {
        function StatesContainer(config) {
          _parseNested(config, function(selectorName, selectorSettings, settings) {
            delete selectorSettings.animations;
            return settings.container[selectorName] = new StatesComposition;
          }, function(viewName, viewSetting, next, statesComposition) {
            var state;
            state = new State(viewSetting);
            statesComposition.add(viewName, state);
            if (viewSetting.childrens) {
              state.childrens = {};
              return next(viewSetting.childrens, {
                container: state.childrens
              });
            }
          }, {
            container: this
          });
        }

        return StatesContainer;

      })();

      StatesCoordinator = (function() {
        var _checkReplecement, _checkState, _checkUpdate, _findActiveView;

        _checkState = function(checkedSelectors, checkSelectorName, checkViewName) {
          var selectorName, selectorViews, viewName, viewSettings;
          for (selectorName in checkedSelectors) {
            selectorViews = checkedSelectors[selectorName];
            for (viewName in selectorViews) {
              viewSettings = selectorViews[viewName];
              if (checkSelectorName === selectorName && checkViewName === viewName) {
                return true;
              }
              if (viewSettings.childrens) {
                return _checkState(viewSettings.childrens, checkSelectorName, checkViewName);
              }
            }
          }
        };

        _findActiveView = function(findedSelector) {
          var viewName, viewSettings;
          for (viewName in findedSelector) {
            if (!hasProp.call(findedSelector, viewName)) continue;
            viewSettings = findedSelector[viewName];
            if (viewSettings.status === "first time" || viewSettings.status === "new") {
              return viewName;
            }
          }
        };

        _checkReplecement = function(checkedSelectors) {
          var viewName, viewSettings;
          for (viewName in checkedSelectors) {
            if (!hasProp.call(checkedSelectors, viewName)) continue;
            viewSettings = checkedSelectors[viewName];
            if (viewSettings.status === "new") {
              return viewName;
            }
          }
        };

        _checkUpdate = (function() {
          var viewsCache;
          viewsCache = {};
          return function(checkedSelectors, checkSelectorName, checkViewName) {
            var cacheName, newUpdate, oldUpdate, selectorName, selectorViews, viewName, viewSettings;
            for (selectorName in checkedSelectors) {
              selectorViews = checkedSelectors[selectorName];
              for (viewName in selectorViews) {
                viewSettings = selectorViews[viewName];
                if (checkSelectorName === selectorName && checkViewName === viewName && viewSettings.update) {
                  cacheName = checkSelectorName + ":" + checkViewName;
                  oldUpdate = viewsCache[cacheName];
                  newUpdate = viewsCache[cacheName] = JSON.stringify(viewSettings.update);
                  if (oldUpdate !== newUpdate) {
                    return true;
                  }
                }
                if (viewSettings.childrens) {
                  return _checkUpdate(viewSettings.childrens, checkSelectorName, checkViewName);
                }
              }
            }
          };
        })();

        function StatesCoordinator(config) {
          _parseNested(config, function(selectorName, selectorSettings, settings) {
            return settings.container[selectorName] = {};
          }, function(viewName, viewSetting, next, selectorConteiner) {
            selectorConteiner[viewName] = {
              status: "unused"
            };
            if (viewSetting.childrens) {
              selectorConteiner[viewName].childrens = {};
              return next(viewSetting.childrens, {
                container: selectorConteiner[viewName].childrens
              });
            }
          }, {
            container: this
          });
        }

        StatesCoordinator.prototype.createCoordinte = function(update) {
          _parseNested(this, function(selectorName, selectorSettings, settings) {
            return {
              name: selectorName,
              activeViewName: _findActiveView(selectorSettings, selectorName)
            };
          }, function(viewName, viewSetting, next, selectorSettings) {
            var updated;
            if (_checkState(update, selectorSettings.name, viewName)) {
              updated = _checkUpdate(update, selectorSettings.name, viewName);
              if (viewSetting.status === "unused" && !selectorSettings.activeViewName) {
                viewSetting.status = "first time";
              } else if (selectorSettings.activeViewName && selectorSettings.activeViewName !== viewName) {
                viewSetting.status = "new";
              } else if (selectorSettings.activeViewName === viewName) {
                if (updated) {
                  viewSetting.status = "update";
                } else {
                  viewSetting.status = "hold visible";
                }
              }
            }
            if (viewSetting.childrens) {
              return next(viewSetting.childrens);
            }
          });
          return _parseNested(this, function(selectorName, selectorSettings, settings) {
            return {
              name: selectorName,
              replacementName: _checkReplecement(selectorSettings),
              activeViewName: _findActiveView(selectorSettings, selectorName)
            };
          }, function(viewName, viewSetting, next, selectorSettings) {
            if (!_checkState(update, selectorSettings.name, viewName)) {
              if (selectorSettings.activeViewName === viewName && viewSetting.status === "first time" || viewSetting.status === "new" || viewSetting.status === "hold") {
                if (selectorSettings.replacementName && selectorSettings.replacementName !== viewName) {
                  viewSetting.status = "old";
                } else {
                  viewSetting.status = "last";
                }
              } else if (viewSetting.status === "old" || viewSetting.status === "last") {
                viewSetting.status = "hold invisible";
              }
            }
            if (viewSetting.childrens) {
              return next(viewSetting.childrens);
            }
          });
        };

        return StatesCoordinator;

      })();

      function Route(config) {
        this.states = new StatesContainer(config);
        this.coordinator = new StatesCoordinator(config);
      }

      Route.prototype.go = function(requiredState) {
        return this.coordinator.createCoordinte(requiredState);
      };

      return Route;

    })();
  });

}).call(this);
