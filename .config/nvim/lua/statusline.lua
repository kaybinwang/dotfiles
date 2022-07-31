local modes = {
   -- TODO: make a truncated version
   ["n"] = "NORMAL",
   ["no"] = "NORMAL OPERATOR PENDING",
   ["v"] = "VISUAL",
   ["V"] = "VISUAL LINE",
   [""] = "VISUAL BLOCK",
   ["s"] = "SELECT",
   ["S"] = "SELECT LINE",
   [""] = "SELECT BLOCK",
   ["i"] = "INSERT",
   ["ic"] = "INSERT",
   ["R"] = "REPLACE",
   ["Rv"] = "VISUAL REPLACE",
   ["c"] = "COMMAND",
   ["cv"] = "VIM EX",
   ["ce"] = "EX",
   ["r"] = "PROMPT",
   ["rm"] = "MOAR",
   ["r?"] = "CONFIRM",
   ["!"] = "SHELL",
   ["t"] = "TERMINAL",
}

local function is_truncated()
   return vim.api.nvim_win_get_width(0) < 80
end

local function mode()
   local mode = vim.api.nvim_get_mode().mode
   return string.format("%s ", modes[mode])
end

local function paste()
   local paste_enabled = vim.o.paste
   if paste_enabled then
      return "PASTE "
   else
      return ""
   end
end

local function git_branch()
   local mark = " "
   local branch = vim.fn.system("git rev-parse --abbrev-ref HEAD 2>/dev/null")
   if branch == "" then
      return ""
   end
   return table.concat({mark, branch, " "})
end

local function file_type()
   if is_truncated() then
      return ""
   end

   local file_name = vim.fn.expand("%:t")
   local file_type = vim.bo.filetype
   if file_type == "" then
      return "no ft"
   end

   local devicons = require("nvim-web-devicons")
   return file_type .. " " .. devicons.get_icon(file_name, file_type, { default = true })
end

local function file_format()
   if is_truncated() then
      return ""
   end

   local fileformat = vim.bo.fileformat
   return table.concat({
      fileformat, " ", "[icon]"
   })
end

local function file_encoding()
   if is_truncated() then
      return ""
   end

   local file_encoding = vim.bo.fenc
   if file_encoding == "" then
      return vim.o.enc  -- fallback to global encoding
   end

   return file_encoding
end

local function modified()
   local file_type = vim.bo.filetype
   if file_type == "help" then
      return ""
   end
   local modified = vim.bo.modified
   if modified then
      return "[+] "
   else
      return "[-] "
   end
end

local function readonly()
   local file_type = vim.bo.filetype
   if file_type == "help" then
      return ""
   end
   local readonly = vim.bo.readonly
   if readonly then
      return ""
   end
   return ""
end

return {
   file_encoding = file_encoding,
   file_format = file_format,
   file_type = file_type,
   git_branch = git_branch,
   mode = mode,
   modified = modified,
   paste = paste,
   readonly = readonly,
}
