return {
  settings = {
    codeAction = {
      disableRuleComment = {
        enable = true,
        location = 'separateLine',
      },
      showDocumentation = {
        enable = true,
      },
    },
    codeActionOnSave = {
      enable = false,
      mode = 'all',
    },
    format = true,
    nodePath = '',
    onIgnoredFiles = 'off',
    packageManager = 'npm', -- 注释掉的话由 LSP 根据锁文件自动推断，兼容 pnpm/yarn
    quiet = false, -- 提示: 如果只想看 Error 不想看 Warning，可改为 true
    rulesCustomizations = {},
    run = 'onSave', -- 已优化: 仅在保存时运行，大幅提升输入时的性能并降低 CPU 占用
    useESLintClass = false,
    validate = 'on',
    workingDirectory = {
      -- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
      mode = 'auto', -- "location" | "auto"
    },
  },
}
