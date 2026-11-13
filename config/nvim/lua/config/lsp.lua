-- lua/config/lsp.lua
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  once = true,
  callback = function()
    vim.lsp.config("*", {
      capabilities = require("blink.cmp").get_lsp_capabilities(),
    })
  end,
})

vim.lsp.enable("ts_ls")
vim.lsp.enable("astro")
vim.lsp.enable("emmet_language_server")
vim.lsp.enable("yamlls")
vim.lsp.enable("tailwindcss")
vim.lsp.enable("lua_ls")
vim.lsp.enable("qmlls")
vim.lsp.enable("jsonls")
vim.lsp.enable("biome")

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    local bufnr = ev.buf
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local ok, telescope = pcall(require, "telescope.builtin")


    -- if client:supports_method("textDocument/inlayHint") then
    --   vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    -- end

    if client:supports_method("textDocument/linkedEditingRange") then
      vim.lsp.linked_editing_range.enable(true, { bufnr = bufnr })
    end

    if client:supports_method("textDocument/inlineCompletion") then
      vim.lsp.inline_completion.enable(true, { bufnr = bufnr })
    end

    if client:supports_method("textDocument/documentHighlight") then
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = bufnr,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd("CursorMoved", {
        buffer = bufnr,
        callback = vim.lsp.buf.clear_references,
      })
    end

    if client:supports_method("textDocument/documentColor") then
      vim.lsp.document_color.enable(true, { bufnr = bufnr })
    end

    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = "LSP: " .. desc })
    end

    -- Go-to navigation (Telescope where a picker exists)
    map("n", "gd", ok and telescope.lsp_definitions or vim.lsp.buf.definition, "Goto Definition")
    map("n", "gD", vim.lsp.buf.declaration, "Goto Declaration") -- no Telescope picker
    map("n", "gi", ok and telescope.lsp_implementations or vim.lsp.buf.implementation, "Goto Implementation")
    map("n", "gr", ok and telescope.lsp_references or vim.lsp.buf.references, "Goto References")
    map("n", "gt", ok and telescope.lsp_type_definitions or vim.lsp.buf.type_definition, "Goto Type Definition")

    -- Symbols
    map("n", "gO", ok and telescope.lsp_document_symbols or vim.lsp.buf.document_symbol, "Document Symbols")
    map("n", "<leader>ws", ok and telescope.lsp_dynamic_workspace_symbols or vim.lsp.buf.workspace_symbol, "Workspace Symbols")

    -- Call hierarchy
    map("n", "<leader>ci", ok and telescope.lsp_incoming_calls or vim.lsp.buf.incoming_calls, "Incoming Calls")
    map("n", "<leader>co", ok and telescope.lsp_outgoing_calls or vim.lsp.buf.outgoing_calls, "Outgoing Calls")

    -- Info / docs (no Telescope equivalent)
    map("n", "K", vim.lsp.buf.hover, "Hover Docs")
    map("i", "<C-s>", vim.lsp.buf.signature_help, "Signature Help")
    map("n", "<C-k>", vim.lsp.buf.signature_help, "Signature Help")

    -- Editing
    map("n", "<leader>rn", vim.lsp.buf.rename, "Rename Symbol")
    map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code Action")
    map("n", "<leader>f", function() vim.lsp.buf.format({ async = true }) end, "Format Buffer")

    -- Code Lens
    if client and client:supports_method("textDocument/codeLens") then
      map("n", "<leader>cl", vim.lsp.codelens.run, "Run CodeLens")
    end

    -- Diagnostics
    map("n", "gl", vim.diagnostic.open_float, "Line Diagnostics")
    map("n", "de", vim.diagnostic.open_float, "Line Diagnostics")
    map("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, "Prev Diagnostic")
    map("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, "Next Diagnostic")
    map("n", "<leader>q", ok and telescope.diagnostics or vim.diagnostic.setloclist, "Diagnostics List")

    -- Workspace folders
    map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "Add Workspace Folder")
    map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "Remove Workspace Folder")
    map("n", "<leader>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, "List Workspace Folders")

    local function source_action(kind)
      return function()
        vim.lsp.buf.code_action({
          context = { only = { kind }, diagnostics = {} },
          apply = true,
        })
      end
    end

    if client and client:supports_method("textDocument/codeLens") then
      map("n", "<leader>cl", vim.lsp.codelens.run, "Run CodeLens")
    end

    map("n", "<leader>oi", source_action("source.organizeImports"), "Organize Imports")
    map("n", "<leader>cf", source_action("source.fixAll"), "Fix All")
    map("n", "<leader>cu", source_action("source.removeUnused"), "Remove Unused")
  end,
})
