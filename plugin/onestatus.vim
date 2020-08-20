if !exists(':OneStatus*')
  command! OneStatus :call onestatus#build([s:defaultStyle(), s:right(), s:curwin(), s:winlist(), s:left()])
endif

if exists('g:loaded_onestatus')
  finish
endif

let g:loaded_onestatus = 1
let g:onestatus_default_layout = 1

fun s:getFormated()
  return g:cwd_formated
endfun

fun s:getHead()
  let head = FugitiveHead()
  if (head == "")
    return ""
  endif
  return printf("  %s ", head)
endfun

fun s:getColor(colSchem, command, isStyleOnly) abort
  let fg = synIDattr(synIDtrans(hlID(a:colSchem)), 'fg#')
  let bg = synIDattr(synIDtrans(hlID(a:colSchem)), 'bg#')
  let attrs = {'isStyleOnly': a:isStyleOnly, 'fg': fg, 'bg': bg}
  return { 'command': a:command, 'attributes': [attrs]}
endfun

" set-option -g status-right
let s:right = { -> {'command': 'set-option -g status-right', 'attributes': [{"fg": "#ffd166", "bg": "default", "label": ""},{"fg": "#26547c", "bg": "#ffd166", "label": "~/" . s:getFormated()}, {"fg": "#26547c","bg": "#ffd166", "label": ""}, {"fg": "#fcfcfc", "bg": "#26547c", "label": printf('[%s]', &filetype)}, {"fg": "#218380","bg": "#26547c", "label": ""}, {"fg": "#fcfcfc", "bg": "#218380", "label": s:getHead()}]}} 

" set-window-option -g window-status-current-style 
let s:curwin = { -> {'command': 'set-window-option -g window-status-current-style ', 'attributes': [{"fg": '#ffd167', "bg": 'default', "isStyleOnly": v:true}]}}

" set-window-option -g window-status-style
let s:winlist = { -> {'command': 'set-window-option -g window-status-style', 'attributes': [{"fg": '#fcfcfc', "bg": 'default', "isStyleOnly": v:true}]}}

" set-option -g status-left
let s:left = { -> {'command': 'set-option -g status-left', 'attributes': [{"fg": "#6c757d", "bg": "default", "label": "#H"}]}}

" set-option status-style
let s:defaultStyle = { -> s:getColor('CursorLineNr', 'set-option status-style', v:true)}

" set default config
if g:onestatus_default_layout
  call onestatus#build([
        \{'command' : 'set-option -g status-justify centre'},
        \{'command': 'set-option status-right-length 50'},
        \{'command': 'set-option status-left-length 60'},
        \])
endif
