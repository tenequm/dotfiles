local wezterm = require 'wezterm'
local config = {}

config.term = "wezterm"
config.color_scheme = 'Solarized (dark) (terminal.sexy)'
config.native_macos_fullscreen_mode = true

-- Make search highlights more prominent
config.colors = {
  -- Selection colors (used for the CURRENT match in search mode)
  selection_bg = '#FFA500',  -- Bright orange for current search match
  selection_fg = '#000000',  -- Black text for visibility

  -- Copy mode colors (used for OTHER matches in search mode)
  copy_mode_active_highlight_bg = { Color = '#FFA500' },  -- Orange when mouse selecting
  copy_mode_active_highlight_fg = { Color = '#000000' },  -- Black text
  copy_mode_inactive_highlight_bg = { Color = '#FFFF00' },  -- Yellow for other matches
  copy_mode_inactive_highlight_fg = { Color = '#000000' },  -- Black text
}

-- Send proper Alt/Option key sequences instead of using for character composition
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false

-- Leader key (like tmux prefix) - Ctrl+f, 1 second timeout
config.leader = { key = 'f', mods = 'CTRL', timeout_milliseconds = 1000 }

-- Scrollback
config.scrollback_lines = 10000
config.enable_scroll_bar = true

-- Hyperlink rules: use well-tested defaults
config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- Optional: file paths open in VS Code
table.insert(config.hyperlink_rules, {
  regex = [[((?:/[a-zA-Z][-\w.]+)+(?::\d+(?::\d+)?)?)(?=\s|$)]],
  format = 'file://$1',
  highlight = 1,
})

-- Mouse bindings: require CMD+Click to open links (like VS Code/IDE behavior)
config.mouse_bindings = {
  -- Plain click only selects/copies text (no link opening)
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'NONE',
    action = wezterm.action.CompleteSelection 'ClipboardAndPrimarySelection',
  },
  -- CMD+Click opens hyperlinks
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'CMD',
    action = wezterm.action.OpenLinkAtMouseCursor,
  },
  -- Disable CMD+Down to prevent sending click to terminal
  {
    event = { Down = { streak = 1, button = 'Left' } },
    mods = 'CMD',
    action = wezterm.action.Nop,
  },
}

-- GPU and animation settings
config.front_end = 'WebGpu'
config.animation_fps = 60
config.cursor_blink_rate = 500

-- Copy mode customization
local act = wezterm.action
local copy_mode = wezterm.gui.default_key_tables().copy_mode

-- Override Ctrl+u/d with smaller jumps (~5 lines instead of half page)
table.insert(copy_mode, { key = 'u', mods = 'CTRL', action = act.CopyMode { MoveByPage = -0.15 } })
table.insert(copy_mode, { key = 'd', mods = 'CTRL', action = act.CopyMode { MoveByPage = 0.15 } })

-- Add '/' and '?' to trigger search from copy mode (like vim/tmux)
table.insert(copy_mode, { key = '/', mods = 'NONE', action = act.Search 'CurrentSelectionOrEmptyString' })
table.insert(copy_mode, { key = '?', mods = 'SHIFT', action = act.Search 'CurrentSelectionOrEmptyString' })

config.key_tables = { copy_mode = copy_mode }

-- smart-splits.nvim integration (seamless nvim/wezterm pane navigation)
local function is_vim(pane)
  return pane:get_user_vars().IS_NVIM == 'true'
end

local direction_keys = {
  h = 'Left',
  j = 'Down',
  k = 'Up',
  l = 'Right',
}

local function split_nav(resize_or_move, key)
  return {
    key = key,
    mods = resize_or_move == 'resize' and 'META' or 'CTRL',
    action = wezterm.action_callback(function(win, pane)
      if is_vim(pane) then
        win:perform_action({
          SendKey = { key = key, mods = resize_or_move == 'resize' and 'META' or 'CTRL' },
        }, pane)
      else
        if resize_or_move == 'resize' then
          win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
        else
          win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
        end
      end
    end),
  }
