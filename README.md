Depends
-------

You must load [zsh-hooks](https://github.com/willghatch/zsh-hooks) before this plugin.

Install
-------

I recommend using [antigen](https://github.com/zsh-users/antigen) or [antigen-hs](https://github.com/Tarrasch/antigen-hs).  Here is how to do it with antigen:

    antigen bundle willghatch/zsh-hooks
    antigen bundle willghatch/zsh-megaprompt

Otherwise, just source the .zsh files

Features
--------

- Maximal information
- Directory coloring based on permissions/ownership
- shows git/hg branch if in repo
- shows current keymap indicator (I suggest replacing vi-ins with emacs, then you get the best of both worlds)
- shows exit status if non-zero
- shows number of jobs if non-zero
- shows time, history number, user/host names

Configuration
-------------

- <code>MEGAPROMPT_STYLES</code> is an array for color codes for different parts
- <code>MEGAPROMPT_KEYMAP_IND</code> is an array of keymap indicators

There are a lot of elements... they're at the top of the source, so just look at it.
