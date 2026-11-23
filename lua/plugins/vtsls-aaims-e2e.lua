-- AAIMS mission-ui/e2e is not in any tsconfig `include`, so vtsls treats those
-- files as an "inferred project": no `paths` aliases ($messages, $common) and
-- non-strict defaults. Playwright compiles them fine; only the editor complains.
-- tsserver cannot take `paths` from editor settings, so we (1) make inferred
-- projects strict, and (2) drop the alias-only false positives for that folder.

local E2E_DIR = "/AAIMS/aaims%-mission/mission%-ui/e2e/"

--- True for diagnostics that only exist because the inferred project lacks the tsconfig.
local function is_false_positive(d)
  local msg = d.message or ""
  if d.code == 2307 and msg:find("Cannot find module '%$") then
    return true -- unresolved $messages / $common path alias
  end
  if d.code == 2339 and msg:find("Property 'api' does not exist on type 'Window") then
    return true -- window.api is declared by the preload/renderer tsconfig
  end
  return false
end

return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      local vtsls = opts.servers.vtsls or {}
      opts.servers.vtsls = vtsls

      vtsls.settings = vtsls.settings or {}
      vtsls.settings["js/ts"] = vim.tbl_deep_extend("force", vtsls.settings["js/ts"] or {}, {
        implicitProjectConfig = {
          strictNullChecks = true, -- fixes the JSONSchemaType "strictNullChecks must be true" error
          strictFunctionTypes = true,
          target = "ESNext",
          module = "ESNext",
        },
      })

      vtsls.handlers = vtsls.handlers or {}
      local default = vim.lsp.handlers["textDocument/publishDiagnostics"]
      vtsls.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
        if result and result.uri and vim.uri_to_fname(result.uri):find(E2E_DIR) then
          result.diagnostics = vim.tbl_filter(function(d)
            return not is_false_positive(d)
          end, result.diagnostics or {})
        end
        return (default or vim.lsp.diagnostic.on_publish_diagnostics)(err, result, ctx, config)
      end
    end,
  },
}
