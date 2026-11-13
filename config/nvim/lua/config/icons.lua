------------------------------------
-- icons colletion from nerd fonts
------------------------------------


--   פּ ﯟ   some other good icons
local custome_icon = {
  editor = {
    File = ' ',
    Module = ' ',
    Method = 'm ',
    Function = "󰊕 ",
    Field = ' ',
    Variable = ' ',
    Class = ' ',
    Interface = ' ',
    Property = ' ',
    Enum = ' ',
    EnumMember = ' ',
    Struct = '󰌗 ',
    Event = ' ',
    Operator = ' ',
    TypeParameter = ' ',

    Constructor = ' ',
    String = ' ',
    Number = '󰎠 ',
    Boolean = ' ',
    Array = ' ',
    Object = ' ',
    Key = '󰌋 ',
    Constant = ' ',
    Package = ' ',
    Null = '󰟢 ',
    Namespace = ' ',

    Text = "󰊄 ",
    Unit = " ",
    Value = ' ',
    Keyword = "󰌆 ",
    Snippet = " ",
    Color = " ",
    Reference = " ",
    Folder = " ",
  },
  listchars = {
    tab = "␣␣", -- Use two ␣ symbols for tabs
    eol = "↲",
    nbsp = "^",
    trail = "~",
    extends = "⟩",
    precedes = "⟨",
    space = "·",
  },
  diagnostic = {
    ERROR = "󰅚",
    WARN = "󰀪",
    HINT = "󰌵",
    INFO = "󰋼",
  },
  gitsigns = {
    line = "▎",
    doubleLine = "󱋱",
    ladder = "󱖢",
    dotedLine = "",
    sidelineblock ="󰔌"

  }
}

return custome_icon
