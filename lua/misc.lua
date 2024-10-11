
-- python testing on save

local testing_ns = vim.api.nvim_create_namespace("testing")
local testing_group = vim.api.nvim_create_augroup("testing-augroup", { clear = true })
local pass_text = { "✔" }

local attach_testing = function (buf, cmds)
  vim.api.nvim_create_autocmd("BufWritePost", {
    group = testing_group,
    pattern = { "*.py" },
    callback = function()
      vim.api.nvim_buf_clear_namespace(buf, testing_ns, 0, -1)

      local failed = {}

      vim.fn.jobstart(cmds[1], {
        stdout_buffered = false,
        on_exit = function ()
          vim.fn.jobstart(cmds[2], {
            stdout_buffered = true,
            on_stdout = function (_, data)
              if not data then
                return
              end
              for _, line in ipairs(data) do
                local decoded = vim.json.decode(line)
                for _, test in ipairs(decoded.tests) do
                  local lineno = test.lineno
                  if test.outcome == "passed" then
                    vim.api.nvim_buf_set_extmark(buf, testing_ns, lineno, 0, {
                      virt_text = { pass_text }
                    })
                  elseif test.outcome == "failed" then
                    table.insert(failed, {
                      bufnr = buf,
                      lnum = lineno,
                      col = 0,
                      severity = vim.diagnostic.severity.ERROR,
                      source = "pytest",
                      message = "Line " .. lineno .. ": " .. test.call.crash.message,
                      user_data = {},
                    })
                  else
                    print("Error: Invalid outcome!")
                  end
                end
              end
            end,
            on_exit = function ()
              vim.diagnostic.set(testing_ns, buf, failed, {})
              vim.fn.jobstart(cmds[3])
            end
          })
        end
      })
    end
  })
end

vim.api.nvim_create_user_command("PyTestOnSave", function ()
  local cur_buf = vim.api.nvim_buf_get_name(0)
  attach_testing(vim.api.nvim_get_current_buf(), {
    {"pytest", "--json-report", cur_buf },
    { "cat", ".report.json" },
    { "rm", ".report.json" }
  })
end, {})

-- gofmt on save

local go_group = vim.api.nvim_create_augroup("go-augroup", { clear = true })

vim.api.nvim_create_autocmd("BufWritePre", {
  group = go_group,
  pattern = { "*.go" },
  callback = function()
    local saved_view = vim.fn.winsaveview()
    vim.cmd("silent %!gofmt")
    if vim.v.shell_error > 0 then
      vim.cmd[[silent undo]]
    else
      vim.cmd("retab")
    end
    vim.fn.winrestview(saved_view)
  end
})

-- custom signature help

vim.lsp.handlers['textDocument/signatureHelp']  = vim.lsp.with(
  vim.lsp.handlers['signature_help'], {
    border = 'single',
    wrap = true,
    max_height = 5,
    close_events = { "CursorMoved", "CursorMovedI", "BufHidden" },
})

