if !exists(':OneStatus*')
  command! -nargs=+ OneStatus :call onestatus#build(<q-args>)
  command! OneStatusDefault :call onestatus#build([s:defaultStyle(), s:right(), s:curwin(), s:winlist(), s:left()])
endif

if exists('g:loaded_onestatus')
  finish
endif

let g:loaded_onestatus = 1
let g:onestatus_default_layout = 1

fun onestatus#build(cmds) abort
  let s:index = 0
  while s:index < len(a:cmds)
    if !has_key(a:cmds[s:index], 'command')
      echoer 'command attribute missing in object ' . s:index
    endif
    let s:index = s:index + 1
  endwhile
  call s:apply(s:buildLine(a:cmds))
endfun

fun s:getFormated()
  return g:cwd_formated
endfun

fun s:getHead()
  let s:head = FugitiveHead()
  if (s:head == "")
    return ""
  endif
  return printf("  %s ", s:head)
endfun

fun s:wrap_in_quotes(text)
  return '"' . escape(a:text, '"') . '"'
endfun

fun s:apply(line_settings) abort
  try
    let s:save_cpo = &cpo
    set cpo&vim
    let s:temp_file = tempname()
    call writefile(a:line_settings, s:temp_file)
    call system("tmux source ". s:wrap_in_quotes(s:temp_file))
  finally
    let &cpo = s:save_cpo
    unlet s:save_cpo
    call delete(s:temp_file)
  endtry
endfun

fun s:getColor(colSchem, command, isStyleOnly) abort
  let s:fg = synIDattr(synIDtrans(hlID(a:colSchem)), 'fg#')
  let s:bg = synIDattr(synIDtrans(hlID(a:colSchem)), 'bg#')
  let s:attrs = {'isStyleOnly': a:isStyleOnly, 'fg': s:fg, 'bg': s:bg}
  return { 'command': a:command, 'attributes': [s:attrs]}
endfun

fun s:buildSection(attrs)
  let s:bg = get(a:attrs, 'bg', '')
  let s:fg = get(a:attrs, 'fg', '')
  let s:label = get(a:attrs, 'label', '')
  let s:fmt = get(a:attrs, 'isStyleOnly', v:false) ? 'fg=%s,bg=%s%s' : '"#[fg=%s,bg=%s]%s"'
  let s:parts = printf(s:fmt, s:fg, s:bg, s:label ? s:label : ' '.s:label)
  return s:parts
endfun

fun s:buildPart(sections)
  let s:part = [] 
  if has_key(a:sections, 'attributes')
    for sect in a:sections.attributes
      call add(s:part, s:buildSection(sect))
    endfor
  endif
  let s:res =  printf('%s %s', a:sections.command, join(s:part, ''))
  return s:res
endfun

fun s:buildLine(parts)
  let s:status = []
  for sections in a:parts
    call add(s:status, s:buildPart(sections))
  endfor
  return s:status
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
