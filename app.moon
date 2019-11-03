lapis = require "lapis"

class extends lapis.Application
  @enable "etlua"
  @include "applications.lights"
  layout: "layout"

  [index: "/"]: =>
    render: true
