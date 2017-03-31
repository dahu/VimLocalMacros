" ============================================================================
" File:        vimlocalmacros - Store and execute macros in current file.
" Description: Allows macros to be stored using the current file's comments.
" Author:      Barry Arthur <barry dot arthur at gmail dot com>
" Last Change: 6 February, 2011
" Website:     http://github.com/dahu/VimLocalMacros
"
" See vimlocalmacros.txt for help.  This can be accessed by doing:
"
" :helptags ~/.vim/doc
" :help vimlocalmacros
"
" Licensed under the same terms as Vim itself.
" ============================================================================
let s:VimLocalMacros = '0.0.3'  " alpha, unreleased
let s:DefaultCommmentStr = '# %s'

" Vimscript setup {{{1
let s:old_cpo = &cpo
set cpo&vim

function! EscapeControlSequences(macro)
  let macro = getreg(a:macro)
  let macro = substitute(macro,"\<Esc>",'\\<esc>','g')
  let macro = substitute(macro,"",'\\<c-r>','g')
  return macro
endfunction

" Public Interface {{{1
function! WriteMacro(macro)
  let commentStr = &commentstring
  if empty(commentStr)
    let commentStr = s:DefaultCommmentStr
  endif

  call append('.', [printf(commentStr ,printf('vlm:let @%s="%s"',a:macro, escape(EscapeControlSequences(a:macro), '"')))])
endfunction

function! RunMacroLine(line)
  let commentStr = &commentstring
  if empty(commentStr)
    let commentStr = s:DefaultCommmentStr
  endif

  let line = a:line
  let vlmm = '^\s*'.substitute(escape(commentStr, '[]^$*.{}\'), '%s', 'vlm:\\(.*\\)', '')
  let vlml = ''
  silent! let vlml = matchlist(line, vlmm)[1]
  if vlml != ''
    silent exe vlml
  else
    echo "Not a vlm line."
  endif
endfunction

function! RunAllVlm()
  for line in getline(1, '$')
    silent call RunMacroLine(line)
  endfor
endfunction

" Maps {{{1
" TODO: add clash and override checks
nnoremap <leader>mw :call WriteMacro(input("Register? "))<CR>
nnoremap <leader>mr :call RunMacroLine(getline('.'))<CR>

" Automatically Run Macros
" autocmd BufRead * call RunAllVlm()

" Teardown:{{{1
"reset &cpo back to users setting
let &cpo = s:old_cpo

" vim: set sw=2 sts=2 et fdm=marker:
