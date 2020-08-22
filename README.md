*Disclaimer*: this is still a very early stage project, feel free to submit a PR if you want to contribute

# Motivation
OneStatus is an interface helps you interact with your tmux.<br>
One of my goal with it was to get rid of vim's redundant statusline and instead use tmux's.

Much better !

![onestatus](https://user-images.githubusercontent.com/26607946/90639803-7f947f00-e22f-11ea-863e-e347f9379dfe.png)

# Requirements
If you just want to use the default template :
 - a font that supports powerline
 - https://github.com/tpope/vim-fugitive installed

If you want to play with the API :
 - nothing ! Make sure to disable the default config by setting and you're done
 `let g:onestatus_default_layout = 0`

# Usage
The plugin comes with a prebuilt statusline, as seen in the screenshot.<br>
You should however note that your current tmux setting may interfere with it.

To use the default template, put this in your config file
```
au BufEnter * :OneStatus
set noshowmode noruler
set laststatus = 0
```
You can of course not use `BufEnter` and use `WinEnter` or some other events but I found it sufficient for my use case.

# Customization
This is how the OneStatus command is implemented.
```
command! OneStatus :call onestatus#build([dict1, dict2, dict3, dict4, dict5])
```

It calls `onestatus#build` which takes a List of Dictionaries.<br>
The only mandatory attribute of each Dict is a `command` key which has a tmux command as its value.
```
{
   'command': 'set-option -g status-justify centre'
}
```
If your command updates tmux's colors, OneStatus can parse an `attributes` List of this form:
```
{
   'command': 'set-option -g status-left',
   'attributes': [{"fg": "#6c757d", "bg": "#fcfcfc", "label": "#H"}]
}
```

Which will be sent to tmux like
```
set-option -g status-left #[fg=#6c757d,bg=#fcfcfc]#H
```

# TODO
- Write a proper `:h`
- Add more default templates
- Improve default template theme integration

# License
Distributed under the same terms as Vim itself. See the vim license.
