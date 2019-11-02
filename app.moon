lapis = require "lapis"
import respond_to from require "lapis.application"
socket = require "socket"
import getKeys, map, filterWithIndex, contains from require "utils"
lifx = require "lifx"
yaml = require "yaml"
inspect = require "inspect"
lfs = require "lfs"

class extends lapis.Application
  @enable "etlua"
  @before_filter =>
    @app\loadLights!

  layout: "layout"

  loadLights: =>
    path = "lights.yml"
    attributes = lfs.attributes(path)
    if not @lightsReadTime or attributes.modification > @lightsReadTime or not @lights
      print path .. " modified since last read. Reading it again..."
      @lightsReadTime = attributes.modification
      f = io.open(path, "r")
      content = f\read("*a")
      @lights = yaml.load(content)
      f\close!

  [index: "/"]: =>
    render: true

  [lights: "/lights"]: respond_to {
    GET: =>
      render: true

    POST: =>
      @session.selectedLights = @params.selectedLights
      @session.lightColor = @params.color
      @session.transitionMs = @params.transitionMs

      selectedLightIps = @app\parseSelectedLightIps(@params)
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

  parseSelectedLightIps: (params) =>
    indices = map(getKeys(params.selectedLights or {}), tonumber)
    map(
      filterWithIndex(@lights, (i, v) -> contains(indices, i)),
      (it) -> it.ip
    )

