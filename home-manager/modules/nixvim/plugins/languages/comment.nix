{
  programs.nixvim.plugins = {
    comment = {
      enable = true;
      settings = {
        opleader.line = "<C-/>";
        toggler.line = "<C-/>";
      };
    };

    todo-comments = {
      enable = true;
      settings = {
        keywords = {
          TODO = {
            color = "warning";
            icon = " ";
          };
        };
        highlight = {
          comments_only = true;
        };
      };
    };
  };
}
