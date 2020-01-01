### To make the keyboard work

On OSX: install vicboard.keylayout, install Karabiner and
save this karabiner.json to
`./.config/karabiner/karabiner.json`. It just remaps
CAPSLOCK to control+option, which is used to enable the
numeric keyboard. Alternatively, just remap CAPSLOCK to
Option, which also enables the numeric keyboard on OSX, but
won't work on Windows via Parsec.

On Windows: download the Microsoft Keyboard Layout Creator,
install it (requires enabling .NET 3.5 using the Windows
"add/remove software" features), open the
vicboard-windows.klc and generate the DLL installers.
Install it, reboot the machine, an option to select Vicboard
should appear on the language menu of the start bar. This
will work via Parsec because the numeric keyboard is enabled
with AltGr on Windows. Since the Macbook CAPSLOCK becomes
control+option, it triggers AltGr on the Windows side.
