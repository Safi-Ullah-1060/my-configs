#!/bin/bash
myD=`grep -m 1 -i "ColorScheme=" "$HOME/.local/share/konsole/My Default.profile"`
myD=`echo "${myD/ColorScheme=}"`
op=`grep -m 1 -i "Opacity=" "$HOME/.local/share/konsole/$myD.colorscheme"`
op=`echo "${op/Opacity=}"`
echo $op
