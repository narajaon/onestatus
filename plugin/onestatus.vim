if !exists(':OneStatus*')
  command! OneStatus call s:setCurDir() | call onestatus#build([s:defaultStyle(), s:right(), s:curwin(), s:winlist(), s:left()])
endif

if exists('g:loaded_onestatus')
  finish
endif

let g:loaded_onestatus = 1
let g:onestatus_default_layout = 1
let g:cwd_formated = ""

function s:setCurDir()
  let cwd = getcwd()
  let g:cwd_formated = get(split(cwd, '/')[-1:], 0, 'root')
endfun

fun s:getFormated()
  return g:cwd_formated
endfun

fun s:getFileName()
  return &filetype != '' ? printf(' %s ', expand("%:t")) : ''
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

let s:col1 = "#218380"
let s:col2 = "#ffd167"
let s:col3 = "#6c757d"
let s:col4 = "default"
let s:col5 = "default"

let s:right = { -> {'command': 'set-option -g status-right', 'attributes': [{"fg": s:col2, "bg": "default", "label": ""},{"fg": s:col1, "bg": s:col2, "label": "~/" . s:getFormated()}, {"fg": s:col1,"bg": s:col2, "label": ""}, {"fg": "#fcfcfc", "bg": s:col1, "label": s:getHead()}]}} 

" set-window-option -g window-status-current-style 
let s:curwin = { -> {'command': 'set-window-option -g window-status-current-style ', 'attributes': [{"fg": s:col2, "bg": 'default', "isStyleOnly": v:true}]}}

" set-window-option -g window-status-style
let s:winlist = { -> {'command': 'set-window-option -g window-status-style', 'attributes': [{"fg": s:col3, "bg": 'default', "isStyleOnly": v:true}]}}

" set-option -g status-left
let s:left = { -> {'command': 'set-option -g status-left', 'attributes': [{"fg": s:col5, "bg": s:col4, "label": s:getFileName()}]}}
" {"fg": "#fcfcfc", "bg": s:col3, "label": "#H"},
" set-option status-style
let s:defaultStyle = { -> s:getColor('Normal', 'set-option status-style', v:true)}

" set default config
if g:onestatus_default_layout
  call onestatus#build([
        \{'command' : 'set-option -g status-justify centre'},
        \{'command': 'set-option status-right-length 30'},
        \{'command': 'set-option status-left-length 50'},
        \])
endif
