{
  writeShellScriptBin,
  kitty,
  terminal ? kitty,
  ...
}:
writeShellScriptBin "nvim-remote" ''
  term_exec=${terminal}/bin/${terminal.pname}

  server_path=$HOME/.cache/nvim/godot.server.pipe

  if [ -e $server_path ]; then
      # open file in server
      nvim --server $server_path --remote "$@"
  else
      # start the server if its pipe doesn't exist
      $term_exec -e nvim --listen $server_path "$@"
  fi
''
