require("config")
-- Enable blinking cursor
vim.opt.guicursor = {
  "n-v-c:block-Cursor/lCursor-blinkon1-blinkoff1-blinkwait500",
  "i:ver25-Cursor/lCursor-blinkon1-blinkoff1-blinkwait500"
}

-- Enable relative line numbers
vim.opt.number = true
vim.opt.relativenumber = true
