local M = {}

local function ollama_models()
  local result = vim.system({ "curl", "-s", "http://localhost:11434/api/tags" }, { text = true }):wait(2000)
  if result == nil or result.code ~= 0 then
    return {}
  end

  local ok, data = pcall(vim.json.decode, result.stdout)
  if not ok or not data.models then
    return {}
  end

  local models = {}
  for _, model in ipairs(data.models) do
    table.insert(models, model.name)
  end
  return models
end

function M.change_model()
  local models = ollama_models()
  if #models == 0 then
    vim.cmd.Minuet({ args = { "change_model" } })
    return
  end

  vim.ui.select(models, {
    prompt = "Select Ollama model",
  }, function(model)
    if model then
      require("minuet").change_model("openai_fim_compatible:" .. model)
    end
  end)
end

function M.menu()
  local virtualtext = require("minuet.virtualtext")
  local minuet = require("minuet")

  local enabled = vim.b.minuet_virtual_text_auto_trigger
  local model = minuet.config.provider_options[minuet.config.provider].model

  local choices = {
    {
      label = ("Toggle Minuet completions: %s"):format(enabled and "ON" or "OFF"),
      value = "toggle",
    },
    {
      label = ("Change model (current: %s)"):format(model),
      value = "model",
    },
  }

  vim.ui.select(choices, {
    prompt = "Minuet options",
    format_item = function(item)
      return item.label
    end,
  }, function(choice)
    if not choice then
      return
    end
    if choice.value == "toggle" then
      virtualtext.action.toggle_auto_trigger()
    else
      M.change_model()
    end
  end)
end

return {
  {
    "milanglacier/minuet-ai.nvim",
    opts = {
      provider = "openai_fim_compatible",
      n_completions = 1,
      context_window = 3000,
      throttle = 300,
      debounce = 100,
      request_timeout = 0.0,
      virtualtext = {
        keymap = {
          accept = "<A-a>",
          accept_line = "<A-l>",
          accept_n_lines = "<A-n>",
          prev = "<A-[>",
          next = "<A-]>",
          dismiss = "<A-e>",
        },
      },
      provider_options = {
        openai_fim_compatible = {
          api_key = "TERM",
          name = "Ollama",
          end_point = "http://localhost:11434/v1/completions",
          model = "qwen2.5-coder:0.5b",
          stream = true,
          optional = {
            max_tokens = 60,
            top_p = 0.9,
          },
        },
      },
    },
    keys = {
      { "<leader>a", M.menu, desc = "Minuet: options" },
    },
    config = function(_, opts)
      require("minuet").setup(opts)
    end,
  },
}
