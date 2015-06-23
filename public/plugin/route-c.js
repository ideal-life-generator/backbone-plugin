(function() {
  var hasProp = {}.hasOwnProperty;

  define(function() {

    /*
    
    Модель роутинга:
     */

    /*
    
    1) Главный контролирующий загрузки и анимации объект:
      1) Берет объект каллбеков загрузки и пользуется им;
      2) Берет объект каллбеков анимаций и пользуется им;
     */
    var Router;
    return Router = (function() {

      /*
      
      2) На основе конфига создается классы с видами:
        1) Хранятся в общем объекте коллекции под уникальным именем;
       */
      var AnimationsController, LoadManager, RouterCoordinator, State, StatesCollection;

      State = (function() {
        function State(url, position, init, update, destroy) {
          this.url = url;
          this.position = position;
          this.init = init;
          this.update = update;
          this.destroy = destroy;
          this.instance = null;
          this.view = null;
        }

        State.prototype.get = function() {
          return this.view;
        };

        return State;

      })();

      StatesCollection = (function() {
        function StatesCollection(statesConfig) {
          var stateConfig, stateName;
          for (stateName in statesConfig) {
            stateConfig = statesConfig[stateName];
            this[stateName] = new State(stateConfig.url, stateConfig.position, stateConfig.init, stateConfig.update, stateConfig.destroy);
          }
        }

        StatesCollection.prototype.find = function(requiredStateName) {
          var stateConfig, stateName;
          for (stateName in this) {
            if (!hasProp.call(this, stateName)) continue;
            stateConfig = this[stateName];
            if (requiredStateName === stateName) {
              return stateConfig;
            }
          }
        };

        return StatesCollection;

      })();


      /*
      
      3) Объект предоставляющий текущее состояние роутера:
        1) Хранит и обновляет текущее состояние роутера;
       */

      RouterCoordinator = (function() {
        var _differentActive, _isReplecement, _updatedParams;

        _updatedParams = (function() {
          var params;
          params = {};
          return function(stateName, stateParams) {
            var stateParamsJson;
            stateParamsJson = JSON.stringify(stateParams);
            if (params[stateName] !== stateParamsJson) {
              params[stateName] = stateParamsJson;
              return true;
            }
          };
        })();

        _differentActive = function(config, findedStateName) {
          var findedSelector, stateIndex, stateName;
          findedSelector = findedStateName.slice(findedStateName, findedStateName.lastIndexOf(":"));
          for (stateName in config) {
            stateIndex = config[stateName];
            if (findedStateName !== stateName && stateName.indexOf(findedSelector) !== -1 && stateName.indexOf(">", findedSelector.length) === -1 && stateIndex === "first" || stateIndex === "new" || stateIndex === "hold" || stateIndex === "update") {
              return true;
            }
          }
        };

        _isReplecement = function(config, findedStateName) {
          var findedSelector, stateIndex, stateName;
          findedSelector = findedStateName.slice(findedStateName, findedStateName.lastIndexOf(":"));
          for (stateName in config) {
            stateIndex = config[stateName];
            if (findedStateName !== stateName && stateName.indexOf(findedSelector) !== -1 && stateName.indexOf(">", findedSelector.length) === -1 && stateIndex === "new") {
              return true;
            }
          }
        };

        function RouterCoordinator(statesConfig) {
          var stateConfig, stateName;
          this.config = {};
          for (stateName in statesConfig) {
            stateConfig = statesConfig[stateName];
            this.config[stateName] = "unused";
          }
        }

        RouterCoordinator.prototype.update = function(requiredStates) {
          var currentStateParam, differentActive, ref, requiredStateName, requiredStateParams, stateName, stateStatus, updatedParams;
          for (requiredStateName in requiredStates) {
            requiredStateParams = requiredStates[requiredStateName];
            differentActive = _differentActive(this.config, requiredStateName);
            updatedParams = _updatedParams(requiredStateName, requiredStateParams);
            currentStateParam = this.config[requiredStateName];
            if (currentStateParam === "unused" && !differentActive) {
              this.config[requiredStateName] = "first";
            } else if (differentActive) {
              this.config[requiredStateName] = "new";
            } else if (!differentActive) {
              if (updatedParams) {
                this.config[requiredStateName] = "update";
              } else {
                this.config[requiredStateName] = "visible";
              }
            }
          }
          ref = this.config;
          for (stateName in ref) {
            stateStatus = ref[stateName];
            if (!(!requiredStates[stateName])) {
              continue;
            }
            differentActive = _differentActive(this.config, stateName);
            if (differentActive && stateStatus === "first" || stateStatus === "new" || stateStatus === "update" || stateStatus === "hold") {
              if (_isReplecement(this.config, stateName)) {
                this.config[stateName] = "old";
              } else {
                this.config[stateName] = "last";
              }
            } else if (this.config[stateName] === "old" || this.config[stateName] === "last") {
              this.config[stateName] = "invisible";
            }
          }
          return this.config;
        };

        return RouterCoordinator;

      })();


      /*
      
      4) Выстраивается два объекта каллбеков с зависимостями:
        1) Зависимости при загрузке от родительского;
        2) Зависимости от анимации родительского;
       */

      LoadManager = (function() {
        function LoadManager(config) {}

        return LoadManager;

      })();


      /*
      
      5) Анимационный движок:
        1) Хранит функции анимаций;
        2) Выполняет анимацию в зависимости от priority;
        3) Проверяет свойства alwaysRun и запускает анимации для дочерних;
        4) Проверяет свойство inOrder и проводит анимации в порядке;
       */

      AnimationsController = (function() {
        var lastAnimation;

        lastAnimation = {};

        function AnimationsController(config) {
          this.animations = config.animations;
          this.priorities = config.priorities;
          return function(animationName, requiredStateName, viewElement, done) {
            var animationParams, idName, results, stateName;
            idName = requiredStateName;
            results = [];
            for (stateName in this) {
              if (!hasProp.call(this, stateName)) continue;
              animationParams = this[stateName];
              if (requiredStateName === stateName) {
                switch (animationName) {
                  case "first":
                    animationParams.first(viewElement, done);
                    results.push(lastAnimation[stateName] = "first");
                    break;
                  case "old":
                    animationParams.first(viewElement, done);
                    results.push(lastAnimation[stateName] = "old");
                    break;
                  default:
                    results.push(void 0);
                }
              }
            }
            return results;
          };
        }

        return AnimationsController;

      })();

      function Router(statesConfig, animationsConfig) {
        this.statesCollection = new StatesCollection(statesConfig);
        this.routerCoordinator = new RouterCoordinator(statesConfig);
        this.animationsController = new AnimationsController(animationsConfig);
      }

      Router.prototype.go = function(requiredStates) {
        var newStateCoordinates;
        newStateCoordinates = this.routerCoordinator.update(requiredStates);
        return console.log(newStateCoordinates);
      };

      return Router;

    })();
  });

}).call(this);
