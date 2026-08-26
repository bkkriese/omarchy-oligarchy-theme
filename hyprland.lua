local active_border_color = "rgb(c9a227)"
local active_shadow_color = "rgb(c9a227)"
local inactive_border_color = "rgba(8a817299)"
local inactive_shadow_color = "rgba(0e0d0b77)"

hl.config({
  general = {
    col = {
      active_border = active_border_color,
      inactive_border = inactive_border_color,
    }
  },

  group = {
    col = {
      border_active = active_border_color,
      border_inactive = inactive_border_color,
    },
  },

  decoration = {
    shadow = {
      enabled = true,
      range = 6,
      render_power = 4,
      color = active_shadow_color,
      color_inactive = inactive_shadow_color,
    },
  },
})
