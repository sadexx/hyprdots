return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup({
      direction = "float",
      open_mapping = [[<leader>t]],
      float_opts = { border = "rounded" },
    })

    for i = 1, 3 do
      vim.keymap.set("n", "<leader>" .. i, function()
        require("toggleterm").toggle(i, nil, nil, "float")
      end)
    end
  end
}
