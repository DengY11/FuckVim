-- 基本设置
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 基本配置
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"
vim.opt.cursorline = true -- 高亮当前行
vim.opt.autoindent = true -- 自动缩进
vim.opt.smartindent = true -- 智能缩进

-- 动感光标设置
vim.opt.guicursor = "n-v-c:block-CursorShape/lCursor,i-ci-ve:ver25-CursorShape/lCursor,r-cr-o:hor20-CursorShape/lCursor"
vim.api.nvim_create_autocmd({"VimEnter", "WinEnter", "BufWinEnter"}, {
  callback = function()
    vim.o.cursorline = true
  end
})
vim.api.nvim_create_autocmd({"WinLeave"}, {
  callback = function()
    vim.o.cursorline = false
  end
})

-- 光标闪烁设置
vim.api.nvim_create_autocmd({"VimEnter"}, {
  callback = function()
    -- 创建更醒目的光标高亮组
    vim.api.nvim_set_hl(0, "CursorShape", { fg = "#ffffff", bg = "#5f00ff", bold = true })
    
    -- 创建光标闪烁效果
    local blink_timer = vim.loop.new_timer()
    local blink_state = false
    blink_timer:start(0, 400, vim.schedule_wrap(function()
      blink_state = not blink_state
      if blink_state then
        vim.api.nvim_set_hl(0, "CursorShape", { fg = "#ffffff", bg = "#ff00ff", bold = true })
      else
        vim.api.nvim_set_hl(0, "CursorShape", { fg = "#ffffff", bg = "#5f00ff", bold = true })
      end
    end))
    
    -- 确保在退出时清理
    vim.api.nvim_create_autocmd({"VimLeave"}, {
      callback = function()
        blink_timer:stop()
        blink_timer:close()
      end
    })
  end
})

-- 平滑滚动设置
vim.opt.scrolloff = 8 -- 保持光标上下至少有8行可见
vim.opt.sidescrolloff = 8 -- 水平滚动时保持光标左右至少有8列可见
vim.keymap.set('n', '<C-d>', '<C-d>zz') -- 半页向下滚动并保持光标居中
vim.keymap.set('n', '<C-u>', '<C-u>zz') -- 半页向上滚动并保持光标居中
vim.keymap.set('n', 'n', 'nzzzv') -- 搜索下一个结果并保持光标居中
vim.keymap.set('n', 'N', 'Nzzzv') -- 搜索上一个结果并保持光标居中

-- 浮动窗口设置
vim.api.nvim_create_autocmd({"UIEnter"}, {
  callback = function()
    vim.api.nvim_set_hl(0, "FloatBorder", { link = "Normal" })
    vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
  end
})

