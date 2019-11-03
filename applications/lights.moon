lapis = require "lapis"
import respond_to from require "lapis.application"
lifx = require "lifx"
yaml = require "yaml"
import getKeys, map, filterWithIndex, contains from require "utils"

loadLights = ->
  f = io.open("lights.yml", "r")
  content = f\read("*a")
  lights = yaml.load(content)
  f\close!
  lights

lights = loadLights! -- load on startup

parseSelectedLightIps = (params) ->
  indices = map(getKeys(params.selectedLights or {}), tonumber)
  map(
    filterWithIndex(lights, (i, v) -> contains(indices, i)),
    (it) -> it.ip
  )

class LightsApplication extends lapis.Application
  @before_filter =>
    @lights = lights

  [lights: "/lights"]: respond_to {
    GET: =>
      render: true

    POST: =>
      @session.selectedLights = @params.selectedLights
      @session.lightColor = @params.color
      @session.transitionMs = @params.transitionMs

      selectedLightIps = parseSelectedLightIps(@params)
      switch @params.action
        when "On"
          lifx.on(selectedLightIps, @params.transitionMs or 0)
        when "Off"
          lifx.off(selectedLightIps, @params.transitionMs or 0)
        when "Set"
          lifx.set(selectedLightIps, @params.color, @params.transitionMs or 0)
        else
          error "Unknown action: " .. (@params.action or "nil")

      redirect_to: @url_for "lights"
  }
