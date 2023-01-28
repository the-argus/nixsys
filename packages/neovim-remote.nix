{
  writeShellScriptBin,
  kitty,
  terminal ? kitty,
  ...
}:
writeShellScriptBin "nvim-remote" ''
  term_exec=${terminal}/bin/${terminal.pname}
  server_path=$HOME/.cache/nvim/nvim-remote.server.pipe

  function open_file_server () {
      if [ -e $server_path ]; then
          # open file in server
          nvim --server $server_path --remote "$@"
      else
          # start the server if its pipe doesn't exist
          $term_exec -e nvim --listen $server_path "$@"
      fi
  }

  # unity flatpak call handling
  IS_UNITY=
  appended_str=""
  for arg in $@; do
      if [ "$arg" == "__UNITY_FLATPAK__" ]; then
          IS_UNITY="yes"
          continue
      fi
      appended_str="${"\${appended_str}} ${"\${arg}"}"
  done
  # there's always a space at the front? get rid of that
  appended_str=${appended_str:1}

  if [ ! -z $IS_UNITY ]; then
      open_file_server "$appended_str"
  else
      open_file_server $@
  fi
''
