## To make the keyboard work

### On OSX:

Install `vicboard.keylayout` and remap CAPSLOCK to Option on OSX Settings.
Karabiner, Seil and similar aren't needed anymore!

### On Windows (for Parsec):

Take a breath and check the README on the `windows_vicboard` directory.

## To make VIM work

- Install VIM with Python3 support.

- Unzip `vim.zip` and move the contents to `~/.vim`

- Move `vimrc` to `~/.vimrc`

#### GPT-3 Completion

The GPT-3 completion can be toggled by typing a number, then `<leader>g`. The
number is the amount of tokens to be requested from GPT-3 Codex. In order for it
to work, the `~/.vim/bundle/vim_codex/python/AUTH.py` file must be edited to
include the secret key found on https://beta.openai.com/account/api-keys.

Edit: outdated, now I just use https://github.com/VictorTaelin/ai-scripts
