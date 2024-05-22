require("dijub.core")
require("dijub.lazy")
vim.opt.clipboard = 'unnamedplus'
if not vim.g.neovide then
	return {}
end

vim.o.guifont = "JetBrainsMono NF Medium:h12"

vim.g.neovide_floating_shadow = true
vim.g.neovide_floating_z_height = 10
vim.g.neovide_light_angle_degrees = 45
vim.g.neovide_light_radius = 5


vim.g.neovide_transparency = 0.85
vim.g.neovide_theme = 'dark'
vim.g.neovide_no_idle = true
vim.g.neovide_remember_window_size = true


vim.g.neovide_scroll_animation_length = 1

vim.g.neovide_hide_mouse_when_typing = true
vim.g.neovide_unlink_border_highlights = true
vim.g.neovide_input_macos_alt_is_meta = true

-- Animations 

vim.g.neovide_cursor_trail_size = 0.7
vim.g.neovide_cursor_antialiasing = true
vim.g.neovide_cursor_animate_in_insert_mode = true
vim.g.neovide_cursor_animate_command_line = true
vim.g.neovide_cursor_unfocused_outline_width = 0.125
vim.g.neovide_cursor_smooth_blink = true
vim.g.neovide_cursor_vfx_mode = "railgun"
vim.g.neovide_cursor_vfx_opacity = 500.0
vim.g.neovide_cursor_vfx_particle_lifetime = 1.2
vim.g.neovide_cursor_vfx_particle_density = 10.0
vim.g.neovide_cursor_vfx_particle_speed = 10
vim.g.neovide_cursor_vfx_particle_phase = 2.5
vim.g.neovide_cursor_vfx_particle_curl = 5.0



