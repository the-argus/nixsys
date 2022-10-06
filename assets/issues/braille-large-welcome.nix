{
  username,
  includeWelcome ? true,
}: let
  color1 = "[1;34m";
  color2 = "[1;36m";
  color3 = "[1;29m";
  color4 = "[1;32m";
in "
  ${color1}          ::::.    ${color2}':::::     ::::'
  ${color1}          ':::::    ${color2}':::::.  ::::'
  ${color1}            :::::     ${color2}'::::.:::::
  ${color1}      .......:::::..... ${color2}::::::::
  ${color1}     ::::::::::::::::::. ${color2}::::::    ${color1}::::.
      ::::::::::::::::::::: ${color2}:::::.  ${color1}.::::'
  ${color2}           .....           ::::' ${color1}:::::'
  ${color2}          :::::            '::' ${color1}:::::'
  ${color2} ........:::::               ' ${color1}:::::::::::.${
  if includeWelcome
  then "                      ${color3}welcome, ${color4}${username}."
  else ""
}
  ${color2}:::::::::::::                 ${color1}:::::::::::::
  ${color2} ::::::::::: ${color1}..              ${color1}:::::
  ${color2}     .::::: ${color1}.:::            ${color1}:::::
  ${color2}    .:::::  ${color1}:::::          ${color1}'''''    ${color2}.....
      :::::   ${color1}':::::.  ${color2}......:::::::::::::'
       :::     ${color1}::::::. ${color2}':::::::::::::::::'
  ${color1}            .:::::::: ${color2}'::::::::::
  ${color1}           .::::''::::.     ${color2}'::::.
  ${color1}          .::::'   ::::.     ${color2}'::::.
  ${color1}         .::::      ::::      ${color2}'::::.
"
