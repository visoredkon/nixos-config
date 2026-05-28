{
  config,
  ...
}:
let
  palette = builtins.fromJSON (builtins.readFile "${config.catppuccin.sources.palette}/palette.json");
  c = palette.mocha.colors;
in
{
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      dark = true;
      navigate = true;
      true-color = "always";
      syntax-theme = "Catppuccin Mocha";

      side-by-side = true;
      line-numbers = true;
      keep-plus-minus-markers = false;
      relative-paths = true;

      file-style = "bold ${c.yellow.hex} ul";
      file-decoration-style = "${c.yellow.hex} box";
      file-added-label = "+";
      file-modified-label = "~";
      file-removed-label = "-";
      file-renamed-label = "→";
      file-copied-label = "⇒";
      diff-stat-align-width = 48;

      commit-style = "raw";
      commit-decoration-style = "bold ${c.yellow.hex} box ol";

      hunk-header-style = "file line-number syntax";
      hunk-header-decoration-style = "${c.blue.hex} box";
      hunk-header-file-style = "${c.blue.hex}";
      hunk-header-line-number-style = "${c.green.hex}";

      plus-style = "syntax #003800";
      minus-style = "syntax #3f0001";
      plus-emph-style = "bold ${c.base.hex} ${c.green.hex}";
      minus-emph-style = "bold ${c.base.hex} ${c.red.hex}";
      zero-style = "syntax normal";
      whitespace-error-style = "${c.mauve.hex} reverse";
      inline-hint-style = "dim ${c.blue.hex}";

      line-numbers-left-format = "{nm:>4} ⋮";
      line-numbers-right-format = "{np:>4} │";
      line-numbers-left-style = "${c.blue.hex}";
      line-numbers-right-style = "${c.blue.hex}";
      line-numbers-minus-style = "${c.red.hex}";
      line-numbers-plus-style = "${c.green.hex}";
      line-numbers-zero-style = "dim";

      max-line-distance = "0.6";
      max-syntax-highlighting-length = 0;
      max-line-length = 5000;

      wrap-max-lines = "unlimited";
      wrap-right-percent = 37;

      hyperlinks = true;

      blame-format = "{author:<18} ({commit:>7}) {timestamp:^16}";
      blame-code-style = "syntax";
      blame-palette = ''"${c.surface1.hex}" "${c.surface2.hex}" "${c.overlay0.hex}" "${c.overlay1.hex}"'';
      blame-separator-format = "│{n:^4}│";
      blame-separator-style = "dim";
      blame-timestamp-output-format = "%Y-%m-%d %H:%M";

      merge-conflict-begin-symbol = "▼";
      merge-conflict-end-symbol = "▲";
      merge-conflict-ours-diff-header-style = "bold ${c.yellow.hex}";
      merge-conflict-ours-diff-header-decoration-style = "${c.blue.hex} box";
      merge-conflict-theirs-diff-header-style = "bold ${c.yellow.hex}";
      merge-conflict-theirs-diff-header-decoration-style = "${c.blue.hex} box";

      inspect-raw-lines = true;
      map-styles = "bold ${c.mauve.hex} => syntax ${c.mauve.hex}, bold ${c.teal.hex} => syntax ${c.teal.hex}";

      grep-file-style = "${c.mauve.hex}";
      grep-line-number-style = "${c.green.hex}";
      grep-match-line-style = "syntax";
      grep-match-word-style = "bold syntax";
      grep-context-line-style = "dim";
      grep-separator-symbol = ":";
    };
  };
}
