-- lua/utils.lua
local custom_utils = {}

----------------------------------------------------------------------
-- persistence layer
----------------------------------------------------------------------
local state_file = vim.fn.stdpath("data") .. "/toggle_state.json"
local state = {}

local function load_state()
  local file = io.open(state_file, "r")
  if not file then
    return {}
  end
  local content = file:read("*a")
  file:close()
  local ok, decoded = pcall(vim.json.decode, content)
  if ok and type(decoded) == "table" then
    return decoded
  end
  return {}
end

local function save_state()
  local file = io.open(state_file, "w")
  if not file then
    vim.notify("utils: could not write " .. state_file, vim.log.levels.WARN)
    return
  end
  file:write(vim.json.encode(state))
  file:close()
end

state = load_state()

-- read a value, seeding it with `default` the first time it's seen
local function get(key, default)
  if state[key] == nil then
    state[key] = default
  end
  return state[key]
end

local function set(key, value)
  state[key] = value
  save_state()
end

local function notify(label, value)
  vim.notify(label .. ": " .. (value and "on" or "off"), vim.log.levels.INFO)
end

----------------------------------------------------------------------
-- diagnostics: enable/disable, virtual_text, virtual_lines, underline, signs
----------------------------------------------------------------------
local function apply_diagnostics_enabled(v)
  vim.diagnostic.enable(v)
end

function custom_utils.toggle_diagnostics()
  local v = not get("diagnostics_enabled", true)
  apply_diagnostics_enabled(v)
  set("diagnostics_enabled", v)
  notify("Diagnostics", v)
end

local function apply_virtual_text(v)
  vim.diagnostic.config({ virtual_text = v })
end

function custom_utils.toggle_virtual_text()
  local v = not get("virtual_text", true)
  apply_virtual_text(v)
  set("virtual_text", v)
  notify("Virtual text", v)
end

local function apply_virtual_lines(v)
  vim.diagnostic.config({ virtual_lines = v })
end

function custom_utils.supress_virtual_line_text()
  local v = not get("virtual_lines", false)
  apply_virtual_lines(v)
  set("virtual_lines", v)
  notify("Virtual lines", v)
end

local function apply_underline(v)
  vim.diagnostic.config({ underline = v })
end

function custom_utils.toggle_underline()
  local v = not get("underline", true)
  apply_underline(v)
  set("underline", v)
  notify("Diagnostic underline", v)
end

local function apply_signs(v)
  vim.diagnostic.config({ signs = v })
end

function custom_utils.toggle_signs()
  local v = not get("diagnostic_signs", true)
  apply_signs(v)
  set("diagnostic_signs", v)
  notify("Diagnostic signs", v)
end


----------------------------------------------------------------------
-- inlay hints
----------------------------------------------------------------------
local function apply_inlay_hints(v)
  vim.lsp.inlay_hint.enable(v)
end

function custom_utils.toggle_inlay_hints()
  local v = not get("inlay_hints", false)
  apply_inlay_hints(v)
  set("inlay_hints", v)
  notify("Inlay hints", v)
end

----------------------------------------------------------------------
-- wrap / listchars / signcolumn / number
----------------------------------------------------------------------
local function apply_wrap(v)
  vim.o.wrap = v
end

function custom_utils.toggle_wrap()
  local v = not get("wrap", vim.o.wrap)
  apply_wrap(v)
  set("wrap", v)
  notify("Wrap", v)
end



local function apply_listchars(v)
  vim.o.list = v
end

function custom_utils.toggleListChars()
  local v = not get("list", vim.o.list)
  apply_listchars(v)
  set("list", v)
  notify("List chars", v)
end

local function apply_signcolumn(v)
  vim.o.signcolumn = v and "yes" or "no"
end

function custom_utils.toggle_signcolumn()
  local v = not get("signcolumn", true)
  apply_signcolumn(v)
  set("signcolumn", v)
  notify("Sign column", v)
end

local function apply_numbers(v)
  vim.o.number = v
  vim.o.relativenumber = v
end

