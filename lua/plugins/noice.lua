return {
  "folke/noice.nvim",
  opts = function(_, opts)
    -- Remove the "No information available" message
    table.insert(opts.routes, {
      filter = {
        event = "notify",
        find = "No information available",
      },
      opts = { skip = true },
    })
  end,
}
