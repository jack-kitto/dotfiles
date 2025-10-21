return {
  {
    "chrisgrieser/nvim-recorder",
    dependencies = "rcarriga/nvim-notify", -- optional
    keys = {
      { "q", desc = "Start/Stop Recording" },
      { "Q", desc = "Play Macro" },
      { "<C-q>", desc = "Switch Macro Slot" },
      { "cq", desc = "Edit Macro" },
      { "yq", desc = "Yank Macro" },
      { "dq", desc = "Delete All Macros" },
    },
    opts = {
      -- Configure multiple slots (registers) for macros
      slots = { "a", "b", "c", "d", "e" }, -- You can add more slots as needed

      -- Optional: Use rotating slots instead of static
      -- dynamicSlots = "rotate", -- uncomment if you want rotating behavior

      mapping = {
        startStopRecording = "q",
        playMacro = "Q",
        switchSlot = "<C-q>", -- This is the key to switch between slots
        editMacro = "cq",
        deleteAllMacros = "dq",
        yankMacro = "yq",
        addBreakPoint = "##",
      },

      -- Clear all macros on startup (useful to see only current session recordings)
      clear = true,

      -- Reduce notifications if you find them annoying
      lessNotifications = false,
    },
  },
}
