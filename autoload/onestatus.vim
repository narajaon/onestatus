fun onestatus#build(cmds) abort
  let index = 0
  while index < len(a:cmds)
    if !has_key(a:cmds[index], 'command')
      echoer 'command attribute missing in object ' . index
    endif
    let index = index + 1
  endwhile
  call s:apply(s:buildLine(a:cmds))
endfun

fun s:wrap_in_quotes(text)
  return '"' . escape(a:text, '"') . '"'
endfun

fun s:apply(line_settings) abort
  try
    let save_cpo = &cpo
    set cpo&vim
    let temp_file = tempname()
    call writefile(a:line_settings, temp_file)
    call system("tmux source ". s:wrap_in_quotes(temp_file))
  finally
    let &cpo = save_cpo
    unlet save_cpo
    call delete(temp_file)
  endtry
endfun

fun s:buildLine(parts)
  let status = []
  for sections in a:parts
    call add(status, s:buildPart(sections))
  endfor
  return status
endfun

fun s:buildSection(attrs)
  let bg = get(a:attrs, 'bg', '')
  let fg = get(a:attrs, 'fg', '')
  let label = get(a:attrs, 'label', '')
  let fmt = get(a:attrs, 'isStyleOnly', v:false) ? 'fg=%s,bg=%s%s' : '"#[fg=%s,bg=%s]%s"'
  let parts = printf(fmt, fg, bg, label ? label : ' '.label)
  return parts
endfun

fun s:buildPart(sections)
  let part = [] 
  if has_key(a:sections, 'attributes')
    for sect in a:sections.attributes
      call add(part, s:buildSection(sect))
    endfor
  endif
  let res =  printf('%s %s', a:sections.command, join(part, ''))
  return res
endfun
