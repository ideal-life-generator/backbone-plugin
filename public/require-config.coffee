require.config
  paths:
    text: "libs/text"
    app: "app"

require [
  "app"
]

$.prototype.cloneElement = ($element) -> $(@[0].cloneNode())

_.templateSettings.interpolate = /\{(.+?)\}/g