end

config.keys = {
  {key="Enter", mods="SHIFT", action=wezterm.action{SendString="\x1b\r"}},
  {key="f", mods="CMD|CTRL", action=wezterm.action.ToggleFullScreen},

  -- Alt+Left/Right for word navigation (macOS standard)
  {
    key = 'LeftArrow',
    mods = 'OPT',
    action = wezterm.action.SendString '\x1bb',  -- \033b - backward word
  },
  {
    key = 'RightArrow',
    mods = 'OPT',
    action = wezterm.action.SendString '\x1bf',  -- \033f - forward word
  },

  -- cmd+\ for horizontal split
  {
    key = '\\',
    mods = 'CMD',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  -- cmd+| (cmd+shift+\) for vertical split - common convention
  {
    key = '|',
    mods = 'CMD|SHIFT',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  -- cmd+shift+p for command palette
  {
    key = 'p',
    mods = 'CMD|SHIFT',
    action = wezterm.action.ActivateCommandPalette,
  },

  -- smart-splits: move between panes (Ctrl+h/j/k/l)
  split_nav('move', 'h'),
  split_nav('move', 'j'),
  split_nav('move', 'k'),
  split_nav('move', 'l'),
  -- smart-splits: resize panes (Alt+h/j/k/l)
  split_nav('resize', 'h'),
  split_nav('resize', 'j'),
  split_nav('resize', 'k'),
  split_nav('resize', 'l'),

  -- Leader key bindings (Ctrl+f, then key)
  { key = 'r', mods = 'LEADER', action = wezterm.action.ReloadConfiguration },
  { key = 'z', mods = 'LEADER', action = wezterm.action.TogglePaneZoomState },
  { key = 'c', mods = 'LEADER', action = wezterm.action.SpawnTab 'CurrentPaneDomain' },
  { key = 'x', mods = 'LEADER', action = wezterm.action.CloseCurrentPane { confirm = true } },
  { key = '{', mods = 'LEADER|SHIFT', action = wezterm.action.RotatePanes 'CounterClockwise' },
  { key = '}', mods = 'LEADER|SHIFT', action = wezterm.action.RotatePanes 'Clockwise' },

  -- Scrollback (like tmux copy-mode)
  { key = '[', mods = 'LEADER', action = wezterm.action.ActivateCopyMode },
  { key = '/', mods = 'LEADER', action = wezterm.action.Search 'CurrentSelectionOrEmptyString' },

  -- Pane select with visual picker
  { key = 's', mods = 'LEADER', action = wezterm.action.PaneSelect { mode = 'SwapWithActive' } },

  -- Leader pane navigation (Ctrl+f, then h/j/k/l) - like tmux
  { key = 'h', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Left' },
  { key = 'j', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Down' },
  { key = 'k', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Up' },
  { key = 'l', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Right' },

  -- Quick scroll without entering copy mode
  { key = 'UpArrow', mods = 'SHIFT', action = wezterm.action.ScrollByLine(-1) },
  { key = 'DownArrow', mods = 'SHIFT', action = wezterm.action.ScrollByLine(1) },
}

-- Smart scrollbar: auto-hide when not needed
wezterm.on('update-status', function(window, pane)
  local overrides = window:get_config_overrides() or {}
  local dimensions = pane:get_dimensions()
  local should_show = dimensions.scrollback_rows > dimensions.viewport_rows
    and not pane:is_alt_screen_active()
  if overrides.enable_scroll_bar ~= should_show then
    overrides.enable_scroll_bar = should_show
    window:set_config_overrides(overrides)
  end

  -- Mode indicator for copy/search mode
  local mode = window:active_key_table()
  if mode then
    window:set_right_status(wezterm.format {
      { Foreground = { Color = '#000000' } },
      { Background = { Color = '#FFA500' } },
      { Text = ' ' .. string.upper(mode):gsub('_', ' ') .. ' ' },
    })
  else
    window:set_right_status('')
  end
end)

return config
