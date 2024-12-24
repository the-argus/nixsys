#!/bin/sh

FILE_PATH="${1}" # Full path of the highlighted file
WIDTH="${2}"     # Width of the preview pane (number of fitting characters)
HEIGHT="${3}"    # Height of the preview pane (number of fitting characters)
X="${4}"         # X coordinate of the preview pane
Y="${5}"         # Y coordinate of the preview pane

if ! [ -f "$FILE_PATH" ] && ! [ -h "$FILE_PATH" ]; then
  exit
fi

FILE_EXTENSION="${FILE_PATH##*.}"
FILE_EXTENSION_LOWER="$(printf "%s" "${FILE_EXTENSION}" | tr '[:upper:]' '[:lower:]')"
MIME_TYPE="$(file --dereference --brief --mime-type -- "${FILE_PATH}")"

# [ -n "$WIDTH" ] && [ -n "$HEIGHT" ] && [ -n "$X" ] && [ -n "$Y" ] || PAGE_MODE=$?
[ $# -gt 1 ] || PAGE_MODE=$?

hash() {
  printf '%s/.cache/lf/%s.jpg' "$HOME" \
    "$(gstat --printf '%n\0%i\0%F\0%s\0%W\0%Y' -- "$(readlink -f "$1")" | md5sum | awk '{print $1}')"
}

CACHEDIR="$HOME/.cache/lf"
if ! [ -e $CACHEDIR ]; then
    mkdir -p $CACHEDIR
fi

IMAGE_CACHE_PATH="$(hash "$FILE_PATH")" # Full path that should be used to cache image preview

create_preview_image_or_fallback() {
  ## Size of the preview if there are multiple options or it has to be
  ## rendered from vector graphics. If the conversion program allows
  ## specifying only one dimension while keeping the aspect ratio, the width
  ## will be used.
  local DEFAULT_SIZE
  DEFAULT_SIZE="1024x768"
  # DEFAULT_SIZE=$(kitty +kitten icat --print-window-size)
  # if [ -z "$DEFAULT_SIZE" ]; then
  #   DEFAULT_SIZE="1024x768"
  # fi

  case "${MIME_TYPE}" in
  ## SVG
  image/svg+xml | image/svg)
    rsvg-convert --keep-aspect-ratio --width "${DEFAULT_SIZE%x*}" "${FILE_PATH}" -o "${IMAGE_CACHE_PATH}.png" &&
      mv "${IMAGE_CACHE_PATH}.png" "${IMAGE_CACHE_PATH}" &&
      return 6
    return 1
    ;;

  ## Image
  image/*)
    local orientation
    orientation="$(identify -format '%[EXIF:Orientation]\n' -- "${FILE_PATH}")"
    ## If orientation data is present and the image actually
    ## needs rotating ("1" means no rotation)...
    if [[ -n "$orientation" && "$orientation" != 1 ]]; then
      ## ...auto-rotate the image according to the EXIF data.
      convert -- "${FILE_PATH}" -auto-orient "${IMAGE_CACHE_PATH}" && return 6
    fi

    ## `w3mimgdisplay` will be called for all images (unless overridden
    ## as above), but might fail for unsupported types.
    return 7
    ;;

  ## Video
  video/*)
    # Get embedded thumbnail
    ffmpeg -i "${FILE_PATH}" -map 0:v -map -0:V -c copy "${IMAGE_CACHE_PATH}" && return 6
    # Get frame 10% into video
    ffmpegthumbnailer -i "${FILE_PATH}" -o "${IMAGE_CACHE_PATH}" -s 0 && return 6
    return 1
    ;;

  ## Audio
  audio/*)
    # Get embedded thumbnail
    ffmpeg -i "${FILE_PATH}" -map 0:v -map -0:V -c copy \
      "${IMAGE_CACHE_PATH}" && return 6
    ;;

  ## PDF
  application/pdf)
    pdftoppm -f 1 -l 1 \
      -scale-to-x "${DEFAULT_SIZE%x*}" \
      -scale-to-y -1 \
      -singlefile \
      -jpeg -tiffcompression jpeg \
      -- "${FILE_PATH}" "${IMAGE_CACHE_PATH%.*}" &&
      return 6 || return 1
    ;;

  ## Font
  application/font* | application/*opentype)
    preview_png="/tmp/$(basename "${IMAGE_CACHE_PATH%.*}").png"
    if fontimage -o "${preview_png}" \
      --pixelsize "120" \
      --fontname \
      --pixelsize "80" \
      --text "  ABCDEFGHIJKLMNOPQRSTUVWXYZ  " \
      --text "  abcdefghijklmnopqrstuvwxyz  " \
      --text "  0123456789.:,;(*!?') ff fl fi ffi ffl  " \
      --text "  The quick brown fox jumps over the lazy dog.  " \
      "${FILE_PATH}"; then
      convert -- "${preview_png}" "${IMAGE_CACHE_PATH}" &&
        rm "${preview_png}" &&
        return 6
    else
      return 1
    fi
    ;;

  esac

  case "${FILE_PATH}" in
    *.tar*) tar tf "$1";;
    *.zip) unzip -l "$1";;
    *.rar) unrar l "$1";;
    *.7z) 7z l "$1";;
    # *.pdf) pdftotext "$1" -;;
    *.md) glow "$1";;
    *) highlight -O ansi "$1";;
  esac
}

hold() {
  tput civis >/dev/tty 2>/dev/null # hide cursor
  read -n 1 -s -r
  # stty raw
  # dd bs=1 count=1 &>/dev/null
  # stty cooked
  tput cnorm >/dev/tty 2>/dev/null # show cursor
}

draw() {
  if [ "$PAGE_MODE" ]; then
    WIDTH=${lf_width:=$(tput cols)}
    HEIGHT=${lf_height:=$(tput lines)}
    X=0
    Y=0
  fi
  if [ -n "$TMUX" ]; then
    WIDTH=$((WIDTH - 1))
    HEIGHT=$((HEIGHT - 1))
  fi
  if [ "$PAGE_MODE" ]; then
    clear
    kitty +kitten icat --stdin no --transfer-mode memory --place "${WIDTH}x${HEIGHT}@${X}x${Y}" "$1" </dev/null >/dev/tty
    hold
    kitty +kitten icat --clear --stdin no --transfer-mode memory </dev/null >/dev/tty
  else
    # preview launched in preview mode
    kitty +kitten icat --stdin no --transfer-mode memory --place "${WIDTH}x${HEIGHT}@${X}x${Y}" "$1" </dev/null >/dev/tty
    exit 1 # needed for the preview to refresh
  fi
}

# check if cached file exists, if not, create it
if [ -f "$IMAGE_CACHE_PATH" ]; then
  image="$IMAGE_CACHE_PATH"
else
  create_preview_image_or_fallback "$FILE_PATH"

  # handle some image cases
  case $? in
  0) ;;
  1) ;;
  2) ;;
  3) ;;
  4) ;;
  5) ;;
  6) image="$IMAGE_CACHE_PATH" ;;
  7) image="$FILE_PATH" ;;
  esac
fi

# if the above generated an image, draw it
if [ -n "$image" ]; then
  draw "$image"
fi