-- 安装并设置包管理器（lazy.nvim）
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- 加载插件
require("lazy").setup({
  -- 深色主题
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha", -- VSCode风格的深灰色主题: mocha
        background = {
          dark = "mocha",
        },
        term_colors = true,
        transparent_background = false,
        dim_inactive = {
          enabled = true,
          percentage = 0.2,
        },
        custom_highlights = function(colors)
          return {
            Normal = { bg = "#1e1e1e" }, -- VSCode 深灰色背景
            NormalFloat = { bg = "#252526" },
            CursorLine = { bg = "#2d2d30" },
            LineNr = { fg = "#6b6b6b" },
            CursorLineNr = { fg = "#c6c6c6" },
            StatusLine = { bg = "#007acc", fg = "#ffffff" }, -- VSCode蓝色状态栏
          }
        end,
        integrations = {
          cmp = true,
          gitsigns = true,
          telescope = true,
          which_key = true,
          treesitter = true,
          native_lsp = {
            enabled = true,
            virtual_text = {
              errors = { "italic" },
              hints = { "italic" },
              warnings = { "italic" },
              information = { "italic" },
            },
            underlines = {
              errors = { "underline" },
              hints = { "underline" },
              warnings = { "underline" },
              information = { "underline" },
            },
          },
        },
      })
      vim.cmd.colorscheme "catppuccin"
    end,
  },
  
  -- 文件浏览器
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        close_if_last_window = true,
        window = {
          width = 30,
        },
      })
      vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>")
    end,
  },
  
  -- 模糊查找
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { 
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
    },
    config = function()
      require("telescope").setup({
        defaults = {
          prompt_prefix = " ",
          selection_caret = " ",
          path_display = { "smart" },
          file_ignore_patterns = { ".git/", "node_modules" },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          }
        }
      })
      
      -- 加载fzf扩展
      pcall(require("telescope").load_extension, "fzf")
      
      -- 设置键位映射
      vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>")
      vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>")
      vim.keymap.set("n", "<leader>fb", ":Telescope buffers<CR>")
      vim.keymap.set("n", "<leader>fh", ":Telescope help_tags<CR>")
      vim.keymap.set("n", "<leader>fw", ":Telescope grep_string<CR>")
      vim.keymap.set("n", "<leader>fs", ":Telescope current_buffer_fuzzy_find<CR>")
    end,
  },
  
  -- FZF原生支持
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
  },
  
  -- 语法高亮
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "c", "cpp", "lua", "vim", "vimdoc", "query" },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
  
  -- 上下文显示插件
  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("treesitter-context").setup({
        enable = true, -- 启用插件
        max_lines = 3, -- 最多显示的上下文行数
        min_window_height = 10, -- 最小窗口高度
        line_numbers = true,
        multiline_threshold = 1, -- 多行上下文的阈值
        trim_scope = 'outer', -- 可以是'inner'或'outer'
        mode = 'cursor', -- 可以是'cursor'或'topline'
        separator = nil, -- 上下文分隔符，nil表示没有分隔符
        zindex = 20, -- 上下文窗口的z-index
        on_attach = function(bufnr)
          -- 可以在这里添加特定缓冲区的设置
          return true
        end,
      })
      
      -- 自定义高亮
      vim.api.nvim_set_hl(0, 'TreesitterContext', { bg = '#2d3033', italic = true })
      vim.api.nvim_set_hl(0, 'TreesitterContextLineNumber', { fg = '#7d8590', bg = '#2d3033' })
    end,
  },
  
  -- 代码导航增强
  {
    "SmiteshP/nvim-navic",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-tree/nvim-web-devicons"
    },
    config = function()
      local navic = require("nvim-navic")
      navic.setup({
        icons = {
          File          = " ",
          Module        = " ",
          Namespace     = " ",
          Package       = " ",
          Class         = " ",
          Method        = " ",
          Property      = " ",
          Field         = " ",
          Constructor   = " ",
          Enum          = " ",
          Interface     = " ",
          Function      = " ",
          Variable      = " ",
          Constant      = " ",
          String        = " ",
          Number        = " ",
          Boolean       = " ",
          Array         = " ",
          Object        = " ",
          Key           = " ",
          Null          = " ",
          EnumMember    = " ",
          Struct        = " ",
          Event         = " ",
          Operator      = " ",
          TypeParameter = " "
        },
        highlight = true,
        separator = " > ",
        depth_limit = 0,
        depth_limit_indicator = "..",
        safe_output = true
      })
      
      -- 将navic与lualine状态栏集成
      local function get_location()
        return navic.get_location()
      end
      
      -- 更新LSP配置以使用navic
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      require("lspconfig").clangd.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        cmd = {
          "clangd",
          "--offset-encoding=utf-16",
          "--fallback-style=Google",
          "--background-index",
          "--clang-tidy",
          "--completion-style=detailed",
          "--header-insertion=iwyu",
          "--function-arg-placeholders",
          "-j=4",
          "--header-insertion-decorators",
          "--pretty",
        },
        init_options = {
          usePlaceholders = true,
          completeUnimported = true,
          clangdFileStatus = true,
          semanticHighlighting = true,
        },
        settings = {
          clangd = {
            fallbackFlags = {
              "-std=c++17",
              "--style=Google",
              "-Wall",
              "-Wextra",
              "-Wpedantic",
              "-Wno-unused-parameter",
              "--tab-size=4"
            }
          }
        }
      })
    end,
  },
  
  -- LSP配置
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "SmiteshP/nvim-navic", -- 添加navic依赖
    },
    config = function()
      local lspconfig = require("lspconfig")
      local navic = require("nvim-navic") -- 引入navic
      
      -- 配置LSP服务器
      lspconfig.clangd.setup({
        on_attach = on_attach,
        capabilities = require('cmp_nvim_lsp').default_capabilities(),
        cmd = {
          "clangd",
          "--offset-encoding=utf-16",
          "--fallback-style=Google",
          "--background-index",
          "--clang-tidy",
          "--completion-style=detailed",
          "--header-insertion=iwyu",
          "--function-arg-placeholders",
          "-j=4",
          "--header-insertion-decorators",
          "--pretty",
        },
        init_options = {
          usePlaceholders = true,
          completeUnimported = true,
          clangdFileStatus = true,
          semanticHighlighting = true,
        },
        settings = {
          clangd = {
            fallbackFlags = {
              "-std=c++17",
              "--style=Google",
              "-Wall",
              "-Wextra",
              "-Wpedantic",
              "-Wno-unused-parameter",
              "--tab-size=4"
            }
          }
        }
      })
    end,
  },
  
  -- 自动补全
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-cmdline", -- 命令行补全
      "onsails/lspkind.nvim", -- 补全菜单图标
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")
      
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<C-d>"] = cmp.mapping.scroll_docs(4),
          ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp", priority = 1000 },
          { name = "luasnip", priority = 750 },
          { name = "buffer", priority = 500 },
          { name = "path", priority = 250 },
        }),
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol_text",
            maxwidth = 50,
            ellipsis_char = "...",
            menu = {
              buffer = "[缓冲区]",
              nvim_lsp = "[LSP]",
              luasnip = "[代码片段]",
              path = "[路径]",
              cmdline = "[命令]"
            }
          }),
        },
        completion = {
          keyword_length = 1, -- 只需输入1个字符即可触发补全
          completeopt = "menu,menuone,noinsert", -- 增强补全体验
        },
        experimental = {
          ghost_text = true, -- 启用幽灵文本预览
        },
      })
      
      -- 命令行补全配置
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' },
          { name = 'cmdline' }
        })
      })
      
      -- 搜索补全配置
      cmp.setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })
    end,
  },

  -- AI 辅助
  {
    "Exafunction/codeium.vim",
    config = function()
      -- 禁用默认键位绑定
      vim.g.codeium_disable_bindings = 1
      
      -- 自定义键位绑定
      vim.keymap.set("i", "<C-g>", function() return vim.fn["codeium#Accept"]() end, { expr = true, desc = "接受建议" })
      vim.keymap.set("i", "<C-;>", function() return vim.fn["codeium#CycleCompletions"](1) end, { expr = true, desc = "下一个建议" })
      vim.keymap.set("i", "<C-,>", function() return vim.fn["codeium#CycleCompletions"](-1) end, { expr = true, desc = "上一个建议" })
      vim.keymap.set("i", "<C-x>", function() return vim.fn["codeium#Clear"]() end, { expr = true, desc = "清除建议" })
      vim.keymap.set("i", "<C-v>", function() return vim.fn["codeium#Complete"]() end, { expr = true, desc = "触发建议" })
      
      -- Codeium状态显示在状态栏上
      vim.g.codeium_enabled = true
      
      -- AI提示板函数
      local function show_ai_help()
        local width = 60
        local height = 15
        local buf = vim.api.nvim_create_buf(false, true)
        
        -- 设置缓冲区文本
        local lines = {
          "┌──────────────── Codeium AI 快捷键 ────────────────┐",
          "│                                                    │",
          "│  插入模式:                                         │",
          "│    <C-g>       - 接受AI建议                        │",
          "│    <C-;>       - 查看下一个建议                    │",
          "│    <C-,>       - 查看上一个建议                    │",
          "│    <C-x>       - 清除当前建议                      │",
          "│    <C-v>       - 手动触发建议                      │",
          "│                                                    │",
          "│  命令:                                             │",
          "│    :Codeium Auth     - 认证Codeium                 │",
          "│    :Codeium Status   - 查看状态                    │",
          "│    :CodeiumToggle    - 启用/禁用                   │",
          "│    :CodeiumSetup     - 设置帮助                    │",
          "│                                                    │",
          "│  认证步骤:                                         │",
          "│    1. 访问 https://www.codeium.com/profile         │",
          "│    2. 登录您的账户                                 │",
          "│    3. 访问特殊链接获取令牌:                        │",
          "│       www.codeium.com/profile?response_type=token& │",
          "│       redirect_uri=vim-show-auth-token             │",
          "│    4. 运行 :Codeium Auth 并粘贴令牌                │",
          "│                                                    │",
          "└────────────────────────────────────────────────────┘",
        }
        
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
        
        -- 设置缓冲区选项
        vim.api.nvim_buf_set_option(buf, 'modifiable', false)
        vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
        
        -- 计算窗口位置（居中）
        local ui = vim.api.nvim_list_uis()[1]
        local win_width = width
        local win_height = #lines
        
        local col = (ui.width - win_width) / 2
        local row = (ui.height - win_height) / 2
        
        -- 创建浮动窗口
        local opts = {
          relative = 'editor',
          width = win_width,
          height = win_height,
          col = col,
          row = row,
          style = 'minimal',
          border = 'rounded',
        }
        
        local win = vim.api.nvim_open_win(buf, true, opts)
        
        -- 设置窗口颜色
        vim.api.nvim_win_set_option(win, 'winhl', 'Normal:Normal,FloatBorder:FloatBorder')
        
        -- 添加按键映射以关闭窗口
        vim.api.nvim_buf_set_keymap(buf, 'n', 'q', '<cmd>close<CR>', {noremap = true, silent = true})
        vim.api.nvim_buf_set_keymap(buf, 'n', '<Esc>', '<cmd>close<CR>', {noremap = true, silent = true})
        vim.api.nvim_buf_set_keymap(buf, 'n', '<CR>', '<cmd>close<CR>', {noremap = true, silent = true})
        
        -- 设置自动命令以设置更多选项（在窗口创建后）
        vim.cmd([[
          augroup AIHelpFloatWin
            autocmd!
            autocmd BufWinLeave <buffer> silent! au! AIHelpFloatWin
          augroup END
        ]])
        
        return win
      end
      
      -- 添加codeium的which-key菜单
      local wk = require("which-key")
      wk.register({
        ["<leader>A"] = {
          name = "AI助手",
          c = { "<cmd>CodeiumToggle<CR>", "切换Codeium" },
          a = { "<cmd>Codeium Auth<CR>", "认证Codeium" },
          s = { "<cmd>Codeium Status<CR>", "Codeium状态" },
          h = { function() show_ai_help() end, "AI快捷键帮助" },
        },
      })
      
      -- 创建一个用户命令来轻松获取认证令牌
      vim.api.nvim_create_user_command("CodeiumSetup", function()
        print("请访问 https://www.codeium.com/account 获取API密钥")
        print("然后运行 :Codeium Auth 命令并粘贴密钥")
      end, {})
      
      -- 启动时自动检查认证状态
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          -- 延迟执行以确保Neovim完全加载
          vim.defer_fn(function()
            -- 检查是否已认证
            local auth_status = vim.fn["codeium#GetStatusString"]()
            if auth_status:find("Not logged in") then
              print("Codeium未登录，请运行 :Codeium Auth 命令进行认证，或 :CodeiumSetup 获取帮助")
            end
          end, 2000)
        end,
      })
    end,
  },
  
  -- 状态栏
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { 
      "nvim-tree/nvim-web-devicons",
      "SmiteshP/nvim-navic", -- 添加navic依赖
    },
    config = function()
      -- 获取navic位置信息函数
      local function get_location()
        return require("nvim-navic").get_location()
      end
      
      require("lualine").setup({
        options = {
          icons_enabled = true,
          theme = 'auto',
          component_separators = { left = '', right = ''},
          section_separators = { left = '', right = ''},
          disabled_filetypes = {
            statusline = {},
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = true,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
          }
        },
        sections = {
          lualine_a = {'mode'},
          lualine_b = {'branch', 'diff', 'diagnostics'},
          lualine_c = {'filename'},
          lualine_x = {'encoding', 'fileformat', 'filetype'},
          lualine_y = {'progress'},
          lualine_z = {'location'}
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {'filename'},
          lualine_x = {'location'},
          lualine_y = {},
          lualine_z = {}
        },
        tabline = {},
        winbar = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {
            { get_location, cond = function() return package.loaded["nvim-navic"] and require("nvim-navic").is_available() end }
          },
          lualine_x = {},
          lualine_y = {},
          lualine_z = {}
        },
        inactive_winbar = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {'filename'},
          lualine_x = {},
          lualine_y = {},
          lualine_z = {}
        },
        extensions = {}
      })
    end,
  },
  
  -- 代码结构
  {
    "stevearc/aerial.nvim",
    config = function()
      require("aerial").setup()
      vim.keymap.set("n", "<leader>a", ":AerialToggle<CR>")
    end,
  },
  
  -- 块注释
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("Comment").setup({
        padding = true, -- 在注释分隔符后添加一个空格
        sticky = true, -- 光标保持在原位置
        ignore = nil, -- 忽略行的正则表达式
        toggler = {
          line = 'gcc', -- 行注释切换
          block = 'gbc', -- 块注释切换
        },
        opleader = {
          line = 'gc', -- 行注释操作
          block = 'gb', -- 块注释操作
        },
        mappings = {
          basic = true, -- 启用基本映射
          extra = true, -- 启用额外映射
          extended = false, -- 启用扩展映射
        },
        pre_hook = nil, -- 注释前钩子函数
        post_hook = nil, -- 注释后钩子函数
      })
      
      -- 设置键盘映射
      vim.keymap.set("n", "<leader>/", function()
        require("Comment.api").toggle.linewise.current()
      end, { desc = "注释当前行" })
      
      vim.keymap.set("v", "<leader>/", "<ESC><CMD>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", { desc = "注释选中区域" })
    end,
  },
  
  -- Git集成
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "│" },
          change = { text = "│" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
        },
        current_line_blame = true,
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = "eol",
          delay = 500,
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          
          -- 导航
          vim.keymap.set("n", "]c", function()
            if vim.wo.diff then return "]c" end
            vim.schedule(function() gs.next_hunk() end)
            return "<Ignore>"
          end, {expr=true, buffer=bufnr})
          
          vim.keymap.set("n", "[c", function()
            if vim.wo.diff then return "[c" end
            vim.schedule(function() gs.prev_hunk() end)
            return "<Ignore>"
          end, {expr=true, buffer=bufnr})
          
          -- 操作
          vim.keymap.set({"n", "v"}, "<leader>gs", ":Gitsigns stage_hunk<CR>", {buffer=bufnr})
          vim.keymap.set({"n", "v"}, "<leader>gr", ":Gitsigns reset_hunk<CR>", {buffer=bufnr})
          vim.keymap.set("n", "<leader>gS", gs.stage_buffer, {buffer=bufnr})
          vim.keymap.set("n", "<leader>gu", gs.undo_stage_hunk, {buffer=bufnr})
          vim.keymap.set("n", "<leader>gR", gs.reset_buffer, {buffer=bufnr})
          vim.keymap.set("n", "<leader>gp", gs.preview_hunk, {buffer=bufnr})
          vim.keymap.set("n", "<leader>gb", function() gs.blame_line{full=true} end, {buffer=bufnr})
          vim.keymap.set("n", "<leader>gl", gs.toggle_current_line_blame, {buffer=bufnr})
          vim.keymap.set("n", "<leader>gd", gs.diffthis, {buffer=bufnr})
          vim.keymap.set("n", "<leader>gD", function() gs.diffthis("~") end, {buffer=bufnr})
        end,
      })
    end,
  },
  
  -- which-key
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      local wk = require("which-key")
      wk.setup({
        plugins = {
          marks = true,
          registers = true,
          spelling = {
            enabled = false,
          },
          presets = {
            operators = true,
            motions = true,
            text_objects = true,
            windows = true,
            nav = true,
            z = true,
            g = true,
          },
        },
        window = {
          border = "single",
          position = "bottom",
          padding = { 2, 2, 2, 2 },
        },
        layout = {
          height = { min = 4, max = 25 },
          width = { min = 20, max = 50 },
          spacing = 3,
          align = "center",
        },
      })
      
      -- 全局帮助提示板函数
      function _G.show_keybindings_help()
        local width = 80
        local buf = vim.api.nvim_create_buf(false, true)
        
        -- 设置缓冲区文本
        local lines = {
          "┌───────────────────────── 全局快捷键帮助 ─────────────────────────┐",
          "│                                                                    │",
          "│ 【Vim基础键位】                                                    │",
          "│   i / a          - 进入插入模式 (当前位置/当前位置之后)           │",
          "│   I / A          - 进入插入模式 (行首/行尾)                       │",
          "│   o / O          - 在下方/上方新建一行并进入插入模式              │",
          "│   v / V          - 进入可视模式 (字符/行)                         │",
          "│   <C-v>          - 进入块选择模式                                  │",
          "│   y / d / c      - 复制/删除/改变                                  │",
          "│   yy / dd / cc   - 复制/删除/改变整行                              │",
          "│   p / P          - 粘贴 (当前位置之后/之前)                        │",
          "│   u / <C-r>      - 撤销/重做                                       │",
          "│   .              - 重复上次操作                                    │",
          "│   gg / G         - 跳到文件开头/结尾                               │",
          "│   w / b          - 向前/后跳转一个单词                             │",
          "│   e              - 跳到单词结尾                                    │",
          "│   0 / $          - 跳到行首/行尾                                   │",
          "│   ^ / g_         - 跳到行内第一个/最后一个非空字符                 │",
          "│   f{char}        - 向前查找字符                                    │",
          "│   t{char}        - 向前查找字符并停在其前                          │",
          "│   % / [{()}]     - 跳转到匹配的括号                                │",
          "│   * / #          - 向前/后搜索当前单词                             │",
          "│   / / ?          - 向前/后搜索                                     │",
          "│   n / N          - 下一个/上一个搜索结果                           │",
          "│   zt / zz / zb   - 将当前行置于屏幕顶部/中间/底部                  │",
          "│   m{a-zA-Z}      - 设置标记                                        │",
          "│   '{a-zA-Z}      - 跳到标记行                                      │",
          "│   `{a-zA-Z}      - 跳到标记位置                                    │",
          "│   <C-w> + hjkl   - 在窗口间导航                                    │",
          "│   :[range]s/old/new/[g] - 替换文本                                 │",
          "│                                                                    │",
          "│ 【文件操作】                                                       │",
          "│   <leader>e      - 打开/关闭文件浏览器                             │",
          "│   <leader>ff     - 查找文件                                        │",
          "│   <leader>fg     - 全局搜索文本                                    │",
          "│   <leader>fw     - 搜索光标下的单词                                │",
          "│   <leader>fs     - 在当前文件中搜索                                │",
          "│   <leader>fb     - 搜索缓冲区                                      │",
          "│                                                                    │",
          "│ 【代码操作】                                                       │",
          "│   <leader>a      - 代码结构                                        │",
          "│   <leader>ca     - 代码操作                                      │",
          "│   <leader>cf     - 格式化代码                                    │",
          "│   <leader>cr     - 重命名变量/函数                               │",
          "│   gr             - 查找所有引用                                  │",
          "│   gi             - 查找实现                                      │",
          "│   [d / ]d        - 跳到上一个/下一个诊断                         │",
          "│   gd             - 跳转到定义                                    │",
          "│   K              - 显示文档                                      │",
          "│   <F5>           - 运行当前代码                                  │",
          "│                                                                    │",
          "│ 【Git操作】                                                        │",
          "│   <leader>gs     - 暂存修改                                        │",
          "│   <leader>gr     - 重置修改                                        │",
          "│   <leader>gS     - 暂存全部                                        │",
          "│   <leader>gb     - 行责任信息                                      │",
          "│   <leader>gg     - 打开Lazygit                                     │",
          "│                                                                    │",
          "│ 【终端操作】                                                       │",
          "│   <C-\\>         - 打开/关闭终端                                   │",
          "│   <leader>tt     - 切换终端                                        │",
          "│   <leader>tn     - 新建浮动终端                                    │",
          "│   <leader>th     - 新建水平终端                                    │",
          "│   <leader>tv     - 新建垂直终端                                    │",
          "│   <leader>tg     - 打开Lazygit                                     │",
          "│                                                                    │",
          "│ 【窗口操作】                                                       │",
          "│   <leader>wh     - 水平分割窗口                                    │",
          "│   <leader>wv     - 垂直分割窗口                                    │",
          "│   <leader>wm     - 移动窗口                                        │",
          "│   <leader>wc     - 关闭窗口                                        │",
          "│   <C-h/j/k/l>    - 在窗口间移动                                    │",
          "│   <C-Left/Down/Up/Right> - 调整窗口大小                            │",
          "│                                                                    │",
          "│ 【AI助手】                                                         │",
          "│   <leader>A      - 打开AI助手菜单                                  │",
          "│   <leader>Aa     - 认证Codeium                                     │",
          "│   <leader>Ac     - 切换Codeium                                     │",
          "│   <leader>As     - Codeium状态                                     │",
          "│   <leader>Ah     - AI快捷键帮助                                    │",
          "│   <C-g>          - 接受AI建议 (插入模式)                           │",
          "│                                                                    │",
          "│ 【导航与移动】                                                     │",
          "│   <C-d/u>        - 半页向下/上滚动                                 │",
          "│   n/N            - 搜索下一个/上一个结果                            │",
          "│   [c / ]c        - 跳到上一个/下一个Git修改                        │",
          "│                                                                    │",
          "│ 【Vim命令】                                                        │",
          "│   :w             - 保存文件                                        │",
          "│   :q             - 退出                                            │",
          "│   :wq / :x       - 保存并退出                                      │",
          "│   :q!            - 强制退出不保存                                  │",
          "│   :e {file}      - 编辑文件                                        │",
          "│   :bn / :bp      - 下一个/上一个缓冲区                             │",
          "│   :bd            - 删除当前缓冲区                                  │",
          "│   :sp / :vs      - 水平/垂直分割窗口                               │",
          "│   :terminal      - 打开终端                                        │",
          "│   :set {option}  - 设置选项                                        │",
          "│                                                                    │",
          "│ 【其他】                                                           │",
          "│   <leader>h      - 显示此帮助                                      │",
          "│                                                                    │",
          "│ 按 q, <Esc> 或 <CR> 关闭此窗口                                     │",
          "└────────────────────────────────────────────────────────────────────┘",
        }
        
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
        
        -- 设置缓冲区选项
        vim.api.nvim_buf_set_option(buf, 'modifiable', false)
        vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
        
        -- 计算窗口位置
        local ui = vim.api.nvim_list_uis()[1]
        local win_width = width
        local win_height = #lines
        
        local col = math.floor((ui.width - win_width) / 2)
        local row = math.floor((ui.height - win_height) / 2)
        
        -- 创建浮动窗口
        local opts = {
          relative = 'editor',
          width = win_width,
          height = win_height,
          col = col,
          row = row,
          style = 'minimal',
          border = 'rounded',
        }
        
        local win = vim.api.nvim_open_win(buf, true, opts)
        
        -- 设置窗口颜色
        vim.api.nvim_win_set_option(win, 'winhl', 'Normal:Normal,FloatBorder:Special')
        
        -- 添加按键映射以关闭窗口
        vim.api.nvim_buf_set_keymap(buf, 'n', 'q', '<cmd>close<CR>', {noremap = true, silent = true})
        vim.api.nvim_buf_set_keymap(buf, 'n', '<Esc>', '<cmd>close<CR>', {noremap = true, silent = true})
        vim.api.nvim_buf_set_keymap(buf, 'n', '<CR>', '<cmd>close<CR>', {noremap = true, silent = true})
        
        return win
      end
      
      -- 使用推荐的新格式
      wk.register({
        ["<leader>a"] = { desc = "代码结构" },
        ["<leader>A"] = { 
          name = "AI助手",
          c = { desc = "切换Codeium" },
          a = { desc = "认证Codeium" },
          s = { desc = "Codeium状态" },
          h = { desc = "AI快捷键帮助" },
        },
        ["<leader>b"] = { 
          name = "缓冲区",
          d = { desc = "删除缓冲区" },
          n = { desc = "下一个缓冲区" },
          p = { desc = "上一个缓冲区" },
        },
        ["<leader>c"] = { 
          name = "代码",
          a = { desc = "代码操作" },
          f = { desc = "格式化" },
          r = { desc = "重命名变量/函数" },
        },
        ["<leader>/"] = { desc = "注释" },
        ["<leader>d"] = { 
          name = "诊断",
          l = { desc = "列出诊断" },
        },
        ["<leader>e"] = { desc = "文件浏览器" },
        ["<leader>f"] = { 
          name = "查找",
          f = { desc = "查找文件" },
          g = { desc = "全局搜索" },
          b = { desc = "搜索缓冲区" },
          h = { desc = "查找帮助" },
          w = { desc = "搜索当前单词" },
          s = { desc = "当前文件搜索" },
        },
        ["<leader>g"] = {
          name = "Git",
          s = { desc = "暂存修改" },
          r = { desc = "重置修改" },
          S = { desc = "暂存全部" },
          u = { desc = "撤销暂存" },
          R = { desc = "重置全部" },
          p = { desc = "预览修改" },
          b = { desc = "行责任" },
          l = { desc = "行责任开关" },
          d = { desc = "差异对比" },
          D = { desc = "与HEAD对比" },
          g = { "<cmd>lua _lazygit_toggle()<CR>", "打开Lazygit" },
        },
        ["<leader>h"] = { function() show_keybindings_help() end, "显示键位帮助" },
        ["<leader>r"] = {
          name = "运行",
          t = { desc = "在新标签页运行" },
          f = { desc = "在浮动窗口运行" },
          c = { desc = "关闭运行窗口" },
        },
        ["<leader>t"] = {
          name = "终端",
          t = { desc = "切换终端" },
          g = { desc = "打开Lazygit" },
          n = { "<cmd>ToggleTerm direction=float<cr>", "新建浮动终端" },
          h = { "<cmd>ToggleTerm direction=horizontal<cr>", "新建水平终端" },
          v = { "<cmd>ToggleTerm direction=vertical<cr>", "新建垂直终端" },
        },
        ["<leader>w"] = {
          name = "窗口",
          h = { desc = "水平分割" },
          v = { desc = "垂直分割" },
          m = { desc = "移动窗口" },
          c = { desc = "关闭窗口" },
        },
      })
    end,
  },
  
  -- 启动界面
  {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")
      
      -- FuckVim ASCII艺术
      dashboard.section.header.val = {
        "                                                     ",
        "                                                     ",
        "                                                     ",
        " ███████╗██╗   ██╗ ██████╗██╗  ██╗██╗   ██╗██╗███╗   ███╗ ",
        " ██╔════╝██║   ██║██╔════╝██║ ██╔╝██║   ██║██║████╗ ████║ ",
        " █████╗  ██║   ██║██║     █████╔╝ ██║   ██║██║██╔████╔██║ ",
        " ██╔══╝  ██║   ██║██║     ██╔═██╗ ╚██╗ ██╔╝██║██║╚██╔╝██║ ",
        " ██║     ╚██████╔╝╚██████╗██║  ██╗ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
        " ╚═╝      ╚═════╝  ╚═════╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
        "                                                     ",
        "                                                     ",
        "                 为C/C++ 开发者打造                  ",
        "                  充满干劲的编辑器                   ",
        "                   我永远喜欢赵敏                    ",
        "                                                     ",
        "                                                     ",
      }
      
      -- 自定义快捷菜单
      dashboard.section.buttons.val = {
        dashboard.button("e", "  新建文件", ":ene <BAR> startinsert<CR>"),
        dashboard.button("f", "  查找文件", ":Telescope find_files<CR>"),
        dashboard.button("r", "  最近文件", ":Telescope oldfiles<CR>"),
        dashboard.button("t", "  查找文本", ":Telescope live_grep<CR>"),
        dashboard.button("c", "  编辑配置", ":e ~/.config/nvim/init.lua<CR>"),
        dashboard.button("l", "  插件管理器", ":Lazy<CR>"),
        dashboard.button("q", "  退出", ":qa<CR>"),
      }
      
      -- 页脚
      local function footer()
        return "去你妈的，干就完了!"
      end
      
      dashboard.section.footer.val = footer()
      dashboard.section.footer.opts.hl = "Type"
      dashboard.section.header.opts.hl = "Include"
      dashboard.section.buttons.opts.hl = "Keyword"
      
      dashboard.opts.opts.noautocmd = true
      alpha.setup(dashboard.opts)
      
      -- 自动启动
      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted",
        callback = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          dashboard.section.footer.val = "加载了 " .. stats.count .. " 个插件，用时 " .. ms .. "ms"
          pcall(vim.cmd.AlphaRedraw)
        end,
      })
    end,
  },
  
  -- 窗口管理
  {
    "mrjones2014/smart-splits.nvim",
    config = function()
      require("smart-splits").setup()
      
      -- 窗口调整大小
      vim.keymap.set("n", "<C-Left>", require("smart-splits").resize_left)
      vim.keymap.set("n", "<C-Down>", require("smart-splits").resize_down)
      vim.keymap.set("n", "<C-Up>", require("smart-splits").resize_up)
      vim.keymap.set("n", "<C-Right>", require("smart-splits").resize_right)
      
      -- 窗口导航
      vim.keymap.set("n", "<C-h>", require("smart-splits").move_cursor_left)
      vim.keymap.set("n", "<C-j>", require("smart-splits").move_cursor_down)
      vim.keymap.set("n", "<C-k>", require("smart-splits").move_cursor_up)
      vim.keymap.set("n", "<C-l>", require("smart-splits").move_cursor_right)
    end,
  },
  
  -- 快速创建窗口
  {
    "sindrets/winshift.nvim",
    config = function()
      require("winshift").setup()
      
      -- 设置键位映射
      vim.keymap.set("n", "<leader>wh", ":split<CR>")
      vim.keymap.set("n", "<leader>wv", ":vsplit<CR>")
      vim.keymap.set("n", "<leader>wm", ":WinShift<CR>")
      vim.keymap.set("n", "<leader>wc", ":close<CR>")
    end,
  },
  
  -- 增强命令行
  {
    "folke/noice.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup({
        cmdline = {
          enabled = true,
          view = "cmdline_popup",
          format = {
            cmdline = { icon = ">" },
            search_down = { icon = "🔍⌄" },
            search_up = { icon = "🔍⌃" },
            filter = { icon = "$" },
            lua = { icon = "☾" },
            help = { icon = "?" },
          },
        },
        messages = {
          enabled = true,
          view = "notify",
          view_error = "notify",
          view_warn = "notify",
          view_history = "messages",
          view_search = "virtualtext",
        },
        popupmenu = {
          enabled = true,
          backend = "nui",
        },
        lsp = {
          progress = {
            enabled = true,
          },
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
          hover = {
            enabled = true,
          },
          signature = {
            enabled = true,
          },
        },
      })
    end,
  },
  
  -- 快速编译运行功能
  {
    "CRAG666/code_runner.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      require("code_runner").setup({
        mode = "term",
        focus = true,
        startinsert = true,
        term = {
          position = "bot",
          size = 15,
        },
        filetype = {
          c = "cd $dir && gcc $fileName -o $fileNameWithoutExt && $dir/$fileNameWithoutExt",
          cpp = "cd $dir && g++ -std=c++17 $fileName -o $fileNameWithoutExt && $dir/$fileNameWithoutExt",
        },
      })
      
      -- 设置快捷键
      vim.keymap.set("n", "<F5>", ":RunCode<CR>")
      vim.keymap.set("n", "<leader>rt", ":RunFile tab<CR>")
      vim.keymap.set("n", "<leader>rf", ":RunFile float<CR>")
      vim.keymap.set("n", "<leader>rc", ":RunClose<CR>")
    end,
  },
  
  -- 终端切换
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        size = 15,
        open_mapping = [[<c-\>]],
        hide_numbers = true,
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        direction = "float", -- float, horizontal, vertical, tab
        close_on_exit = true,
        shell = vim.o.shell,
        float_opts = {
          border = "curved",
          winblend = 0,
          highlights = {
            border = "FloatBorder",
            background = "NormalFloat",
          },
        },
      })
      
      -- 自定义终端
      local Terminal = require("toggleterm.terminal").Terminal
      
      -- 创建一个持久化的lazygit终端实例
      local lazygit = Terminal:new({
        cmd = "lazygit",
        hidden = true,
        direction = "float",
        float_opts = {
          border = "double",
          width = function()
            return math.floor(vim.o.columns * 0.9)
          end,
          height = function()
            return math.floor(vim.o.lines * 0.9)
          end,
        },
        on_open = function(term)
          vim.cmd("startinsert!")
          -- 设置lazygit终端的特殊按键映射
          vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", {noremap = true, silent = true})
        end,
      })
      
      -- 函数切换lazygit
      function _G._lazygit_toggle()
        lazygit:toggle()
      end
      
      vim.keymap.set("n", "<leader>gg", "<cmd>lua _lazygit_toggle()<CR>", {desc = "打开Lazygit"})
      vim.keymap.set("n", "<leader>tg", "<cmd>lua _lazygit_toggle()<CR>", {desc = "打开Lazygit"})
      
      -- 设置终端快捷键
      vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm<CR>")
      vim.keymap.set("n", "<leader>tn", "<cmd>ToggleTerm direction=float<CR>")
      vim.keymap.set("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>")
      vim.keymap.set("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical<CR>")
      
      -- 终端内导航键映射
      function _G.set_terminal_keymaps()
        local opts = {buffer = 0}
        vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
        vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
        vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
        vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
        vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
      end
      
      -- 当进入终端时自动设置按键映射
      vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
    end,
  },
  
  -- 括号自动匹配
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({
        check_ts = true, -- 使用Treesitter检查
        ts_config = {
          lua = {'string'},  -- 不在lua字符串内自动匹配
          javascript = {'template_string'}, -- 不在js模板字符串内匹配
          java = false,  -- 不在java中检查
        },
        disable_filetype = { "TelescopePrompt", "vim" },
        fast_wrap = {
          map = "<M-e>", -- Alt+e 快速包裹
          chars = { "{", "[", "(", '"', "'" },
          pattern = [=[[%'%"%)%>%]%)%}%,]]=],
          end_key = "$",
          keys = "qwertyuiopzxcvbnmasdfghjkl",
          check_comma = true,
          highlight = "Search",
          highlight_grey = "Comment"
        },
      })
      
      -- 与nvim-cmp集成
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      local cmp = require('cmp')
      cmp.event:on(
        'confirm_done',
        cmp_autopairs.on_confirm_done()
      )
    end,
  },
})

