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

fun s:buildLine(parts)
  let s:status = []
  for sections in a:parts
    call add(s:status, s:buildPart(sections))
  endfor
  return s:status
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
