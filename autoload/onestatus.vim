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
