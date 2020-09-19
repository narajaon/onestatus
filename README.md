*disclaimer*: this is still a very early stage project, feel free to submit a pr if you want to contribute

# motivation
onestatus is an interface helps you interact with your tmux.<br>
one of my goal with it was to get rid of vim's redundant statusline and instead use tmux's.

Much better !

![onestatus](https://user-images.githubusercontent.com/26607946/90639803-7f947f00-e22f-11ea-863e-e347f9379dfe.png)

# requirements
if you just want to use the default template :
 - a font that supports powerline
 - https://github.com/tpope/vim-fugitive installed

if you want to play with the api :
 - make sure to disable the default config by setting
 `let g:onestatus_default_layout = 0`
  and you're done !

# usage
the plugin comes with a prebuilt statusline, as seen in the screenshot.<br>
*you should however note that your current tmux setting may interfere with it.*

to use the default template, put this in your config file
```
au bufenter * :onestatus
set noshowmode noruler
set laststatus = 0
```
you can of course not use `bufenter` and use `winenter` or some other events but i found it sufficient for my use case.

# customization
since v0.2.0 you can now very easily customize your statusline via a `onestatus.json` file that you put in your $myvimdir folder !
here's an example of configuration file

```json
{
  "status-right": [
    { "fg": "#ffd167", "bg": "default", "label": "" },
    { "fg": "#218380", "bg": "#ffd167", "labelfunc": "s:getcwd" },
    { "fg": "#218380", "bg": "#ffd167", "label": "" },
    { "fg": "#fcfcfc", "bg": "#218380", "labelfunc": "s:gethead" }
  ],
  "status-left": [
    { "fg": "default", "bg": "default", "labelfunc": "s:getfilename" }
  ],
  "status-style": "s:getdefaultcolor",
  "window-status-style": [
    { "fg": "#6c757d", "bg": "default", "isstyleonly": true }
  ],
  "window-status-current-style": [
    { "fg": "#ffd167", "bg": "default", "isstyleonly": true }
  ]
}
```

which will give your current git head and the name of the focused file at the bottom right of your screen.

## the api
you can notice that our json file has these types
- tmux option: an option that will be sent to tmux, you can learn more about them in `man tmux` 
- tmux color: can be any color forma supported by tmux (ex: #ffd167)
- onestatus' builtin function: they begin by `s:` like `s:getfilename`

and has this form
```json
{
  option: attributes
}
```
in order to give a maximum amount of flexibility, attributes can either be an array of attribute of this shape:
```json
{
  "fg": optional tmux color (will default to tmux's default),
  "bg": optional tmux color (will default to tmux's default),
  "label": the text to be displayed if your option takes a string as an argument (ex: status-left ),
  "labelfunc": you can dynamicaly display labels by using one of the functions exposed by onestatus (will take precedance over "label"),
  "isstyleonly": a boolean that has to be set to true if your option does not display a label
}
```

You can also use also use a onestatus function to dynamicaly generate your attributes.
Currently only `s:getdefaultcolor` is supported.

## available onestatus functions
labelFunc:
- s:getCWD
- s:getFileName
- s:getHead

attributes:
- s:getDefaultColor (it will make your statusline's background match with your vim's theme)

# TODO
- Write a proper `:h`
- Add more default templates
- Improve default template theme integration
- Add more builtin functions

# License
Distributed under the same terms as Vim itself. See the vim license.
