local M = {}

local cache = {}

local function tokenize(d)
  local tokens = {}
  local i, len = 1, #d

  while i <= len do
    local ch = d:sub(i, i)
    if ch:match("^[%s,]$") then
      i = i + 1
    elseif ch:match("^[a-zA-Z]$") then
      table.insert(tokens, { type = "c", val = ch })
      i = i + 1
    elseif ch:match("^[%d%.%-]$") then
      local start = i
      local has_dot = false
      if ch == "-" then
        i = i + 1
      elseif ch == "." then
        has_dot = true
        i = i + 1
      else
        i = i + 1
      end
      while i <= len do
        local nc = d:sub(i, i)
        if nc:match("^%d$") then
          i = i + 1
        elseif nc == "." then
          if has_dot then
            break
          end
          has_dot = true
          i = i + 1
        else
          break
        end
      end
      local num = tonumber(d:sub(start, i - 1))
      if num then
        table.insert(tokens, { type = "n", val = num })
      end
    else
      i = i + 1
    end
  end
  return tokens
end

local function parse(tokens)
  local cmds = {}
  local i, n = 1, #tokens
  while i <= n do
    if tokens[i].type == "c" then
      local c = tokens[i].val
      i = i + 1
      if c:match("^[Mm]$") then
        local rel = c == "m"
        local first = true
        while i <= n and tokens[i].type == "n" do
          local x, y = tokens[i].val, tokens[i + 1] and tokens[i + 1].val
          if not y then break end
          i = i + 2
          if rel then
            local prev = cmds[#cmds]
            local px, py = 0, 0
            if prev and prev.args and #prev.args >= 2 then
              px, py = prev.args[#prev.args - 1], prev.args[#prev.args]
            end
            x, y = px + x, py + y
          end
          if first then
            table.insert(cmds, { cmd = "M", args = { x, y } })
            first = false
          else
            table.insert(cmds, { cmd = "L", args = { x, y } })
          end
        end
      elseif c:match("^[Ll]$") then
        local rel = c == "l"
        while i <= n and tokens[i].type == "n" do
          local x, y = tokens[i].val, tokens[i + 1] and tokens[i + 1].val
          if not y then break end
          i = i + 2
          if rel then
            local prev = cmds[#cmds]
            local px, py = 0, 0
            if prev and prev.args and #prev.args >= 2 then
              px, py = prev.args[#prev.args - 1], prev.args[#prev.args]
            end
            x, y = px + x, py + y
          end
          table.insert(cmds, { cmd = "L", args = { x, y } })
        end
      elseif c:match("^[Hh]$") then
        local rel = c == "h"
        while i <= n and tokens[i].type == "n" do
          local x = tokens[i].val
          i = i + 1
          if rel then
            local prev = cmds[#cmds]
            local px = 0
            if prev and prev.args and #prev.args >= 2 then
              px = prev.args[#prev.args - 1]
            end
            x = px + x
          end
          local prev = cmds[#cmds]
          local py = 0
          if prev and prev.args and #prev.args >= 2 then
            py = prev.args[#prev.args]
          end
          table.insert(cmds, { cmd = "L", args = { x, py } })
        end
      elseif c:match("^[Vv]$") then
        local rel = c == "v"
        while i <= n and tokens[i].type == "n" do
          local y = tokens[i].val
          i = i + 1
          if rel then
            local prev = cmds[#cmds]
            local py = 0
            if prev and prev.args and #prev.args >= 2 then
              py = prev.args[#prev.args]
            end
            y = py + y
          end
          local prev = cmds[#cmds]
          local px = 0
          if prev and prev.args and #prev.args >= 2 then
            px = prev.args[#prev.args - 1]
          end
          table.insert(cmds, { cmd = "L", args = { px, y } })
        end
      elseif c:match("^[Cc]$") then
        local rel = c == "c"
        while i <= n and tokens[i].type == "n" do
          local x1 = tokens[i].val
          local y1 = tokens[i + 1] and tokens[i + 1].val
          local x2 = tokens[i + 2] and tokens[i + 2].val
          local y2 = tokens[i + 3] and tokens[i + 3].val
          local x = tokens[i + 4] and tokens[i + 4].val
          local y = tokens[i + 5] and tokens[i + 5].val
          if not y then break end
          i = i + 6
          local prev = cmds[#cmds]
          local px, py = 0, 0
          if prev and prev.args and #prev.args >= 2 then
            px, py = prev.args[#prev.args - 1], prev.args[#prev.args]
          end
          if rel then
            x1, y1 = px + x1, py + y1
            x2, y2 = px + x2, py + y2
            x, y = px + x, py + y
          end
          table.insert(cmds, { cmd = "C", args = { x1, y1, x2, y2, x, y } })
        end
      elseif c:match("^[Aa]$") then
        local rel = c == "a"
        while i <= n and tokens[i].type == "n" do
          local rx = tokens[i].val
          local ry = tokens[i + 1] and tokens[i + 1].val
          local rot = tokens[i + 2] and tokens[i + 2].val
          local laf = tokens[i + 3] and tokens[i + 3].val
          local sf = tokens[i + 4] and tokens[i + 4].val
          local x = tokens[i + 5] and tokens[i + 5].val
          local y = tokens[i + 6] and tokens[i + 6].val
          if not y then break end
          i = i + 7
          if rel then
            local prev = cmds[#cmds]
            local px, py = 0, 0
            if prev and prev.args and #prev.args >= 2 then
              px, py = prev.args[#prev.args - 1], prev.args[#prev.args]
            end
            x, y = px + x, py + y
          end
          table.insert(cmds, { cmd = "A", args = { rx, ry, rot, laf, sf, x, y } })
        end
      elseif c:match("^[Zz]$") then
        table.insert(cmds, { cmd = "Z", args = {} })
      end
    else
      i = i + 1
    end
  end
  return cmds
end

local function flatten_bezier(x1, y1, cx1, cy1, cx2, cy2, x2, y2, segs)
  local mx, my = (x1 + x2) / 2, (y1 + y2) / 2
  local p01x, p01y = (x1 + cx1) / 2, (y1 + cy1) / 2
  local p12x, p12y = (cx1 + cx2) / 2, (cy1 + cy2) / 2
  local p23x, p23y = (cx2 + x2) / 2, (cy2 + y2) / 2
  local p012x, p012y = (p01x + p12x) / 2, (p01y + p12y) / 2
  local p123x, p123y = (p12x + p23x) / 2, (p12y + p23y) / 2
  local p0123x, p0123y = (p012x + p123x) / 2, (p012y + p123y) / 2
  local dx, dy = p0123x - mx, p0123y - my
  if dx * dx + dy * dy < 0.25 then
    table.insert(segs, { x1 = x1, y1 = y1, x2 = x2, y2 = y2 })
  else
    flatten_bezier(x1, y1, p01x, p01y, p012x, p012y, p0123x, p0123y, segs)
    flatten_bezier(p0123x, p0123y, p123x, p123y, p23x, p23y, x2, y2, segs)
  end
end

local function arc_point(cx, cy, rx, ry, cos_phi, sin_phi, t)
  local x = cx + cos_phi * rx * math.cos(t) - sin_phi * ry * math.sin(t)
  local y = cy + sin_phi * rx * math.cos(t) + cos_phi * ry * math.sin(t)
  return x, y
end

local function arc_to_segments(x1, y1, rx, ry, phi, fA, fS, x2, y2, segs)
  if rx == 0 or ry == 0 then
    table.insert(segs, { x1 = x1, y1 = y1, x2 = x2, y2 = y2 })
    return
  end
  rx, ry = math.abs(rx), math.abs(ry)
  local sin_phi, cos_phi = math.sin(phi), math.cos(phi)
  local dx = (x1 - x2) / 2
  local dy = (y1 - y2) / 2
  local x1p = cos_phi * dx + sin_phi * dy
  local y1p = -sin_phi * dx + cos_phi * dy
  local lam = (x1p * x1p) / (rx * rx) + (y1p * y1p) / (ry * ry)
  if lam > 1 then
    local s = math.sqrt(lam)
    rx, ry = rx * s, ry * s
  end
  local rx2, ry2 = rx * rx, ry * ry
  local s = (rx2 * ry2 - rx2 * y1p * y1p - ry2 * x1p * x1p) / (rx2 * y1p * y1p + ry2 * x1p * x1p)
  if s < 0 then s = 0 end
  local sq = math.sqrt(s)
  if fA == fS then sq = -sq end
  local cxp = sq * rx * y1p / ry
  local cyp = -sq * ry * x1p / rx
  local cx = cos_phi * cxp - sin_phi * cyp + (x1 + x2) / 2
  local cy = sin_phi * cxp + cos_phi * cyp + (y1 + y2) / 2
  local ux = (x1p - cxp) / rx
  local uy = (y1p - cyp) / ry
  local vx = (-x1p - cxp) / rx
  local vy = (-y1p - cyp) / ry
  local start_angle = math.atan2(uy, ux)
  local end_angle = math.atan2(vy, vx)
  local delta = end_angle - start_angle
  if fS == 1 and delta < 0 then
    delta = delta + 2 * math.pi
  elseif fS == 0 and delta > 0 then
    delta = delta - 2 * math.pi
  end
  local nsegs = math.max(4, math.ceil(math.abs(delta) / (math.pi / 4)))
  local prev_x, prev_y = x1, y1
  for i = 1, nsegs do
    local t = start_angle + delta * i / nsegs
    local px, py = arc_point(cx, cy, rx, ry, cos_phi, sin_phi, t)
    table.insert(segs, { x1 = prev_x, y1 = prev_y, x2 = px, y2 = py })
    prev_x, prev_y = px, py
  end
end

local function to_segments(cmds)
  local segs = {}
  local cx, cy = 0, 0
  local sx, sy = 0, 0
  for _, cmd in ipairs(cmds) do
    if cmd.cmd == "M" then
      cx, cy = cmd.args[1], cmd.args[2]
      sx, sy = cx, cy
    elseif cmd.cmd == "L" then
      local nx, ny = cmd.args[1], cmd.args[2]
      table.insert(segs, { x1 = cx, y1 = cy, x2 = nx, y2 = ny })
      cx, cy = nx, ny
    elseif cmd.cmd == "C" then
      local a = cmd.args
      flatten_bezier(cx, cy, a[1], a[2], a[3], a[4], a[5], a[6], segs)
      cx, cy = a[5], a[6]
    elseif cmd.cmd == "A" then
      local a = cmd.args
      arc_to_segments(cx, cy, a[1], a[2], a[3], a[4], a[5], a[6], a[7], segs)
      cx, cy = a[6], a[7]
    elseif cmd.cmd == "Z" then
      if cx ~= sx or cy ~= sy then
        table.insert(segs, { x1 = cx, y1 = cy, x2 = sx, y2 = sy })
        cx, cy = sx, sy
      end
    end
  end
  return segs
end

local function inside(px, py, segs)
  local hit = false
  for _, s in ipairs(segs) do
    local x1, y1, x2, y2 = s.x1, s.y1, s.x2, s.y2
    if (y1 > py) ~= (y2 > py) then
      local xi = x1 + (x2 - x1) * (py - y1) / (y2 - y1)
      if px < xi then
        hit = not hit
      end
    end
  end
  return hit
end

local function ellipse_to_path(cx, cy, rx, ry, n)
  local parts = {}
  for i = 0, n - 1 do
    local a = 2 * math.pi * i / n
    local x = cx + rx * math.cos(a)
    local y = cy + ry * math.sin(a)
    if i == 0 then
      table.insert(parts, "M " .. x .. " " .. y)
    else
      table.insert(parts, "L " .. x .. " " .. y)
    end
  end
  table.insert(parts, "Z")
  return table.concat(parts, " ")
end

local function line_to_path(x1, y1, x2, y2, sw)
  local dx, dy = x2 - x1, y2 - y1
  local len = math.sqrt(dx * dx + dy * dy)
  if len < 0.001 then
    sw = sw or 1
    local r = sw / 2
    return "M " .. (x1 - r) .. " " .. (y1 - r) .. " L " .. (x1 + r) .. " " .. (y1 - r) .. " L " .. (x1 + r) .. " " .. (y1 + r) .. " L " .. (x1 - r) .. " " .. (y1 + r) .. " Z"
  end
  local hw = (sw or 1) / 2
  local nx = -dy / len * hw
  local ny = dx / len * hw
  return "M " .. (x1 + nx) .. " " .. (y1 + ny) .. " L " .. (x2 + nx) .. " " .. (y2 + ny) .. " L " .. (x2 - nx) .. " " .. (y2 - ny) .. " L " .. (x1 - nx) .. " " .. (y1 - ny) .. " Z"
end

local function rounded_rect_path(x, y, w, h, rx)
  if not rx or rx <= 0 then
    return "M " .. x .. " " .. y .. " L " .. (x + w) .. " " .. y .. " L " .. (x + w) .. " " .. (y + h) .. " L " .. x .. " " .. (y + h) .. " Z"
  end
  local r = rx
  if r > w / 2 then r = w / 2 end
  if r > h / 2 then r = h / 2 end
  return "M " .. (x + r) .. " " .. y
    .. " L " .. (x + w - r) .. " " .. y
    .. " A " .. r .. " " .. r .. " 0 0 1 " .. (x + w) .. " " .. (y + r)
    .. " L " .. (x + w) .. " " .. (y + h - r)
    .. " A " .. r .. " " .. r .. " 0 0 1 " .. (x + w - r) .. " " .. (y + h)
    .. " L " .. (x + r) .. " " .. (y + h)
    .. " A " .. r .. " " .. r .. " 0 0 1 " .. x .. " " .. (y + h - r)
    .. " L " .. x .. " " .. (y + r)
    .. " A " .. r .. " " .. r .. " 0 0 1 " .. (x + r) .. " " .. y
    .. " Z"
end

local function attr(tag, name)
  local v = tag:match(name .. '="(.-)"')
  if not v then v = tag:match(name .. "='(.-)'") end
  return v
end

local function has_visible_fill(tag)
  local fill = attr(tag, "fill")
  return fill and fill ~= "none"
end

local function has_visible_stroke(tag)
  local stroke = attr(tag, "stroke")
  return stroke and stroke ~= "none"
end

local function parse_svg(xml)
  local vw, vh = 16, 16
  local vb = xml:match('viewBox="(.-)"')
  if vb then
    local a, b, c, d = vb:match("([%-%d%.]+)%s+([%-%d%.]+)%s+([%-%d%.]+)%s+([%-%d%.]+)")
    if d then
      vw, vh = tonumber(c), tonumber(d)
    end
  end
  local paths = {}

  for tag in xml:gmatch('<path[^>]*/>') do
    local d = attr(tag, "d")
    if d and (has_visible_fill(tag) or has_visible_stroke(tag)) then
      local opa_str = tag:match('fill%-opacity="(.-)"')
      if not opa_str then opa_str = tag:match("fill%-opacity='(.-)'") end
      local opa = opa_str and tonumber(opa_str) or 1.0
      if not d:match("Z%s*$") then d = d .. " Z" end
      table.insert(paths, { d = d, opacity = opa })
    end
  end

  for tag in xml:gmatch('<line[^>]*/>') do
    local x1, y1 = attr(tag, "x1"), attr(tag, "y1")
    local x2, y2 = attr(tag, "x2"), attr(tag, "y2")
    local sw = attr(tag, "stroke%-width")
    if x1 and y1 and x2 and y2 and has_visible_stroke(tag) then
      table.insert(paths, { d = line_to_path(tonumber(x1), tonumber(y1), tonumber(x2), tonumber(y2), tonumber(sw or 1)), opacity = 1.0 })
    end
  end

  for tag in xml:gmatch('<circle[^>]*/>') do
    local cx, cy, r = attr(tag, "cx"), attr(tag, "cy"), attr(tag, "r")
    if cx and cy and r and (has_visible_fill(tag) or has_visible_stroke(tag)) then
      table.insert(paths, { d = ellipse_to_path(tonumber(cx), tonumber(cy), tonumber(r), tonumber(r), 8), opacity = 1.0 })
    end
  end

  for tag in xml:gmatch('<ellipse[^>]*/>') do
    local cx, cy, rx, ry = attr(tag, "cx"), attr(tag, "cy"), attr(tag, "rx"), attr(tag, "ry")
    if cx and cy and rx and ry and (has_visible_fill(tag) or has_visible_stroke(tag)) then
      table.insert(paths, { d = ellipse_to_path(tonumber(cx), tonumber(cy), tonumber(rx), tonumber(ry), 8), opacity = 1.0 })
    end
  end

  for tag in xml:gmatch('<rect[^>]*/>') do
    local x, y, w, h = attr(tag, "x"), attr(tag, "y"), attr(tag, "width"), attr(tag, "height")
    local rx = attr(tag, "rx")
    if x and y and w and h and (has_visible_fill(tag) or has_visible_stroke(tag)) then
      table.insert(paths, { d = rounded_rect_path(tonumber(x), tonumber(y), tonumber(w), tonumber(h), rx and tonumber(rx) or 0), opacity = 1.0 })
    end
  end

  for tag in xml:gmatch('<polygon[^>]*/>') do
    local pts = attr(tag, "points")
    if pts and (has_visible_fill(tag) or has_visible_stroke(tag)) then
      local parts = {}
      local first = true
      for x, y in pts:gmatch("([%d%.%-]+)[%s,]+([%d%.%-]+)") do
        if first then
          table.insert(parts, "M " .. x .. " " .. y)
          first = false
        else
          table.insert(parts, "L " .. x .. " " .. y)
        end
      end
      table.insert(parts, "Z")
      table.insert(paths, { d = table.concat(parts, " "), opacity = 1.0 })
    end
  end

  for tag in xml:gmatch('<polyline[^>]*/>') do
    local pts = attr(tag, "points")
    if pts and (has_visible_fill(tag) or has_visible_stroke(tag)) then
      local parts = {}
      local first = true
      for x, y in pts:gmatch("([%d%.%-]+)[%s,]+([%d%.%-]+)") do
        if first then
          table.insert(parts, "M " .. x .. " " .. y)
          first = false
        else
          table.insert(parts, "L " .. x .. " " .. y)
        end
      end
      table.insert(paths, { d = table.concat(parts, " "), opacity = 1.0 })
    end
  end

  return paths, vw, vh
end

local function download(url)
  local tmp = vim.fn.tempname()
  vim.fn.system({ "curl", "-sfL", "-o", tmp, url })
  if vim.v.shell_error ~= 0 then
    os.remove(tmp)
    return nil
  end
  local content = vim.fn.readfile(tmp)
  os.remove(tmp)
  return table.concat(content, "\n")
end

local function rasterize(paths, gw, gh, vw, vh)
  local grid = {}
  for y = 0, gh - 1 do
    grid[y] = {}
    for x = 0, gw - 1 do
      grid[y][x] = 0
    end
  end

  for _, p in ipairs(paths) do
    local toks = tokenize(p.d)
    local cmds = parse(toks)
    local segs = to_segments(cmds)
    local ss = 2

    for sy = 0, gh * ss - 1 do
      for sx = 0, gw * ss - 1 do
        local vx = (sx + 0.5) / (gw * ss) * vw
        local vy = (sy + 0.5) / (gh * ss) * vh
        if inside(vx, vy, segs) then
          local gx = math.floor(sx / ss)
          local gy = math.floor(sy / ss)
          grid[gy][gx] = grid[gy][gx] + p.opacity / (ss * ss)
        end
      end
    end
  end

  for y = 0, gh - 1 do
    for x = 0, gw - 1 do
      grid[y][x] = math.min(1, grid[y][x])
    end
  end

  local chars = { " ", "▓", "█" }
  local lines = {}
  for y = 0, gh - 1 do
    local line = {}
    for x = 0, gw - 1 do
      local idx = math.floor(grid[y][x] * 2) + 1
      line[x + 1] = chars[idx]
    end
    lines[y + 1] = table.concat(line)
  end
  return lines
end

function M.get_icon(url, opts)
  opts = opts or {}
  local w = opts.width or 24
  local h = opts.height or 12
  local key = url .. ":" .. w .. "x" .. h
  if cache[key] then
    return cache[key]
  end
  local xml = download(url)
  if not xml then return nil end
  local paths, vw, vh = parse_svg(xml)
  if #paths == 0 then return nil end
  local lines = rasterize(paths, w, h, vw, vh)
  cache[key] = lines
  return lines
end

return M