-- 快速运行代码
vim.api.nvim_create_user_command("RunCode", function()
  local filetype = vim.bo.filetype
  if filetype == "cpp" then
    vim.cmd("split term://g++ -std=c++17 % -o %:r && ./%:r")
  elseif filetype == "c" then
    vim.cmd("split term://gcc % -o %:r && ./%:r")
  else
    print("不支持的文件类型: " .. filetype)
  end
end, {})

vim.keymap.set("n", "<F5>", ":RunCode<CR>")

-- 格式化函数 (使用LSP)
_G.format_code = function()
  vim.lsp.buf.format({ 
    async = true,
    timeout_ms = 2000,
  })
end
    
-- 设置全局格式化快捷键
vim.keymap.set("n", "<leader>cf", function() _G.format_code() end, { desc = "LSP格式化代码" })

-- 设置全局快捷键以显示帮助
vim.keymap.set('n', '<leader>h', function() show_keybindings_help() end, {desc = "显示键位帮助"})

-- LSP格式化配置
vim.lsp.handlers["textDocument/formatting"] = function(err, result, ctx)
  if err ~= nil or result == nil then
    return
  end
  
  local bufnr = ctx.bufnr
  
  -- 保存当前视图
  local view = vim.fn.winsaveview()
  
  -- 设置格式化选项
  vim.bo.tabstop = 4
  vim.bo.shiftwidth = 4
  vim.bo.expandtab = true
  
  -- 应用格式化更改
  if not vim.api.nvim_buf_is_loaded(bufnr) then
    return
  end
  
  vim.lsp.util.apply_text_edits(result, bufnr, "utf-8")
  
  -- 恢复视图
  vim.fn.winrestview(view)
  
  -- 如果是lua或c/cpp文件，额外处理缩进
  local filetype = vim.bo[bufnr].filetype
  if filetype == "lua" or filetype == "c" or filetype == "cpp" then
    -- 重新缩进整个文件
    vim.cmd("silent normal! gg=G")
  end
  
  -- 通知用户
  vim.notify(
    "已成功格式化文件，使用4空格缩进",
    vim.log.levels.INFO,
    { title = "LSP格式化" }
  )
