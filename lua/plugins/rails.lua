return {
  "tpope/vim-rails",
  ft = {
    "ruby",
    "eruby",
  },
  config = function()
    vim.g.rails_projections = {
      ["app/controllers/*_controller.rb"] = {
        alternate = {
          "spec/requests/{}_spec.rb",
          "spec/features/{}_spec.rb",
          "spec/system/{}_spec.rb",
          "spec/controllers/{}_controller_spec.rb",
          "test/controllers/{}_controller_test.rb",
        },
        type = "controller",
      },
      ["spec/requests/*_spec.rb"] = {
        alternate = "app/controllers/{}_controller.rb",
        type = "request test",
      },
      ["spec/features/*_spec.rb"] = {
        alternate = "app/controllers/{}_controller.rb",
        type = "feature test",
      },
      ["spec/system/*_spec.rb"] = {
        alternate = "app/controllers/{}_controller.rb",
        type = "system test",
      },
      ["lib/*.rb"] = {
        alternate = "spec/lib/{}_spec.rb",
        type = "lib",
      },
    }
  end,
}
