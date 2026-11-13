---@brief
---
--- https://github.com/typescript-language-server/typescript-language-server
---
--- `ts_ls`, aka `typescript-language-server`, is a Language Server Protocol implementation for TypeScript wrapping `tsserver`. Note that `ts_ls` is not `tsserver`.
---
--- `typescript-language-server` depends on `typescript`. Both packages can be installed via `npm`:
--- ```sh
--- npm install -g typescript typescript-language-server
--- ```


---@type vim.lsp.Config
return {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
  root_markers = { "tsconfig.json", "package.json", ".git" },

  init_options = {
    hostInfo = "neovim",
    completionDisableFilterText = false,
    disableAutomaticTypingAcquisition = false,
    maxTsServerMemory = 4096,
    -- npmLocation = nil,
    -- locale = nil,
    plugins = {}, -- { { name = "...", location = "...", languages = {} } }
    supportsHoverVerbosity = true,
    supportsMoveToFileCodeAction = true,

    tsserver = {
      logDirectory = nil,
      logVerbosity = "off", -- 'off'|'terse'|'normal'|'requestTime'|'verbose'
      path = nil,
      fallbackPath = nil,
      trace = "off", -- 'off'|'messages'|'verbose'
      useClientFileWatcher = false,
      useSyntaxServer = "auto", -- 'auto'|'never'
    },

    preferences = {
      autoImportFileExcludePatterns = {},
      autoImportSpecifierExcludeRegexes = {},
      disableSuggestions = false,
      quotePreference = "auto", -- 'auto'|'double'|'single'
      includeCompletionsForModuleExports = true,
      includeCompletionsForImportStatements = true,
      includeCompletionsWithSnippetText = true,
      includeCompletionsWithInsertText = true,
      includeAutomaticOptionalChainCompletions = true,
      includeCompletionsWithClassMemberSnippets = true,
      includeCompletionsWithObjectLiteralMethodSnippets = true,
      useLabelDetailsInCompletionEntries = true,
      allowIncompleteCompletions = true,
      importModuleSpecifierPreference = "shortest", -- 'shortest'|'project-relative'|'relative'|'non-relative'
      importModuleSpecifierEnding = "auto", -- 'auto'|'minimal'|'index'|'js'
      allowTextChangesInNewFiles = true,
      lazyConfiguredProjectsFromExternalProject = false,
      maximumHoverLength = 500,
      organizeImportsIgnoreCase = "auto", -- 'auto' | boolean
      organizeImportsCollation = "ordinal", -- 'ordinal'|'unicode'
      organizeImportsLocale = "en",
      organizeImportsNumericCollation = false,
      organizeImportsAccentCollation = true,
      organizeImportsCaseFirst = false, -- 'upper'|'lower'|false
      organizeImportsTypeOrder = "last", -- 'last'|'inline'|'first'
      preferTypeOnlyAutoImports = false,
      providePrefixAndSuffixTextForRename = true,
      provideRefactorNotApplicableReason = true,
      allowRenameOfImportPath = true,
      includePackageJsonAutoImports = "auto", -- 'auto'|'on'|'off'
      interactiveInlayHints = true,
      jsxAttributeCompletionStyle = "auto", -- 'auto'|'braces'|'none'
      displayPartsForJSDoc = true,
      excludeLibrarySymbolsInNavTo = true,
      generateReturnInDocTemplate = true,

      -- Inlay hints (same as before)
      -- includeInlayParameterNameHints = "none", -- 'none'|'literals'|'all'
      includeInlayParameterNameHints = "all",
      includeInlayEnumMemberValueHints = true,
      includeInlayFunctionLikeReturnTypeHints = true,
      includeInlayFunctionParameterTypeHints = true,
      includeInlayParameterNameHintsWhenArgumentMatchesName = true,
      includeInlayPropertyDeclarationTypeHints = true,
      includeInlayVariableTypeHints = true,
      includeInlayVariableTypeHintsWhenTypeMatchesName = true,
    },
  },
  settings = {
    typescript = {
      format = {
        baseIndentSize = 0,
        convertTabsToSpaces = true,
        indentSize = 2,
        indentStyle = "Smart", -- 'None'|'Block'|'Smart'
        insertSpaceAfterCommaDelimiter = true,
        insertSpaceAfterConstructor = false,
        insertSpaceAfterFunctionKeywordForAnonymousFunctions = false,
        insertSpaceAfterKeywordsInControlFlowStatements = true,
        insertSpaceAfterOpeningAndBeforeClosingEmptyBraces = true,
        insertSpaceAfterOpeningAndBeforeClosingJsxExpressionBraces = false,
        insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces = true,
        insertSpaceAfterOpeningAndBeforeClosingNonemptyBrackets = false,
        insertSpaceAfterOpeningAndBeforeClosingNonemptyParenthesis = false,
        insertSpaceAfterOpeningAndBeforeClosingTemplateStringBraces = false,
        insertSpaceAfterSemicolonInForStatements = true,
        insertSpaceAfterTypeAssertion = false,
        insertSpaceBeforeAndAfterBinaryOperators = true,
        insertSpaceBeforeFunctionParenthesis = false,
        insertSpaceBeforeTypeAnnotation = false,
        newLineCharacter = "\n",
        placeOpenBraceOnNewLineForControlBlocks = false,
        placeOpenBraceOnNewLineForFunctions = false,
        semicolons = "ignore", -- 'ignore'|'insert'|'remove'
        tabSize = 2,
        trimTrailingWhitespace = true,
      },

      inlayHints = {
        -- includeInlayParameterNameHints = "none",
        includeInlayParameterNameHints = "all",
        includeInlayEnumMemberValueHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayVariableTypeHintsWhenTypeMatchesName = true,
      },

      implementationsCodeLens = { enabled = true },
      referencesCodeLens = { enabled = true, showOnAllFunctions = true },
    },

    javascript = {
      format = {
        baseIndentSize = 0,
        convertTabsToSpaces = true,
        indentSize = 2,
        indentStyle = "Smart", -- 'None'|'Block'|'Smart'
        insertSpaceAfterCommaDelimiter = true,
        insertSpaceAfterConstructor = false,
        insertSpaceAfterFunctionKeywordForAnonymousFunctions = false,
        insertSpaceAfterKeywordsInControlFlowStatements = true,
        insertSpaceAfterOpeningAndBeforeClosingEmptyBraces = true,
        insertSpaceAfterOpeningAndBeforeClosingJsxExpressionBraces = false,
        insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces = true,
        insertSpaceAfterOpeningAndBeforeClosingNonemptyBrackets = false,
        insertSpaceAfterOpeningAndBeforeClosingNonemptyParenthesis = false,
        insertSpaceAfterOpeningAndBeforeClosingTemplateStringBraces = false,
        insertSpaceAfterSemicolonInForStatements = true,
        insertSpaceAfterTypeAssertion = false,
        insertSpaceBeforeAndAfterBinaryOperators = true,
        insertSpaceBeforeFunctionParenthesis = false,
        insertSpaceBeforeTypeAnnotation = false,
        newLineCharacter = "\n",
        placeOpenBraceOnNewLineForControlBlocks = false,
        placeOpenBraceOnNewLineForFunctions = false,
        semicolons = "ignore", -- 'ignore'|'insert'|'remove'
        tabSize = 2,
        trimTrailingWhitespace = true,
      },

      inlayHints = {
        includeInlayEnumMemberValueHints = false,
        includeInlayFunctionLikeReturnTypeHints = false,
        includeInlayFunctionParameterTypeHints = false,
        includeInlayParameterNameHints = "none",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayPropertyDeclarationTypeHints = false,
        includeInlayVariableTypeHints = false,
        includeInlayVariableTypeHintsWhenTypeMatchesName = false,
      },

      implementationsCodeLens = { enabled = true},
      referencesCodeLens = { enabled = true, showOnAllFunctions = true },
    },

    completions = {
      completeFunctionCalls = true, -- default false; needs completionItem/resolve support
    },

    diagnostics = {
      ignoredCodes = {}, -- e.g. { 80001 } (see TS diagnosticMessages.json)
      eagerClear = false,
    },

    implicitProjectConfiguration = {
      checkJs = false,
      experimentalDecorators = false,
      module = "ESNext",
      strictFunctionTypes = true,
      strictNullChecks = true,
      target = "ES2020",
    },
  }
}
