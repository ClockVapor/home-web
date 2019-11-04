socket = require "socket"
colors = require "colors"
import stringGroup, reverse, hexStrToBinaryStr from require "utils"
local *

on = (ips, transitionMs = 0) ->
  header = "2A0000340000000000000000000000000000000000000000000000000000000075000000"
  payload = "FFFF" .. intToHexStrLittleEndian(transitionMs, 8)
  sendPackets(ips, header .. payload)

off = (ips, transitionMs = 0) ->
  header = "2A0000340000000000000000000000000000000000000000000000000000000075000000"
  payload = "0000" .. intToHexStrLittleEndian(transitionMs, 8)
  sendPackets(ips, header .. payload)

set = (ips, color, transitionMs = 0) ->
  header = "310000340000000000000000000000000000000000000000000000000000000066000000"
  payload = "00" .. colorStrToHexStr(color) .. intToHexStrLittleEndian(transitionMs, 8)
  sendPackets(ips, header .. payload)

sendPackets = (ips, data) ->
  msg = hexStrToBinaryStr(data)
  udp = assert(socket.udp!)
  for ip in *ips
    udp\sendto(msg, ip, "56700")
  udp\close!

colorStrToHexStr = (s) ->
  c = colors.new("#" .. s)
  r, g, b = colors.hsl_to_rgb(c.H, c.S, c.L)
  cMax = math.max(r, g, b)
  cMin = math.min(r, g, b)
  hueHexStr = intToHexStrLittleEndian(math.ceil(c.H / 360 * 65535), 4)
  saturationHexStr = intToHexStrLittleEndian(math.ceil((if cMax == 0 then 0 else (cMax - cMin) / cMax) * 65535), 4)
  lightnessHexStr = intToHexStrLittleEndian(math.ceil(cMax * 65535), 4)
  hueHexStr .. saturationHexStr .. lightnessHexStr .. "AC0D"

intToHexStrLittleEndian = (n, length = 8) ->
  table.concat(reverse(stringGroup(string.format("%0" .. length .. "x", n), 2)))

{ :on, :off, :set }