end

-- 设置LSP快捷键
local function set_lsp_keymaps(bufnr)
  -- 基本映射
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, {buffer = bufnr, desc = "转到定义"})
  vim.keymap.set("n", "K", vim.lsp.buf.hover, {buffer = bufnr, desc = "显示文档"})
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {buffer = bufnr, desc = "代码操作"})
  vim.keymap.set("n", "<leader>cf", function()
    vim.lsp.buf.format({ 
      async = true,
      timeout_ms = 2000,
    })
  end, {buffer = bufnr, desc = "LSP格式化"})
  
  -- 重命名变量
  vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, {buffer = bufnr, desc = "重命名变量"})
  
  -- 引用查找
  vim.keymap.set("n", "gr", vim.lsp.buf.references, {buffer = bufnr, desc = "查找引用"})
  
  -- 实现查找
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {buffer = bufnr, desc = "查找实现"})
  
  -- 类型定义
  vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, {buffer = bufnr, desc = "类型定义"})
  
  -- 调整导航
  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, {buffer = bufnr, desc = "上一个诊断"})
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next, {buffer = bufnr, desc = "下一个诊断"})
  vim.keymap.set("n", "<leader>dl", "<cmd>Telescope diagnostics<cr>", {buffer = bufnr, desc = "列出诊断"})
end

-- 设置公共的on_attach函数
local on_attach = function(client, bufnr)
  -- 设置LSP快捷键
  set_lsp_keymaps(bufnr)
  
  -- 为支持文档符号的服务器附加navic
  if client.server_capabilities.documentSymbolProvider then
    local navic = require("nvim-navic")
    navic.attach(client, bufnr)
  end
end
