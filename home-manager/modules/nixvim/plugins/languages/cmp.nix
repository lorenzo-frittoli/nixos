{
  programs.nixvim.plugins = {
    cmp = {
      enable = true;
      settings = {
        snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";
        mapping = {
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-e>" = "cmp.mapping.close()";
          "<C-n>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          "<C-p>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
        };
        sources = [
          {
            name = "path";
          }
          {
            name = "nvim_lsp";
            entry_filter = ''
              function(entry, ctx)
                  return require("cmp").lsp.CompletionItemKind.Text ~= entry:get_kind()
              end'';
          }
          { name = "nvim_lua"; }
          {
            name = "luasnip";
            keyword_length = 2;
          }
          {
            name = "buffer";
            keyword_length = 3;
          }
        ];
      };
    };
  };
}