function custom_utils.toggle_numbers()
  local v = not get("numbers", true)
  apply_numbers(v)
  set("numbers", v)
  notify("Line numbers", v)
end

----------------------------------------------------------------------
-- statusline (works whether you use lualine or native statusline)
----------------------------------------------------------------------
local function apply_statusline(v)
  if v then
    vim.o.laststatus = get("laststatus_value", 3)
  else
    -- remember the non-zero value so we can restore it later
    if vim.o.laststatus ~= 0 then
      set("laststatus_value", vim.o.laststatus)
    end
    vim.o.laststatus = 0
  end
end

function custom_utils.toggle_statusline()
  local v = not get("statusline", true)
  apply_statusline(v)
  set("statusline", v)
  notify("Status bar", v)
end

-- if you specifically want to hide lualine's own render instead of laststatus:
function custom_utils.toggle_lua_line()
  local v = not get("lualine", true)
  local ok, lualine = pcall(require, "lualine")
  if ok then
    if v then
      lualine.hide({ unhide = true })
    else
      lualine.hide({ unhide = false })
    end
  end
  set("lualine", v)
  notify("Lualine", v)
end

----------------------------------------------------------------------
-- global LSP kill switch
----------------------------------------------------------------------
local lsp_group = vim.api.nvim_create_augroup("UtilsLspToggle", { clear = true })

local function apply_lsp_enabled(v)
  vim.g.utils_lsp_disabled = not v
  if not v then
    for _, client in ipairs(vim.lsp.get_clients()) do
      vim.lsp.stop(client.id)
    end
  end
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = lsp_group,
  callback = function(args)
    if vim.g.utils_lsp_disabled then
      vim.lsp.stop(args.data.client_id)
    end
  end,
})

function custom_utils.toggle_diagnostics_lsp()
  local v = not get("lsp_enabled", true)
  apply_lsp_enabled(v)
  set("lsp_enabled", v)
  notify("LSP", v)
end

----------------------------------------------------------------------
-- apply everything on startup, so a fresh nvim matches your saved state
----------------------------------------------------------------------
function custom_utils.setup()
  apply_diagnostics_enabled(get("diagnostics_enabled", true))
  apply_virtual_text(get("virtual_text", true))
  apply_virtual_lines(get("virtual_lines", false))
  apply_inlay_hints(get("inlay_hints", false))
  apply_underline(get("underline", true))
  apply_signs(get("diagnostic_signs", true))
  apply_wrap(get("wrap", vim.o.wrap))
  apply_listchars(get("list", vim.o.list))
  apply_signcolumn(get("signcolumn", true))
  apply_numbers(get("numbers", true))
  apply_statusline(get("statusline", true))
  apply_lsp_enabled(get("lsp_enabled", true))
end


-- Show current state of all utils toggles
function custom_utils.show_state()
  local lines = {
    "=== Utils State ===",
    "Diagnostics:     " .. (get("diagnostics_enabled", true) and "on" or "off"),
    "Virtual text:    " .. (get("virtual_text", true) and "on" or "off"),
    "Virtual lines:   " .. (get("virtual_lines", false) and "on" or "off"),
    "Inlay hints:      " .. (get("inlay_hints", false) and "on" or "off"),
    "Underline:       " .. (get("underline", true) and "on" or "off"),
    "Diagnostic signs:" .. (get("diagnostic_signs", true) and "on" or "off"),
    "Wrap:             " .. (get("wrap", vim.o.wrap) and "on" or "off"),
    "List chars:       " .. (get("list", vim.o.list) and "on" or "off"),
    "Sign column:      " .. (get("signcolumn", true) and "on" or "off"),
    "Line numbers:     " .. (get("numbers", true) and "on" or "off"),
    "Status bar:       " .. (get("statusline", true) and "on" or "off"),
    "Lualine:          " .. (get("lualine", true) and "on" or "off"),
    "LSP:              " .. (get("lsp_enabled", true) and "on" or "off"),
  }

  vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
end

vim.api.nvim_create_user_command("UtilsState", function()
  custom_utils.show_state()
end, {})








return custom_utils
