{writeShellScriptBin, ...}:
writeShellScriptBin "ctrlf" ''
  PATTERN="$1"
  REPLACEMENT="$2"

  TMPDIR=$(mktemp -d --suffix "replacement")

  echo "Replacing regex $PATTERN with $REPLACEMENT ..."

  for file in $(rg --color=never --files-with-matches $PATTERN); do
      output=$TMPDIR/$file
      delta_output="${"$\{output}"}.delta"
      mkdir -p $TMPDIR/$(dirname $file)
      rg --passthru $PATTERN --replace $REPLACEMENT $file > $output
      delta --paging=never $file $output > $delta_output
      less -K -R $delta_output
      status=$?
      if [ $status -eq 2 ]; then
          echo "Replacement for $file confirmed."
          cat $output > $file
          continue
      fi
      echo "Replacement for $file cancelled."
      rm $output
  done

  rm -rf $TMPDIR
''
