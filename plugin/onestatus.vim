if !exists(':OneStatus')
  if !exists('g:onestatus_default_layout')
    let g:onestatus_default_layout = 1
    command! OneStatus call s:setCurDir() | call onestatus#build(s:onestatusDefault())
  endif
endif

if exists('g:loaded_onestatus')
  finish
endif

if !exists('g:onestatus_config_path')
  let s:currentPath = expand('$HOME')
  if has('nvim')
    let s:currentPath = s:currentPath . '/.config/nvim'
  endif
  let g:onestatus_config_path = s:currentPath . '/onestatus.json'
endif

if !exists('g:onestatus_right_length')
  let g:onestatus_right_length = 50
endif

if !exists('g:onestatus_left_length')
  let g:onestatus_left_length = 50
endif

let g:loaded_onestatus = 1
let g:cwd_formated = ""

function s:setCurDir()
  let cwd = getcwd()
  let g:cwd_formated = printf(' ~/%s ', get(split(cwd, '/')[-1:], 0, 'root'))
endfun

fun s:getCWD()
  return g:cwd_formated
endfun

fun s:getFileName()
  return &filetype != '' ? printf(' %s ', expand("%:t")) : ''
endfun

fun s:getHead()
  let s:headRef = { -> '' }
  if exists('g:loaded_fugitive')
    let s:headRef = funcref('FugitiveHead')
  elseif exists('g:loaded_gitbranch')
    let s:headRef = funcref('gitbranch#name')
  else
    echo 'OneStatus: please install vim-gitbranch or vim-fugitive to use s:getHead'
    return ''
  endif
  let head = s:headRef()
  if (head == "")
    return ""
  endif
  return printf("  %s ", head)
endfun

fun s:getDefaultColor() abort
  let s:fg = synIDattr(synIDtrans(hlID('Normal')), 'fg#')
  let s:bg = synIDattr(synIDtrans(hlID('Normal')), 'bg#')
  let s:attrs = {'isStyleOnly': v:true, 'fg': s:fg, 'bg': s:bg}
  return [s:attrs]
endfun

fun s:execLabelFuncs(val)
  for [key, val] in items(a:val)
    if key == "labelFunc"
      let a:val.label = function(val)()
      unlet a:val.labelFunc
    endif
  endfor
  return a:val
endfun

fun s:getConfig(path) abort
  let config = json_decode(readfile(a:path))
  let template = []
  for [key, val] in items(config)

    if type(val) == v:t_list
      let fmtVal = map(val, { _,dict -> s:execLabelFuncs(dict) })
    elseif type(val) == v:t_string
      let fmtVal = function(val)()
    else
      throw printf('% has bad attribute type', key)
    endif

    call add(template, { 'command': 'set-window-option -g ' . key, 'attributes': fmtVal })
  endfor
  return template
endfun

fun s:onestatusDefault()
  let configPath = expand(g:onestatus_config_path)
  if !filereadable(configPath)
    echo 'OneStatus: onestatus.json not found. Please Provide one at ' . s:currentPath . ' or override g:onestatus_config_path'
    return []
  endif
  return s:getConfig(configPath) 
endfun

" set default config
if g:onestatus_default_layout == 1
  call onestatus#build([
        \{'command' : 'set-option status-justify centre'},
        \{'command': 'set-option status-right-length ' . g:onestatus_right_length},
        \{'command': 'set-option status-left-length ' . g:onestatus_left_length},
        \])
endif
