### To make the keyboard work

#### On OSX:

Install vicboard.keylayout, install Karabiner and save this
karabiner.json to `./.config/karabiner/karabiner.json`. It
just remaps CAPSLOCK to control+option, which is used to
enable the numeric keyboard. Alternatively, just remap
CAPSLOCK to Option, which also enables the numeric keyboard
on OSX, but won't work on Windows via Parsec.

#### On Windows (for Parsec):

Download the Microsoft Keyboard Layout Creator, install it
(requires enabling .NET 3.5 using the Windows "add/remove
software" features), open the vicboard-windows.klc and
generate the DLL installers. Alternatively, download
vicbr0_windows.zip, which has the DLL installers already.
Install it, reboot the machine, an option to select Vicboard
should appear on the language menu of the start bar. This
will make my Mcc keyboard layout work identically on Windows
via Parsec because the numeric keyboard is enabled with
AltGr on Windows. Since the Macbook CAPSLOCK becomes
control+option, it triggers AltGr on the Windows side.

Also download special_keys_windows.zip and unzip. The .exe
file inside it swaps the special keys on the Windows side,
so that:

- Left-Command (mac) becomes Left-Ctrl (windows). Allows
  using Command+C on Mac for Ctrl+C on Windows.

- Left-Control (mac) becomes Left-Alt (windows). Allows
  using Control on Mac for Alt on Windows. 

- Left-Option (mac) becomes Left-Ctrl (windows). Just
  another option for Ctrl - I couldn't map this to the Win
  key, but the Right-Command on Mac does it.

To make the .exe always load on startup, press Win+R, enter
`shell::startup` and paste it on that directory.
